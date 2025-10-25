package com.wmt.framework.cache.example;

import com.wmt.framework.cache.annotation.MultiLevelCache;
import com.wmt.framework.cache.service.CacheService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

/**
 * 缓存使用示例
 *
 * @author Wmt
 */
@Slf4j
@Service
public class CacheExampleService {

    @Autowired
    private CacheService cacheService;

    /**
     * 示例1: 使用多级缓存注解
     */
    @MultiLevelCache(
        key = "#userId",
        levels = {"local", "redis", "database"},
        ttl = "1h",
        condition = "#userId > 0"
    )
    public String getUserInfo(Long userId) {
        log.info("从数据库查询用户信息: {}", userId);
        // 模拟数据库查询
        try {
            TimeUnit.MILLISECONDS.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return "User-" + userId;
    }

    /**
     * 示例2: 使用传统Spring Cache注解
     */
    @Cacheable(value = "user#30m", key = "#userId")
    public String getUserName(Long userId) {
        log.info("从数据库查询用户名: {}", userId);
        return "UserName-" + userId;
    }

    /**
     * 示例3: 使用编程式缓存
     */
    public String getUserEmail(Long userId) {
        return cacheService.get("user:email:" + userId, String.class, () -> {
            log.info("从数据库查询用户邮箱: {}", userId);
            return "user" + userId + "@example.com";
        });
    }

    /**
     * 示例4: 缓存空值防护
     */
    @MultiLevelCache(
        key = "#name",
        ttl = "30m",
        cacheNull = true
    )
    public String findUserByName(String name) {
        log.info("从数据库查询用户: {}", name);
        // 模拟查询结果可能为空
        if ("empty".equals(name)) {
            return null;
        }
        return "User-" + name;
    }

    /**
     * 示例5: 条件缓存
     */
    @MultiLevelCache(
        key = "#userId",
        ttl = "1h",
        condition = "#userId > 100",
        unless = "#result == null"
    )
    public String getVIPUser(Long userId) {
        log.info("从数据库查询VIP用户: {}", userId);
        if (userId < 100) {
            return null;
        }
        return "VIP-User-" + userId;
    }

    /**
     * 示例6: 手动缓存操作
     */
    public void updateUser(Long userId, String userInfo) {
        log.info("更新用户信息: {} -> {}", userId, userInfo);
        
        // 更新缓存
        cacheService.put("user:" + userId, userInfo);
        
        // 或者清除缓存
        cacheService.evict("user:" + userId);
    }

    /**
     * 示例7: 获取缓存统计信息
     */
    public void printCacheStats() {
        com.wmt.framework.cache.core.MultiLevelCacheManager.CacheStats stats = cacheService.getStats();
        log.info("缓存统计 - 命中次数: {}, 未命中次数: {}, 总请求次数: {}, 命中率: {:.2f}%",
                stats.getHitCount(),
                stats.getMissCount(),
                stats.getRequestCount(),
                stats.getHitRate() * 100);
    }
}
