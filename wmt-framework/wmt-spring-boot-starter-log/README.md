# WMT日志管理组件使用指南

## 概述

`wmt-spring-boot-starter-log` 是WMT框架的日志管理增强组件，提供日志收集、存储、分析、告警和可视化功能，支持与ELK Stack 7.17.23集成。

## 功能特性

- **日志收集**: 支持多种日志来源的收集，包括应用日志、访问日志、错误日志
- **日志存储**: 支持文件存储、Elasticsearch存储、数据库存储
- **日志分析**: 提供异常检测、趋势分析、统计分析
- **日志告警**: 支持多种告警规则和通知渠道
- **日志可视化**: 与Kibana集成，提供仪表板和可视化功能

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-log</artifactId>
    <version>2025.10-jdk8-SNAPSHOT</version>
</dependency>
```

### 2. 基础配置

在 `application.yml` 中添加基础配置：

```yaml
wmt:
  log:
    enabled: true
    collection:
      enabled: true
      levels: [INFO, WARN, ERROR]
      sources: [application, access, error]
      async: true
      queue-size: 1000
    storage:
      enabled: true
      type: elasticsearch  # file, elasticsearch, database
      elasticsearch:
        hosts: [localhost:9200]
        index-prefix: wmt-logs
        bulk-size: 1000
    analysis:
      enabled: true
      interval: PT5M  # 5分钟
      exception-detection:
        enabled: true
        threshold: 10
        time-window: PT10M
    alerting:
      enabled: true
      channels: [email, webhook]
      rules:
        - name: error-rate-alert
          description: 错误率告警
          condition: error_rate
          threshold: 0.1
          time-window: PT5M
          enabled: true
    visualization:
      enabled: true
      kibana:
        url: http://localhost:5601
        index-pattern: wmt-logs-*
```

### 3. ELK集成配置

#### Elasticsearch配置

```yaml
spring:
  elasticsearch:
    rest:
      uris: http://localhost:9200
      connection-timeout: 10s
      read-timeout: 30s
```

#### Logback配置

在 `logback-spring.xml` 中添加WMT日志Appender：

```xml
<configuration>
    <!-- 其他配置... -->
    
    <!-- WMT日志Appender -->
    <appender name="WMT_LOG" class="com.wmt.framework.log.appender.WmtLogAppender">
        <appName>${spring.application.name}</appName>
        <env>${spring.profiles.active}</env>
        <nodeId>${HOSTNAME:-${spring.application.name}}</nodeId>
    </appender>
    
    <!-- 异步WMT日志Appender -->
    <appender name="ASYNC_WMT_LOG" class="ch.qos.logback.classic.AsyncAppender">
        <discardingThreshold>0</discardingThreshold>
        <queueSize>512</queueSize>
        <appender-ref ref="WMT_LOG"/>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="ASYNC_FILE"/>
        <appender-ref ref="ASYNC_WMT_LOG"/>
    </root>
</configuration>
```

## 详细配置

### 日志收集配置

```yaml
wmt:
  log:
    collection:
      enabled: true                    # 是否启用日志收集
      levels: [INFO, WARN, ERROR]     # 收集的日志级别
      sources: [application, access, error]  # 日志来源
      interval: PT30S                 # 收集间隔
      batch-size: 100                 # 批量大小
      async: true                     # 是否异步收集
      queue-size: 1000               # 异步队列大小
```

### 日志存储配置

#### Elasticsearch存储

```yaml
wmt:
  log:
    storage:
      type: elasticsearch
      elasticsearch:
        hosts: [localhost:9200]        # Elasticsearch主机
        index-prefix: wmt-logs        # 索引前缀
        index-template: wmt-logs-template  # 索引模板
        bulk-size: 1000               # 批量写入大小
        refresh-interval: PT1S        # 刷新间隔
        connect-timeout: PT10S        # 连接超时
        read-timeout: PT30S           # 读取超时
```

#### 文件存储

```yaml
wmt:
  log:
    storage:
      type: file
      file:
        path: logs                    # 日志文件路径
        retention-days: 30           # 文件保留天数
        compress: true               # 是否压缩
        max-file-size: 100          # 文件大小限制(MB)
```

### 日志分析配置

```yaml
wmt:
  log:
    analysis:
      enabled: true
      interval: PT5M                 # 分析间隔
      exception-detection:
        enabled: true
        threshold: 10               # 异常阈值
        time-window: PT10M          # 时间窗口
      trend-analysis:
        enabled: true
        period: PT1H                # 分析周期
        metrics: [error_rate, response_time, throughput]  # 趋势指标
```

### 日志告警配置

```yaml
wmt:
  log:
    alerting:
      enabled: true
      channels: [email, webhook, sms]  # 告警通知方式
      rules:
        - name: error-rate-alert
          description: 错误率告警
          condition: error_rate
          threshold: 0.1
          time-window: PT5M
          enabled: true
        - name: response-time-alert
          description: 响应时间告警
          condition: avg_response_time
          threshold: 1000
          time-window: PT5M
          enabled: true
      config:
        email:
          smtp-host: smtp.example.com
          smtp-port: 587
          username: alert@example.com
          password: password
        webhook:
          url: http://webhook.example.com/alerts
          timeout: 30s
