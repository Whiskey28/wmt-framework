# WMT Demo 快速开始指南

## 简介

`wmt-demo` 是一个完整的 Spring Boot 演示项目，用于验证 WMT 组件库的各项功能。它集成了 redis、excel、xxljob、mybatis、security、web 等核心组件。

## 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 5.7+ (可选：如果要测试数据库功能)
- Redis 5.0+ (可选：如果要测试缓存功能)

## 快速启动步骤

### 1. 初始化数据库（可选）

如果需要测试数据库功能，请先创建数据库并执行初始化脚本：

```bash
# 连接MySQL
mysql -u root -p

# 执行初始化脚本
source src/main/resources/sql/schema.sql
```

或者直接运行SQL文件：

```bash
mysql -u root -p < src/main/resources/sql/schema.sql
```

### 2. 配置连接信息

编辑 `src/main/resources/application.yml` 文件，修改数据库和Redis连接配置：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/wmt_demo
    username: root
    password: your-password
  
  redis:
    host: 127.0.0.1
    port: 6379
    password: your-redis-password  # 如果没有密码，留空即可
```

### 3. 启动应用

#### 方式一：使用 Maven

```bash
# Windows
start.bat

# Linux/Mac
./start.sh
```

或者手动启动：

```bash
mvn spring-boot:run
```

#### 方式二：使用 IDE

在 IDE 中直接运行 `com.wmt.demo.DemoApplication` 主类。

### 4. 访问应用

应用启动成功后，访问以下地址：

- **Swagger API文档**: http://localhost:8080/demo/swagger-ui/index.html
- **Druid监控面板**: http://localhost:8080/demo/druid/index.html (账号/密码：admin/admin)

## 主要功能演示

### 1. 查看API文档

访问 Swagger 文档可以看到所有可用的API接口，包括：

- 用户管理（CRUD操作）
- Redis缓存测试
- Excel导入导出

### 2. 测试用户管理

使用 Swagger 或 curl 测试用户管理功能：

```bash
# 获取用户列表
curl http://localhost:8080/demo/api/user/list

# 根据ID获取用户
curl http://localhost:8080/demo/api/user/1

# 创建用户
curl -X POST http://localhost:8080/demo/api/user \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"123456","nickname":"测试用户","status":1}'
```

### 3. 测试Redis缓存

```bash
# 测试Redis基本操作
curl -X POST "http://localhost:8080/demo/api/user/redis/test?key=test&value=hello"

# 测试缓存查询（第二次查询会从缓存读取）
curl http://localhost:8080/demo/api/user/username/admin
```

### 4. 测试Excel导出

```bash
# 导出用户数据为Excel
curl http://localhost:8080/demo/api/user/export -o users.xlsx
```

## 组件配置说明

### Web 组件

- 自动配置了跨域支持
- 集成了 Swagger 文档
- 统一异常处理
- 统一返回结果封装

### Security 组件

- Token 认证机制
- 可配置的白名单路径
- 密码加密

### Redis 组件

- 自动配置 RedisTemplate
- 支持 @Cacheable 等缓存注解
- 可配置缓存过期时间

### MyBatis 组件

- 集成 MyBatis Plus
- 支持分页查询
- 逻辑删除
- 自动填充

### Excel 组件

- 基于 FastExcel/EasyExcel
- 支持导入导出
- 数据字典转换
- 自定义样式

### XXL-JOB 组件

- 分布式定时任务
- 可视化任务管理
- 支持任务监控

## 常见问题

### 1. 应用启动失败

**问题**：启动时报错 "Failed to configure a DataSource"

**解决**：
- 检查 MySQL 是否启动
- 确认数据库连接配置是否正确
- 如果不需要数据库，可以在 `application.yml` 中禁用：
  ```yaml
  spring:
    autoconfigure:
      exclude: org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
  ```

### 2. Redis 连接失败

**问题**：启动时报错 "Unable to connect to Redis"

**解决**：
- 检查 Redis 是否启动
- 确认 Redis 连接配置是否正确
- 如果不需要 Redis，可以禁用：
  ```yaml
  wmt:
    redis:
      enabled: false
  ```

### 3. Excel导出失败

**问题**：导出Excel时报错

**解决**：
- 确保已添加 EasyExcel 依赖
- 检查实体类上的注解是否正确

### 4. Swagger 无法访问

**问题**：访问 Swagger 页面404

**解决**：
- 确认应用是否启动成功
- 检查 context-path 配置
- 确认 Swagger 是否启用：
  ```yaml
  wmt:
    web:
      doc:
        enabled: true
  ```

## 下一步

- 查看 [README.md](README.md) 了解项目详情
- 查看 [TESTING.md](TESTING.md) 进行完整的功能测试
- 查看 [CONFIG_EXAMPLES.md](CONFIG_EXAMPLES.md) 了解详细配置

## 技术支持

如有问题，请查看项目文档或联系技术支持团队。

---

**快速体验 WMT 组件库，开启高效开发之旅！** 🚀
