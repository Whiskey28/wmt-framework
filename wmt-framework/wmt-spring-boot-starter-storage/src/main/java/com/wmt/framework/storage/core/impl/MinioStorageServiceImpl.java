package com.wmt.framework.storage.core.impl;

import com.wmt.framework.storage.*;
import com.wmt.framework.storage.core.FileInfo;
import com.wmt.framework.storage.core.FileUploadRequest;
import com.wmt.framework.storage.core.StorageService;
import com.wmt.framework.storage.config.StorageProperties;
import io.minio.*;
import io.minio.http.Method;
import io.minio.messages.DeleteError;
import io.minio.messages.DeleteObject;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import javax.annotation.PostConstruct;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * MinIO存储服务实现
 */
@Slf4j
@Service
public class MinioStorageServiceImpl implements StorageService {

    @Autowired
    private StorageProperties storageProperties;

    private MinioClient minioClient;
    private String bucketName;

    @PostConstruct
    public void init() {
        StorageProperties.MinioConfig config = storageProperties.getMinio();

        if (!StringUtils.hasText(config.getEndpoint()) ||
            !StringUtils.hasText(config.getAccessKey()) ||
            !StringUtils.hasText(config.getSecretKey())) {
            log.warn("MinIO配置不完整，跳过初始化");
            return;
        }

        try {
            this.minioClient = MinioClient.builder()
                    .endpoint(config.getEndpoint())
                    .credentials(config.getAccessKey(), config.getSecretKey())
                    .build();

            this.bucketName = config.getBucketName();

            // 检查并创建存储桶
            boolean bucketExists = minioClient.bucketExists(BucketExistsArgs.builder()
                    .bucket(bucketName)
                    .build());

            if (!bucketExists) {
                minioClient.makeBucket(MakeBucketArgs.builder()
                        .bucket(bucketName)
                        .build());
                log.info("创建MinIO存储桶: {}", bucketName);
            }

            log.info("MinIO存储初始化完成，端点: {}, 存储桶: {}", config.getEndpoint(), bucketName);

        } catch (Exception e) {
            log.error("MinIO存储初始化失败: {}", e.getMessage(), e);
            throw new RuntimeException("MinIO存储初始化失败", e);
        }
    }

    @Override
    public String upload(FileUploadRequest request) {
        if (minioClient == null) {
            throw new RuntimeException("MinIO客户端未初始化");
        }

        try {
            // 生成对象名称
            String objectName = generateObjectName(request);

            // 准备元数据
            Map<String, String> metadata = new HashMap<>();
            metadata.put("original-filename", request.getFileName());
            metadata.put("content-type", request.getContentType());
            metadata.put("file-size", String.valueOf(request.getFileSize()));

            if (request.getMetadata() != null) {
                metadata.putAll(request.getMetadata());
            }

            // 上传文件
            minioClient.putObject(PutObjectArgs.builder()
                    .bucket(bucketName)
                    .object(objectName)
                    .stream(request.getInputStream(), request.getFileSize(), -1)
                    .contentType(request.getContentType())
                    .userMetadata(metadata)
                    .build());

            // 生成文件标识
            String fileKey = generateFileKey(objectName);

            log.info("文件上传成功，文件标识: {}, 对象名称: {}", fileKey, objectName);
            return fileKey;

        } catch (Exception e) {
            log.error("文件上传失败: {}", e.getMessage(), e);
            throw new RuntimeException("文件上传失败", e);
        }
    }

    @Override
    public InputStream download(String fileKey) {
        if (minioClient == null) {
            throw new RuntimeException("MinIO客户端未初始化");
        }

        try {
            String objectName = getObjectName(fileKey);

            GetObjectResponse response = minioClient.getObject(GetObjectArgs.builder()
                    .bucket(bucketName)
                    .object(objectName)
                    .build());

            return response;

        } catch (Exception e) {
            log.error("文件下载失败: {}", e.getMessage(), e);
            throw new RuntimeException("文件下载失败", e);
        }
    }

    @Override
    public boolean delete(String fileKey) {
        if (minioClient == null) {
            throw new RuntimeException("MinIO客户端未初始化");
        }

        try {
            String objectName = getObjectName(fileKey);

            minioClient.removeObject(RemoveObjectArgs.builder()
                    .bucket(bucketName)
                    .object(objectName)
                    .build());

            log.info("文件删除成功: {}", fileKey);
            return true;

        } catch (Exception e) {
            log.error("文件删除失败: {}", e.getMessage(), e);
            return false;
        }
    }

