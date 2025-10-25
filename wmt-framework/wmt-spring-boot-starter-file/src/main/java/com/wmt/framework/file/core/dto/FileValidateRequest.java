package com.wmt.framework.file.core.dto;

import lombok.Data;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

/**
 * 文件校验请求
 */
@Data
public class FileValidateRequest {

    /**
     * 文件流
     */
    private InputStream fileStream;

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
    private String fileType;

    /**
     * 允许的文件类型列表
     */
    private List<String> allowedTypes;

    /**
     * 最大文件大小（字节）
     */
    private Long maxSize;

    /**
     * 最小文件大小（字节）
     */
    private Long minSize;

    /**
     * 是否校验文件内容
     */
    private boolean validateContent = true;

    /**
     * 是否计算文件哈希值
     */
    private boolean calculateHash = true;

    /**
     * 校验参数
     */
    private Map<String, Object> parameters;

    /**
     * 创建校验请求
     */
    public static FileValidateRequest create(InputStream fileStream, String fileName, long fileSize) {
        FileValidateRequest request = new FileValidateRequest();
        request.setFileStream(fileStream);
        request.setFileName(fileName);
        request.setFileSize(fileSize);
        return request;
    }
}
