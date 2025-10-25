package com.wmt.framework.storage.core.util;

import com.wmt.framework.storage.core.dto.FileInfo;
import com.wmt.framework.storage.core.dto.FileUploadRequest;
import com.wmt.framework.storage.core.factory.StorageServiceFactory;
import com.wmt.framework.storage.core.service.StorageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.List;

/**
 * 存储工具类
 * 提供便捷的文件操作方法
 */
@Slf4j
@Component
public class StorageUtils {

    @Autowired
    private StorageServiceFactory storageServiceFactory;

    /**
     * 上传文件
     */
    public String uploadFile(MultipartFile file) {
        return uploadFile(file, null, null);
    }

    /**
     * 上传文件（带路径前缀）
     */
    public String uploadFile(MultipartFile file, String pathPrefix) {
        return uploadFile(file, pathPrefix, null);
    }

    /**
     * 上传文件（带路径前缀和分类）
     */
    public String uploadFile(MultipartFile file, String pathPrefix, String category) {
        try {
            FileUploadRequest request = FileUploadRequest.fromMultipartFile(file);
            request.setPathPrefix(pathPrefix);
            request.setCategory(category);

            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.upload(request);
        } catch (Exception e) {
            log.error("上传文件失败: {}", e.getMessage(), e);
            throw new RuntimeException("上传文件失败", e);
        }
    }

    /**
     * 上传文件流
     */
    public String uploadFile(InputStream inputStream, String fileName, long fileSize, String contentType) {
        return uploadFile(inputStream, fileName, fileSize, contentType, null, null);
    }

    /**
     * 上传文件流（带路径前缀和分类）
     */
    public String uploadFile(InputStream inputStream, String fileName, long fileSize, String contentType,
                           String pathPrefix, String category) {
        try {
            FileUploadRequest request = FileUploadRequest.fromInputStream(inputStream, fileName, fileSize, contentType);
            request.setPathPrefix(pathPrefix);
            request.setCategory(category);

            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.upload(request);
        } catch (Exception e) {
            log.error("上传文件失败: {}", e.getMessage(), e);
            throw new RuntimeException("上传文件失败", e);
        }
    }

    /**
     * 下载文件
     */
    public InputStream downloadFile(String fileKey) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.download(fileKey);
        } catch (Exception e) {
            log.error("下载文件失败: {}", e.getMessage(), e);
            throw new RuntimeException("下载文件失败", e);
        }
    }

    /**
     * 删除文件
     */
    public boolean deleteFile(String fileKey) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.delete(fileKey);
        } catch (Exception e) {
            log.error("删除文件失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 批量删除文件
     */
    public int deleteFiles(List<String> fileKeys) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.deleteBatch(fileKeys);
        } catch (Exception e) {
            log.error("批量删除文件失败: {}", e.getMessage(), e);
            return 0;
        }
    }

    /**
     * 获取文件信息
     */
    public FileInfo getFileInfo(String fileKey) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.getFileInfo(fileKey);
        } catch (Exception e) {
            log.error("获取文件信息失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 检查文件是否存在
     */
    public boolean fileExists(String fileKey) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.exists(fileKey);
        } catch (Exception e) {
            log.error("检查文件是否存在失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 获取文件访问URL
     */
    public String getFileUrl(String fileKey) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.getFileUrl(fileKey);
        } catch (Exception e) {
            log.error("获取文件URL失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 获取带过期时间的文件访问URL
     */
    public String getFileUrl(String fileKey, int expireSeconds) {
        try {
            StorageService storageService = storageServiceFactory.getStorageService();
            return storageService.getFileUrl(fileKey, expireSeconds);
        } catch (Exception e) {
            log.error("获取文件URL失败: {}", e.getMessage(), e);
            return null;
        }
    }
}
