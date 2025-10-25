# WMT Redis 组件

WMT Redis 组件提供了完整的Redis缓存解决方案，支持直连Redis和多级缓存两种模式。

## 功能特性

### 1. 基础Redis功能
- RedisTemplate配置和序列化
- 支持JSON序列化，包括LocalDateTime等时间类型
- Redisson集成，支持分布式锁
- Spring Cache集成，支持@Cacheable注解

### 2. 多级缓存（新增）
- **L1缓存**: 本地缓存（Caffeine）
- **L2缓存**: Redis缓存
- **L3缓存**: 数据库（通过回调函数）
- 缓存穿透防护
- 缓存统计信息
- 灵活的配置选项

## 配置说明

### 基础Redis配置

```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password: 
    database: 0
    timeout: 2000ms
    lettuce:
      pool:
        max-active: 8
        max-wait: -1ms
        max-idle: 8
        min-idle: 0

# WMT缓存配置
wmt:
  cache:
    # Redis扫描批次大小
    redis-scan-batch-size: 30
    # 多级缓存配置
    multi-level:
      enabled: true  # 是否启用多级缓存
      local:
        enabled: true
        max-size: 1000
        ttl: 5m
        refresh-after-write: 3m
      redis:
        enabled: true
        ttl: 1h
        key-prefix: "wmt:cache:"
      database:
        enabled: true
        null-value-protection: true
        null-value-ttl: 5m
```

## 使用方式

### 1. 传统Redis使用方式

```java
@Service
public class UserService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public void setUser(String key, User user) {
        redisTemplate.opsForValue().set(key, user);
    }
    
    public User getUser(String key) {
        return (User) redisTemplate.opsForValue().get(key);
    }
}
```

### 2. Spring Cache注解方式

```java
@Service
public class UserService {
    
    @Cacheable(value = "user#1h", key = "#userId")
    public User getUserById(Long userId) {
        // 从数据库查询用户
        return userRepository.findById(userId);
    }
    
    @CacheEvict(value = "user", key = "#user.id")
    public void updateUser(User user) {
        userRepository.save(user);
    }
}
```

### 3. 多级缓存注解方式（新增）

```java
@Service
public class UserService {
    
    @MultiLevelCache(
        key = "#userId", 
        levels = {"local", "redis", "database"},
        ttl = "1h",
        condition = "#userId > 0"
    )
    public User getUserById(Long userId) {
        // 从数据库查询用户
        return userRepository.findById(userId);
    }
    
    @MultiLevelCache(
        key = "#user.id + ':' + #user.name",
        ttl = "30m",
        cacheNull = true
    )
    public User getUserByName(String name) {
        return userRepository.findByName(name);
    }
}
```

### 4. 编程式多级缓存

```java
@Service
public class UserService {
    
    @Autowired
    private CacheService cacheService;
    
    public User getUserById(Long userId) {
        return cacheService.get("user:" + userId, User.class, () -> {
            // 从数据库查询
            return userRepository.findById(userId);
        });
    }
    
    public void updateUser(User user) {
        // 更新数据库
        userRepository.save(user);
        // 清除缓存
        cacheService.evict("user:" + user.getId());
    }
}
```

## 缓存策略说明

### 多级缓存工作流程

1. **L1缓存（本地缓存）**: 最快，但容量有限，适合热点数据
2. **L2缓存（Redis缓存）**: 容量大，支持分布式，适合共享数据
3. **L3缓存（数据库）**: 数据源，通过回调函数加载

### 缓存穿透防护

当数据库查询返回null时，会缓存一个特殊值，防止缓存穿透攻击。

### 缓存统计

```java
@Autowired
private CacheService cacheService;

public void printCacheStats() {
    MultiLevelCacheManager.CacheStats stats = cacheService.getStats();
    System.out.println("命中次数: " + stats.getHitCount());
    System.out.println("未命中次数: " + stats.getMissCount());
    System.out.println("命中率: " + stats.getHitRate());
}
```

## 依赖说明

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-cache</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

## 注意事项

1. **多级缓存启用**: 需要设置`wmt.cache.multi-level.enabled=true`
2. **本地缓存**: 基于Caffeine实现，适合单机部署
3. **Redis缓存**: 支持集群模式，适合分布式部署
4. **性能优化**: 合理配置各级缓存的TTL和容量
5. **内存管理**: 注意本地缓存的内存使用，避免OOM

## 最佳实践

1. **热点数据**: 使用本地缓存，TTL设置较短
2. **共享数据**: 使用Redis缓存，TTL设置较长
3. **冷数据**: 直接从数据库加载
4. **缓存更新**: 及时清理相关缓存，保证数据一致性
5. **监控告警**: 关注缓存命中率和性能指标
