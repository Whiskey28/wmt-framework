# WMT Framework 模块功能与用法指南

> 本文档详细说明 WMT Framework 各个模块的功能特性、使用方法和配置说明，帮助业务系统快速集成和使用。

## 📋 目录

- [WMT Framework 模块功能与用法指南](#wmt-framework-模块功能与用法指南)
  - [📋 目录](#-目录)
  - [一、基础层模块](#一基础层模块)
    - [1. wmt-common - 基础公共组件](#1-wmt-common---基础公共组件)
      - [📦 Maven坐标](#-maven坐标)
      - [✨ 功能特性](#-功能特性)
      - [💡 使用示例](#-使用示例)
      - [⚙️ 配置说明](#️-配置说明)
      - [📌 注意事项](#-注意事项)
  - [二、框架技术组件](#二框架技术组件)
    - [2. wmt-spring-boot-starter-web - Web框架增强](#2-wmt-spring-boot-starter-web---web框架增强)
      - [📦 Maven坐标](#-maven坐标-1)
      - [✨ 功能特性](#-功能特性-1)
      - [💡 使用示例](#-使用示例-1)
      - [⚙️ 配置说明](#️-配置说明-1)
      - [📌 注意事项](#-注意事项-1)
    - [3. wmt-spring-boot-starter-mybatis - MyBatis Plus增强](#3-wmt-spring-boot-starter-mybatis---mybatis-plus增强)
      - [📦 Maven坐标](#-maven坐标-2)
      - [✨ 功能特性](#-功能特性-2)
      - [💡 使用示例](#-使用示例-2)
      - [⚙️ 配置说明](#️-配置说明-2)
      - [📌 注意事项](#-注意事项-2)
    - [4. wmt-spring-boot-starter-cache - 多级缓存组件](#4-wmt-spring-boot-starter-cache---多级缓存组件)
      - [📦 Maven坐标](#-maven坐标-3)
      - [✨ 功能特性](#-功能特性-3)
      - [💡 使用示例](#-使用示例-3)
      - [⚙️ 配置说明](#️-配置说明-3)
      - [📌 注意事项](#-注意事项-3)
    - [5. wmt-spring-boot-starter-redis - Redis操作组件](#5-wmt-spring-boot-starter-redis---redis操作组件)
      - [📦 Maven坐标](#-maven坐标-4)
      - [✨ 功能特性](#-功能特性-4)
      - [💡 使用示例](#-使用示例-4)
      - [⚙️ 配置说明](#️-配置说明-4)
    - [6. wmt-spring-boot-starter-security - 安全认证组件](#6-wmt-spring-boot-starter-security---安全认证组件)
      - [📦 Maven坐标](#-maven坐标-5)
      - [✨ 功能特性](#-功能特性-5)
      - [💡 使用示例](#-使用示例-5)
      - [⚙️ 配置说明](#️-配置说明-5)
      - [📌 注意事项](#-注意事项-4)
    - [7. wmt-spring-boot-starter-websocket - WebSocket实时通信](#7-wmt-spring-boot-starter-websocket---websocket实时通信)
      - [📦 Maven坐标](#-maven坐标-6)
      - [✨ 功能特性](#-功能特性-6)
      - [💡 使用示例](#-使用示例-6)
      - [⚙️ 配置说明](#️-配置说明-6)
    - [8. wmt-spring-boot-starter-monitor - 服务监控组件](#8-wmt-spring-boot-starter-monitor---服务监控组件)
      - [📦 Maven坐标](#-maven坐标-7)
      - [✨ 功能特性](#-功能特性-7)
      - [💡 使用示例](#-使用示例-7)
      - [⚙️ 配置说明](#️-配置说明-7)
    - [9. wmt-spring-boot-starter-protection - 服务保护组件](#9-wmt-spring-boot-starter-protection---服务保护组件)
      - [📦 Maven坐标](#-maven坐标-8)
      - [✨ 功能特性](#-功能特性-8)
      - [💡 使用示例](#-使用示例-8)
      - [⚙️ 配置说明](#️-配置说明-8)
    - [10. wmt-spring-boot-starter-job - 定时任务组件](#10-wmt-spring-boot-starter-job---定时任务组件)
      - [📦 Maven坐标](#-maven坐标-9)
      - [✨ 功能特性](#-功能特性-9)
      - [💡 使用示例](#-使用示例-9)
      - [⚙️ 配置说明](#️-配置说明-9)
    - [11. wmt-spring-boot-starter-xxljob - XXL-Job集成组件](#11-wmt-spring-boot-starter-xxljob---xxl-job集成组件)
      - [📦 Maven坐标](#-maven坐标-10)
      - [✨ 功能特性](#-功能特性-10)
      - [💡 使用示例](#-使用示例-10)
      - [⚙️ 配置说明](#️-配置说明-10)
    - [12. wmt-spring-boot-starter-mq - 消息队列组件](#12-wmt-spring-boot-starter-mq---消息队列组件)
      - [📦 Maven坐标](#-maven坐标-11)
      - [✨ 功能特性](#-功能特性-11)
      - [💡 使用示例](#-使用示例-11)
      - [⚙️ 配置说明](#️-配置说明-11)
    - [13. wmt-spring-boot-starter-excel - Excel导入导出组件](#13-wmt-spring-boot-starter-excel---excel导入导出组件)
      - [📦 Maven坐标](#-maven坐标-12)
      - [✨ 功能特性](#-功能特性-12)
      - [💡 使用示例](#-使用示例-12)
      - [⚙️ 配置说明](#️-配置说明-12)
    - [14. wmt-spring-boot-starter-test - 测试组件](#14-wmt-spring-boot-starter-test---测试组件)
      - [📦 Maven坐标](#-maven坐标-13)
      - [✨ 功能特性](#-功能特性-13)
      - [💡 使用示例](#-使用示例-13)
    - [15. wmt-spring-boot-starter-prometheus-grafana - Prometheus监控](#15-wmt-spring-boot-starter-prometheus-grafana---prometheus监控)
      - [📦 Maven坐标](#-maven坐标-14)
      - [✨ 功能特性](#-功能特性-14)
      - [💡 使用示例](#-使用示例-14)
      - [⚙️ 配置说明](#️-配置说明-13)
    - [16. wmt-spring-boot-starter-elk-logging - ELK日志组件](#16-wmt-spring-boot-starter-elk-logging---elk日志组件)
      - [📦 Maven坐标](#-maven坐标-15)
      - [✨ 功能特性](#-功能特性-15)
      - [💡 使用示例](#-使用示例-15)
      - [⚙️ 配置说明](#️-配置说明-14)
  - [三、业务技术组件](#三业务技术组件)
    - [17. wmt-spring-boot-starter-biz-tenant - 多租户组件](#17-wmt-spring-boot-starter-biz-tenant---多租户组件)
      - [📦 Maven坐标](#-maven坐标-16)
      - [✨ 功能特性](#-功能特性-16)
      - [💡 使用示例](#-使用示例-16)
      - [⚙️ 配置说明](#️-配置说明-15)
    - [18. wmt-spring-boot-starter-biz-data-permission - 数据权限组件](#18-wmt-spring-boot-starter-biz-data-permission---数据权限组件)
      - [📦 Maven坐标](#-maven坐标-17)
      - [✨ 功能特性](#-功能特性-17)
      - [💡 使用示例](#-使用示例-17)
      - [⚙️ 配置说明](#️-配置说明-16)
    - [19. wmt-spring-boot-starter-biz-ip - IP地理位置组件](#19-wmt-spring-boot-starter-biz-ip---ip地理位置组件)
      - [📦 Maven坐标](#-maven坐标-18)
      - [✨ 功能特性](#-功能特性-18)
      - [💡 使用示例](#-使用示例-18)
      - [⚙️ 配置说明](#️-配置说明-17)
  - [四、模块依赖关系](#四模块依赖关系)
    - [依赖层级](#依赖层级)
    - [常用组合](#常用组合)
  - [五、快速集成指南](#五快速集成指南)
    - [1. 添加依赖管理](#1-添加依赖管理)
    - [2. 引入所需模块](#2-引入所需模块)
    - [3. 配置文件](#3-配置文件)
    - [4. 代码规范](#4-代码规范)
    - [5. 最佳实践](#5-最佳实践)
  - [📚 相关文档](#-相关文档)
  - [📞 技术支持](#-技术支持)

---

## 一、基础层模块

### 1. wmt-common - 基础公共组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-common</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

**1. 通用POJO类**
- `CommonResult<T>`：统一API返回结果封装
- `PageResult<T>`：分页查询结果封装
- `PageParam`：分页查询参数
- `SortablePageParam`：可排序分页参数
- `SortingField`：排序字段定义

**2. 工具类集合**
- `JsonUtils`：JSON序列化/反序列化工具（基于Jackson）
- `ObjectUtils`：对象操作工具（判空、转换等）
- `SpringUtils`：Spring上下文工具（获取Bean等）
- `BeanUtils`：Bean属性复制工具
- `PageUtils`：分页工具类
- `MyBatisUtils`：MyBatis工具类

**3. 异常处理**
- `ServiceException`：业务异常类
- `ErrorCode`：错误码接口
- `GlobalErrorCodeConstants`：全局错误码常量
- `ServiceExceptionUtil`：异常工具类

**4. 枚举定义**
- `CommonStatusEnum`：通用状态枚举（启用/禁用）
- `UserTypeEnum`：用户类型枚举
- 其他业务枚举

**5. 验证注解**
- 自定义验证注解和工具

#### 💡 使用示例

**统一返回结果**
```java
@RestController
public class UserController {
    
    @GetMapping("/users/{id}")
    public CommonResult<UserVO> getUser(@PathVariable Long id) {
        UserVO user = userService.getUser(id);
        return CommonResult.success(user);
    }
    
    @PostMapping("/users")
    public CommonResult<Long> createUser(@Valid @RequestBody UserCreateReqVO reqVO) {
        Long userId = userService.createUser(reqVO);
        return CommonResult.success(userId);
    }
    
    @GetMapping("/users/page")
    public CommonResult<PageResult<UserVO>> getUserPage(
            @Valid SortablePageParam pageParam,
            @Validated UserPageReqVO req) {
        PageResult<UserVO> page = userService.getUserPage(pageParam, req);
        return CommonResult.success(page);
    }
}
```

**异常处理**
```java
@Service
public class UserService {
    
    public UserDO getUserById(Long id) {
        UserDO user = userMapper.selectById(id);
        if (user == null) {
            throw new ServiceException(GlobalErrorCodeConstants.BAD_REQUEST.getCode(), "用户不存在");
        }
        return user;
    }
    
    public void validateUsernameUnique(String username) {
        if (userMapper.selectByUsername(username) != null) {
            throw ServiceExceptionUtil.exception0(GlobalErrorCodeConstants.BAD_REQUEST);
        }
    }
}
```

**工具类使用**
```java
@Service
public class UserService {
    
    public void processUser(UserDO user) {
        // JSON工具类
        String json = JsonUtils.toJsonString(user);
        UserDO parsedUser = JsonUtils.parseObject(json, UserDO.class);
        
        // 对象工具类
        if (ObjectUtils.isNull(user)) {
            throw new ServiceException("用户不能为空");
        }
        
        // Spring工具类
        UserService userService = SpringUtils.getBean(UserService.class);
        
        // Bean复制
        UserVO vo = BeanUtils.toBean(user, UserVO.class);
    }
}
```

#### ⚙️ 配置说明

无需额外配置，引入依赖即可使用。

#### 📌 注意事项

1. **CommonResult使用规范**：所有Controller方法必须返回`CommonResult`，禁止返回裸对象
2. **分页统一使用**：分页查询统一使用`PageParam`/`SortablePageParam`作为入参，`PageResult`作为出参
3. **异常抛出规范**：业务异常统一使用`ServiceException`抛出，由全局异常处理器统一处理

---

## 二、框架技术组件

### 2. wmt-spring-boot-starter-web - Web框架增强

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-web</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **全局异常处理**：统一异常处理机制，自动转换异常为API响应
2. **API日志记录**：自动记录请求和响应日志，支持脱敏处理
3. **参数校验**：基于Bean Validation的参数校验
4. **安全增强**：支持API签名、防重放攻击
5. **API文档**：集成Knife4j和SpringDoc，自动生成API文档
6. **跨域支持**：自动配置CORS跨域支持
7. **压缩支持**：支持Gzip压缩和Brotli压缩
8. **路径前缀**：支持API路径前缀配置

#### 💡 使用示例

**全局异常处理（自动生效）**
```java
@RestController
public class UserController {
    
    @GetMapping("/users/{id}")
    public CommonResult<UserVO> getUser(@PathVariable Long id) {
        UserVO user = userService.getUser(id);
        if (user == null) {
            throw new ServiceException(ErrorCodeConstants.USER_NOT_EXISTS);
        }
        return CommonResult.success(user);
    }
}
// 异常自动转换为: {"code": 1001, "msg": "用户不存在", "data": null}
```

**API日志记录**
```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @ApiLog(module = "用户管理", name = "创建用户")
    public CommonResult<Long> createUser(@RequestBody @Valid UserCreateReqVO reqVO) {
        Long userId = userService.createUser(reqVO);
        return CommonResult.success(userId);
    }
}
```

**参数校验**
```java
@PostMapping("/users")
public CommonResult<Long> createUser(@RequestBody @Valid UserCreateReqVO reqVO) {
    // 自动进行参数校验
    return CommonResult.success(userService.createUser(reqVO));
}

public class UserCreateReqVO {
    @NotBlank(message = "用户名不能为空")
    private String username;
    
    @Email(message = "邮箱格式不正确")
    private String email;
    
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String mobile;
}
```

**压缩支持**
```java
@GzipCompress
@GetMapping("/large-data")
public CommonResult<List<Data>> getLargeData() {
    // 自动进行Gzip压缩
    return CommonResult.success(dataService.getLargeData());
}

@BrotliCompress
@GetMapping("/large-data")
public CommonResult<List<Data>> getLargeData() {
    // 自动进行Brotli压缩
    return CommonResult.success(dataService.getLargeData());
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  web:
    admin-api:
      prefix: /admin-api
      controller: com.wmt.module.admin.controller
    app-api:
      prefix: /app-api
      controller: com.wmt.module.app.controller
    cors:
      allowed-origins: "*"
      allowed-methods: "*"
      allowed-headers: "*"
    api-log:
      enabled: true
      ignore-urls:
        - /actuator/**
      sensitive-words:
        - password
        - secret
```

#### 📌 注意事项

1. Controller必须返回`CommonResult`格式
2. 使用`@Valid`或`@Validated`进行参数校验
3. API文档访问路径：`http://localhost:8080/doc.html`（Knife4j）或`http://localhost:8080/swagger-ui.html`（SpringDoc）

---

### 3. wmt-spring-boot-starter-mybatis - MyBatis Plus增强

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **多数据源支持**：支持动态数据源切换，支持读写分离
2. **事务管理**：基于Spring事务管理，支持分布式事务
3. **分页查询**：自动分页插件，支持多种分页方式
4. **数据加密**：支持字段级数据加密存储
5. **多租户**：支持多租户数据隔离
6. **自动填充**：自动填充创建时间、更新时间等字段
7. **数据翻译**：支持数据字典、枚举等数据翻译
8. **SQL安全**：防止SQL注入，支持SQL审计
9. **BaseMapperX**：扩展的Mapper接口，提供常用查询方法

#### 💡 使用示例

**实体类定义**
```java
@TableName("sys_user")
public class UserDO extends BaseDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("username")
    private String username;
    
    @TableField("email")
    private String email;
    
    @TableLogic
    private Integer deleted;
}
```

**Mapper接口**
```java
@Mapper
public interface UserMapper extends BaseMapperX<UserDO> {
    
    default UserDO selectByUsername(String username) {
        return selectOne(new LambdaQueryWrapperX<UserDO>()
                .eq(UserDO::getUsername, username));
    }
    
    default PageResult<UserDO> selectPage(UserPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(UserDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(UserDO::getId));
    }
}
```

**Service使用**
```java
@Service
public class UserServiceImpl implements UserService {
    
    @Resource
    private UserMapper userMapper;
    
    @Override
    public Long createUser(UserCreateReqVO reqVO) {
        validateUsernameUnique(reqVO.getUsername());
        
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
    
    @Override
    public PageResult<UserDO> getUserPage(UserPageReqVO reqVO) {
        return userMapper.selectPage(reqVO);
    }
}
```

**多数据源切换**
```java
@Service
public class UserService {
    
    @DS("master")
    public void createUser(UserDO user) {
        // 使用主数据源
        userMapper.insert(user);
    }
    
    @DS("slave")
    public List<UserDO> getUsers() {
        // 使用从数据源
        return userMapper.selectList(null);
    }
}
```

#### ⚙️ 配置说明

```yaml
spring:
  datasource:
    druid:
      url: jdbc:mysql://localhost:3306/wmt_demo
      username: root
      password: password
      driver-class-name: com.mysql.cj.jdbc.Driver

mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0
```

#### 📌 注意事项

1. Mapper必须继承`BaseMapperX<Entity>`
2. 分页查询使用`PageParam`/`SortablePageParam`作为参数
3. 实体类建议继承`BaseDO`，自动填充通用字段

---

### 4. wmt-spring-boot-starter-cache - 多级缓存组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-cache</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **多级缓存**：
   - L1缓存：本地缓存（Caffeine）
   - L2缓存：Redis缓存
   - L3缓存：数据库（通过回调函数）
2. **缓存穿透防护**：防止缓存穿透攻击
3. **缓存统计**：提供缓存命中率统计
4. **Spring Cache集成**：支持@Cacheable注解
5. **编程式缓存**：提供CacheService接口

#### 💡 使用示例

**多级缓存注解方式**
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
}
```

**编程式多级缓存**
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

**Spring Cache方式**
```java
@Service
public class UserService {
    
    @Cacheable(value = "user#1h", key = "#userId")
    public User getUserById(Long userId) {
        return userRepository.findById(userId);
    }
    
    @CacheEvict(value = "user", key = "#user.id")
    public void updateUser(User user) {
        userRepository.save(user);
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  cache:
    redis-scan-batch-size: 30
    multi-level:
      enabled: true
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

#### 📌 注意事项

1. 多级缓存需要设置`wmt.cache.multi-level.enabled=true`
2. 本地缓存基于Caffeine，适合单机部署
3. Redis缓存支持集群模式，适合分布式部署

---

### 5. wmt-spring-boot-starter-redis - Redis操作组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-redis</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **Redis连接**：基于Redisson的Redis连接管理
2. **缓存支持**：支持Spring Cache注解和手动缓存操作
3. **分布式锁**：基于Redisson的分布式锁
4. **数据序列化**：支持JSON序列化，自动处理数据类型转换
5. **连接池**：支持Redis连接池配置
6. **故障转移**：支持Redis故障转移和重连

#### 💡 使用示例

**RedisTemplate使用**
```java
@Service
public class UserService {
    
    @Resource
    private RedisTemplate<String, Object> redisTemplate;
    
    public void setUserCache(Long userId, UserDO user) {
        String key = "user:" + userId;
        redisTemplate.opsForValue().set(key, user, 3600, TimeUnit.SECONDS);
    }
    
    public UserDO getUserCache(Long userId) {
        String key = "user:" + userId;
        return (UserDO) redisTemplate.opsForValue().get(key);
    }
}
```

**分布式锁使用**
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

#### ⚙️ 配置说明

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

redisson:
  single-server-config:
    address: redis://localhost:6379
    password: password
    database: 0
    connection-pool-size: 64
    connection-minimum-idle-size: 10
```

---

### 6. wmt-spring-boot-starter-security - 安全认证组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-security</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **用户认证**：基于Token的用户认证机制
2. **权限校验**：基于注解的权限校验
3. **操作日志**：自动记录用户操作日志
4. **密码加密**：BCrypt密码加密
5. **跨域支持**：支持跨域请求
6. **登录统计**：登录次数、最后登录时间统计
7. **会话管理**：支持会话超时、强制下线
8. **多端登录**：支持多端同时登录

#### 💡 使用示例

**权限校验**
```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @PreAuthorize("@ss.hasPermission('system:user:list')")
    public CommonResult<PageResult<User>> getUsers() {
        return CommonResult.success(userService.getUsers());
    }
    
    @PostMapping("/users")
    @PreAuthorize("@ss.hasPermission('system:user:create')")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

**操作日志**
```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @OperateLog(module = "用户管理", name = "创建用户")
    @PreAuthorize("@ss.hasPermission('system:user:create')")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

**获取当前用户**
```java
@Service
public class UserService {
    
    public UserDO getCurrentUser() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        return userMapper.selectById(userId);
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  security:
    password-encoder-length: 4
    token:
      secret-key: your-secret-key
      expire-time: 7200
    permit-all-urls:
      - /admin-api/login
      - /admin-api/captcha
      - /app-api/login
      - /app-api/register
```

#### 📌 注意事项

1. 需要实现`PermissionCommonApi`和`OAuth2TokenCommonApi`接口
2. 权限命名规范：`模块:功能:操作`，如`system:user:list`

---

### 7. wmt-spring-boot-starter-websocket - WebSocket实时通信

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-websocket</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **WebSocket连接**：基于Spring WebSocket的实时连接
2. **多节点广播**：支持Redis、RocketMQ、Kafka、RabbitMQ多节点消息广播
3. **会话管理**：支持用户会话管理和多端登录
4. **安全认证**：集成用户认证，支持Token验证
5. **消息监听**：支持自定义消息监听器
6. **消息路由**：支持消息路由和分发
7. **连接统计**：支持连接数统计和监控
8. **断线重连**：支持客户端断线重连

#### 💡 使用示例

**消息监听器**
```java
@Component
public class UserMessageListener implements WebSocketMessageListener<UserMessage> {
    
    @Override
    public void onMessage(UserMessage message, WebSocketSession session) {
        log.info("收到用户消息: {}", message);
        
        UserMessage reply = new UserMessage();
        reply.setType("reply");
        reply.setContent("收到您的消息");
        WebSocketUtils.send(session, reply);
    }
    
    @Override
    public String getType() {
        return "user";
    }
}
```

**发送消息**
```java
@Service
public class NotificationService {
    
    @Resource
    private WebSocketMessageSender webSocketMessageSender;
    
    public void sendToUser(Long userId, String message) {
        UserMessage userMessage = new UserMessage();
        userMessage.setType("notification");
        userMessage.setContent(message);
        userMessage.setUserId(userId);
        
        webSocketMessageSender.send(userId, userMessage);
    }
    
    public void broadcast(String message) {
        BroadcastMessage broadcastMessage = new BroadcastMessage();
        broadcastMessage.setType("broadcast");
        broadcastMessage.setContent(message);
        
        webSocketMessageSender.send(broadcastMessage);
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  websocket:
    path: /ws
    sender-type: redis  # local、redis、rocketmq、kafka、rabbitmq

spring:
  redis:
    host: localhost
    port: 6379
    password: password
```

---

### 8. wmt-spring-boot-starter-monitor - 服务监控组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-monitor</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **链路追踪**：基于SkyWalking的分布式链路追踪
2. **指标收集**：基于Micrometer的应用指标收集
3. **日志服务**：集成SkyWalking日志追踪
4. **业务追踪**：支持自定义业务追踪注解@BizTrace
5. **性能监控**：自动收集性能指标

#### 💡 使用示例

**业务追踪**
```java
@Service
public class UserService {
    
    @BizTrace(operation = "创建用户", tags = {"module:user", "action:create"})
    public Long createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
}
```

**自定义指标**
```java
@Service
public class UserService {
    
    @Resource
    private MeterRegistry meterRegistry;
    
    public void createUser(UserCreateReqVO reqVO) {
        Counter.builder("user.create.count")
                .tag("module", "user")
                .register(meterRegistry)
                .increment();
        
        userMapper.insert(BeanUtils.toBean(reqVO, UserDO.class));
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  tracer:
    enable: true
    ignore-urls:
      - /actuator/**
  metrics:
    enable: true

skywalking:
  agent:
    service_name: ${spring.application.name}
    collector:
      backend_service: 127.0.0.1:11800
```

---

### 9. wmt-spring-boot-starter-protection - 服务保护组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-protection</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **分布式锁**：基于Redisson的分布式锁，支持可重入锁、公平锁
2. **幂等性**：基于Redis的幂等性控制，防止重复提交
3. **限流**：支持令牌桶、漏桶、滑动窗口等多种限流算法
4. **熔断**：基于Hystrix的熔断器，防止雪崩效应
5. **API签名**：支持API签名验证，防止接口被篡改
6. **防重放**：支持请求防重放攻击

#### 💡 使用示例

**分布式锁**
```java
@Service
public class UserService {
    
    @Lock4j(keys = "#reqVO.username", expire = 30000)
    public Long createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
}
```

**幂等性**
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

**限流**
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

#### ⚙️ 配置说明

```yaml
wmt:
  protection:
    lock:
      enabled: true
      default-lease-time: 30000
    idempotent:
      enabled: true
      default-expire-time: 300
    rate-limit:
      enabled: true
      default-rate: 100
      default-capacity: 1000
```

---

### 10. wmt-spring-boot-starter-job - 定时任务组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-job</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **定时任务**：基于Quartz的定时任务调度
2. **异步任务**：基于Spring Async的异步任务执行
3. **任务管理**：支持任务的启动、停止、暂停、恢复
4. **任务日志**：自动记录任务执行日志
5. **任务重试**：支持任务失败重试机制
6. **任务监控**：提供任务执行状态监控
7. **多实例**：支持多实例任务调度

#### 💡 使用示例

**任务处理器**
```java
@Component
public class UserSyncJobHandler implements JobHandler {
    
    @Override
    public String execute(String param) throws Exception {
        log.info("开始执行用户同步任务，参数：{}", param);
        
        UserSyncParam syncParam = JsonUtils.parseObject(param, UserSyncParam.class);
        int syncCount = userService.syncUsers(syncParam);
        
        log.info("用户同步任务执行完成，同步数量：{}", syncCount);
        return "同步成功，数量：" + syncCount;
    }
}
```

**异步任务**
```java
@Service
public class UserService {
    
    @Async("taskExecutor")
    public CompletableFuture<Void> sendEmailAsync(Long userId, String content) {
        emailService.sendEmail(userId, content);
        return CompletableFuture.completedFuture(null);
    }
}
```

#### ⚙️ 配置说明

```yaml
spring:
  quartz:
    job-store-type: jdbc
    jdbc:
      initialize-schema: always

wmt:
  job:
    async:
      core-pool-size: 10
      max-pool-size: 20
      queue-capacity: 100
      thread-name-prefix: async-task-
```

---

### 11. wmt-spring-boot-starter-xxljob - XXL-Job集成组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-xxljob</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **独立模块**：与Job模块解耦，可独立使用
2. **自动配置**：基于Spring Boot的自动配置机制
3. **参数支持**：支持简单参数和JSON复杂参数
4. **日志记录**：集成XXL-Job日志系统
5. **异常处理**：完善的异常处理机制
6. **监控支持**：支持任务执行监控和告警
7. **配置验证**：启动时自动验证必填配置项
8. **健康检查**：集成Spring Boot Actuator

#### 💡 使用示例

**创建任务**
```java
@Component
@Slf4j
public class UserSyncJob {
    
    @XxlJob("userSyncJob")
    public void execute() {
        String param = XxlJobHelper.getJobParam();
        XxlJobHelper.log("任务开始执行，参数：{}", param);
        
        try {
            UserSyncParam syncParam = JsonUtils.parseObject(param, UserSyncParam.class);
            int syncCount = userService.syncUsers(syncParam);
            XxlJobHelper.log("任务执行成功，同步数量：{}", syncCount);
        } catch (Exception e) {
            XxlJobHelper.log("任务执行失败：{}", e.getMessage());
            throw e;
        }
    }
}
```

#### ⚙️ 配置说明

```yaml
xxl:
  job:
    enabled: true
    access-token: your-access-token
    admin:
      addresses: http://your-xxljob-admin:8088/xxl-job-admin
    executor:
      appname: your-app-name
      port: 9999
      logpath: ./logs/xxl-job
      logretentiondays: 30
```

---

### 12. wmt-spring-boot-starter-mq - 消息队列组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-mq</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **多消息队列支持**：支持Redis、RocketMQ、RabbitMQ、Kafka四种消息队列
2. **统一接口**：提供统一的消息发送和消费接口
3. **消息序列化**：支持JSON序列化，自动处理消息转换
4. **消息路由**：支持消息路由和分发
5. **消息确认**：支持消息确认机制
6. **消息监控**：提供消息发送和消费统计
7. **容错处理**：支持消息重试和死信队列

#### 💡 使用示例

**Redis消息队列**
```java
@Service
public class UserService {
    
    @Resource
    private RedisMQTemplate redisMQTemplate;
    
    public void sendUserCreateMessage(Long userId) {
        UserCreateMessage message = new UserCreateMessage();
        message.setUserId(userId);
        message.setTimestamp(System.currentTimeMillis());
        
        redisMQTemplate.send("user.create", message);
    }
}

@Component
public class UserMessageListener {
    
    @RedisMQListener(topic = "user.create")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
}
```

**RocketMQ**
```java
@Service
public class UserService {
    
    @Resource
    private RocketMQTemplate rocketMQTemplate;
    
    public void sendUserCreateMessage(Long userId) {
        UserCreateMessage message = new UserCreateMessage();
        message.setUserId(userId);
        
        rocketMQTemplate.convertAndSend("user-create-topic", message);
    }
}
```

#### ⚙️ 配置说明

```yaml
# Redis配置
spring:
  redis:
    host: localhost
    port: 6379
    password: password

# RocketMQ配置
rocketmq:
  name-server: localhost:9876
  producer:
    group: wmt-producer
  consumer:
    group: wmt-consumer
```

---

### 13. wmt-spring-boot-starter-excel - Excel导入导出组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-excel</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **Excel导入导出**：支持Excel文件的导入和导出
2. **数据转换**：支持数据字典、枚举等数据转换
3. **样式设置**：支持Excel样式设置和格式化
4. **注解驱动**：基于注解的Excel配置
5. **数据校验**：支持Excel数据校验
6. **多格式支持**：支持.xlsx、.xls等格式

#### 💡 使用示例

**Excel实体类**
```java
@Data
@ExcelProperty("用户信息")
public class UserExcelVO {
    
    @ExcelProperty("用户ID")
    private Long id;
    
    @ExcelProperty("用户名")
    private String username;
    
    @ExcelProperty("邮箱")
    private String email;
    
    @ExcelProperty("状态")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_STATUS)
    private Integer status;
    
    @ExcelProperty("创建时间")
    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
```

**导出Excel**
```java
@RestController
public class UserController {
    
    @GetMapping("/users/export")
    public void exportUsers(HttpServletResponse response) throws IOException {
        List<UserDO> users = userService.getUsers();
        List<UserExcelVO> excelData = BeanUtils.toBeanList(users, UserExcelVO.class);
        
        ExcelUtils.write(response, "用户列表.xlsx", "用户信息", UserExcelVO.class, excelData);
    }
}
```

**导入Excel**
```java
@RestController
public class UserController {
    
    @PostMapping("/users/import")
    public CommonResult<String> importUsers(@RequestParam("file") MultipartFile file) throws IOException {
        List<UserExcelVO> excelData = ExcelUtils.read(file, UserExcelVO.class);
        String result = userService.importUsers(excelData);
        return CommonResult.success(result);
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  excel:
    max-import-rows: 10000
    max-export-rows: 100000
    template-path: /templates/excel
```

---

### 14. wmt-spring-boot-starter-test - 测试组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-test</artifactId>
    <version>${wmt.version}</version>
    <scope>test</scope>
</dependency>
```

#### ✨ 功能特性

1. **单元测试**：基于JUnit 5的单元测试支持
2. **集成测试**：基于Spring Boot Test的集成测试
3. **数据库测试**：支持H2内存数据库测试
4. **Redis测试**：支持内嵌Redis测试
5. **Mock支持**：基于Mockito的Mock功能
6. **测试数据**：支持随机测试数据生成
7. **测试工具**：提供测试工具类和断言

#### 💡 使用示例

**单元测试**
```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @Test
    void testCreateUser() {
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        
        Long userId = userService.createUser(reqVO);
        
        AssertUtils.assertNotNull(userId);
        AssertUtils.assertTrue(userId > 0);
    }
}
```

**集成测试**
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UserControllerTest {
    
    @Resource
    private TestRestTemplate restTemplate;
    
    @Test
    void testCreateUser() {
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        
        ResponseEntity<CommonResult<Long>> response = restTemplate.postForEntity(
            "/admin-api/system/user/create", reqVO, CommonResult.class);
        
        AssertUtils.assertEquals(HttpStatus.OK, response.getStatusCode());
    }
}
```

---

### 15. wmt-spring-boot-starter-prometheus-grafana - Prometheus监控

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-prometheus-grafana</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **统一指标**：基于Micrometer自动注册HTTP、JVM、数据库等核心指标
2. **公共标签**：可统一注入service、env等自定义标签
3. **告警模板**：内置告警规则模板
4. **Grafana Dashboard**：预置仪表盘模板
5. **PushGateway支持**：内置定时推送器
6. **可扩展**：保留扩展点

#### 💡 使用示例

**业务指标埋点**
```java
@Service
public class OrderService {
    
    public Long createOrder(OrderCreateReq req) {
        try {
            Long orderId = orderMapper.insert(order);
            
            DomainMetricPublisher.counter(
                "biz_order_create_total",
                Tag.of("channel", req.getChannel()),
                Tag.of("status", "success")
            );
            
            return orderId;
        } catch (Exception e) {
            DomainMetricPublisher.counter(
                "biz_order_create_total",
                Tag.of("channel", req.getChannel()),
                Tag.of("status", "failure")
            );
            throw e;
        }
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  prometheus:
    enabled: true
    endpoint: /actuator/prometheus
    common-tags:
      enabled: true
      service: ${spring.application.name}
      environment: prod
    dashboard:
      export-path: ./monitoring/grafana/dashboards
    alerts:
      export-path: ./monitoring/prometheus/rules
```

---

### 16. wmt-spring-boot-starter-elk-logging - ELK日志组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-elk-logging</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **无侵入接入**：开发走Logstash TCP，生产走Filebeat + 本地文件
2. **零配置自动集成**：无需维护logback.xml
3. **可自定义扩展**：支持自定义logback-spring.xml
4. **统一JSON输出**：结构化日志
5. **自动MDC字段**：链路追踪、业务上下文、请求信息

#### 💡 使用示例

**零配置使用（推荐）**
```yaml
# 开发环境
wmt:
  logging:
    enabled: true
    output: logstash
    logstash-host: 127.0.0.1
    logstash-port: 5000

# 生产环境
wmt:
  logging:
    enabled: true
    output: file
    file-path: /data/logs/${spring.application.name}/app.log
    auto-activate-profile: true
```

#### ⚙️ 配置说明

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `wmt.logging.enabled` | boolean | true | 是否启用组件 |
| `wmt.logging.output` | string | file | 输出方式：logstash / file |
| `wmt.logging.logstash-host` | string | 127.0.0.1 | Logstash 主机 |
| `wmt.logging.logstash-port` | int | 5000 | Logstash 端口 |
| `wmt.logging.file-path` | string | /data/logs/${spring.application.name}/app.log | 文件输出路径 |

---

## 三、业务技术组件

### 17. wmt-spring-boot-starter-biz-tenant - 多租户组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-tenant</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **多租户支持**：支持多租户数据隔离
2. **租户认证**：支持租户身份认证
3. **数据隔离**：支持数据库级别的数据隔离
4. **租户切换**：支持动态租户切换
5. **租户管理**：提供租户管理功能
6. **权限控制**：支持租户级别的权限控制

#### 💡 使用示例

**租户实体类**
```java
@TableName("sys_user")
public class UserDO extends BaseDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("tenant_id")
    private Long tenantId;  // 租户ID
}
```

**租户服务**
```java
@Service
public class UserService {
    
    @Resource
    private UserMapper userMapper;
    
    public Long createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        // 自动设置租户ID
        userMapper.insert(user);
        return user.getId();
    }
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        // 自动过滤租户
        return userMapper.selectPage(reqVO);
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  tenant:
    enabled: true
    tenant-id-column: tenant_id
    ignore-tables:
      - sys_tenant
      - sys_tenant_package
```

---

### 18. wmt-spring-boot-starter-biz-data-permission - 数据权限组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-data-permission</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **数据权限**：支持基于用户、角色、部门的数据权限控制
2. **权限规则**：支持多种数据权限规则配置
3. **精确控制**：支持字段级别的权限控制
4. **动态权限**：支持动态权限规则配置
5. **权限审计**：提供数据权限审计功能

#### 💡 使用示例

**数据权限注解**
```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "READ")
    public CommonResult<PageResult<User>> getUsers() {
        return CommonResult.success(userService.getUsers());
    }
}
```

**数据权限规则应用**
```java
@Service
public class UserService {
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .orderByDesc(UserDO::getId);
        
        // 应用数据权限
        applyDataPermission(queryWrapper);
        
        return userMapper.selectPage(reqVO, queryWrapper);
    }
    
    private void applyDataPermission(LambdaQueryWrapperX<UserDO> queryWrapper) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        String permissionType = DataPermissionUtils.getUserDataPermissionType(userId);
        
        switch (permissionType) {
            case "ALL":
                break;
            case "DEPT":
                Long deptId = getUserDeptId(userId);
                queryWrapper.eq(UserDO::getDeptId, deptId);
                break;
            case "SELF":
                queryWrapper.eq(UserDO::getId, userId);
                break;
        }
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  data-permission:
    enabled: true
    default-permission-type: SELF
    rules:
      - type: ALL
        name: 全部数据权限
      - type: DEPT
        name: 部门数据权限
      - type: SELF
        name: 仅本人数据权限
```

---

### 19. wmt-spring-boot-starter-biz-ip - IP地理位置组件

#### 📦 Maven坐标
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-ip</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

#### ✨ 功能特性

1. **IP地址解析**：支持IP地址到地理位置的解析
2. **地理位置查询**：支持国家、省份、城市等地理位置信息
3. **IP白名单**：支持IP白名单功能
4. **IP黑名单**：支持IP黑名单功能
5. **IP统计**：提供IP访问统计功能

#### 💡 使用示例

**IP解析**
```java
@Service
public class IpService {
    
    @Resource
    private Ip2RegionSearcher ip2RegionSearcher;
    
    public IpInfo parseIp(String ip) {
        return ip2RegionSearcher.parseIp(ip);
    }
}
```

**IP白名单**
```java
@Service
public class IpWhitelistService {
    
    public boolean isWhitelisted(String ip) {
        // 检查配置的白名单
        if (isConfiguredWhitelisted(ip)) {
            return true;
        }
        
        // 检查数据库中的白名单
        return ipWhitelistMapper.selectCount(new LambdaQueryWrapperX<IpWhitelistDO>()
                .eq(IpWhitelistDO::getIp, ip)
                .eq(IpWhitelistDO::getStatus, 1)) > 0;
    }
}
```

#### ⚙️ 配置说明

```yaml
wmt:
  ip:
    enabled: true
    database-path: classpath:ip2region.xdb
    whitelist:
      - 127.0.0.1
      - 192.168.1.0/24
    blacklist:
      - 192.168.100.1
```

---

## 四、模块依赖关系

### 依赖层级

```
wmt-common (基础层)
    ↓
框架技术组件 (中间层)
    ├── wmt-spring-boot-starter-web (依赖 common)
    ├── wmt-spring-boot-starter-mybatis (依赖 common)
    ├── wmt-spring-boot-starter-cache (依赖 common, redis)
    ├── wmt-spring-boot-starter-redis (依赖 common)
    ├── wmt-spring-boot-starter-security (依赖 common, web)
    ├── wmt-spring-boot-starter-websocket (依赖 common, security)
    ├── wmt-spring-boot-starter-monitor (依赖 common)
    ├── wmt-spring-boot-starter-protection (依赖 common, redis)
    ├── wmt-spring-boot-starter-job (依赖 common)
    ├── wmt-spring-boot-starter-xxljob (依赖 common)
    ├── wmt-spring-boot-starter-mq (依赖 common, redis)
    ├── wmt-spring-boot-starter-excel (依赖 common)
    ├── wmt-spring-boot-starter-test (依赖 common)
    ├── wmt-spring-boot-starter-prometheus-grafana (依赖 common)
    └── wmt-spring-boot-starter-elk-logging (依赖 common)
    ↓
业务技术组件 (应用层)
    ├── wmt-spring-boot-starter-biz-tenant (依赖 common, mybatis)
    ├── wmt-spring-boot-starter-biz-data-permission (依赖 common, mybatis, security)
    └── wmt-spring-boot-starter-biz-ip (依赖 common)
```

### 常用组合

**基础Web应用**
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-cache</artifactId>
</dependency>
```

**完整企业应用**
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-cache</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-protection</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-monitor</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-tenant</artifactId>
</dependency>
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-data-permission</artifactId>
</dependency>
```

---

## 五、快速集成指南

### 1. 添加依赖管理

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-dependencies</artifactId>
            <version>${wmt.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### 2. 引入所需模块

根据业务需求引入相应的模块，参考上面的"常用组合"。

### 3. 配置文件

在`application.yml`中添加相应配置，参考各模块的配置说明。

### 4. 代码规范

- Controller统一返回`CommonResult`
- 分页统一使用`PageParam`/`SortablePageParam`和`PageResult`
- 异常统一使用`ServiceException`抛出
- Mapper统一继承`BaseMapperX<Entity>`

### 5. 最佳实践

1. **模块选择**：按需引入，避免引入不必要的模块
2. **配置管理**：使用配置中心统一管理配置
3. **日志规范**：使用统一的日志格式和级别
4. **异常处理**：充分利用全局异常处理机制
5. **性能优化**：合理使用缓存和异步处理

---

## 📚 相关文档

- [快速开始指南](../../README.md)
- [组件开发指南](COMPONENT_DEVELOPMENT.md)
- [后端开发规范](../后端开发规范.md)

---

## 📞 技术支持

如有问题，请通过以下方式联系：
- 提交Issue：https://github.com/Wmt/wmt-framework/issues
- 查看各模块的README文档获取更详细的使用说明

