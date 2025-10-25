package com.wmt.framework.file.core.dto;

import lombok.Data;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

/**
 * 文件压缩请求
 */
@Data
public class FileCompressRequest {

    /**
     * 要压缩的文件列表
     */
    private List<CompressFile> files;

    /**
     * 压缩格式（zip, rar, 7z等）
     */
    private String format = "zip";

    /**
     * 压缩级别（1-9）
     */
    private int level = 6;

    /**
     * 压缩文件名
     */
    private String compressFileName;

    /**
     * 压缩参数
     */
    private Map<String, Object> parameters;

    /**
     * 是否加密
     */
    private boolean encrypted = false;

    /**
     * 加密密码
     */
    private String password;

    /**
     * 压缩文件信息
     */
    @Data
    public static class CompressFile {
        /**
         * 文件名
         */
        private String fileName;

        /**
         * 文件流
         */
        private InputStream fileStream;

        /**
         * 文件大小
         */
        private long fileSize;

        /**
         * 在压缩包中的路径
         */
        private String pathInArchive;

        /**
         * 创建压缩文件
         */
        public static CompressFile create(String fileName, InputStream fileStream, long fileSize) {
            CompressFile file = new CompressFile();
            file.setFileName(fileName);
            file.setFileStream(fileStream);
            file.setFileSize(fileSize);
            file.setPathInArchive(fileName);
            return file;
        }
    }
}
