# WMT Redis Starter

基于Redisson的Redis操作组件，提供Redis连接、缓存、分布式锁等功能。

## 功能特性

- 🔴 **Redis连接**: 基于Redisson的Redis连接管理
- 💾 **缓存支持**: 支持Spring Cache注解和手动缓存操作
- 🔒 **分布式锁**: 基于Redisson的分布式锁
- 📊 **数据序列化**: 支持JSON序列化，自动处理数据类型转换
- 🔄 **连接池**: 支持Redis连接池配置
- 🛡️ **故障转移**: 支持Redis故障转移和重连
- 📝 **监控统计**: 提供Redis连接和操作统计
- 🔧 **配置灵活**: 支持多种Redis配置方式

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-redis</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password: password
    database: 0
    timeout: 3000
    lettuce:
      pool:
        max-active: 8
        max-idle: 8
        min-idle: 0
        max-wait: -1

# Redisson配置
redisson:
  single-server-config:
    address: redis://localhost:6379
    password: password
    database: 0
    connection-pool-size: 64
    connection-minimum-idle-size: 10
    idle-connection-timeout: 10000
    connect-timeout: 10000
    timeout: 3000
```

### 3. 使用RedisTemplate

```java
@Service
public class UserService {
    
    @Resource
    private RedisTemplate<String, Object> redisTemplate;
    
    /**
     * 设置缓存
     */
    public void setUserCache(Long userId, UserDO user) {
        String key = "user:" + userId;
        redisTemplate.opsForValue().set(key, user, 3600, TimeUnit.SECONDS);
    }
    
    /**
     * 获取缓存
     */
    public UserDO getUserCache(Long userId) {
        String key = "user:" + userId;
        return (UserDO) redisTemplate.opsForValue().get(key);
    }
    
    /**
     * 删除缓存
     */
    public void deleteUserCache(Long userId) {
        String key = "user:" + userId;
        redisTemplate.delete(key);
    }
}
```

### 4. 使用Spring Cache

```java
@Service
public class UserService {
    
    @Cacheable(value = "user", key = "#userId")
    public UserDO getUserById(Long userId) {
        // 查询数据库
        return userMapper.selectById(userId);
    }
    
    @CacheEvict(value = "user", key = "#user.id")
    public void updateUser(UserDO user) {
        // 更新数据库
        userMapper.updateById(user);
    }
    
    @CacheEvict(value = "user", allEntries = true)
    public void clearUserCache() {
        // 清空所有用户缓存
    }
}
```

### 5. 使用分布式锁

```java
@Service
public class UserService {
    
    @Resource
    private RedissonClient redissonClient;
    
