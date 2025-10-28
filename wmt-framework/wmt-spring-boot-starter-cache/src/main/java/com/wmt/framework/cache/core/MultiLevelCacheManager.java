package com.wmt.framework.cache.core;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.wmt.framework.cache.config.WmtCacheProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * 多级缓存管理器
 * L1: 本地缓存 (Caffeine)
 * L2: Redis缓存
 * L3: 数据库 (通过回调函数实现)
 *
 * @author Wmt
 */
@Slf4j
@Component
@ConditionalOnProperty(prefix = "wmt.cache.multi-level", name = "enabled", havingValue = "true")
public class MultiLevelCacheManager {

    private final WmtCacheProperties cacheProperties;
    private final RedisTemplate<String, Object> redisTemplate;
    private Cache<String, Object> localCache;

    public MultiLevelCacheManager(WmtCacheProperties cacheProperties, RedisTemplate<String, Object> redisTemplate) {
        this.cacheProperties = cacheProperties;
        this.redisTemplate = redisTemplate;
    }

    @PostConstruct
    public void init() {
        if (cacheProperties.getMultiLevel().getLocal().isEnabled()) {
            WmtCacheProperties.LocalCacheConfig localConfig = cacheProperties.getMultiLevel().getLocal();
            this.localCache = Caffeine.newBuilder()
                    .maximumSize(localConfig.getMaxSize())
                    .expireAfterWrite(localConfig.getTtl())
                    .recordStats()
                    .build();
            log.info("多级缓存本地缓存初始化完成，最大条目数: {}, TTL: {}",
                    localConfig.getMaxSize(), localConfig.getTtl());
        }
    }

    /**
     * 获取缓存值
     *
     * @param key 缓存键
     * @param type 返回值类型
     * @param databaseLoader 数据库加载器
     * @return 缓存值
     */
    public <T> T get(String key, Class<T> type, DatabaseLoader<T> databaseLoader) {
        // L1: 本地缓存
        if (localCache != null) {
            Object value = localCache.getIfPresent(key);
            if (value != null) {
                log.debug("从本地缓存获取数据: {}", key);
                return type.cast(value);
            }
        }

        // L2: Redis缓存
        if (cacheProperties.getMultiLevel().getRedis().isEnabled()) {
            String redisKey = buildRedisKey(key);
            Object value = redisTemplate.opsForValue().get(redisKey);
            if (value != null) {
                log.debug("从Redis缓存获取数据: {}", key);
                // 回写到本地缓存
                if (localCache != null) {
                    localCache.put(key, value);
                }
                return type.cast(value);
            }
        }

        // L3: 数据库
        if (cacheProperties.getMultiLevel().getDatabase().isEnabled()) {
            try {
                T value = databaseLoader.load();
                if (value != null) {
                    log.debug("从数据库获取数据: {}", key);
                    // 回写到Redis缓存
                    if (cacheProperties.getMultiLevel().getRedis().isEnabled()) {
                        String redisKey = buildRedisKey(key);
                        redisTemplate.opsForValue().set(redisKey, value,
                                cacheProperties.getMultiLevel().getRedis().getTtl());
                    }
                    // 回写到本地缓存
                    if (localCache != null) {
                        localCache.put(key, value);
                    }
                    return value;
                } else if (cacheProperties.getMultiLevel().getDatabase().isNullValueProtection()) {
                    // 缓存空值防止缓存穿透
                    Object nullValue = new Object();
                    if (cacheProperties.getMultiLevel().getRedis().isEnabled()) {
                        String redisKey = buildRedisKey(key);
                        redisTemplate.opsForValue().set(redisKey, nullValue,
                                cacheProperties.getMultiLevel().getDatabase().getNullValueTtl());
                    }
                    if (localCache != null) {
                        localCache.put(key, nullValue);
                    }
                }
            } catch (Exception e) {
                log.error("从数据库加载数据失败: {}", key, e);
                throw new RuntimeException("数据库加载失败", e);
            }
        }

        return null;
    }

    /**
     * 设置缓存值
     *
     * @param key 缓存键
     * @param value 缓存值
     */
    public void put(String key, Object value) {
        if (value == null) {
            return;
        }

        // 设置本地缓存
        if (localCache != null) {
            localCache.put(key, value);
        }

        // 设置Redis缓存
        if (cacheProperties.getMultiLevel().getRedis().isEnabled()) {
            String redisKey = buildRedisKey(key);
            redisTemplate.opsForValue().set(redisKey, value,
                    cacheProperties.getMultiLevel().getRedis().getTtl());
        }
    }

    /**
     * 删除缓存
     *
     * @param key 缓存键
     */
    public void evict(String key) {
        // 删除本地缓存
        if (localCache != null) {
            localCache.invalidate(key);
        }

        // 删除Redis缓存
        if (cacheProperties.getMultiLevel().getRedis().isEnabled()) {
            String redisKey = buildRedisKey(key);
            redisTemplate.delete(redisKey);
        }
    }

    /**
     * 清空所有缓存
     */
    public void clear() {
        // 清空本地缓存
        if (localCache != null) {
            localCache.invalidateAll();
        }

        // 清空Redis缓存 (这里只清空当前应用相关的缓存)
        if (cacheProperties.getMultiLevel().getRedis().isEnabled()) {
            String pattern = cacheProperties.getMultiLevel().getRedis().getKeyPrefix() + "*";
            redisTemplate.delete(redisTemplate.keys(pattern));
        }
    }

    /**
     * 构建Redis缓存键
     */
    private String buildRedisKey(String key) {
        return cacheProperties.getMultiLevel().getRedis().getKeyPrefix() + key;
    }

    /**
     * 数据库加载器接口
     */
    @FunctionalInterface
    public interface DatabaseLoader<T> {
        T load() throws Exception;
    }

    /**
     * 获取本地缓存实例
     */
    public Cache<String, Object> getLocalCache() {
        return localCache;
    }

    /**
     * 获取缓存统计信息
     */
    public CacheStats getStats() {
        if (localCache != null) {
            com.github.benmanes.caffeine.cache.stats.CacheStats stats = localCache.stats();
            return new CacheStats(
                    stats.hitCount(),
                    stats.missCount(),
                    stats.requestCount(),
                    stats.hitRate()
            );
        }
        return new CacheStats(0, 0, 0, 0.0);
    }

    /**
     * 缓存统计信息
     */
    public static class CacheStats {
        private final long hitCount;
        private final long missCount;
        private final long requestCount;
        private final double hitRate;

        public CacheStats(long hitCount, long missCount, long requestCount, double hitRate) {
            this.hitCount = hitCount;
            this.missCount = missCount;
            this.requestCount = requestCount;
            this.hitRate = hitRate;
        }

        public long getHitCount() { return hitCount; }
        public long getMissCount() { return missCount; }
        public long getRequestCount() { return requestCount; }
        public double getHitRate() { return hitRate; }
    }
}
