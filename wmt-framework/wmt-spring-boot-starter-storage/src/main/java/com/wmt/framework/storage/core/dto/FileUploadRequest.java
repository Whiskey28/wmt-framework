package com.wmt.framework.storage.core.dto;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;

/**
 * 文件上传请求
 */
@Data
public class FileUploadRequest {

    /**
     * 文件输入流
     */
    private InputStream inputStream;

    /**
     * 文件名
     */
    private String fileName;

    /**
     * 文件大小
     */
    private long fileSize;

    /**
     * 文件类型
     */
    private String contentType;

    /**
     * 存储路径前缀
     */
    private String pathPrefix;

    /**
     * 文件分类
     */
    private String category;

    /**
     * 文件标签
     */
    private String tags;

    /**
     * 是否公开访问
     */
    private boolean publicAccess = false;

    /**
     * 元数据
     */
    private java.util.Map<String, String> metadata;

    /**
     * 从MultipartFile创建上传请求
     */
    public static FileUploadRequest fromMultipartFile(MultipartFile file) {
        try {
            FileUploadRequest request = new FileUploadRequest();
            request.setInputStream(file.getInputStream());
            request.setFileName(file.getOriginalFilename());
            request.setFileSize(file.getSize());
            request.setContentType(file.getContentType());
            return request;
        } catch (Exception e) {
            throw new RuntimeException("创建文件上传请求失败", e);
        }
    }

    /**
     * 从InputStream创建上传请求
     */
    public static FileUploadRequest fromInputStream(InputStream inputStream, String fileName, long fileSize, String contentType) {
        FileUploadRequest request = new FileUploadRequest();
        request.setInputStream(inputStream);
        request.setFileName(fileName);
        request.setFileSize(fileSize);
        request.setContentType(contentType);
        return request;
    }
}
