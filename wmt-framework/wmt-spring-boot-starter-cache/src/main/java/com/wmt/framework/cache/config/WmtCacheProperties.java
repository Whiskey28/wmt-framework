package com.wmt.framework.cache.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

/**
 * Cache 配置项
 *
 * @author Wanwan
 */
@ConfigurationProperties("wmt.cache")
@Data
@Validated
public class WmtCacheProperties {

    /**
     * {@link #redisScanBatchSize} 默认值
     */
    private static final Integer REDIS_SCAN_BATCH_SIZE_DEFAULT = 30;

    /**
     * redis scan 一次返回数量
     */
    private Integer redisScanBatchSize = REDIS_SCAN_BATCH_SIZE_DEFAULT;

    /**
     * 多级缓存配置
     */
    private MultiLevelCache multiLevel = new MultiLevelCache();

    @Data
    public static class MultiLevelCache {
        /**
         * 是否启用多级缓存
         */
        private boolean enabled = false;

        /**
         * 本地缓存配置
         */
        private LocalCacheConfig local = new LocalCacheConfig();

        /**
         * Redis缓存配置
         */
        private RedisCacheConfig redis = new RedisCacheConfig();

        /**
         * 数据库缓存配置
         */
        private DatabaseCacheConfig database = new DatabaseCacheConfig();
    }

    @Data
    public static class LocalCacheConfig {
        /**
         * 是否启用本地缓存
         */
        private boolean enabled = true;

        /**
         * 最大缓存条目数
         */
        private long maxSize = 1000;

        /**
         * 缓存过期时间
         */
        private Duration ttl = Duration.ofMinutes(5);

        /**
         * 缓存刷新时间
         */
        private Duration refreshAfterWrite = Duration.ofMinutes(3);
    }

    @Data
    public static class RedisCacheConfig {
        /**
         * 是否启用Redis缓存
         */
        private boolean enabled = true;

        /**
         * 缓存过期时间
         */
        private Duration ttl = Duration.ofHours(1);

        /**
         * 缓存键前缀
         */
        private String keyPrefix = "wmt:cache:";
    }

    @Data
    public static class DatabaseCacheConfig {
        /**
         * 是否启用数据库缓存
         */
        private boolean enabled = true;

        /**
         * 缓存穿透防护
         */
        private boolean nullValueProtection = true;

        /**
         * 空值缓存时间
         */
        private Duration nullValueTtl = Duration.ofMinutes(5);
    }
}
