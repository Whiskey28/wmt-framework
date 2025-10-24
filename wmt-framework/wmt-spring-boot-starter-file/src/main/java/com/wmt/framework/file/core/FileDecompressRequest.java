package com.wmt.framework.file.core;

import lombok.Data;

import java.io.InputStream;
import java.util.Map;

/**
 * 文件解压请求
 */
@Data
public class FileDecompressRequest {

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
     * 压缩格式
     */
    private String format;

    /**
     * 解压密码
     */
    private String password;

    /**
     * 解压参数
     */
    private Map<String, Object> parameters;

    /**
     * 是否解压到指定目录
     */
    private boolean extractToDirectory = false;

    /**
     * 解压目录路径
     */
    private String extractPath;

    /**
     * 创建解压请求
     */
    public static FileDecompressRequest create(InputStream compressStream, String compressFileName, String format) {
        FileDecompressRequest request = new FileDecompressRequest();
        request.setCompressStream(compressStream);
        request.setCompressFileName(compressFileName);
        request.setFormat(format);
        return request;
    }
}
