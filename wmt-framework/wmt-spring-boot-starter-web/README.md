# WMT Web Starter

基于Spring MVC的Web框架增强组件，提供全局异常处理、API日志、参数校验、错误码等Web开发常用功能。

## 功能特性

- 🛡️ **全局异常处理**: 统一异常处理机制，自动转换异常为API响应
- 📝 **API日志记录**: 自动记录请求和响应日志，支持脱敏处理
- ✅ **参数校验**: 基于Bean Validation的参数校验
- 🔐 **安全增强**: 支持API签名、防重放攻击
- 📊 **API文档**: 集成Knife4j和SpringDoc，自动生成API文档
- 🌐 **跨域支持**: 自动配置CORS跨域支持
- 🗜️ **压缩支持**: 支持Gzip压缩和Brotli压缩
- 🎯 **路径前缀**: 支持API路径前缀配置

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-web</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

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
```

### 3. 使用全局异常处理

```java
@RestController
public class UserController {
    
    @GetMapping("/users/{id}")
    public CommonResult<User> getUser(@PathVariable Long id) {
        User user = userService.getById(id);
        if (user == null) {
            throw new ServiceException(ErrorCodeConstants.USER_NOT_EXISTS);
        }
        return CommonResult.success(user);
    }
}
```

### 4. 使用API日志

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

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.web.admin-api.prefix` | String | /admin-api | 管理端API前缀 |
| `wmt.web.admin-api.controller` | String | - | 管理端Controller包路径 |
| `wmt.web.app-api.prefix` | String | /app-api | 应用端API前缀 |
| `wmt.web.app-api.controller` | String | - | 应用端Controller包路径 |

### CORS配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.web.cors.allowed-origins` | String[] | * | 允许的源 |
| `wmt.web.cors.allowed-methods` | String[] | * | 允许的HTTP方法 |
| `wmt.web.cors.allowed-headers` | String[] | * | 允许的请求头 |
| `wmt.web.cors.allow-credentials` | boolean | true | 是否允许凭证 |

### API日志配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.web.api-log.enabled` | boolean | true | 是否启用API日志 |
| `wmt.web.api-log.ignore-urls` | String[] | - | 忽略的URL列表 |
| `wmt.web.api-log.sensitive-words` | String[] | password,secret | 敏感词列表 |

## 核心功能

### 全局异常处理

#### GlobalExceptionHandler

自动处理各种异常并转换为统一的API响应：

```java
// 业务异常
throw new ServiceException(ErrorCodeConstants.USER_NOT_EXISTS);
// 自动转换为: {"code": 1001, "msg": "用户不存在", "data": null}

// 参数校验异常
@Valid @RequestBody UserCreateReqVO reqVO
// 自动转换为: {"code": 400, "msg": "参数校验失败", "data": [...]}

// 系统异常
throw new RuntimeException("系统错误");
// 自动转换为: {"code": 500, "msg": "系统异常", "data": null}
```

### API日志记录

#### RequestLogAspect

自动记录API请求和响应：

```java
@ApiLog(module = "用户管理", name = "创建用户")
@PostMapping("/users")
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    // 自动记录请求参数和响应结果
    return CommonResult.success(userService.createUser(reqVO));
}
```

日志记录内容：
- 请求URL、方法、参数
- 响应结果、耗时
- 用户信息、IP地址
- 异常信息（如有）

### 参数校验

#### 自动校验

```java
@PostMapping("/users")
public CommonResult<Long> createUser(@RequestBody @Valid UserCreateReqVO reqVO) {
    // 自动进行参数校验
    return CommonResult.success(userService.createUser(reqVO));
}
```

#### 自定义校验

```java
public class UserCreateReqVO {
    
    @NotBlank(message = "用户名不能为空")
    private String username;
    
    @Email(message = "邮箱格式不正确")
    private String email;
    
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String mobile;
}
```

### API文档

#### Knife4j集成

访问 `http://localhost:8080/doc.html` 查看API文档

