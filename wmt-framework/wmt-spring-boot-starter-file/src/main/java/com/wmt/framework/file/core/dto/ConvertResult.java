package com.wmt.framework.file.core.dto;

import lombok.Data;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * 文件转换结果
 */
@Data
public class ConvertResult {

    /**
     * 转换是否成功
     */
    private boolean success;

    /**
     * 转换后的文件流
     */
    private InputStream targetStream;

    /**
     * 目标文件名
     */
    private String targetFileName;

    /**
     * 目标文件大小
     */
    private long targetFileSize;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 转换耗时（毫秒）
     */
    private long convertTime;

    /**
     * 转换时间
     */
    private LocalDateTime convertDateTime;

    /**
     * 转换参数
     */
    private Map<String, Object> parameters;

    /**
     * 创建成功结果
     */
    public static ConvertResult success(InputStream targetStream, String targetFileName, long targetFileSize) {
        ConvertResult result = new ConvertResult();
        result.setSuccess(true);
        result.setTargetStream(targetStream);
        result.setTargetFileName(targetFileName);
        result.setTargetFileSize(targetFileSize);
        result.setConvertDateTime(LocalDateTime.now());
        return result;
    }

    /**
     * 创建失败结果
     */
    public static ConvertResult failure(String errorMessage) {
        ConvertResult result = new ConvertResult();
        result.setSuccess(false);
        result.setErrorMessage(errorMessage);
        result.setConvertDateTime(LocalDateTime.now());
        return result;
    }
}
