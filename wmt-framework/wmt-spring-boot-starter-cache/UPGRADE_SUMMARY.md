# WMT Redis 组件升级总结

## 升级概述

本次升级在现有的 `wmt-spring-boot-starter-cache` 组件中增加了多级缓存功能，实现了L1(本地缓存) + L2(Redis缓存) + L3(数据库)的三级缓存架构。

## 新增功能

### 1. 多级缓存管理器 (MultiLevelCacheManager)
- **L1缓存**: 基于Caffeine的本地缓存，适合热点数据
- **L2缓存**: Redis分布式缓存，适合共享数据
- **L3缓存**: 数据库回调加载，保证数据一致性
- **缓存穿透防护**: 空值缓存机制
- **缓存统计**: 命中率、请求次数等统计信息

### 2. 多级缓存注解 (@MultiLevelCache)
- 支持SpEL表达式的缓存键构建
- 灵活的缓存级别配置
- 条件缓存和更新条件
- 空值缓存防护

### 3. 缓存服务接口 (CacheService)
- 统一的缓存操作API
- 编程式缓存操作
- 缓存统计信息获取

### 4. 配置增强
- 多级缓存配置选项
- 本地缓存配置 (Caffeine)
- Redis缓存配置
- 数据库缓存配置

## 文件结构

```
wmt-spring-boot-starter-cache/
├── src/main/java/com/wmt/framework/redis/
│   ├── annotation/
│   │   └── MultiLevelCache.java          # 多级缓存注解
│   ├── aspect/
│   │   └── MultiLevelCacheAspect.java   # 切面处理器
│   ├── config/
│   │   ├── WmtCacheProperties.java      # 配置类(增强)
│   │   └── WmtCacheAutoConfiguration.java # 自动配置(增强)
│   ├── core/
│   │   └── MultiLevelCacheManager.java  # 多级缓存管理器
│   ├── service/
│   │   ├── CacheService.java            # 缓存服务接口
│   │   └── impl/
│   │       └── CacheServiceImpl.java    # 缓存服务实现
│   └── example/
│       └── CacheExampleService.java     # 使用示例
├── src/main/resources/
│   └── application-cache-example.yml     # 配置示例
├── README.md                             # 使用文档
└── UPGRADE_SUMMARY.md                    # 升级总结
```

## 配置示例

```yaml
wmt:
  cache:
    multi-level:
      enabled: true
      local:
        enabled: true
        max-size: 1000
        ttl: 5m
      redis:
        enabled: true
        ttl: 1h
        key-prefix: "wmt:cache:"
      database:
        enabled: true
        null-value-protection: true
```

## 使用方式

### 1. 注解方式
```java
@MultiLevelCache(key = "#userId", ttl = "1h")
public User getUserById(Long userId) {
    return userRepository.findById(userId);
}
```

### 2. 编程式方式
```java
@Autowired
private CacheService cacheService;

public User getUser(Long userId) {
    return cacheService.get("user:" + userId, User.class, () -> {
        return userRepository.findById(userId);
    });
}
```

### 3. 传统方式 (保持兼容)
```java
@Cacheable(value = "user#1h", key = "#userId")
public User getUserById(Long userId) {
    return userRepository.findById(userId);
}
```

## 依赖更新

新增依赖：
- `caffeine`: 本地缓存支持
- `spring-aspects`: AOP切面支持

## 向后兼容性

- ✅ 保持原有Redis功能不变
- ✅ 保持原有Spring Cache注解支持
- ✅ 保持原有配置方式
- ✅ 多级缓存功能通过配置开关控制

## 性能优化

1. **本地缓存**: 减少Redis网络开销，提升响应速度
2. **缓存穿透防护**: 避免大量无效请求打到数据库
3. **缓存统计**: 便于监控和调优
4. **灵活配置**: 可根据业务场景调整缓存策略

## 最佳实践

1. **热点数据**: 使用本地缓存，TTL设置较短
2. **共享数据**: 使用Redis缓存，TTL设置较长
3. **冷数据**: 直接从数据库加载
4. **缓存更新**: 及时清理相关缓存
5. **监控告警**: 关注缓存命中率

## 注意事项

1. 多级缓存需要设置 `wmt.cache.multi-level.enabled=true`
2. 本地缓存适合单机部署，集群环境建议关闭
3. 注意本地缓存的内存使用，避免OOM
4. 合理配置各级缓存的TTL和容量

## 测试建议

1. 单元测试：测试缓存逻辑
2. 集成测试：测试多级缓存协作
3. 性能测试：测试缓存性能提升
4. 压力测试：测试缓存穿透防护效果
