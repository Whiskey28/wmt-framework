# WMT 框架快速入门

本文档帮助您快速上手WMT技术组件库。

## 前置条件

- JDK 1.8 或更高版本
- Maven 3.6 或更高版本
- Spring Boot 2.7.x

## 1. 创建Spring Boot项目

使用Spring Initializr或您喜欢的IDE创建一个新的Spring Boot项目。

## 2. 添加WMT依赖

### 方式一：使用依赖管理（推荐）

在 `pom.xml` 中添加WMT依赖管理：

```xml
<project>
    <properties>
        <wmt.version>2025.10-jdk8-SNAPSHOT</wmt.version>
    </properties>
    
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
    
    <dependencies>
        <!-- Web组件 -->
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-spring-boot-starter-web</artifactId>
        </dependency>
        
        <!-- MyBatis组件 -->
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
        </dependency>
        
        <!-- Redis组件 -->
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-spring-boot-starter-redis</artifactId>
        </dependency>
    </dependencies>
</project>
```

### 方式二：直接依赖

如果不想使用依赖管理，可以直接指定版本：

```xml
<dependencies>
    <dependency>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-spring-boot-starter-web</artifactId>
        <version>2025.10-jdk8-SNAPSHOT</version>
    </dependency>
</dependencies>
```

## 3. 配置应用

在 `application.yml` 中配置：

```yaml
server:
  port: 8080

spring:
  application:
    name: wmt-demo
  
  # 数据源配置（如果使用MyBatis组件）
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/demo?useUnicode=true&characterEncoding=utf-8
    username: root
    password: root
  
  # Redis配置（如果使用Redis组件）
  redis:
    host: localhost
    port: 6379
    database: 0

# WMT框架配置
wmt:
  # Web配置
  web:
    app-name: ${spring.application.name}
    api-prefix: /api
  
  # 安全配置
  security:
    permit-all-urls:
      - /doc.html
      - /v3/api-docs/**
      - /swagger-ui/**
```

## 4. 编写代码

### 4.1 创建实体类

```java
package com.example.demo.domain;

import lombok.Data;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@Data
@TableName("user")
public class User {
    @TableId
    private Long id;
    private String username;
    private String email;
}
```

### 4.2 创建Mapper

```java
package com.example.demo.mapper;

import com.example.demo.domain.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {
}
```

### 4.3 创建Service

```java
package com.example.demo.service;

import com.example.demo.domain.User;
import com.example.demo.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.data.redis.core.RedisTemplate;

import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public User getUser(Long id) {
        // 先从缓存获取
        String key = "user:" + id;
        User user = (User) redisTemplate.opsForValue().get(key);
        
        if (user == null) {
            // 缓存未命中，从数据库查询
            user = userMapper.selectById(id);
            if (user != null) {
                // 写入缓存
                redisTemplate.opsForValue().set(key, user, 1, TimeUnit.HOURS);
            }
        }
        
        return user;
    }
    
    public List<User> list() {
        return userMapper.selectList(null);
    }
    
    public void save(User user) {
        userMapper.insert(user);
    }
}
```

### 4.4 创建Controller

```java
package com.example.demo.controller;

import com.example.demo.domain.User;
import com.example.demo.service.UserService;
import com.wmt.framework.common.pojo.CommonResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@Tag(name = "用户管理")
@RestController
@RequestMapping("/api/user")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @Operation(summary = "获取用户详情")
    @GetMapping("/{id}")
    public CommonResult<User> getUser(@PathVariable Long id) {
        User user = userService.getUser(id);
        return CommonResult.success(user);
    }
    
    @Operation(summary = "获取用户列表")
    @GetMapping("/list")
    public CommonResult<List<User>> list() {
        List<User> users = userService.list();
        return CommonResult.success(users);
    }
    
    @Operation(summary = "创建用户")
    @PostMapping
    public CommonResult<Void> create(@Valid @RequestBody User user) {
        userService.save(user);
        return CommonResult.success();
    }
}
```

### 4.5 创建启动类

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

## 5. 运行应用

```bash
mvn spring-boot:run
```

