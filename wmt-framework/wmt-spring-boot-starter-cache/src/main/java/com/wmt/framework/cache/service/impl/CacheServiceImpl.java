package com.wmt.framework.cache.service.impl;

import com.wmt.framework.cache.core.MultiLevelCacheManager;
import com.wmt.framework.cache.service.CacheService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.Duration;

/**
 * 缓存服务实现类
 *
 * @author Wmt
 */
@Slf4j
@Service
@ConditionalOnProperty(prefix = "wmt.cache.multi-level", name = "enabled", havingValue = "true")
public class CacheServiceImpl implements CacheService {

    @Resource
    private MultiLevelCacheManager cacheManager;

    @Resource
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public <T> T get(String key, Class<T> type, MultiLevelCacheManager.DatabaseLoader<T> databaseLoader) {
        return cacheManager.get(key, type, databaseLoader);
    }

    @Override
    public void put(String key, Object value) {
        cacheManager.put(key, value);
    }

    @Override
    public void evict(String key) {
        cacheManager.evict(key);
    }

    @Override
    public void clear() {
        cacheManager.clear();
    }

    @Override
    public MultiLevelCacheManager.CacheStats getStats() {
        return cacheManager.getStats();
    }

    @Override
    public boolean exists(String key) {
        // 检查本地缓存
        if (cacheManager.getLocalCache() != null) {
            Object value = cacheManager.getLocalCache().getIfPresent(key);
            if (value != null) {
                return true;
            }
        }

        // 检查Redis缓存
        try {
            Boolean exists = redisTemplate.hasKey(key);
            return exists != null && exists;
        } catch (Exception e) {
            log.warn("检查Redis缓存存在性失败: {}", key, e);
            return false;
        }
    }

    @Override
    public void put(String key, Object value, long ttlSeconds) {
        if (value == null) {
            return;
        }

        // 设置本地缓存
        if (cacheManager.getLocalCache() != null) {
            cacheManager.getLocalCache().put(key, value);
        }

        // 设置Redis缓存
        try {
            redisTemplate.opsForValue().set(key, value, Duration.ofSeconds(ttlSeconds));
        } catch (Exception e) {
            log.warn("设置Redis缓存失败: {}", key, e);
        }
    }
}
