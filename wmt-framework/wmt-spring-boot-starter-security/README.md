# WMT Security Starter

基于Spring Security的安全认证组件，提供用户认证、权限校验、操作日志等功能。

## 功能特性

- 🔐 **用户认证**: 基于Token的用户认证机制
- 🛡️ **权限校验**: 基于注解的权限校验
- 📝 **操作日志**: 自动记录用户操作日志
- 🔑 **密码加密**: BCrypt密码加密
- 🌐 **跨域支持**: 支持跨域请求
- 📊 **登录统计**: 登录次数、最后登录时间统计
- 🔒 **会话管理**: 支持会话超时、强制下线
- 📱 **多端登录**: 支持多端同时登录

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-security</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  security:
    # 密码加密强度
    password-encoder-length: 4
    # Token配置
    token:
      secret-key: your-secret-key
      expire-time: 7200  # 2小时
    # 权限配置
    permit-all-urls:
      - /admin-api/login
      - /admin-api/captcha
      - /app-api/login
      - /app-api/register
```

### 3. 实现业务接口

```java
@Service
public class PermissionServiceImpl implements PermissionCommonApi {
    
    @Override
    public boolean hasAnyPermissions(Long userId, String... permissions) {
        // 实现权限校验逻辑
        return permissionService.hasAnyPermissions(userId, permissions);
    }
    
    @Override
    public boolean hasAnyRoles(Long userId, String... roles) {
        // 实现角色校验逻辑
        return roleService.hasAnyRoles(userId, roles);
    }
}

@Service
public class OAuth2TokenServiceImpl implements OAuth2TokenCommonApi {
    
    @Override
    public OAuth2AccessTokenDO getAccessToken(String accessToken) {
        // 实现Token查询逻辑
        return tokenService.getAccessToken(accessToken);
    }
    
    @Override
    public void removeAccessToken(String accessToken) {
        // 实现Token删除逻辑
        tokenService.removeAccessToken(accessToken);
    }
}
```

### 4. 使用权限校验

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
    
    @DeleteMapping("/users/{id}")
    @PreAuthorize("@ss.hasPermission('system:user:delete')")
    public CommonResult<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return CommonResult.success();
    }
}
```

### 5. 使用操作日志

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @OperateLog(module = "用户管理", name = "创建用户")
    @PreAuthorize("@ss.hasPermission('system:user:create')")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
    
    @PutMapping("/users/{id}")
    @OperateLog(module = "用户管理", name = "更新用户")
    @PreAuthorize("@ss.hasPermission('system:user:update')")
    public CommonResult<Void> updateUser(@PathVariable Long id, @RequestBody UserUpdateReqVO reqVO) {
        userService.updateUser(id, reqVO);
        return CommonResult.success();
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.security.password-encoder-length` | int | 4 | 密码加密强度 |
| `wmt.security.token.secret-key` | String | - | Token密钥 |
| `wmt.security.token.expire-time` | int | 7200 | Token过期时间（秒） |

### 权限配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.security.permit-all-urls` | String[] | - | 允许匿名访问的URL |
| `wmt.security.ignore-urls` | String[] | - | 忽略权限校验的URL |

### 操作日志配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.security.operate-log.enabled` | boolean | true | 是否启用操作日志 |
| `wmt.security.operate-log.ignore-urls` | String[] | - | 忽略的URL列表 |

## 核心功能

### 用户认证

#### Token认证

```java
@Service
public class AuthService {
    
    public LoginRespVO login(LoginReqVO reqVO) {
        // 校验用户名密码
        UserDO user = validateUser(reqVO.getUsername(), reqVO.getPassword());
        
        // 生成Token
        String accessToken = tokenService.createAccessToken(user.getId());
        
        // 记录登录日志
        loginLogService.createLoginLog(user.getId(), reqVO.getUsername(), LoginLogTypeEnum.LOGIN_USERNAME);
        
        return new LoginRespVO(accessToken, user);
    }
}
```

#### 密码加密

```java
@Service
public class UserService {
    
    @Resource
    private PasswordEncoder passwordEncoder;
    
    public void createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        // 密码加密
        user.setPassword(passwordEncoder.encode(reqVO.getPassword()));
        userMapper.insert(user);
    }
}
```

### 权限校验

#### 基于注解的权限校验

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

#### 基于角色的权限校验

```java
@RestController
public class UserController {
    
    @GetMapping("/admin/users")
    @PreAuthorize("@ss.hasRole('admin')")
    public CommonResult<PageResult<User>> getAdminUsers() {
        return CommonResult.success(userService.getAdminUsers());
    }
}
```

### 操作日志

#### 自动记录操作日志

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @OperateLog(module = "用户管理", name = "创建用户")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
    
    @PutMapping("/users/{id}")
    @OperateLog(module = "用户管理", name = "更新用户", type = OperateLogTypeEnum.UPDATE)
    public CommonResult<Void> updateUser(@PathVariable Long id, @RequestBody UserUpdateReqVO reqVO) {
        userService.updateUser(id, reqVO);
        return CommonResult.success();
    }
}
```

### 当前用户信息

#### 获取当前登录用户

```java
@Service
public class UserService {
    
