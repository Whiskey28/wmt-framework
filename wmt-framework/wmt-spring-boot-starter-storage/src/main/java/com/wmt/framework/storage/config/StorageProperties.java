package com.wmt.framework.storage.config;

import com.wmt.framework.storage.core.enums.StorageType;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 存储配置属性
 */
@Data
@ConfigurationProperties(prefix = "wmt.storage")
public class StorageProperties {

    /**
     * 存储类型
     */
    private StorageType type = StorageType.LOCAL;

    /**
     * 本地存储配置
     */
    private LocalStorageConfig local = new LocalStorageConfig();

    /**
     * MinIO配置
     */
    private MinioConfig minio = new MinioConfig();

    /**
     * 本地存储配置
     */
    @Data
    public static class LocalStorageConfig {
        /**
         * 存储根路径
         */
        private String rootPath = "uploads";

        /**
         * 访问URL前缀
         */
        private String urlPrefix = "/files";

        /**
         * 是否按日期分目录存储
         */
        private boolean datePath = true;

        /**
         * 是否按文件类型分目录存储
         */
        private boolean typePath = true;
    }

    /**
     * MinIO配置
     */
    @Data
    public static class MinioConfig {
        /**
         * MinIO服务地址
         */
        private String endpoint;

        /**
         * 访问密钥
         */
        private String accessKey;

        /**
         * 秘密密钥
         */
        private String secretKey;

        /**
         * 存储桶名称
         */
        private String bucketName = "wmt-files";

        /**
         * 访问URL前缀
         */
        private String urlPrefix;

        /**
         * 是否使用HTTPS
         */
        private boolean secure = false;

        /**
         * 连接超时时间（毫秒）
         */
        private int connectTimeout = 10000;

        /**
         * 读取超时时间（毫秒）
         */
        private int readTimeout = 10000;
    }
}
