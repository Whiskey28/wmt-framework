# WMT Demo - 组件库演示项目

这是一个完整的 Spring Boot 演示项目，用于验证 WMT 组件库的各项功能。

## 项目简介

本项目模拟真实的业务系统，集成了 WMT 组件库中的以下组件：

- **wmt-spring-boot-starter-web** - Web基础组件（含Swagger文档）
- **wmt-spring-boot-starter-security** - 安全认证组件
- **wmt-spring-boot-starter-cache** - Redis缓存组件
- **wmt-spring-boot-starter-mybatis** - MyBatis增强组件
- **wmt-spring-boot-starter-excel** - Excel导入导出组件
- **wmt-spring-boot-starter-xxljob** - XXL-JOB定时任务组件

## 快速开始

### 1. 环境准备

确保已安装以下软件：

- JDK 1.8+
- Maven 3.6+
- MySQL 5.7+
- Redis 5.0+
- （可选）XXL-JOB调度中心

### 2. 数据库初始化

执行 SQL 脚本初始化数据库：

```bash
mysql -u root -p < src/main/resources/sql/schema.sql
```

### 3. 修改配置

编辑 `src/main/resources/application-dev.yml`，修改数据库和 Redis 连接配置：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/wmt_demo?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
    username: root
    password: your-password
  
  redis:
    host: 127.0.0.1
    port: 6379
    password: your-redis-password
```

### 4. 启动应用

```bash
# 在项目根目录执行
cd wmt-demo
mvn spring-boot:run
```

或者在IDE中直接运行 `DemoApplication` 主类。

### 5. 访问应用

启动成功后，访问以下地址：

- 应用首页：http://localhost:8080/demo
- API文档：http://localhost:8080/demo/swagger-ui/index.html
- Druid监控：http://localhost:8080/demo/druid/index.html (账号/密码：admin/admin)

## 功能演示

### 1. Web 功能测试

访问 Swagger 文档，可以看到所有的 API 接口：

- 用户列表查询：`GET /api/user/list`
- 用户详情查询：`GET /api/user/{id}`
- 创建用户：`POST /api/user`
- 更新用户：`PUT /api/user`
- 删除用户：`DELETE /api/user/{id}`

### 2. Redis 缓存测试

调用以下接口测试 Redis 缓存功能：

```bash
# 测试Redis存取
curl -X POST "http://localhost:8080/demo/api/user/redis/test?key=test&value=hello"

# 根据用户名查询（会使用Redis缓存）
curl "http://localhost:8080/demo/api/user/username/admin"
```

### 3. MyBatis 功能测试

所有的用户 CRUD 操作都通过 MyBatis Plus 实现，支持：

- 基础的增删改查
- 分页查询
- 条件构造器
- Lambda 查询

### 4. Excel 导入导出测试

```bash
# 导出用户列表为Excel
curl "http://localhost:8080/demo/api/user/export" -o users.xlsx
```

### 5. Security 安全认证测试

部分接口需要认证才能访问，可以通过配置中的 `permit-all-urls` 来设置不需要认证的路径。

### 6. XXL-JOB 定时任务测试

如果配置了 XXL-JOB 调度中心，可以在调度中心添加以下任务：

- 执行器：wmt-demo-executor
- JobHandler：demoJob
- 运行模式：BEAN
- Cron表达式：根据需要设置

## 项目结构

```
wmt-demo/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/wmt/demo/
│   │   │       ├── DemoApplication.java          # 应用启动类
│   │   │       ├── controller/                    # 控制器层
│   │   │       │   └── UserController.java
│   │   │       ├── service/                       # 服务层
│   │   │       │   ├── UserService.java
│   │   │       │   └── impl/
│   │   │       │       └── UserServiceImpl.java
│   │   │       ├── mapper/                        # 数据访问层
│   │   │       │   └── UserMapper.java
│   │   │       ├── entity/                        # 实体类
│   │   │       │   ├── User.java
│   │   │       │   └── UserExcelVO.java
│   │   │       └── job/                           # 定时任务
│   │   │           └── DemoJob.java
│   │   └── resources/
│   │       ├── application.yml                    # 主配置文件
│   │       ├── application-dev.yml                # 开发环境配置
│   │       ├── application-prod.yml               # 生产环境配置
│   │       └── sql/
│   │           └── schema.sql                     # 数据库初始化脚本
│   └── test/
│       └── java/
│           └── com/wmt/demo/
│               └── DemoApplicationTest.java       # 单元测试
├── pom.xml                                         # Maven配置
└── README.md                                       # 项目说明
```

## 配置说明

### 主要配置项

在 `application.yml` 中配置各组件：

```yaml
wmt:
  # Web配置
  web:
    api-prefix: /api
    cors:
      enabled: true
    doc:
      enabled: true
      title: WMT Demo API文档
  
  # Security配置
  security:
    enabled: true
    permit-all-urls:
      - /api/user/list
      - /druid/**
      - /swagger-ui/**
  
  # Redis配置
  redis:
    enabled: true
  
  # Excel配置
  excel:
    enabled: true
  
  # MyBatis配置
  mybatis:
    enabled: true
```

## 常见问题

### 1. 数据库连接失败

检查 MySQL 是否启动，数据库是否已创建，用户名密码是否正确。

### 2. Redis 连接失败

检查 Redis 是否启动，连接配置是否正确。如果 Redis 没有密码，将配置中的 `password` 留空。

### 3. 组件未生效

确保在 `application.yml` 中将对应组件的 `enabled` 设置为 `true`。

### 4. XXL-JOB 启动失败

如果不使用 XXL-JOB，可以在配置中设置：

```yaml
xxl:
  job:
    enabled: false
```

## 扩展开发

基于本演示项目，你可以：

1. 添加更多的实体类和业务逻辑
2. 集成其他 WMT 组件（如 WebSocket、MQ 等）
3. 扩展 Controller 添加更多接口
4. 添加更多的定时任务
5. 实现复杂的业务场景

## 技术支持

如有问题，请联系 WMT 技术团队。

## 许可证

本项目采用 MIT 许可证。

