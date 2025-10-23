# WMT Demo 配置示例

本文档提供各个组件的详细配置示例和说明。

## 目录

- [基础配置](#基础配置)
- [数据源配置](#数据源配置)
- [Redis配置](#redis配置)
- [MyBatis配置](#mybatis配置)
- [Security配置](#security配置)
- [Web配置](#web配置)
- [Excel配置](#excel配置)
- [XXL-JOB配置](#xxl-job配置)
- [日志配置](#日志配置)

## 基础配置

### 服务器配置

```yaml
server:
  # 服务端口
  port: 8080
  # 应用上下文路径
  servlet:
    context-path: /demo
  # Tomcat配置
  tomcat:
    # 最大线程数
    max-threads: 200
    # 最小空闲线程数
    min-spare-threads: 10
    # 连接超时时间
    connection-timeout: 5000
    # URI编码
    uri-encoding: UTF-8
```

### 应用配置

```yaml
spring:
  application:
    # 应用名称
    name: wmt-demo
  
  # 环境配置
  profiles:
    # 激活的环境：dev/test/prod
    active: dev
```

## 数据源配置

### MySQL + Druid 配置

```yaml
spring:
  datasource:
    # 数据库类型
    type: com.alibaba.druid.pool.DruidDataSource
    # 驱动类
    driver-class-name: com.mysql.cj.jdbc.Driver
    # 数据库连接URL
    url: jdbc:mysql://127.0.0.1:3306/wmt_demo?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false
    # 用户名
    username: root
    # 密码
    password: root
    
    # Druid连接池配置
    druid:
      # 初始连接数
      initial-size: 5
      # 最小空闲连接数
      min-idle: 5
      # 最大活动连接数
      max-active: 20
      # 获取连接等待超时时间（毫秒）
      max-wait: 60000
      # 配置间隔多久进行一次检测，检测需要关闭的空闲连接（毫秒）
      time-between-eviction-runs-millis: 60000
      # 配置一个连接在池中最小生存的时间（毫秒）
      min-evictable-idle-time-millis: 300000
      # 验证连接有效性的SQL
      validation-query: SELECT 1
      # 建议配置为true，不影响性能，并且保证安全性
      test-while-idle: true
      # 申请连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能
      test-on-borrow: false
      # 归还连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能
      test-on-return: false
      # 是否缓存preparedStatement，也就是PSCache
      pool-prepared-statements: true
      # 要启用PSCache，必须配置大于0，当大于0时，poolPreparedStatements自动触发修改为true
      max-pool-prepared-statement-per-connection-size: 20
      
      # 监控统计配置
      web-stat-filter:
        enabled: true
        url-pattern: /*
        exclusions: "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*"
      
      # StatViewServlet配置（监控页面配置）
      stat-view-servlet:
        enabled: true
        url-pattern: /druid/*
        # 登录用户名
        login-username: admin
        # 登录密码
        login-password: admin
        # 允许访问的IP地址，为空则允许所有
        allow: 
        # 拒绝访问的IP地址
        deny: 
        # 是否能够重置数据
        reset-enable: false
      
      # 配置StatFilter
      filter:
        stat:
          enabled: true
          # 慢SQL记录
          log-slow-sql: true
          slow-sql-millis: 1000
          merge-sql: false
        # 配置WallFilter（防火墙）
        wall:
          enabled: true
          config:
            multi-statement-allow: true
```

### 多数据源配置示例

```yaml
spring:
  datasource:
    # 主数据源
    master:
      driver-class-name: com.mysql.cj.jdbc.Driver
      url: jdbc:mysql://127.0.0.1:3306/master_db
      username: root
      password: root
    # 从数据源
    slave:
      driver-class-name: com.mysql.cj.jdbc.Driver
      url: jdbc:mysql://127.0.0.1:3306/slave_db
      username: root
      password: root
```

## Redis配置

### 单机模式

```yaml
spring:
  redis:
    # Redis服务器地址
    host: 127.0.0.1
    # Redis服务器端口
    port: 6379
    # Redis服务器密码（默认为空）
    password: 
    # Redis数据库索引（默认为0）
    database: 0
    # 连接超时时间
    timeout: 5000ms
    
    # Lettuce连接池配置
    lettuce:
      pool:
        # 最大连接数
        max-active: 8
        # 最大阻塞等待时间（负数表示没有限制）
        max-wait: -1ms
        # 最大空闲连接
        max-idle: 8
        # 最小空闲连接
        min-idle: 0
      # 关闭超时时间
      shutdown-timeout: 100ms
```

### 集群模式

```yaml
spring:
  redis:
    cluster:
      nodes:
        - 192.168.1.1:6379
        - 192.168.1.2:6379
        - 192.168.1.3:6379
      max-redirects: 3
    password: your-password
    timeout: 5000ms
```

### 哨兵模式

```yaml
spring:
  redis:
    sentinel:
      master: mymaster
      nodes:
        - 192.168.1.1:26379
        - 192.168.1.2:26379
        - 192.168.1.3:26379
    password: your-password
    timeout: 5000ms
```

### 缓存配置

```yaml
spring:
  cache:
    # 缓存类型：redis
    type: redis
    redis:
      # 缓存过期时间（毫秒）
      time-to-live: 3600000
      # 是否缓存空值
      cache-null-values: true
      # 键前缀
      key-prefix: "wmt:cache:"
      # 是否使用键前缀
      use-key-prefix: true
```

## MyBatis配置

### MyBatis Plus 配置

```yaml
mybatis-plus:
  # 配置
  configuration:
    # 驼峰下划线转换
    map-underscore-to-camel-case: true
    # 日志实现
    log-impl: org.apache.ibatis.logging.slf4j.Slf4jImpl
    # 是否开启缓存
    cache-enabled: false
    # 延迟加载
    lazy-loading-enabled: true
  
  # 全局配置
  global-config:
    db-config:
      # 主键类型：auto（数据库自增）
      id-type: auto
      # 逻辑删除字段
      logic-delete-field: deleted
      # 逻辑删除值
      logic-delete-value: 1
      # 逻辑未删除值
      logic-not-delete-value: 0
      # 表名前缀
      table-prefix: 
  
  # Mapper XML文件位置
  mapper-locations: classpath*:mapper/*.xml
  # 实体类别名包路径
  type-aliases-package: com.wmt.demo.entity
```

### 分页配置

```yaml
# MyBatis Plus自动配置分页插件
mybatis-plus:
  configuration:
    # 默认分页大小
    default-fetch-size: 10
    # 最大分页大小
    default-statement-timeout: 30
```

## Security配置

### WMT Security 组件配置

```yaml
wmt:
  security:
    # 是否启用
    enabled: true
    
    # 排除路径（不需要认证）
    permit-all-urls:
      - /api/auth/**
      - /api/public/**
      - /api/user/list
      - /druid/**
      - /swagger-ui/**
      - /v3/api-docs/**
      - /webjars/**
      - /favicon.ico
      - /error
    
    # Token配置
    token:
      # 令牌自定义标识（请求头名称）
      header: Authorization
      # 令牌密钥（请使用足够复杂的密钥）
      secret: abcdefghijklmnopqrstuvwxyz0123456789
      # 令牌有效期（分钟）
      expire-time: 720
      # 令牌前缀
      token-prefix: "Bearer "
    
    # 密码加密配置
    password:
      # 加密算法：BCrypt
      encoder: BCrypt
      # BCrypt强度（4-31，推荐10-12）
      strength: 10
```

## Web配置

### WMT Web 组件配置

```yaml
wmt:
  web:
    # API前缀
    api-prefix: /api
    
    # 跨域配置
    cors:
      enabled: true
      # 允许的源（* 表示所有）
      allowed-origins: "*"
      # 允许的方法
      allowed-methods: "*"
      # 允许的请求头
      allowed-headers: "*"
      # 是否允许携带凭证
      allow-credentials: true
      # 预检请求的有效期（秒）
      max-age: 3600
    
    # 接口文档配置（Swagger/OpenAPI）
    doc:
      enabled: true
      title: WMT Demo API文档
      description: WMT组件库演示项目接口文档
      version: 1.0.0
      contact-name: WMT Team
      contact-email: support@wmt.com
      contact-url: https://wmt.com
      # 扫描的包路径
      base-package: com.wmt.demo.controller
    
    # 全局返回值包装
    response:
      enabled: true
      # 排除路径
      exclude-urls:
        - /swagger-ui/**
        - /v3/api-docs/**
    
    # 全局异常处理
    exception:
      enabled: true
```

## Excel配置

### WMT Excel 组件配置

```yaml
wmt:
  excel:
    # 是否启用
    enabled: true
    
    # 导出配置
    export:
      # 默认sheet名称
      default-sheet-name: Sheet1
      # 最大导出行数
      max-rows: 100000
    
    # 导入配置
    import:
      # 最大导入行数
      max-rows: 10000
```

## XXL-JOB配置

### XXL-JOB 执行器配置

```yaml
xxl:
  job:
    # 是否启用
    enabled: true
    
    # 访问令牌（与调度中心配置一致）
    access-token: default_token
    
    # 调度中心配置
    admin:
      # 调度中心地址（多个用逗号分隔）
      addresses: http://127.0.0.1:8088/xxl-job-admin
    
    # 执行器配置
    executor:
      # 执行器AppName（与调度中心注册名称一致）
      appname: wmt-demo-executor
      # 执行器注册地址，为空则自动获取
      address: 
      # 执行器IP，为空则自动获取
      ip: 
      # 执行器端口
      port: 9999
      # 执行器日志路径
      logpath: ./logs/xxl-job
      # 执行器日志保留天数
      logretentiondays: 30
```

## 日志配置

### Logback 配置

```yaml
logging:
  # 日志级别
  level:
    root: INFO
    com.wmt: DEBUG
    org.springframework: INFO
    org.mybatis: DEBUG
  
  # 日志格式
  pattern:
    # 控制台输出格式
    console: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n"
    # 文件输出格式
    file: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n"
  
  # 日志文件配置
  file:
    # 日志文件名称
    name: ./logs/wmt-demo.log
    # 日志文件最大大小
    max-size: 100MB
    # 日志文件最大保存天数
    max-history: 30
```

## 完整配置示例

以下是一个生产环境的完整配置示例：

```yaml
server:
  port: 8080
  servlet:
    context-path: /api
  tomcat:
    max-threads: 200
    min-spare-threads: 10

spring:
  application:
    name: wmt-demo
  profiles:
    active: prod
  
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://prod-mysql:3306/wmt_demo?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=true
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
    druid:
      initial-size: 10
      min-idle: 10
      max-active: 50
      max-wait: 60000
      stat-view-servlet:
        enabled: true
        login-username: ${DRUID_USERNAME}
        login-password: ${DRUID_PASSWORD}
  
  redis:
    host: ${REDIS_HOST}
    port: 6379
    password: ${REDIS_PASSWORD}
    database: 0
    timeout: 5000ms
    lettuce:
      pool:
        max-active: 20
        max-wait: -1ms
        max-idle: 10
        min-idle: 5
  
  cache:
    type: redis
    redis:
      time-to-live: 3600000

mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.slf4j.Slf4jImpl
  global-config:
    db-config:
      id-type: auto
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0

xxl:
  job:
    enabled: true
    access-token: ${XXL_JOB_TOKEN}
    admin:
      addresses: ${XXL_JOB_ADMIN_ADDRESSES}
    executor:
      appname: wmt-demo-executor
      port: 9999
      logpath: /app/logs/xxl-job
      logretentiondays: 30

wmt:
  web:
    api-prefix: /api
    cors:
      enabled: true
      allowed-origins: "https://yourdomain.com"
      allowed-methods: "GET,POST,PUT,DELETE"
      allow-credentials: true
    doc:
      enabled: false  # 生产环境关闭文档
  
  security:
    enabled: true
    permit-all-urls:
      - /api/auth/**
      - /api/public/**
    token:
      header: Authorization
      secret: ${JWT_SECRET}
      expire-time: 720
  
  redis:
    enabled: true
  
  excel:
    enabled: true
  
  mybatis:
    enabled: true

logging:
  level:
    root: INFO
    com.wmt: INFO
  file:
    name: /app/logs/wmt-demo.log
    max-size: 100MB
    max-history: 30
```

## 环境变量说明

在生产环境中，建议使用环境变量替换敏感信息：

| 环境变量 | 说明 | 示例 |
|---------|------|------|
| DB_USERNAME | 数据库用户名 | root |
| DB_PASSWORD | 数据库密码 | your-db-password |
| REDIS_HOST | Redis主机地址 | redis.example.com |
| REDIS_PASSWORD | Redis密码 | your-redis-password |
| JWT_SECRET | JWT密钥 | your-jwt-secret-key |
| XXL_JOB_TOKEN | XXL-JOB访问令牌 | your-xxljob-token |
| XXL_JOB_ADMIN_ADDRESSES | XXL-JOB调度中心地址 | http://xxljob.example.com |
| DRUID_USERNAME | Druid监控用户名 | admin |
| DRUID_PASSWORD | Druid监控密码 | your-druid-password |

## 配置优先级

Spring Boot 配置文件的加载优先级（从高到低）：

1. 命令行参数
2. JNDI属性
3. Java系统属性（System.getProperties()）
4. 操作系统环境变量
5. 配置文件（application-{profile}.yml）
6. 默认配置文件（application.yml）

## 最佳实践

1. **敏感信息保护**：不要在配置文件中硬编码密码等敏感信息，使用环境变量或配置中心
2. **环境隔离**：为不同环境（开发、测试、生产）使用不同的配置文件
3. **配置外部化**：生产环境的配置文件应放在应用外部，便于修改
4. **合理的日志级别**：开发环境使用DEBUG，生产环境使用INFO或WARN
5. **连接池配置**：根据实际负载合理配置数据库和Redis连接池大小
6. **安全配置**：生产环境关闭不必要的端点和监控页面

祝配置顺利！ 🎉

