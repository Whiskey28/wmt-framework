# WMT Protection Starter

服务保障组件，提供分布式锁、幂等性、限流、熔断、API签名等功能，保障系统稳定性和安全性。

## 功能特性

- 🔒 **分布式锁**: 基于Redisson的分布式锁，支持可重入锁、公平锁
- 🔄 **幂等性**: 基于Redis的幂等性控制，防止重复提交
- 🚦 **限流**: 支持令牌桶、漏桶、滑动窗口等多种限流算法
- ⚡ **熔断**: 基于Hystrix的熔断器，防止雪崩效应
- 🔐 **API签名**: 支持API签名验证，防止接口被篡改
- 🛡️ **防重放**: 支持请求防重放攻击
- 📊 **监控统计**: 提供限流、熔断等统计信息
- 🔧 **配置灵活**: 支持多种配置方式和策略

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-protection</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  protection:
    # 分布式锁配置
    lock:
      enabled: true
      default-lease-time: 30000  # 默认锁超时时间（毫秒）
    # 幂等性配置
    idempotent:
      enabled: true
      default-expire-time: 300  # 默认过期时间（秒）
    # 限流配置
    rate-limit:
      enabled: true
      default-rate: 100  # 默认限流速率（每秒）
      default-capacity: 1000  # 默认容量
    # API签名配置
    api-sign:
      enabled: true
      secret-key: your-secret-key
      expire-time: 300  # 签名过期时间（秒）
```

### 3. 使用分布式锁

```java
@Service
public class UserService {
    
    @Resource
    private Lock4j lock4j;
    
    @Lock4j(keys = "#reqVO.username", expire = 30000)
    public Long createUser(UserCreateReqVO reqVO) {
        // 创建用户逻辑，自动加锁
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
    
    public void updateUser(Long id, UserUpdateReqVO reqVO) {
        // 手动加锁
        lock4j.lock("user:update:" + id, 30000);
        try {
            userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class).setId(id));
        } finally {
            lock4j.unlock("user:update:" + id);
        }
    }
}
```

### 4. 使用幂等性

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @Idempotent(key = "#reqVO.username", expireTime = 300)
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
    
    @PutMapping("/users/{id}")
    @Idempotent(key = "#id", expireTime = 300)
    public CommonResult<Void> updateUser(@PathVariable Long id, @RequestBody UserUpdateReqVO reqVO) {
        userService.updateUser(id, reqVO);
        return CommonResult.success();
    }
}
```

### 5. 使用限流

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @RateLimit(key = "#userId", rate = 100, capacity = 1000)
    public CommonResult<PageResult<User>> getUsers(@RequestParam Long userId) {
        return CommonResult.success(userService.getUsers());
    }
    
    @PostMapping("/users")
    @RateLimit(key = "user:create", rate = 10, capacity = 100)
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

### 6. 使用API签名

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @ApiSign(secretKey = "your-secret-key", expireTime = 300)
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.protection.lock.enabled` | boolean | true | 是否启用分布式锁 |
| `wmt.protection.lock.default-lease-time` | long | 30000 | 默认锁超时时间（毫秒） |
| `wmt.protection.idempotent.enabled` | boolean | true | 是否启用幂等性 |
| `wmt.protection.idempotent.default-expire-time` | long | 300 | 默认过期时间（秒） |
| `wmt.protection.rate-limit.enabled` | boolean | true | 是否启用限流 |
| `wmt.protection.rate-limit.default-rate` | int | 100 | 默认限流速率（每秒） |
| `wmt.protection.api-sign.enabled` | boolean | true | 是否启用API签名 |

### 分布式锁配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.protection.lock.wait-time` | long | 3000 | 等待锁时间（毫秒） |
| `wmt.protection.lock.retry-times` | int | 3 | 重试次数 |

### 限流配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.protection.rate-limit.algorithm` | String | token-bucket | 限流算法 |
| `wmt.protection.rate-limit.default-capacity` | int | 1000 | 默认容量 |

## 核心功能

### 分布式锁

#### @Lock4j注解

分布式锁注解：

```java
@Lock4j(
    keys = "#reqVO.username",  // 锁的键
    expire = 30000,            // 锁超时时间（毫秒）
    waitTime = 3000,           // 等待锁时间（毫秒）
    retryTimes = 3             // 重试次数
)
public Long createUser(UserCreateReqVO reqVO) {
    return userService.createUser(reqVO);
}
```

#### 手动加锁

```java
@Service
public class UserService {
    
    @Resource
    private Lock4j lock4j;
    
    public void updateUser(Long id, UserUpdateReqVO reqVO) {
        String lockKey = "user:update:" + id;
        lock4j.lock(lockKey, 30000);
        try {
            userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class).setId(id));
        } finally {
            lock4j.unlock(lockKey);
        }
    }
}
```

### 幂等性

#### @Idempotent注解

幂等性注解：