#### SpringDoc集成

访问 `http://localhost:8080/swagger-ui.html` 查看API文档

### 路径前缀

#### 自动路径前缀

```java
// 管理端Controller
@RestController
@RequestMapping("/user")
public class AdminUserController {
    // 实际路径: /admin-api/user/xxx
}

// 应用端Controller  
@RestController
@RequestMapping("/user")
public class AppUserController {
    // 实际路径: /app-api/user/xxx
}
```

### 压缩支持

#### Gzip压缩

```java
@GzipCompress
@GetMapping("/large-data")
public CommonResult<List<Data>> getLargeData() {
    // 自动进行Gzip压缩
    return CommonResult.success(dataService.getLargeData());
}
```

#### Brotli压缩

```java
@BrotliCompress
@GetMapping("/large-data")
public CommonResult<List<Data>> getLargeData() {
    // 自动进行Brotli压缩
    return CommonResult.success(dataService.getLargeData());
}
```

## 注解说明

### @ApiLog

API日志注解：

```java
@ApiLog(
    module = "用户管理",    // 模块名称
    name = "创建用户",      // 操作名称
    type = ApiLogTypeEnum.CREATE,  // 操作类型
    ignoreRequestArgs = {"password"},  // 忽略的请求参数
    ignoreResponseArgs = {"password"}  // 忽略的响应参数
)
@PostMapping("/users")
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

### @GzipCompress

Gzip压缩注解：

```java
@GzipCompress
@GetMapping("/large-data")
public CommonResult<List<Data>> getLargeData() {
    return CommonResult.success(dataService.getLargeData());
}
```

### @BrotliCompress

Brotli压缩注解：

```java
@BrotliCompress
@GetMapping("/large-data")
public CommonResult<List<Data>> getLargeData() {
    return CommonResult.success(dataService.getLargeData());
}
```

## 最佳实践

### 1. 统一API响应格式

所有API都应该返回`CommonResult`格式：

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    public CommonResult<PageResult<User>> getUsers(@RequestParam(defaultValue = "1") Integer pageNum,
                                                   @RequestParam(defaultValue = "10") Integer pageSize) {
        PageResult<User> pageResult = userService.getUsers(pageNum, pageSize);
        return CommonResult.success(pageResult);
    }
}
```

### 2. 异常处理

使用`ServiceException`抛出业务异常：

```java
@Service
public class UserService {
    
    public User getUserById(Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new ServiceException(ErrorCodeConstants.USER_NOT_EXISTS);
        }
        return user;
    }
}
```

### 3. 参数校验

使用Bean Validation进行参数校验：

```java
@PostMapping("/users")
public CommonResult<Long> createUser(@RequestBody @Valid UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

### 4. API文档

为API添加详细的文档注解：

```java
@Api(tags = "用户管理")
@RestController
public class UserController {
    
    @ApiOperation("获取用户列表")
    @GetMapping("/users")
    public CommonResult<PageResult<User>> getUsers(
            @ApiParam("页码") @RequestParam(defaultValue = "1") Integer pageNum,
            @ApiParam("每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        PageResult<User> pageResult = userService.getUsers(pageNum, pageSize);
        return CommonResult.success(pageResult);
    }
}
```

## 故障排除

### 常见问题

1. **CORS跨域问题**
   - 检查CORS配置是否正确
   - 确认前端请求的域名在允许列表中

2. **API文档无法访问**
   - 检查Knife4j或SpringDoc依赖是否正确引入
   - 确认访问路径是否正确

3. **参数校验不生效**
   - 确认使用了`@Valid`注解
   - 检查校验注解是否正确

4. **异常处理不生效**
   - 确认Controller在正确的包路径下
   - 检查异常是否被其他处理器捕获

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.web: DEBUG
    org.springframework.web: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Spring MVC: 5.3.x
- Java: 8+
- Knife4j: 4.5.x
- SpringDoc: 1.8.x

## 许可证

本项目基于 MIT 许可证开源。
