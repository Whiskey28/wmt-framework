# WMT Common

WMT框架的基础公共组件，提供通用的POJO类、枚举、工具类等基础功能。

## 功能特性

- 📦 **通用POJO**: 提供CommonResult、PageResult等通用返回对象
- 🔧 **工具类集合**: 基于Hutool扩展的工具类，包含JSON、对象、集合等操作
- 📋 **枚举定义**: 通用状态枚举、用户类型枚举等
- 🛡️ **异常处理**: ServiceException等业务异常定义
- 🔍 **验证注解**: 自定义验证注解和工具
- 🌐 **业务接口**: 为业务模块提供的通用接口定义

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-common</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 使用通用返回对象

```java
@RestController
public class UserController {
    
    @GetMapping("/users/{id}")
    public CommonResult<User> getUser(@PathVariable Long id) {
        User user = userService.getById(id);
        return CommonResult.success(user);
    }
    
    @PostMapping("/users")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        Long userId = userService.createUser(reqVO);
        return CommonResult.success(userId);
    }
}
```

### 3. 使用工具类

```java
@Service
public class UserService {
    
    public void processUser(User user) {
        // JSON工具类
        String json = JsonUtils.toJsonString(user);
        User parsedUser = JsonUtils.parseObject(json, User.class);
        
        // 对象工具类
        if (ObjectUtils.isNull(user)) {
            throw new ServiceException("用户不能为空");
        }
        
        // Spring工具类
        UserService userService = SpringUtils.getBean(UserService.class);
    }
}
```

## 核心组件

### 通用返回对象

#### CommonResult

通用API返回结果：

```java
// 成功返回
CommonResult<User> result = CommonResult.success(user);

// 失败返回
CommonResult<Void> result = CommonResult.error(ErrorCodeConstants.USER_NOT_EXISTS);

// 分页返回
CommonResult<PageResult<User>> result = CommonResult.success(pageResult);
```

#### PageResult

分页查询结果：

```java
PageResult<User> pageResult = new PageResult<>();
pageResult.setList(users);
pageResult.setTotal(total);
pageResult.setPageNum(pageNum);
pageResult.setPageSize(pageSize);
```

### 工具类

#### JsonUtils

JSON序列化工具：

```java
// 对象转JSON
String json = JsonUtils.toJsonString(user);

// JSON转对象
User user = JsonUtils.parseObject(json, User.class);

// JSON转List
List<User> users = JsonUtils.parseArray(json, User.class);
```

#### ObjectUtils

对象操作工具：

```java
// 判断对象是否为空
if (ObjectUtils.isNull(user)) {
    // 处理空对象
}

// 判断对象是否不为空
if (ObjectUtils.isNotNull(user)) {
    // 处理非空对象
}
```

#### SpringUtils

Spring上下文工具：

```java
// 获取Bean
UserService userService = SpringUtils.getBean(UserService.class);

// 获取Bean（按名称）
UserService userService = SpringUtils.getBean("userService", UserService.class);

// 获取Bean（按类型）
List<UserService> userServices = SpringUtils.getBeansOfType(UserService.class);
```

### 枚举定义

#### CommonStatusEnum

通用状态枚举：

```java
public enum CommonStatusEnum {
    ENABLE(0, "启用"),
    DISABLE(1, "禁用");
}
```

#### UserTypeEnum

用户类型枚举：

```java
public enum UserTypeEnum {
    ADMIN(1, "管理员"),
    USER(2, "普通用户");
}
```

### 异常处理

#### ServiceException

业务异常：

```java
// 抛出业务异常
throw new ServiceException(ErrorCodeConstants.USER_NOT_EXISTS);

// 带参数的异常
throw new ServiceException(ErrorCodeConstants.USER_NOT_EXISTS, userId);
```

### 验证注解

#### 自定义验证

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

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.common.json.serializer` | String | jackson | JSON序列化器 |
| `wmt.common.exception.log-enabled` | boolean | true | 是否记录异常日志 |

## 最佳实践

### 1. 统一返回格式

所有API接口都应该使用`CommonResult`包装返回结果：

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

### 3. 工具类使用

优先使用Hutool工具类，如果没有则使用自定义工具类：

```java
// 优先使用Hutool
String str = StrUtil.format("用户{}不存在", userId);

// 使用自定义工具类
String json = JsonUtils.toJsonString(user);
```

## 版本兼容性

- Spring Framework: 5.3.x
- Spring Boot: 2.7.x
- Java: 8+
- Hutool: 5.8.x

## 许可证

本项目基于 MIT 许可证开源。
