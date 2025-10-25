package com.wmt.framework.file.core.service;

import com.wmt.framework.file.core.dto.FileValidateRequest;
import com.wmt.framework.file.core.dto.ValidateResult;

import java.io.InputStream;

/**
 * 文件校验服务接口
 * 支持文件类型、大小、内容校验
 */
public interface FileValidateService {

    /**
     * 校验文件
     *
     * @param request 校验请求
     * @return 校验结果
     */
    ValidateResult validate(FileValidateRequest request);

    /**
     * 校验文件类型
     *
     * @param fileStream 文件流
     * @param fileName 文件名
     * @return 文件类型
     */
    String validateFileType(InputStream fileStream, String fileName);

    /**
     * 校验文件大小
     *
     * @param fileSize 文件大小
     * @param maxSize 最大允许大小
     * @return 是否通过校验
     */
    boolean validateFileSize(long fileSize, long maxSize);

    /**
     * 校验文件内容
     *
     * @param fileStream 文件流
     * @param fileName 文件名
     * @return 校验结果
     */
    ValidateResult validateFileContent(InputStream fileStream, String fileName);

    /**
     * 计算文件MD5
     *
     * @param fileStream 文件流
     * @return MD5值
     */
    String calculateMD5(InputStream fileStream);

    /**
     * 计算文件SHA1
     *
     * @param fileStream 文件流
     * @return SHA1值
     */
    String calculateSHA1(InputStream fileStream);
}
