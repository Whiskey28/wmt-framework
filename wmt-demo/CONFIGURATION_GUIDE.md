# WMT Demo 配置指南

## 必需的配置项

### 1. 基础包路径配置

MyBatis Mapper 扫描需要配置基础包路径：

```yaml
Wmt:
  info:
    base-package: com.wmt.demo  # 你的项目基础包路径
```

> **注意**：这里是大写的 `Wmt`，不是小写的 `wmt`！

### 2. 数据库配置

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/wmt_demo
    username: root
    password: your-password
```

### 3. Redis配置

```yaml
spring:
  redis:
    host: 127.0.0.1
    port: 6379
    password: your-password  # 如果没有密码，留空或删除此行
```

## 可选的配置项

### 1. Web组件配置

```yaml
wmt:
  web:
    api-prefix: /api
    cors:
      enabled: true
    doc:
      enabled: true
      title: 你的API文档标题
```

### 2. Security组件配置

```yaml
wmt:
  security:
    enabled: true
    permit-all-urls:
      - /api/public/**
      - /swagger-ui/**
    token:
      secret: your-jwt-secret
      expire-time: 720
```

### 3. XXL-JOB配置（默认禁用）

```yaml
xxl:
  job:
    enabled: false  # 如果不使用定时任务，保持false
    # enabled: true  # 如果使用，需配置以下参数
    # admin:
    #   addresses: http://your-xxljob-server:8088/xxl-job-admin
    # executor:
    #   appname: wmt-demo-executor
```

## 配置优先级

1. `wmt.info.base-package` - **必需**，大写W开头
2. 数据库连接 - 如果使用MyBatis功能
3. Redis连接 - 如果使用缓存功能
4. 其他 `wmt.*` 配置 - 小写w开头，可选

## 常见配置问题

### Q1: 启动报错 `Could not resolve placeholder 'wmt.info.base-package'`

**原因**：缺少基础包配置

**解决**：在 application.yml 中添加：
```yaml
Wmt:
  info:
    base-package: com.wmt.demo
```

### Q2: 大写 Wmt 和小写 wmt 有什么区别？

- `wmt.info.base-package` - 用于 MyBatis Mapper 扫描，大写W
- `wmt.*` - 其他组件配置，小写w

这是框架的设计，两者不能混用。

### Q3: 如何禁用某个组件？

大多数组件都支持通过 `enabled` 属性禁用：

```yaml
wmt:
  redis:
    enabled: false  # 禁用Redis组件
  security:
    enabled: false  # 禁用Security组件
  mybatis:
    enabled: false  # 禁用MyBatis组件
```

### Q4: 如何配置开发和生产环境？

使用 Spring Profile：

- `application.yml` - 通用配置
- `application-dev.yml` - 开发环境
- `application-prod.yml` - 生产环境

在 `application.yml` 中激活：
```yaml
spring:
  profiles:
    active: dev  # 或 prod
```

## 完整配置示例

### 最小配置（仅数据库和基础功能）

```yaml
server:
  port: 8080

spring:
  application:
    name: wmt-demo
  datasource:
    url: jdbc:mysql://localhost:3306/wmt_demo
    username: root
    password: root

Wmt:
  info:
    base-package: com.wmt.demo
```

### 完整配置（所有功能）

参考项目中的 `application.yml` 文件。

## 配置验证

启动应用后，检查日志：

✅ 成功启动的标志：
```
Started DemoApplication in X.XXX seconds
```

❌ 配置错误的标志：
```
Could not resolve placeholder 'wmt.info.base-package'
Failed to configure a DataSource
Unable to connect to Redis
```

## 获取帮助

如果遇到配置问题：

1. 检查日志中的具体错误信息
2. 参考 `CONFIG_EXAMPLES.md` 查看详细配置示例
3. 参考 `TESTING.md` 查看测试指南
4. 确保所有依赖的服务（MySQL、Redis等）已启动

---

**配置优先级提示**：
- 命令行参数 > 环境变量 > 配置文件
- application-{profile}.yml > application.yml

