package com.wmt.framework.file.core.dto;

import lombok.Data;

import java.io.InputStream;
import java.util.Map;

/**
 * 文件预览请求
 */
@Data
public class FilePreviewRequest {

    /**
     * 文件输入流
     */
    private InputStream fileStream;

    /**
     * 文件名
     */
    private String fileName;

    /**
     * 文件类型
     */
    private String fileType;

    /**
     * 文件大小
     */
    private long fileSize;

    /**
     * 预览参数
     */
    private Map<String, Object> parameters;

    /**
     * 预览质量（1-100）
     */
    private Integer quality = 80;

    /**
     * 预览尺寸（宽度）
     */
    private Integer width;

    /**
     * 预览尺寸（高度）
     */
    private Integer height;

    /**
     * 是否生成缩略图
     */
    private boolean thumbnail = false;

    /**
     * 创建预览请求
     */
    public static FilePreviewRequest create(InputStream fileStream, String fileName, String fileType) {
        FilePreviewRequest request = new FilePreviewRequest();
        request.setFileStream(fileStream);
        request.setFileName(fileName);
        request.setFileType(fileType);
        return request;
    }
}
