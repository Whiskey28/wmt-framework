# WMT Prometheus + Grafana Starter

> 面向 Spring Boot 业务系统的一站式 Prometheus 指标采集与 Grafana 可视化组件，开箱即用地暴露指标、导出 Dashboard/告警模板，并提供 PushGateway/自定义标签等扩展能力。

## 功能特性

- 📊 **统一指标**：基于 Micrometer 自动注册 HTTP、JVM、数据库、线程等核心指标，默认暴露 `/actuator/prometheus`。
- 🏷️ **公共标签**：可统一注入 `service`、`env` 等自定义标签，方便跨系统聚合。
- 🚨 **告警模板**：内置 `default-alert-rules.yml`（错误率、延迟、JVM、磁盘等），可一键导出并对接 Alertmanager。
- 📈 **Grafana Dashboard 模板**：预置 `default-app.json` 仪表盘，覆盖核心指标，支持导出后直接导入 Grafana。
- 🚀 **PushGateway 支持**：内置定时推送器，适配无长期运行的 Job/批处理任务。
- 🧩 **可扩展**：保留 `MeterRegistryCustomizer` 扩展点，可自由添加业务指标或自定义 Exporter。

## 快速开始

### 1. 引入依赖

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-prometheus-grafana</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置示例

```yaml
wmt:
  prometheus:
    enabled: true
    endpoint: /actuator/prometheus
    common-tags:
      enabled: true
      service: ${spring.application.name}
      environment: prod
      extra:
        region: cn-shanghai
    dashboard:
      export-path: ./monitoring/grafana/dashboards
    alerts:
      export-path: ./monitoring/prometheus/rules
    push-gateway:
      enabled: false
      base-url: http://localhost:9091
      job: ${spring.application.name}
      push-rate: 30s
```

- `dashboard.export-path`、`alerts.export-path` 配置后，Starter 会在应用启动期自动将内置模板拷贝到指定目录（便于纳入 Git 或运维仓库）。
- PushGateway 默认关闭；适合短任务/批任务时开启，通过 `push-rate` 控制推送间隔（支持 `10s`、`1m` 等 ISO-8601/简单持续时间写法）。

### 3. Grafana & Prometheus

1. **Prometheus 抓取**：`prometheus.yml` 中追加
   ```yaml
   - job_name: my-service
     metrics_path: /actuator/prometheus
     scheme: http
     static_configs:
       - targets: ["my-service:8080"]
   ```
2. **Grafana 导入**：在 Grafana -> Dashboards -> Import，上传 `default-app.json`。
3. **告警规则**：将导出的 `default-alert-rules.yml` 放入 Prometheus/Alertmanager Rule 目录并重载即可。

## 属性说明

| 配置项 | 默认值 | 说明 |
| --- | --- | --- |
| `wmt.prometheus.enabled` | `true` | 是否启用 Starter |
| `wmt.prometheus.endpoint` | `/actuator/prometheus` | 暴露指标端点 |
| `wmt.prometheus.common-tags.*` | - | 统一标签配置（service/environment/extra） |
| `wmt.prometheus.dashboard.export-path` | `null` | 指定后自动导出 Grafana Dashboard 模板 |
| `wmt.prometheus.alerts.export-path` | `null` | 指定后自动导出 Prometheus 告警规则模板 |
| `wmt.prometheus.push-gateway.enabled` | `false` | 是否启用 PushGateway 推送 |
| `wmt.prometheus.push-gateway.base-url` | `http://localhost:9091` | PushGateway 地址 |
| `wmt.prometheus.push-gateway.job` | `wmt-app` | 推送 Job 名称 |
| `wmt.prometheus.push-gateway.push-rate` | `30s` | 推送间隔（ISO-8601 Duration 或简单时间，如 `15s`） |

## 模板清单

- `wmt/prometheus/dashboards/default-app.json`：包含 JVM、HTTP、数据库、线程、系统负载等核心图表。
- `wmt/prometheus/alerts/default-alert-rules.yml`：覆盖高错误率、高延迟、JVM 内存、CPU、磁盘等告警示例。

