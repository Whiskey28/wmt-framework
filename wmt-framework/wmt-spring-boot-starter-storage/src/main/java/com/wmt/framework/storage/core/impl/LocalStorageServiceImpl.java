package com.wmt.framework.storage.core.impl;

import com.wmt.framework.storage.core.dto.FileInfo;
import com.wmt.framework.storage.core.dto.FileUploadRequest;
import com.wmt.framework.storage.core.service.StorageService;
import com.wmt.framework.storage.config.StorageProperties;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import javax.annotation.PostConstruct;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * 本地存储服务实现
 */
@Slf4j
@Service
public class LocalStorageServiceImpl implements StorageService {

    @Autowired
    private StorageProperties storageProperties;

    private Path rootPath;

    @PostConstruct
    public void init() {
        StorageProperties.LocalStorageConfig config = storageProperties.getLocal();
        this.rootPath = Paths.get(config.getRootPath());

        try {
            // 创建根目录
            Files.createDirectories(rootPath);
            log.info("本地存储初始化完成，根路径: {}", rootPath.toAbsolutePath());
        } catch (IOException e) {
            log.error("创建本地存储根目录失败: {}", e.getMessage(), e);
            throw new RuntimeException("本地存储初始化失败", e);
        }
    }

    @Override
    public String upload(FileUploadRequest request) {
        try {
            // 生成文件路径
            String filePath = generateFilePath(request);
            Path fullPath = rootPath.resolve(filePath);

            // 创建目录
            Files.createDirectories(fullPath.getParent());

            // 保存文件
            try (FileOutputStream fos = new FileOutputStream(fullPath.toFile())) {
                IOUtils.copy(request.getInputStream(), fos);
            }

            // 生成文件标识
            String fileKey = generateFileKey(filePath);

            log.info("文件上传成功，文件标识: {}, 路径: {}", fileKey, fullPath);
            return fileKey;

        } catch (IOException e) {
            log.error("文件上传失败: {}", e.getMessage(), e);
            throw new RuntimeException("文件上传失败", e);
        }
    }

    @Override
    public InputStream download(String fileKey) {
        try {
            Path filePath = getFilePath(fileKey);
            if (!Files.exists(filePath)) {
                throw new FileNotFoundException("文件不存在: " + fileKey);
            }
            return Files.newInputStream(filePath);
        } catch (IOException e) {
            log.error("文件下载失败: {}", e.getMessage(), e);
            throw new RuntimeException("文件下载失败", e);
        }
    }

    @Override
    public boolean delete(String fileKey) {
        try {
            Path filePath = getFilePath(fileKey);
            if (!Files.exists(filePath)) {
                return false;
            }

            Files.delete(filePath);
            log.info("文件删除成功: {}", fileKey);
            return true;

        } catch (IOException e) {
            log.error("文件删除失败: {}", e.getMessage(), e);
            return false;
        }
    }

    @Override
    public int deleteBatch(List<String> fileKeys) {
        int successCount = 0;
        for (String fileKey : fileKeys) {
            if (delete(fileKey)) {
                successCount++;
            }
        }
        return successCount;
    }

    @Override
    public FileInfo getFileInfo(String fileKey) {
        try {
            Path filePath = getFilePath(fileKey);
            if (!Files.exists(filePath)) {
                return null;
            }

            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileKey(fileKey);
            fileInfo.setFileName(extractFileName(fileKey));
            fileInfo.setFileSize(Files.size(filePath));
            fileInfo.setContentType(Files.probeContentType(filePath));
            fileInfo.setPath(filePath.toString());
            fileInfo.setCreateTime(LocalDateTime.now());
            fileInfo.setUpdateTime(LocalDateTime.now());

            // 计算MD5
            try (InputStream is = Files.newInputStream(filePath)) {
                String md5 = DigestUtils.md5DigestAsHex(is);
                fileInfo.setMd5(md5);
            }

            return fileInfo;

        } catch (IOException e) {
            log.error("获取文件信息失败: {}", e.getMessage(), e);
            return null;
        }
    }

    @Override
    public boolean exists(String fileKey) {
        Path filePath = getFilePath(fileKey);
        return Files.exists(filePath);
    }

    @Override
    public String getFileUrl(String fileKey) {
        StorageProperties.LocalStorageConfig config = storageProperties.getLocal();
        return config.getUrlPrefix() + "/" + fileKey;
    }

    @Override
    public String getFileUrl(String fileKey, int expireSeconds) {
        // 本地存储不支持过期时间，直接返回普通URL
        return getFileUrl(fileKey);
    }

    /**
     * 生成文件路径
     */
    private String generateFilePath(FileUploadRequest request) {
        StringBuilder pathBuilder = new StringBuilder();

        // 添加路径前缀
        if (StringUtils.hasText(request.getPathPrefix())) {
            pathBuilder.append(request.getPathPrefix()).append("/");
        }

        // 按日期分目录
        StorageProperties.LocalStorageConfig config = storageProperties.getLocal();
        if (config.isDatePath()) {
            String datePath = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            pathBuilder.append(datePath).append("/");
        }

        // 按文件类型分目录
        if (config.isTypePath() && StringUtils.hasText(request.getContentType())) {
            String typePath = request.getContentType().split("/")[0];
            pathBuilder.append(typePath).append("/");
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
        pathBuilder.append(uniqueFileName);

        return pathBuilder.toString();
    }

    /**
     * 生成文件标识
     */
    private String generateFileKey(String filePath) {
        // 使用文件路径的MD5作为文件标识
        return DigestUtils.md5DigestAsHex(filePath.getBytes());
    }

    /**
     * 根据文件标识获取文件路径
     */
    private Path getFilePath(String fileKey) {
        // 这里简化处理，实际应该维护文件标识到路径的映射关系
        // 可以通过数据库或配置文件来维护这个映射关系
        return rootPath.resolve(fileKey);
    }

    /**
     * 从文件标识中提取文件名
     */
    private String extractFileName(String fileKey) {
        // 简化处理，实际应该从映射关系中获取
        return fileKey;
    }
}
