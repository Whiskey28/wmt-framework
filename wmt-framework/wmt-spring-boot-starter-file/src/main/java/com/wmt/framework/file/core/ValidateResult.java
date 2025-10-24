package com.wmt.framework.file.core;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 文件校验结果
 */
@Data
public class ValidateResult {

    /**
     * 校验是否通过
     */
    private boolean valid;

    /**
     * 文件类型
     */
    private String fileType;

    /**
     * 文件大小
     */
    private long fileSize;

    /**
     * 文件MD5
     */
    private String md5;

    /**
     * 文件SHA1
     */
    private String sha1;

    /**
     * 错误信息列表
     */
    private List<String> errors;

    /**
     * 警告信息列表
     */
    private List<String> warnings;

    /**
     * 校验耗时（毫秒）
     */
    private long validateTime;

    /**
     * 校验时间
     */
    private LocalDateTime validateDateTime;

    /**
     * 校验参数
     */
    private Map<String, Object> parameters;

    /**
     * 创建通过结果
     */
    public static ValidateResult valid(String fileType, long fileSize, String md5, String sha1) {
        ValidateResult result = new ValidateResult();
        result.setValid(true);
        result.setFileType(fileType);
        result.setFileSize(fileSize);
        result.setMd5(md5);
        result.setSha1(sha1);
        result.setValidateDateTime(LocalDateTime.now());
        return result;
    }

    /**
     * 创建失败结果
     */
    public static ValidateResult invalid(List<String> errors) {
        ValidateResult result = new ValidateResult();
        result.setValid(false);
        result.setErrors(errors);
        result.setValidateDateTime(LocalDateTime.now());
        return result;
    }
}
