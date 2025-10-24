package com.wmt.framework.storage.core;

import java.io.InputStream;
import java.util.List;

/**
 * 统一存储服务接口
 * 支持多种存储方式：本地存储、MinIO、阿里云OSS、腾讯云COS、AWS S3
 */
public interface StorageService {

    /**
     * 上传文件
     * 
     * @param request 文件上传请求
     * @return 文件访问URL或文件标识
     */
    String upload(FileUploadRequest request);

    /**
     * 下载文件
     * 
     * @param fileKey 文件标识
     * @return 文件输入流
     */
    InputStream download(String fileKey);

    /**
     * 删除文件
     * 
     * @param fileKey 文件标识
     * @return 是否删除成功
     */
    boolean delete(String fileKey);

    /**
     * 批量删除文件
     * 
     * @param fileKeys 文件标识列表
     * @return 删除成功的文件数量
     */
    int deleteBatch(List<String> fileKeys);

    /**
     * 获取文件信息
     * 
     * @param fileKey 文件标识
     * @return 文件信息
     */
    FileInfo getFileInfo(String fileKey);

    /**
     * 检查文件是否存在
     * 
     * @param fileKey 文件标识
     * @return 文件是否存在
     */
    boolean exists(String fileKey);

    /**
     * 获取文件访问URL
     * 
     * @param fileKey 文件标识
     * @return 文件访问URL
     */
    String getFileUrl(String fileKey);

    /**
     * 获取带过期时间的文件访问URL
     * 
     * @param fileKey 文件标识
     * @param expireSeconds 过期时间（秒）
     * @return 文件访问URL
     */
    String getFileUrl(String fileKey, int expireSeconds);
}
