package com.wmt.framework.file.core;

import lombok.Data;

import java.io.InputStream;
import java.util.Map;

/**
 * 文件转换请求
 */
@Data
public class FileConvertRequest {

    /**
     * 源文件输入流
     */
    private InputStream sourceStream;

    /**
     * 源文件格式
     */
    private String sourceFormat;

    /**
     * 目标文件格式
     */
    private String targetFormat;

    /**
     * 源文件名
     */
    private String sourceFileName;

    /**
     * 目标文件名
     */
    private String targetFileName;

    /**
     * 转换参数
     */
    private Map<String, Object> parameters;

    /**
     * 质量设置（1-100）
     */
    private Integer quality;

    /**
     * 页面范围（PDF转换时使用）
     */
    private String pageRange;

    /**
     * 是否保持原始格式
     */
    private boolean keepFormat = true;

    /**
     * 创建转换请求
     */
    public static FileConvertRequest create(InputStream sourceStream, String sourceFormat, String targetFormat) {
        FileConvertRequest request = new FileConvertRequest();
        request.setSourceStream(sourceStream);
        request.setSourceFormat(sourceFormat);
        request.setTargetFormat(targetFormat);
        return request;
    }
}