## 业务指标埋点

### 使用 DomainMetricPublisher（推荐）

Starter 提供了 `DomainMetricPublisher` 工具类，让业务系统无需直接依赖 `MeterRegistry` 即可发布指标，避免与 SpringDoc Swagger 的 `Tag` 类冲突。

#### 计数器示例

```java
@Service
public class OrderService {
    
    public Long createOrder(OrderCreateReq req) {
        try {
            // 业务逻辑...
            Long orderId = orderMapper.insert(order);
            
            // 记录成功计数
            DomainMetricPublisher.counter(
                "biz_order_create_total",
                Tag.of("channel", req.getChannel()),
                Tag.of("status", "success")
            );
            
            return orderId;
        } catch (Exception e) {
            // 记录失败计数
            DomainMetricPublisher.counter(
                "biz_order_create_total",
                Tag.of("channel", req.getChannel()),
                Tag.of("status", "failure")
            );
            throw e;
        }
    }
}
```

#### 计时器示例

```java
@RestController
public class OrderController {
    
    @GetMapping("/orders/{id}")
    public CommonResult<OrderVO> getOrder(@PathVariable Long id) {
        Timer.Sample sample = DomainMetricPublisher.startTimer("biz_order_query_duration");
        try {
            OrderVO order = orderService.getOrder(id);
            return CommonResult.success(order);
        } finally {
            if (sample != null) {
                sample.stop(
                    Timer.builder("biz_order_query_duration")
                        .tag("type", "detail")
                        .register(/* MeterRegistry 会自动注入 */)
                );
            }
        }
    }
}
```

或者使用更简单的 `recordTimer` 方法：

```java
@GetMapping("/orders/{id}")
public CommonResult<OrderVO> getOrder(@PathVariable Long id) {
    long startTime = System.currentTimeMillis();
    try {
        OrderVO order = orderService.getOrder(id);
        return CommonResult.success(order);
    } finally {
        DomainMetricPublisher.recordTimer("biz_order_query_duration", 
            System.currentTimeMillis() - startTime,
            Tag.of("type", "detail"));
    }
}
```

#### 状态值（Gauge）示例

```java
@Service
public class InventoryService {
    
    @PostConstruct
    public void initMetrics() {
        // 注册库存数量 Gauge
        DomainMetricPublisher.gauge(
            "biz_inventory_count",
            () -> this.getTotalInventory(),
            Tag.of("warehouse", "main")
        );
    }
    
    private Long getTotalInventory() {
        return inventoryMapper.selectCount(null);
    }
}
```

### 注意事项

- **Tag 类不会冲突**：`DomainMetricPublisher` 使用的是 `io.micrometer.core.instrument.Tag`，与 SpringDoc Swagger 的 `io.swagger.v3.oas.annotations.tags.Tag` 完全不同的包路径，不会产生冲突。
- **指标命名规范**：建议使用 `biz_module_action_total` 或 `biz_module_action_duration` 格式，便于在 Grafana 中统一查询。
- **标签数量控制**：建议每个指标不超过 5 个标签，避免维度爆炸。

## 测试指南

完整的测试方案（包括 Docker Compose 环境搭建、业务指标测试、Grafana 可视化验证）请参考：[TESTING_GUIDE.md](./TESTING_GUIDE.md)

快速启动测试环境：

```bash
# 在 wmt-spring-boot-starter-prometheus-grafana 目录下
docker-compose up -d

# 访问 Prometheus: http://localhost:9090
# 访问 Grafana: http://localhost:3000 (admin/admin123)
```

## 与现有模块的关系

- `wmt-spring-boot-starter-monitor`：聚焦 SkyWalking 链路追踪、业务追踪；Prom/Grafana Starter 可以单独或同时使用。
- `wmt-spring-boot-starter-elk-logging`：负责日志投递；与本模块互补，共同组成可观测性三件套。

## 后续扩展方向

- Grafana Provisioning（自动落盘 JSON + 数据源）。
- Helm/Compose 一键部署 Prometheus/Grafana/Alertmanager。
- Alertmanager Webhook/企业 IM 通知 Starter。

