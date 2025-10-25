package com.wmt.framework.cache.service;

import com.wmt.framework.cache.core.MultiLevelCacheManager;

/**
 * 缓存服务接口
 * 提供统一的缓存操作API
 *
 * @author Wmt
 */
public interface CacheService {

    /**
     * 获取缓存值
     *
     * @param key 缓存键
     * @param type 返回值类型
     * @param databaseLoader 数据库加载器
     * @return 缓存值
     */
    <T> T get(String key, Class<T> type, MultiLevelCacheManager.DatabaseLoader<T> databaseLoader);

    /**
     * 设置缓存值
     *
     * @param key 缓存键
     * @param value 缓存值
     */
    void put(String key, Object value);

    /**
     * 删除缓存
     *
     * @param key 缓存键
     */
    void evict(String key);

    /**
     * 清空所有缓存
     */
    void clear();

    /**
     * 获取缓存统计信息
     *
     * @return 缓存统计信息
     */
    MultiLevelCacheManager.CacheStats getStats();

    /**
     * 检查缓存是否存在
     *
     * @param key 缓存键
     * @return 是否存在
     */
    boolean exists(String key);

    /**
     * 设置缓存值并指定过期时间
     *
     * @param key 缓存键
     * @param value 缓存值
     * @param ttlSeconds 过期时间(秒)
     */
    void put(String key, Object value, long ttlSeconds);
}