```java
@Idempotent(
    key = "#reqVO.username",    // 幂等键
    expireTime = 300,           // 过期时间（秒）
    message = "请勿重复提交"     // 重复提交提示信息
)
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

#### 自定义幂等键

```java
@Idempotent(key = "#id + ':' + #reqVO.username", expireTime = 300)
public CommonResult<Void> updateUser(@PathVariable Long id, @RequestBody UserUpdateReqVO reqVO) {
    userService.updateUser(id, reqVO);
    return CommonResult.success();
}
```

### 限流

#### @RateLimit注解

限流注解：

```java
@RateLimit(
    key = "#userId",            // 限流键
    rate = 100,                 // 限流速率（每秒）
    capacity = 1000,            // 容量
    algorithm = "token-bucket"  // 限流算法
)
public CommonResult<PageResult<User>> getUsers(@RequestParam Long userId) {
    return CommonResult.success(userService.getUsers());
}
```

#### 限流算法

支持以下限流算法：
- `token-bucket`: 令牌桶算法
- `leaky-bucket`: 漏桶算法
- `sliding-window`: 滑动窗口算法

### API签名

#### @ApiSign注解

API签名注解：

```java
@ApiSign(
    secretKey = "your-secret-key",  // 签名密钥
    expireTime = 300,               // 签名过期时间（秒）
    timestampParam = "timestamp",   // 时间戳参数名
    signParam = "sign"              // 签名参数名
)
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

#### 签名生成

```java
@Service
public class ApiSignService {
    
    public String generateSign(Map<String, Object> params, String secretKey) {
        // 1. 参数排序
        TreeMap<String, Object> sortedParams = new TreeMap<>(params);
        
        // 2. 拼接参数
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Object> entry : sortedParams.entrySet()) {
            sb.append(entry.getKey()).append("=").append(entry.getValue()).append("&");
        }
        
        // 3. 添加密钥
        sb.append("key=").append(secretKey);
        
        // 4. MD5加密
        return DigestUtils.md5Hex(sb.toString());
    }
}
```

### 熔断

#### @CircuitBreaker注解

熔断注解：

```java
@CircuitBreaker(
    fallbackMethod = "fallbackMethod",  // 降级方法
    failureThreshold = 5,               // 失败阈值
    timeout = 3000                      // 超时时间（毫秒）
)
public CommonResult<String> callExternalApi() {
    return CommonResult.success(externalApiService.call());
}

public CommonResult<String> fallbackMethod() {
    return CommonResult.error("服务暂时不可用");
}
```

## 注解说明

### @Lock4j

分布式锁注解：

```java
@Lock4j(
    keys = "#reqVO.username",  // 锁的键，支持SpEL表达式
    expire = 30000,            // 锁超时时间（毫秒）
    waitTime = 3000,           // 等待锁时间（毫秒）
    retryTimes = 3             // 重试次数
)
public Long createUser(UserCreateReqVO reqVO) {
    return userService.createUser(reqVO);
}
```

### @Idempotent

幂等性注解：

```java
@Idempotent(
    key = "#reqVO.username",    // 幂等键，支持SpEL表达式
    expireTime = 300,           // 过期时间（秒）
    message = "请勿重复提交"     // 重复提交提示信息
)
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

### @RateLimit

限流注解：

```java
@RateLimit(
    key = "#userId",            // 限流键，支持SpEL表达式
    rate = 100,                 // 限流速率（每秒）
    capacity = 1000,            // 容量
    algorithm = "token-bucket"  // 限流算法
)
public CommonResult<PageResult<User>> getUsers(@RequestParam Long userId) {
    return CommonResult.success(userService.getUsers());
}
```

### @ApiSign

API签名注解：

```java
@ApiSign(
    secretKey = "your-secret-key",  // 签名密钥
    expireTime = 300,               // 签名过期时间（秒）
    timestampParam = "timestamp",   // 时间戳参数名
    signParam = "sign"              // 签名参数名
)
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

## 最佳实践

### 1. 分布式锁使用

```java
@Service
public class UserService {
    
    @Lock4j(keys = "#reqVO.username", expire = 30000)
    public Long createUser(UserCreateReqVO reqVO) {
        // 校验用户名唯一性
        validateUsernameUnique(reqVO.getUsername());
        
        // 创建用户
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
}
```

### 2. 幂等性使用

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @Idempotent(key = "#reqVO.username", expireTime = 300)
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

### 3. 限流使用

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @RateLimit(key = "#userId", rate = 100, capacity = 1000)
    public CommonResult<PageResult<User>> getUsers(@RequestParam Long userId) {
        return CommonResult.success(userService.getUsers());
    }
}
```

### 4. API签名使用

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @ApiSign(secretKey = "your-secret-key", expireTime = 300)
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

## 故障排除

### 常见问题

1. **分布式锁不生效**
   - 检查Redis连接是否正常
   - 确认锁的键是否唯一
   - 验证锁超时时间设置

2. **幂等性不生效**
   - 检查幂等键是否唯一
   - 确认Redis连接是否正常
   - 验证过期时间设置

3. **限流不生效**
   - 检查限流配置是否正确
   - 确认限流键是否唯一
   - 验证限流算法设置

4. **API签名验证失败**
   - 检查签名密钥是否正确
   - 确认时间戳是否在有效期内
   - 验证签名算法是否正确

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.protection: DEBUG
    com.baomidou.lock4j: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Lock4j: 2.2.x
- Redisson: 3.51.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
