# WMT Monitor Starter

基于SkyWalking和Micrometer的服务监控组件，提供链路追踪、指标收集、日志服务等功能。

## 功能特性

- 🔍 **链路追踪**: 基于SkyWalking的分布式链路追踪
- 📊 **指标收集**: 基于Micrometer的应用指标收集
- 📝 **日志服务**: 集成SkyWalking日志追踪
- 🎯 **业务追踪**: 支持自定义业务追踪注解
- 📈 **性能监控**: 自动收集性能指标
- 🔧 **配置灵活**: 支持多种监控配置
- 📱 **多端支持**: 支持Web、移动端监控
- 🛡️ **安全监控**: 支持安全事件监控

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-monitor</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  tracer:
    enable: true
    ignore-urls:
      - /actuator/**
      - /doc.html
      - /swagger-ui/**
  metrics:
    enable: true

# SkyWalking配置
skywalking:
  agent:
    service_name: ${spring.application.name}
    collector:
      backend_service: 127.0.0.1:11800
```

### 3. 使用业务追踪

```java
@Service
public class UserService {
    
    @BizTrace(operation = "创建用户", tags = {"module:user", "action:create"})
    public Long createUser(UserCreateReqVO reqVO) {
        // 创建用户逻辑
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
    
    @BizTrace(operation = "查询用户", tags = {"module:user", "action:query"})
    public UserDO getUserById(Long id) {
        return userMapper.selectById(id);
    }
}
```

### 4. 使用指标收集

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    public CommonResult<PageResult<User>> getUsers() {
        // 自动收集HTTP请求指标
        return CommonResult.success(userService.getUsers());
    }
    
    @PostMapping("/users")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        // 自动收集HTTP请求指标
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

### 5. 自定义指标

```java
@Service
public class UserService {
    
    @Resource
    private MeterRegistry meterRegistry;
    
    public void createUser(UserCreateReqVO reqVO) {
        // 自定义计数器
        Counter.builder("user.create.count")
                .tag("module", "user")
                .register(meterRegistry)
                .increment();
        
        // 创建用户逻辑
        userMapper.insert(BeanUtils.toBean(reqVO, UserDO.class));
    }
    
    public void updateUser(Long id, UserUpdateReqVO reqVO) {
        // 自定义计时器
        Timer.Sample sample = Timer.start(meterRegistry);
        try {
            // 更新用户逻辑
            userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class).setId(id));
        } finally {
            sample.stop(Timer.builder("user.update.duration")
                    .tag("module", "user")
                    .register(meterRegistry));
        }
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.tracer.enable` | boolean | true | 是否启用链路追踪 |
| `wmt.tracer.ignore-urls` | String[] | - | 忽略追踪的URL列表 |
| `wmt.metrics.enable` | boolean | true | 是否启用指标收集 |

### SkyWalking配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `skywalking.agent.service_name` | String | - | 服务名称 |
| `skywalking.agent.collector.backend_service` | String | - | SkyWalking后端服务地址 |

### 指标配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `management.metrics.export.prometheus.enabled` | boolean | true | 是否启用Prometheus指标导出 |
| `management.endpoints.web.exposure.include` | String[] | health,info,metrics | 暴露的端点 |

## 核心功能

### 链路追踪

#### TraceFilter

自动追踪HTTP请求：

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    public CommonResult<PageResult<User>> getUsers() {
        // 自动创建Span，追踪请求
        return CommonResult.success(userService.getUsers());
    }
}
```

#### 自定义追踪

```java
@Service
public class UserService {
    
    @BizTrace(operation = "创建用户", tags = {"module:user", "action:create"})
    public Long createUser(UserCreateReqVO reqVO) {
        // 创建用户逻辑
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
}
```

### 指标收集

#### 自动指标

自动收集以下指标：
- HTTP请求计数
- HTTP请求耗时
- JVM内存使用
- GC次数和时间
- 线程数
- 数据库连接池状态

#### 自定义指标

```java
@Service
public class UserService {
    
    @Resource
    private MeterRegistry meterRegistry;
    
    public void createUser(UserCreateReqVO reqVO) {
        // 计数器
        Counter.builder("user.create.count")
                .tag("module", "user")
                .register(meterRegistry)
                .increment();
        
        // 创建用户逻辑
        userMapper.insert(BeanUtils.toBean(reqVO, UserDO.class));
    }
    
    public void updateUser(Long id, UserUpdateReqVO reqVO) {
        // 计时器
        Timer.Sample sample = Timer.start(meterRegistry);
        try {
            userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class).setId(id));
        } finally {
            sample.stop(Timer.builder("user.update.duration")
                    .tag("module", "user")
                    .register(meterRegistry));
        }
    }
}
```

### 业务追踪

#### @BizTrace注解

业务追踪注解：

```java
@BizTrace(
    operation = "创建用户",           // 操作名称
    tags = {"module:user", "action:create"},  // 标签
    description = "创建新用户"        // 描述
)
public Long createUser(UserCreateReqVO reqVO) {
    return userService.createUser(reqVO);
}
```

#### BizTraceAspect

业务追踪切面：

```java
@Aspect
@Component
public class BizTraceAspect {
    
    @Around("@annotation(bizTrace)")
    public Object around(ProceedingJoinPoint joinPoint, BizTrace bizTrace) throws Throwable {
        // 创建业务追踪Span
        Span span = tracer.nextSpan()
                .name(bizTrace.operation())
                .tag("module", bizTrace.tags()[0])
                .start();
        
        try {
            return joinPoint.proceed();
        } finally {
            span.end();
        }
    }
}
```

### 日志追踪

#### 集成SkyWalking日志

```yaml
logging:
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%X{traceId},%X{spanId}] %-5level [%thread] %logger{36} - %msg%n"
```

#### 自定义日志追踪

```java
@Service
public class UserService {
    
    private static final Logger log = LoggerFactory.getLogger(UserService.class);
    
    public Long createUser(UserCreateReqVO reqVO) {
        // 自动包含TraceId和SpanId
        log.info("开始创建用户: {}", reqVO.getUsername());
        
        try {
            UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
            userMapper.insert(user);
            
            log.info("用户创建成功: {}", user.getId());
            return user.getId();
        } catch (Exception e) {
            log.error("用户创建失败: {}", reqVO.getUsername(), e);
            throw e;
        }
    }
}
```

## 注解说明

### @BizTrace

业务追踪注解：

```java
@BizTrace(
    operation = "创建用户",           // 操作名称
    tags = {"module:user", "action:create"},  // 标签
    description = "创建新用户"        // 描述
)
public Long createUser(UserCreateReqVO reqVO) {
    return userService.createUser(reqVO);
}
```

## 工具类

### TracerFrameworkUtils

追踪工具类：

```java
// 获取当前TraceId
String traceId = TracerFrameworkUtils.getTraceId();

// 获取当前SpanId
String spanId = TracerFrameworkUtils.getSpanId();

// 创建自定义Span
Span span = TracerFrameworkUtils.createSpan("custom-operation");

// 添加标签
TracerFrameworkUtils.addTag("key", "value");

// 记录事件
TracerFrameworkUtils.addEvent("user-created");
```

## 最佳实践

### 1. 业务追踪设计

```java
@Service
public class UserService {
    
    @BizTrace(operation = "创建用户", tags = {"module:user", "action:create"})
    public Long createUser(UserCreateReqVO reqVO) {
        // 创建用户逻辑
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
    
    @BizTrace(operation = "更新用户", tags = {"module:user", "action:update"})
    public void updateUser(Long id, UserUpdateReqVO reqVO) {
        // 更新用户逻辑
        userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class).setId(id));
    }
}
```

### 2. 指标收集设计

```java
@Service
public class UserService {
    
    @Resource
    private MeterRegistry meterRegistry;
    
    public Long createUser(UserCreateReqVO reqVO) {
        // 计数器
        Counter.builder("user.create.count")
                .tag("module", "user")
                .tag("status", "success")
                .register(meterRegistry)
                .increment();
        
        // 创建用户逻辑
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        
        return user.getId();
    }
}
```

### 3. 异常监控

```java
@Service
public class UserService {
    
    @Resource
    private MeterRegistry meterRegistry;
    
    public Long createUser(UserCreateReqVO reqVO) {
        try {
            UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
            userMapper.insert(user);
            return user.getId();
        } catch (Exception e) {
            // 异常计数器
            Counter.builder("user.create.error.count")
                    .tag("module", "user")
                    .tag("error", e.getClass().getSimpleName())
                    .register(meterRegistry)
                    .increment();
            throw e;
        }
    }
}
```

### 4. 性能监控

```java
@Service
public class UserService {
    
    @Resource
    private MeterRegistry meterRegistry;
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        // 计时器
        Timer.Sample sample = Timer.start(meterRegistry);
        try {
            PageResult<UserDO> result = userMapper.selectPage(reqVO);
            
            // 记录结果数量
            Gauge.builder("user.query.result.count")
                    .tag("module", "user")
                    .register(meterRegistry, result.getList().size());
            
            return result;
        } finally {
            sample.stop(Timer.builder("user.query.duration")
                    .tag("module", "user")
                    .register(meterRegistry));
        }
    }
}
```

## 故障排除

### 常见问题

1. **SkyWalking连接失败**
   - 检查SkyWalking后端服务是否启动
   - 确认服务地址配置是否正确
   - 验证网络连接是否正常

2. **指标收集不生效**
   - 检查Micrometer配置是否正确
   - 确认Prometheus端点是否暴露
   - 验证指标注册是否正确

3. **业务追踪不生效**
   - 确认使用了`@BizTrace`注解
   - 检查AOP配置是否正确
   - 验证SkyWalking Agent是否正常

4. **日志追踪不生效**
   - 检查日志格式配置
   - 确认SkyWalking日志插件是否启用
   - 验证日志级别设置

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.tracer: DEBUG
    org.apache.skywalking: DEBUG
    io.micrometer: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- SkyWalking: 8.12.x
- Micrometer: 1.9.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
