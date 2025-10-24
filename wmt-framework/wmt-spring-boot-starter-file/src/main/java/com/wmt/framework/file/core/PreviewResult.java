package com.wmt.framework.file.core;

import lombok.Data;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * 文件预览结果
 */
@Data
public class PreviewResult {

    /**
     * 预览是否成功
     */
    private boolean success;

    /**
     * 预览文件流
     */
    private InputStream previewStream;

    /**
     * 预览文件名
     */
    private String previewFileName;

    /**
     * 预览文件类型
     */
    private String previewFileType;

    /**
     * 预览文件大小
     */
    private long previewFileSize;

    /**
     * 缩略图流
     */
    private InputStream thumbnailStream;

    /**
     * 缩略图文件名
     */
    private String thumbnailFileName;

    /**
     * 缩略图大小
     */
    private long thumbnailSize;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 预览耗时（毫秒）
     */
    private long previewTime;

    /**
     * 预览时间
     */
    private LocalDateTime previewDateTime;

    /**
     * 预览参数
     */
    private Map<String, Object> parameters;

    /**
     * 创建成功结果
     */
    public static PreviewResult success(InputStream previewStream, String previewFileName, 
                                       String previewFileType, long previewFileSize) {
        PreviewResult result = new PreviewResult();
        result.setSuccess(true);
        result.setPreviewStream(previewStream);
        result.setPreviewFileName(previewFileName);
        result.setPreviewFileType(previewFileType);
        result.setPreviewFileSize(previewFileSize);
        result.setPreviewDateTime(LocalDateTime.now());
        return result;
    }

    /**
     * 创建失败结果
     */
    public static PreviewResult failure(String errorMessage) {
        PreviewResult result = new PreviewResult();
        result.setSuccess(false);
        result.setErrorMessage(errorMessage);
        result.setPreviewDateTime(LocalDateTime.now());
        return result;
    }
}