    public UserDO getCurrentUser() {
        // 获取当前登录用户ID
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        return userMapper.selectById(userId);
    }
    
    public void updateCurrentUser(UserUpdateReqVO reqVO) {
        // 获取当前登录用户ID
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class).setId(userId));
    }
}
```

## 注解说明

### @PreAuthorize

权限校验注解：

```java
@PreAuthorize("@ss.hasPermission('system:user:list')")
@GetMapping("/users")
public CommonResult<PageResult<User>> getUsers() {
    return CommonResult.success(userService.getUsers());
}
```

### @OperateLog

操作日志注解：

```java
@OperateLog(
    module = "用户管理",           // 模块名称
    name = "创建用户",            // 操作名称
    type = OperateLogTypeEnum.CREATE,  // 操作类型
    content = "创建用户：#{#reqVO.username}"  // 操作内容
)
@PostMapping("/users")
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

### @PermitAll

允许匿名访问注解：

```java
@PermitAll
@GetMapping("/public/info")
public CommonResult<String> getPublicInfo() {
    return CommonResult.success("公开信息");
}
```

## 工具类

### SecurityFrameworkUtils

安全框架工具类：

```java
// 获取当前登录用户ID
Long userId = SecurityFrameworkUtils.getLoginUserId();

// 获取当前登录用户名
String username = SecurityFrameworkUtils.getLoginUsername();

// 获取当前登录用户
LoginUser loginUser = SecurityFrameworkUtils.getLoginUser();

// 检查是否有权限
boolean hasPermission = SecurityFrameworkUtils.hasPermission("system:user:list");

// 检查是否有角色
boolean hasRole = SecurityFrameworkUtils.hasRole("admin");
```

## 最佳实践

### 1. 权限设计

```java
// 权限命名规范：模块:功能:操作
// 例如：system:user:list, system:user:create, system:user:update, system:user:delete

@RestController
@RequestMapping("/admin-api/system/user")
public class UserController {
    
    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermission('system:user:list')")
    public CommonResult<PageResult<User>> getUserList() {
        return CommonResult.success(userService.getUserList());
    }
    
    @PostMapping("/create")
    @PreAuthorize("@ss.hasPermission('system:user:create')")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

### 2. 操作日志设计

```java
@RestController
public class UserController {
    
    @PostMapping("/users")
    @OperateLog(module = "用户管理", name = "创建用户")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
    
    @PutMapping("/users/{id}")
    @OperateLog(module = "用户管理", name = "更新用户", type = OperateLogTypeEnum.UPDATE)
    public CommonResult<Void> updateUser(@PathVariable Long id, @RequestBody UserUpdateReqVO reqVO) {
        userService.updateUser(id, reqVO);
        return CommonResult.success();
    }
}
```

### 3. 登录设计

```java
@RestController
public class AuthController {
    
    @PostMapping("/login")
    @PermitAll
    public CommonResult<LoginRespVO> login(@RequestBody LoginReqVO reqVO) {
        return CommonResult.success(authService.login(reqVO));
    }
    
    @PostMapping("/logout")
    public CommonResult<Void> logout() {
        authService.logout();
        return CommonResult.success();
    }
}
```

### 4. 密码加密

```java
@Service
public class UserService {
    
    @Resource
    private PasswordEncoder passwordEncoder;
    
    public void createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        // 密码加密
        user.setPassword(passwordEncoder.encode(reqVO.getPassword()));
        userMapper.insert(user);
    }
    
    public boolean validatePassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
}
```

## 故障排除

### 常见问题

1. **Token认证失败**
   - 检查Token是否过期
   - 确认Token密钥配置是否正确
   - 验证用户状态是否正常

2. **权限校验不生效**
   - 确认使用了`@PreAuthorize`注解
   - 检查权限字符串是否正确
   - 验证用户是否具有相应权限

3. **操作日志不记录**
   - 确认使用了`@OperateLog`注解
   - 检查操作日志配置是否正确
   - 验证数据库连接是否正常

4. **跨域问题**
   - 检查CORS配置
   - 确认前端请求头设置正确

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.security: DEBUG
    org.springframework.security: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Spring Security: 5.8.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