    /**
     * 使用分布式锁
     */
    public void updateUserWithLock(Long userId, UserUpdateReqVO reqVO) {
        String lockKey = "user:update:" + userId;
        RLock lock = redissonClient.getLock(lockKey);
        
        try {
            // 尝试获取锁，最多等待3秒，锁定10秒
            if (lock.tryLock(3, 10, TimeUnit.SECONDS)) {
                // 执行业务逻辑
                UserDO user = userMapper.selectById(userId);
                BeanUtils.copyProperties(reqVO, user);
                userMapper.updateById(user);
            } else {
                throw new ServiceException("获取锁失败");
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ServiceException("获取锁被中断");
        } finally {
            // 释放锁
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
}
```

### 6. 使用RedissonClient

```java
@Service
public class UserService {
    
    @Resource
    private RedissonClient redissonClient;
    
    /**
     * 使用Redisson操作Redis
     */
    public void setUserData(Long userId, UserDO user) {
        String key = "user:data:" + userId;
        RBucket<UserDO> bucket = redissonClient.getBucket(key);
        bucket.set(user, 3600, TimeUnit.SECONDS);
    }
    
    /**
     * 获取用户数据
     */
    public UserDO getUserData(Long userId) {
        String key = "user:data:" + userId;
        RBucket<UserDO> bucket = redissonClient.getBucket(key);
        return bucket.get();
    }
    
    /**
     * 使用Map操作
     */
    public void setUserMap(Long userId, Map<String, Object> data) {
        String key = "user:map:" + userId;
        RMap<String, Object> map = redissonClient.getMap(key);
        map.putAll(data);
        map.expire(3600, TimeUnit.SECONDS);
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `spring.redis.host` | String | localhost | Redis主机地址 |
| `spring.redis.port` | int | 6379 | Redis端口 |
| `spring.redis.password` | String | - | Redis密码 |
| `spring.redis.database` | int | 0 | Redis数据库索引 |
| `spring.redis.timeout` | int | 3000 | 连接超时时间（毫秒） |

### Redisson配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `redisson.single-server-config.address` | String | - | Redis服务器地址 |
| `redisson.single-server-config.password` | String | - | Redis密码 |
| `redisson.single-server-config.database` | int | 0 | Redis数据库索引 |
| `redisson.single-server-config.connection-pool-size` | int | 64 | 连接池大小 |
| `redisson.single-server-config.connection-minimum-idle-size` | int | 10 | 最小空闲连接数 |

### 缓存配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.redis.cache.default-expire-time` | long | 3600 | 默认过期时间（秒） |
| `wmt.redis.cache.key-prefix` | String | wmt: | 缓存键前缀 |

## 核心功能

### RedisTemplate配置

#### WmtRedisAutoConfiguration

Redis自动配置类：

```java
@AutoConfiguration(before = RedissonAutoConfiguration.class)
public class WmtRedisAutoConfiguration {
    
    /**
     * 创建RedisTemplate Bean，使用JSON序列化方式
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        
        // 使用String序列化方式，序列化KEY
        template.setKeySerializer(RedisSerializer.string());
        template.setHashKeySerializer(RedisSerializer.string());
        
        // 使用JSON序列化方式，序列化VALUE
        template.setValueSerializer(buildRedisSerializer());
        template.setHashValueSerializer(buildRedisSerializer());
        
        return template;
    }
    
    /**
     * 构建Redis序列化器
     */
    public static RedisSerializer<?> buildRedisSerializer() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        return new GenericJackson2JsonRedisSerializer(objectMapper);
    }
}
```

#### 使用RedisTemplate

```java
@Service
public class UserService {
    
    @Resource
    private RedisTemplate<String, Object> redisTemplate;
    
    /**
     * 设置缓存
     */
    public void setUserCache(Long userId, UserDO user) {
        String key = "user:" + userId;
        redisTemplate.opsForValue().set(key, user, 3600, TimeUnit.SECONDS);
    }
    
    /**
     * 获取缓存
     */
    public UserDO getUserCache(Long userId) {
        String key = "user:" + userId;
        return (UserDO) redisTemplate.opsForValue().get(key);
    }
    
    /**
     * 删除缓存
     */
    public void deleteUserCache(Long userId) {
        String key = "user:" + userId;
        redisTemplate.delete(key);
    }
    
    /**
     * 使用Hash操作
     */
    public void setUserHash(Long userId, Map<String, Object> data) {
        String key = "user:hash:" + userId;
        redisTemplate.opsForHash().putAll(key, data);
        redisTemplate.expire(key, 3600, TimeUnit.SECONDS);
    }
    
    /**
     * 获取Hash数据
     */
    public Map<Object, Object> getUserHash(Long userId) {
        String key = "user:hash:" + userId;
        return redisTemplate.opsForHash().entries(key);
    }
}
```

### 缓存配置

#### WmtCacheAutoConfiguration

缓存自动配置类：

```java
@AutoConfiguration
@EnableConfigurationProperties(CacheProperties.class)
@EnableCaching
public class WmtCacheAutoConfiguration {
    
    /**
     * 创建Redis缓存管理器
     */
    @Bean
    @Primary
    public RedisCacheManager redisCacheManager(RedisConnectionFactory factory, CacheProperties cacheProperties) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofSeconds(cacheProperties.getDefaultExpireTime()))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(RedisSerializer.string()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(buildRedisSerializer()));
        
        return RedisCacheManager.builder(factory)
                .cacheDefaults(config)
                .build();
    }
}
```

#### 使用Spring Cache

```java
@Service
public class UserService {
    
    @Cacheable(value = "user", key = "#userId")
    public UserDO getUserById(Long userId) {
        // 查询数据库
        return userMapper.selectById(userId);
    }
    
    @CacheEvict(value = "user", key = "#user.id")
    public void updateUser(UserDO user) {
        // 更新数据库
        userMapper.updateById(user);
    }
    
    @CacheEvict(value = "user", allEntries = true)
    public void clearUserCache() {
        // 清空所有用户缓存
    }
    
    @CachePut(value = "user", key = "#user.id")
    public UserDO saveUser(UserDO user) {
        // 保存用户
        userMapper.insert(user);
        return user;
    }
}
```

### 分布式锁

#### 使用RedissonClient

```java
@Service
public class UserService {
    
    @Resource
    private RedissonClient redissonClient;
    
    /**
     * 使用分布式锁
     */
    public void updateUserWithLock(Long userId, UserUpdateReqVO reqVO) {
        String lockKey = "user:update:" + userId;
        RLock lock = redissonClient.getLock(lockKey);
        
        try {
            // 尝试获取锁，最多等待3秒，锁定10秒
            if (lock.tryLock(3, 10, TimeUnit.SECONDS)) {
                // 执行业务逻辑
                UserDO user = userMapper.selectById(userId);
                BeanUtils.copyProperties(reqVO, user);
                userMapper.updateById(user);
            } else {
                throw new ServiceException("获取锁失败");
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ServiceException("获取锁被中断");
        } finally {
            // 释放锁
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
    
    /**
     * 使用公平锁
     */
    public void updateUserWithFairLock(Long userId, UserUpdateReqVO reqVO) {
        String lockKey = "user:update:" + userId;
        RLock lock = redissonClient.getFairLock(lockKey);
        
        try {
            if (lock.tryLock(3, 10, TimeUnit.SECONDS)) {
                // 执行业务逻辑
                UserDO user = userMapper.selectById(userId);
                BeanUtils.copyProperties(reqVO, user);
                userMapper.updateById(user);
            } else {
                throw new ServiceException("获取锁失败");
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ServiceException("获取锁被中断");
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
}
```

## 工具类

### RedisUtils

Redis工具类：

```java
public class RedisUtils {
    
    /**
     * 设置缓存
     */
    public static void set(String key, Object value) {
        redisTemplate.opsForValue().set(key, value);
    }
    
    /**
     * 设置缓存（带过期时间）
     */
    public static void set(String key, Object value, long timeout, TimeUnit unit) {
        redisTemplate.opsForValue().set(key, value, timeout, unit);
    }
    
    /**
     * 获取缓存
     */
    public static Object get(String key) {
        return redisTemplate.opsForValue().get(key);
    }
    
    /**
     * 删除缓存
     */
    public static void delete(String key) {
        redisTemplate.delete(key);
    }
    
    /**
     * 判断缓存是否存在
     */
    public static boolean hasKey(String key) {
        return redisTemplate.hasKey(key);
    }
    
    /**
     * 设置过期时间
     */
    public static boolean expire(String key, long timeout, TimeUnit unit) {
        return redisTemplate.expire(key, timeout, unit);
    }
}
```

## 最佳实践

### 1. 缓存设计

```java
@Service
public class UserService {
    
    @Cacheable(value = "user", key = "#userId")
    public UserDO getUserById(Long userId) {
        // 查询数据库
        return userMapper.selectById(userId);
    }
    
    @CacheEvict(value = "user", key = "#user.id")
    public void updateUser(UserDO user) {
        // 更新数据库
        userMapper.updateById(user);
    }
    
    @CacheEvict(value = "user", allEntries = true)
    public void clearUserCache() {
        // 清空所有用户缓存
    }
}
```

### 2. 分布式锁设计

```java
@Service
public class UserService {
    
    @Resource
    private RedissonClient redissonClient;
    
    public void updateUserWithLock(Long userId, UserUpdateReqVO reqVO) {
        String lockKey = "user:update:" + userId;
        RLock lock = redissonClient.getLock(lockKey);
        
        try {
            if (lock.tryLock(3, 10, TimeUnit.SECONDS)) {
                // 执行业务逻辑
                UserDO user = userMapper.selectById(userId);
                BeanUtils.copyProperties(reqVO, user);
                userMapper.updateById(user);
            } else {
                throw new ServiceException("获取锁失败");
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ServiceException("获取锁被中断");
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
}
```

### 3. 缓存策略

```java
@Service
public class UserService {
    
    @Resource
    private RedisTemplate<String, Object> redisTemplate;
    
    /**
     * 缓存穿透防护
     */
    public UserDO getUserById(Long userId) {
        String key = "user:" + userId;
        UserDO user = (UserDO) redisTemplate.opsForValue().get(key);
        
        if (user != null) {
            return user;
        }
        
        // 查询数据库
        user = userMapper.selectById(userId);
        
        if (user != null) {
            // 缓存用户信息
            redisTemplate.opsForValue().set(key, user, 3600, TimeUnit.SECONDS);
        } else {
            // 缓存空值，防止缓存穿透
            redisTemplate.opsForValue().set(key, new UserDO(), 300, TimeUnit.SECONDS);
        }
        
        return user;
    }
}
```

### 4. 错误处理

```java
@Service
public class UserService {
    
    @Resource
    private RedisTemplate<String, Object> redisTemplate;
    
    public UserDO getUserById(Long userId) {
        try {
            String key = "user:" + userId;
            UserDO user = (UserDO) redisTemplate.opsForValue().get(key);
            
            if (user != null) {
                return user;
            }
            
            // 查询数据库
            user = userMapper.selectById(userId);
            
            if (user != null) {
                redisTemplate.opsForValue().set(key, user, 3600, TimeUnit.SECONDS);
            }
            
            return user;
        } catch (Exception e) {
            log.error("Redis操作失败", e);
            // 降级到数据库查询
            return userMapper.selectById(userId);
        }
    }
}
```

## 故障排除

### 常见问题

1. **Redis连接失败**
   - 检查Redis服务是否启动
   - 确认连接配置是否正确
   - 验证网络连接是否正常

2. **序列化失败**
   - 检查对象是否实现了Serializable接口
   - 确认序列化配置是否正确
   - 验证对象结构是否复杂

3. **分布式锁不生效**
   - 检查锁的键是否唯一
   - 确认锁超时时间设置
   - 验证锁释放逻辑

4. **缓存不生效**
   - 检查缓存配置是否正确
   - 确认缓存键是否唯一
   - 验证缓存过期时间设置

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.redis: DEBUG
    org.redisson: DEBUG
    org.springframework.data.redis: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Redisson: 3.51.x
- Spring Data Redis: 2.7.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