```

### 日志可视化配置

```yaml
wmt:
  log:
    visualization:
      enabled: true
      kibana:
        url: http://localhost:5601
        index-pattern: wmt-logs-*
        default-time-range: last 1 hour
      dashboard:
        enabled: true
        config:
          title: WMT日志监控仪表板
          panels:
            - type: histogram
              title: 日志时间分布
            - type: pie
              title: 日志级别分布
```

## API接口

组件提供了REST API接口用于日志管理：

### 日志查询

```bash
# 查询日志
POST /api/logs/query
Content-Type: application/json

{
  "level": "ERROR",
  "startTime": "2025-01-01T00:00:00",
  "endTime": "2025-01-01T23:59:59",
  "appName": "my-app"
}

# 分页查询日志
POST /api/logs/query/page?page=0&size=20
Content-Type: application/json

{
  "level": "ERROR",
  "startTime": "2025-01-01T00:00:00",
  "endTime": "2025-01-01T23:59:59"
}
```

### 日志分析

```bash
# 执行日志分析
POST /api/logs/analysis?startTime=2025-01-01T00:00:00&endTime=2025-01-01T23:59:59

# 获取分析历史
GET /api/logs/analysis/history?limit=10
```

### 告警管理

```bash
# 获取告警历史
GET /api/logs/alerts/history?startTime=2025-01-01T00:00:00&endTime=2025-01-01T23:59:59

# 获取未处理告警
GET /api/logs/alerts/unhandled

# 处理告警
POST /api/logs/alerts/{alertId}/handle?handler=admin&handleNote=已处理

# 获取告警统计
GET /api/logs/alerts/statistics
```

### 可视化管理

```bash
# 创建索引模式
POST /api/logs/visualization/index-pattern?indexPattern=wmt-logs-*

# 创建仪表板
POST /api/logs/visualization/dashboard
Content-Type: application/json

{
  "title": "WMT日志监控",
  "panels": [...]
}

# 获取仪表板列表
GET /api/logs/visualization/dashboards

# 导出仪表板
GET /api/logs/visualization/dashboard/{dashboardId}/export

# 导入仪表板
POST /api/logs/visualization/dashboard/import
Content-Type: application/json

{
  "title": "导入的仪表板",
  "config": {...}
}
```

## 使用示例

### 在代码中使用

```java
@Service
public class UserService {
    
    private static final Logger log = LoggerFactory.getLogger(UserService.class);
    
    public User getUserById(Long userId) {
        // 设置MDC上下文
        MDC.put("userId", userId.toString());
        MDC.put("operation", "getUserById");
        
        try {
            log.info("查询用户信息: {}", userId);
            User user = userRepository.findById(userId);
            
            if (user == null) {
                log.warn("用户不存在: {}", userId);
                return null;
            }
            
            log.info("用户查询成功: {}", user.getName());
            return user;
        } catch (Exception e) {
            log.error("查询用户失败: {}", userId, e);
            throw e;
        } finally {
            // 清理MDC
            MDC.clear();
        }
    }
}
```

### 自定义告警规则

```java
@Component
public class CustomAlertRule {
    
    @Autowired
    private LogAlertingService alertingService;
    
    @Scheduled(fixedDelay = 60000) // 每分钟检查一次
    public void checkCustomAlert() {
        LocalDateTime endTime = LocalDateTime.now();
        LocalDateTime startTime = endTime.minusMinutes(5);
        
        List<LogAlert> alerts = alertingService.checkAlerts(startTime, endTime);
        
        for (LogAlert alert : alerts) {
            // 自定义告警处理逻辑
            if ("error_rate".equals(alert.getCondition())) {
                // 发送邮件通知
                sendEmailNotification(alert);
            }
        }
    }
    
    private void sendEmailNotification(LogAlert alert) {
        // 实现邮件发送逻辑
    }
}
```

## 注意事项

1. **性能考虑**: 在生产环境中建议启用异步日志收集，避免影响应用性能
2. **存储空间**: 根据日志量合理配置存储策略，避免存储空间不足
3. **告警频率**: 合理设置告警规则，避免告警风暴
4. **ELK版本**: 确保Elasticsearch版本与ELK 7.17.23兼容
5. **网络配置**: 确保应用能够访问Elasticsearch和Kibana服务

## 故障排除

### 常见问题

1. **日志收集失败**
   - 检查队列大小是否足够
   - 检查存储服务是否正常
   - 查看应用日志中的错误信息

2. **Elasticsearch连接失败**
   - 检查Elasticsearch服务是否启动
   - 检查网络连接和防火墙设置
   - 验证Elasticsearch版本兼容性

3. **告警不生效**
   - 检查告警规则配置
   - 验证告警通知渠道配置
   - 查看告警服务日志

4. **Kibana可视化问题**
   - 检查Kibana服务状态
   - 验证索引模式配置
   - 检查仪表板权限设置

## 版本兼容性

- Spring Boot: 2.7.18
- Elasticsearch: 7.17.23
- Logstash: 7.17.23
- Kibana: 7.17.23
- Java: 8+