访问 http://localhost:8080/doc.html 查看API文档（Swagger UI）

## 6. 常用组件使用

### 6.1 统一异常处理

WMT框架自动处理异常，您只需要抛出异常即可：

```java
import com.wmt.framework.common.exception.ServiceException;
import static com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants.*;

@Service
public class UserService {
    public User getUser(Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new ServiceException(NOT_FOUND.getCode(), "用户不存在");
        }
        return user;
    }
}
```

### 6.2 参数校验

使用JSR-303注解进行参数校验：

```java
import javax.validation.constraints.*;

@Data
public class UserCreateReq {
    @NotBlank(message = "用户名不能为空")
    @Size(min = 3, max = 20, message = "用户名长度必须在3-20之间")
    private String username;
    
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;
}
```

Controller中使用 `@Valid` 或 `@Validated` 触发校验：

```java
@PostMapping
public CommonResult<Void> create(@Valid @RequestBody UserCreateReq req) {
    // 参数已自动校验
    userService.create(req);
    return CommonResult.success();
}
```

### 6.3 数据权限

启用数据权限：

```yaml
wmt:
  data-permission:
    enabled: true
```

在Service方法上使用注解：

```java
import com.wmt.framework.datapermission.core.annotation.DataPermission;

@Service
public class UserService {
    
    @DataPermission(enable = true)
    public List<User> list() {
        // 自动根据当前用户的数据权限过滤
        return userMapper.selectList(null);
    }
}
```

### 6.4 多租户

启用多租户：

```yaml
wmt:
  tenant:
    enabled: true
    ignore-tables:
      - sys_config
      - sys_dict
```

在Service方法上使用注解：

```java
import com.wmt.framework.tenant.core.annotation.TenantIgnore;

@Service
public class UserService {
    
    public List<User> getUserList() {
        // 自动根据当前租户ID过滤
        return userMapper.selectList(null);
    }
    
    @TenantIgnore
    public List<User> getAllUsers() {
        // 忽略租户隔离
        return userMapper.selectList(null);
    }
}
```

### 6.5 分布式锁

使用Redis分布式锁：

```java
import com.wmt.framework.lock4j.core.annotation.Lock4j;

@Service
public class OrderService {
    
    @Lock4j(key = "order:create:#userId", waitTime = 3000, leaseTime = 5000)
    public void createOrder(Long userId) {
        // 使用分布式锁保护订单创建
    }
}
```

### 6.6 限流

```java
import com.wmt.framework.ratelimiter.core.annotation.RateLimiter;

@RestController
public class ApiController {
    
    @RateLimiter(key = "api:upload", count = 10, time = 60)
    @PostMapping("/upload")
    public CommonResult<String> upload() {
        // 每60秒最多10次请求
        return CommonResult.success();
    }
}
```

## 7. 进阶使用

### 7.1 查看所有自动配置

在 `application.yml` 中启用调试模式：

```yaml
debug: true
```

启动应用后会输出所有自动配置的详细信息。

### 7.2 自定义配置

大部分组件都支持自定义配置，查看对应的 `XxxProperties` 类了解所有配置项。

### 7.3 查看API文档

组件文档和API文档请参考：
- [README.md](README.md)
- [组件开发指南](COMPONENT_DEVELOPMENT.md)
- 各组件的 `package-info.java` 文件

## 8. 常见问题

### Q: 如何禁用某个组件？

A: 在配置文件中设置 `enabled = false`：

```yaml
wmt:
  xxx:
    enabled: false
```

### Q: 如何自定义错误响应格式？

A: 实现 `GlobalExceptionHandler` 的子类并覆盖相关方法。

### Q: 如何集成其他框架？

A: 参考 [组件开发指南](COMPONENT_DEVELOPMENT.md) 开发自定义组件。

## 9. 示例项目

完整的示例项目请参考：
- [GitHub示例仓库](https://github.com/Wmt/wmt-examples)

## 10. 获取帮助

- 查看文档：[README.md](README.md)
- 提交Issue：https://github.com/Wmt/wmt-framework/issues
- 邮箱：support@wmt.com