    @Override
    public int deleteBatch(List<String> fileKeys) {
        if (minioClient == null) {
            throw new RuntimeException("MinIO客户端未初始化");
        }

        int successCount = 0;
        try {
            List<DeleteObject> objects = new ArrayList<>();
            for (String fileKey : fileKeys) {
                objects.add(new DeleteObject(getObjectName(fileKey)));
            }

            Iterable<Result<DeleteError>> results = minioClient.removeObjects(
                    RemoveObjectsArgs.builder()
                            .bucket(bucketName)
                            .objects(objects)
                            .build());

            for (Result<DeleteError> result : results) {
                try {
                    DeleteError error = result.get();
                    log.warn("删除文件失败: {}", error.objectName());
                } catch (Exception e) {
                    successCount++;
                }
            }

        } catch (Exception e) {
            log.error("批量删除文件失败: {}", e.getMessage(), e);
        }

        return successCount;
    }

    @Override
    public FileInfo getFileInfo(String fileKey) {
        if (minioClient == null) {
            return null;
        }

        try {
            String objectName = getObjectName(fileKey);

            StatObjectResponse stat = minioClient.statObject(StatObjectArgs.builder()
                    .bucket(bucketName)
                    .object(objectName)
                    .build());

            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileKey(fileKey);
            fileInfo.setFileName(stat.userMetadata().get("original-filename"));
            fileInfo.setFileSize(stat.size());
            fileInfo.setContentType(stat.contentType());
            fileInfo.setPath(objectName);
            fileInfo.setCreateTime(stat.lastModified().toLocalDateTime());
            fileInfo.setUpdateTime(stat.lastModified().toLocalDateTime());
            fileInfo.setMetadata(new HashMap<>(stat.userMetadata()));

            return fileInfo;

        } catch (Exception e) {
            log.error("获取文件信息失败: {}", e.getMessage(), e);
            return null;
        }
    }

    @Override
    public boolean exists(String fileKey) {
        if (minioClient == null) {
            return false;
        }

        try {
            String objectName = getObjectName(fileKey);

            minioClient.statObject(StatObjectArgs.builder()
                    .bucket(bucketName)
                    .object(objectName)
                    .build());

            return true;

        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public String getFileUrl(String fileKey) {
        if (minioClient == null) {
            throw new RuntimeException("MinIO客户端未初始化");
        }

        try {
            String objectName = getObjectName(fileKey);

            String url = minioClient.getPresignedObjectUrl(GetPresignedObjectUrlArgs.builder()
                    .method(Method.GET)
                    .bucket(bucketName)
                    .object(objectName)
                    .expiry(7, TimeUnit.DAYS)
                    .build());

            return url;

        } catch (Exception e) {
            log.error("获取文件URL失败: {}", e.getMessage(), e);
            throw new RuntimeException("获取文件URL失败", e);
        }
    }

    @Override
    public String getFileUrl(String fileKey, int expireSeconds) {
        if (minioClient == null) {
            throw new RuntimeException("MinIO客户端未初始化");
        }

        try {
            String objectName = getObjectName(fileKey);

            String url = minioClient.getPresignedObjectUrl(GetPresignedObjectUrlArgs.builder()
                    .method(Method.GET)
                    .bucket(bucketName)
                    .object(objectName)
                    .expiry(expireSeconds, TimeUnit.SECONDS)
                    .build());

            return url;

        } catch (Exception e) {
            log.error("获取文件URL失败: {}", e.getMessage(), e);
            throw new RuntimeException("获取文件URL失败", e);
        }
    }

    /**
     * 生成对象名称
     */
    private String generateObjectName(FileUploadRequest request) {
        StringBuilder nameBuilder = new StringBuilder();

        // 添加路径前缀
        if (StringUtils.hasText(request.getPathPrefix())) {
            nameBuilder.append(request.getPathPrefix()).append("/");
        }

        // 按日期分目录
        String datePath = LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        nameBuilder.append(datePath).append("/");

        // 按文件类型分目录
        if (StringUtils.hasText(request.getContentType())) {
            String typePath = request.getContentType().split("/")[0];
            nameBuilder.append(typePath).append("/");
        }

        // 生成唯一文件名
        String fileName = request.getFileName();
        if (!StringUtils.hasText(fileName)) {
            fileName = "file";
        }

        String extension = "";
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            extension = fileName.substring(lastDotIndex);
            fileName = fileName.substring(0, lastDotIndex);
        }

        String uniqueFileName = fileName + "_" + UUID.randomUUID().toString().replace("-", "") + extension;
        nameBuilder.append(uniqueFileName);

        return nameBuilder.toString();
    }

    /**
     * 生成文件标识
     */
    private String generateFileKey(String objectName) {
        // 使用对象名称的MD5作为文件标识
        return DigestUtils.md5DigestAsHex(objectName.getBytes());
    }

    /**
     * 根据文件标识获取对象名称
     */
    private String getObjectName(String fileKey) {
        // 这里简化处理，实际应该维护文件标识到对象名称的映射关系
        // 可以通过数据库或配置文件来维护这个映射关系
        return fileKey;
    }
}
