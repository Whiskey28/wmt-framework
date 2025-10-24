package com.wmt.framework.storage.core;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 文件信息
 */
@Data
public class FileInfo {

    /**
     * 文件标识
     */
    private String fileKey;

    /**
     * 文件名
     */
    private String fileName;

    /**
     * 文件大小（字节）
     */
    private long fileSize;

    /**
     * 文件类型
     */
    private String contentType;

    /**
     * 文件MD5
     */
    private String md5;

    /**
     * 文件访问URL
     */
    private String url;

    /**
     * 存储路径
     */
    private String path;

    /**
     * 文件分类
     */
    private String category;

    /**
     * 文件标签
     */
    private String tags;

    /**
     * 是否公开访问
     */
    private boolean publicAccess;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;

    /**
     * 元数据
     */
    private Map<String, String> metadata;
}
