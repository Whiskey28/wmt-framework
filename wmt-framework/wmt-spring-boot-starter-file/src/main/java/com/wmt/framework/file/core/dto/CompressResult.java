package com.wmt.framework.file.core.dto;

import lombok.Data;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * 文件压缩结果
 */
@Data
public class CompressResult {

    /**
     * 压缩是否成功
     */
    private boolean success;

    /**
     * 压缩文件流
     */
    private InputStream compressStream;

    /**
     * 压缩文件名
     */
    private String compressFileName;

    /**
     * 压缩文件大小
     */
    private long compressFileSize;

    /**
     * 压缩率
     */
    private double compressRatio;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 压缩耗时（毫秒）
     */
    private long compressTime;

    /**
     * 压缩时间
     */
    private LocalDateTime compressDateTime;

    /**
     * 压缩参数
     */
    private Map<String, Object> parameters;

    /**
     * 创建成功结果
     */
    public static CompressResult success(InputStream compressStream, String compressFileName,
                                        long compressFileSize, double compressRatio) {
        CompressResult result = new CompressResult();
        result.setSuccess(true);
        result.setCompressStream(compressStream);
        result.setCompressFileName(compressFileName);
        result.setCompressFileSize(compressFileSize);
        result.setCompressRatio(compressRatio);
        result.setCompressDateTime(LocalDateTime.now());
        return result;
    }

    /**
     * 创建失败结果
     */
    public static CompressResult failure(String errorMessage) {
        CompressResult result = new CompressResult();
        result.setSuccess(false);
        result.setErrorMessage(errorMessage);
        result.setCompressDateTime(LocalDateTime.now());
        return result;
    }
}
