package com.wmt.framework.file.core.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 文件解压结果
 */
@Data
public class DecompressResult {

    /**
     * 解压是否成功
     */
    private boolean success;

    /**
     * 解压出的文件列表
     */
    private List<DecompressedFile> files;

    /**
     * 解压出的文件数量
     */
    private int fileCount;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 解压耗时（毫秒）
     */
    private long decompressTime;

    /**
     * 解压时间
     */
    private LocalDateTime decompressDateTime;

    /**
     * 解压参数
     */
    private Map<String, Object> parameters;

    /**
     * 解压出的文件信息
     */
    @Data
    public static class DecompressedFile {
        /**
         * 文件名
         */
        private String fileName;

        /**
         * 文件路径
         */
        private String filePath;

        /**
         * 文件大小
         */
        private long fileSize;

        /**
         * 文件类型
         */
        private String fileType;

        /**
         * 文件内容（字节数组）
         */
        private byte[] content;
    }

    /**
     * 创建成功结果
     */
    public static DecompressResult success(List<DecompressedFile> files) {
        DecompressResult result = new DecompressResult();
        result.setSuccess(true);
        result.setFiles(files);
        result.setFileCount(files.size());
        result.setDecompressDateTime(LocalDateTime.now());
        return result;
    }

    /**
     * 创建失败结果
     */
    public static DecompressResult failure(String errorMessage) {
        DecompressResult result = new DecompressResult();
        result.setSuccess(false);
        result.setErrorMessage(errorMessage);
        result.setDecompressDateTime(LocalDateTime.now());
        return result;
    }
}
