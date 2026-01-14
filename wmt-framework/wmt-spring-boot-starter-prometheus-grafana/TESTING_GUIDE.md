# WMT Prometheus + Grafana Starter 测试指南

本指南帮助业务系统验证 `wmt-spring-boot-starter-prometheus-grafana` 的可用性，包括基础环境搭建、业务指标埋点测试、以及 Grafana 可视化验证。

---

## 一、环境准备

### 1.1 前置条件

- Docker & Docker Compose（用于启动 Prometheus + Grafana）
- JDK 8+ 和 Maven（用于编译业务系统）
- 业务系统已集成 `wmt-spring-boot-starter-prometheus-grafana` 依赖

### 1.2 启动监控基础设施

在 `wmt-spring-boot-starter-prometheus-grafana` 目录下执行：

```bash
docker-compose up -d
```

验证服务状态：

```bash
# 检查容器状态
docker-compose ps

# 访问 Prometheus（http://localhost:9090）
# 访问 Grafana（http://localhost:3000，用户名/密码：admin/admin123）
```

---

## 二、业务系统配置

### 2.1 添加依赖

在业务系统的 `pom.xml` 中添加：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-prometheus-grafana</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2.2 配置文件（application.yml）

```yaml
# 启用 Prometheus 指标
wmt:
  prometheus:
    enabled: true
    common-tags:
      enabled: true
      service: ${spring.application.name}
      environment: ${spring.profiles.active:dev}
      extra:
        version: "1.0.0"

# Spring Boot Actuator 配置
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
  metrics:
    export:
      prometheus:
        enabled: true
    tags:
      application: ${spring.application.name}
```

### 2.3 修改 Prometheus 抓取配置

#### 场景 A：Prometheus 在 Docker 中，业务系统在同一台机器（Linux/Mac）

编辑 `docker/prometheus/prometheus.yml`：

```yaml
scrape_configs:
  - job_name: 'wmt-application'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['host.docker.internal:8080']  # Docker 自动解析主机地址
```

#### 场景 B：Prometheus 在 VMware 虚拟机（CentOS7），业务系统在 Windows 主机

**步骤 1：确定 Windows 主机在 VMware 网络中的 IP**

在 CentOS7 虚拟机中执行：

```bash
# 查看网关 IP（通常是 Windows 主机的 IP）
ip route | grep default

# 或者查看网络接口信息
ip addr show

# 如果是 NAT 模式，Windows 主机 IP 通常是：
# - 192.168.x.1（x 是子网号）
# - 或 10.0.2.2（VMware 默认 NAT 网关）
```

**步骤 2：测试网络连通性**

在 CentOS7 虚拟机中测试能否访问 Windows 主机：

```bash
# 测试端口连通性（假设 Java 应用运行在 8080 端口）
curl http://192.168.x.1:8080/actuator/prometheus

# 或者使用 telnet
telnet 192.168.x.1 8080
```

如果无法访问，检查：
- Windows 防火墙是否允许 8080 端口入站
- Java 应用是否绑定到 `0.0.0.0` 而不是 `127.0.0.1`

**步骤 3：修改 Prometheus 配置**

编辑 `docker/prometheus/prometheus.yml`：

```yaml
scrape_configs:
  - job_name: 'wmt-application'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['192.168.x.1:8080']  # 替换为实际的 Windows 主机 IP 和端口
        labels:
          application: 'wmt-love'
          service: 'love-service'
          host: 'windows-idea'
```

**步骤 4：确保 Windows 防火墙允许访问**

在 Windows 上执行（以管理员身份运行 PowerShell）：

```powershell
# 允许 8080 端口入站（临时，仅用于测试）
New-NetFirewallRule -DisplayName "Allow Java App 8080" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow

# 或者通过 Windows 防火墙 GUI：
# 控制面板 -> Windows Defender 防火墙 -> 高级设置 -> 入站规则 -> 新建规则 -> 端口 -> TCP 8080 -> 允许
```

**步骤 5：确保 Java 应用监听所有网络接口**

在 `application.yml` 中确保：

```yaml
server:
  address: 0.0.0.0  # 监听所有网络接口，而不是默认的 127.0.0.1
  port: 8080
```

**步骤 6：重启 Prometheus**

```bash
docker-compose restart prometheus
```

**步骤 7：验证抓取是否成功**

1. 在 CentOS7 虚拟机中访问 Prometheus UI：`http://localhost:9090`
2. 进入 **Status → Targets**，查看 `wmt-application` 的状态
3. 如果状态为 **UP**，说明抓取成功
4. 在 **Graph** 页面输入 `up{job="wmt-application"}`，应该返回 `1`

#### 场景 C：使用桥接模式（推荐用于开发环境）

如果 VMware 使用桥接模式，Windows 主机和虚拟机在同一局域网，可以直接使用 Windows 主机的局域网 IP：

```bash
# 在 Windows 上查看 IP（PowerShell）
ipconfig

# 找到 VMware 网络适配器的 IP，例如：192.168.1.100
```

然后在 Prometheus 配置中使用：

```yaml
scrape_configs:
  - job_name: 'wmt-application'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['192.168.1.100:8080']  # Windows 主机的局域网 IP
```

---

## 三、业务指标埋点测试

### 3.1 使用 DomainMetricPublisher 发布指标

#### 示例 1：计数器（订单创建）

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

#### 示例 2：计时器（接口耗时）

**方式一：使用 startTimer（需要检查 null）**

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

**方式二：使用 recordTimer（推荐，更简单）**

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

#### 示例 3：状态值（库存数量）

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

### 3.2 验证指标暴露

启动业务系统后，访问：

```
http://localhost:8080/actuator/prometheus
```

搜索以下指标：

- `biz_order_create_total`（业务计数器）
- `biz_order_query_duration_seconds`（业务耗时）
- `biz_inventory_count`（业务状态值）
- `jvm_memory_used_bytes`（JVM 指标，自动暴露）
- `http_server_requests_seconds_count`（HTTP 指标，自动暴露）

---

## 四、Grafana 可视化验证

### 4.1 导入默认 Dashboard

1. 登录 Grafana（http://localhost:3000）
2. 进入 **Dashboards** → **Import**
3. 如果已配置 `wmt.prometheus.dashboard.export-path`，Dashboard JSON 文件会自动导出到指定目录
4. 或手动导入 `src/main/resources/wmt/prometheus/dashboards/default-app.json`

### 4.2 创建业务指标 Dashboard

#### 查询 1：订单创建成功率

```promql
sum(rate(biz_order_create_total{status="success"}[5m])) 
/ 
sum(rate(biz_order_create_total[5m])) * 100
```

#### 查询 2：订单查询 P95 延迟

```promql
histogram_quantile(0.95, 
  sum(rate(biz_order_query_duration_seconds_bucket[5m])) by (le)
)
```

#### 查询 3：按渠道统计订单量

```promql
sum(rate(biz_order_create_total[5m])) by (channel)
```

### 4.3 验证告警规则

在 Prometheus 界面（http://localhost:9090/alerts）查看告警规则状态，或触发测试告警：

- 模拟高内存使用（可通过压测工具）
- 模拟高错误率（手动返回 5xx 响应）

---

## 五、完整测试清单

### 5.1 基础功能测试

- [ ] 业务系统启动后，`/actuator/prometheus` 端点可访问
- [ ] Prometheus 能成功抓取业务系统指标（在 Prometheus UI 的 **Status → Targets** 中查看）
- [ ] Grafana 能连接 Prometheus 数据源（**Configuration → Data Sources** 中测试）
- [ ] JVM 指标（内存、GC、线程）正常显示

### 5.2 业务指标测试

- [ ] 调用业务接口后，`biz_*` 指标出现在 `/actuator/prometheus` 中
- [ ] 在 Prometheus 中能查询到业务指标（**Graph** 页面输入指标名）
- [ ] Grafana Dashboard 能展示业务指标趋势图
- [ ] 告警规则能正常触发（可选）

### 5.3 标签验证

- [ ] 公共标签（`service`、`env`）自动添加到所有指标
- [ ] 业务标签（如 `channel`、`status`）正确显示在指标中
- [ ] 在 Grafana 中能按标签过滤和分组

---

## 六、常见问题排查

### 6.1 Prometheus 无法抓取指标

**现象**：Prometheus UI 中 Target 状态为 DOWN

**排查步骤**：

**通用排查**：
1. 检查业务系统是否启动，`/actuator/prometheus` 是否可访问
2. 检查 `docker/prometheus/prometheus.yml` 中的 `targets` 地址是否正确

**VMware 虚拟机场景（CentOS7 → Windows）**：
1. **确认 Windows 主机 IP**：
   ```bash
   # 在 CentOS7 虚拟机中执行
   ip route | grep default
   # 或
   ping 10.0.2.2  # VMware NAT 默认网关
   ```

2. **测试端口连通性**：
   ```bash
   # 在 CentOS7 虚拟机中测试
   curl http://192.168.x.1:8080/actuator/prometheus
   # 或
   telnet 192.168.x.1 8080
   ```

3. **检查 Windows 防火墙**：
   - 确保 8080 端口允许入站
   - 或在测试时临时关闭防火墙验证

4. **检查 Java 应用绑定地址**：
   ```yaml
   # application.yml 中确保
   server:
     address: 0.0.0.0  # 不能是 127.0.0.1
     port: 8080
   ```

5. **检查 VMware 网络模式**：
   - NAT 模式：使用网关 IP（如 `192.168.x.1` 或 `10.0.2.2`）
   - 桥接模式：使用 Windows 主机的局域网 IP

**Docker 场景**：
- 如果业务系统在宿主机，使用 `host.docker.internal:端口`
- 如果在 Docker 网络内，使用服务名

### 6.2 业务指标未出现

**现象**：只有 JVM/HTTP 指标，没有 `biz_*` 指标

**排查步骤**：
1. 确认已调用埋点代码（检查日志是否有 `[WmtPrometheus]` 相关输出）
2. 确认 `DomainMetricPublisher` 已初始化（启动日志中应有提示）
3. 检查指标名称是否符合 Prometheus 命名规范（小写+下划线）

### 6.3 Grafana 查询无数据

**现象**：Dashboard 显示 "No data"

**排查步骤**：

1. **验证 Grafana 数据源连接**：
   - 进入 **Configuration → Data Sources → Prometheus → Test**
   - 应该显示 "Data source is working"

2. **在 Grafana Explore 中测试查询**：
   ```promql
   up{job="wmt-application"}
   ```
   - 如果返回 `1`，说明数据源正常
   - 如果无数据，检查 Prometheus Target 状态

3. **检查 Dashboard 的 job 变量**：
   - **重要**：确保 Dashboard 顶部选择了 `job="wmt-application"`（不是 `prometheus`）
   - 这是最常见的问题！

4. **验证基础指标**：
   ```promql
   jvm_memory_used_bytes{job="wmt-application"}
   http_server_requests_seconds_count{job="wmt-application"}
   ```

5. **检查时间范围**：
   - 切换到 **Last 5 minutes** 或 **Last 1 hour**

**详细排查指南**：参考 `GRAFANA_VERIFICATION.md` 文档

---

## 七、性能测试建议

### 7.1 指标埋点性能影响

- 使用 JMeter 或 Gatling 压测业务接口，对比埋点前后的 QPS/延迟
- 预期影响：< 1% 的性能损耗（Micrometer 指标记录是异步的）

### 7.2 Prometheus 存储压力

- 监控 Prometheus 磁盘使用（`prometheus_tsdb_storage_blocks_bytes`）
- 根据指标数量和保留时间调整 `--storage.tsdb.retention.time`

---

## 八、进阶测试

### 8.1 PushGateway 测试（短生命周期任务）

如果业务系统使用 PushGateway（配置 `wmt.prometheus.push-gateway.enabled=true`）：

1. 在业务代码中调用 `DomainMetricPublisher.counter(...)` 后，指标会自动推送到 PushGateway
2. 在 Prometheus UI 中查询 `pushgateway_*` 相关指标验证

### 8.2 多实例测试

启动多个业务系统实例，验证：

- Prometheus 能抓取所有实例的指标
- Grafana 能按 `instance` 标签区分不同实例
- 告警规则能聚合所有实例的指标

---

## 九、测试报告模板

完成测试后，建议记录：

```
测试日期：YYYY-MM-DD
测试人员：XXX
业务系统：XXX
WMT Starter 版本：XXX

测试结果：
- 基础功能：✅/❌
- 业务指标：✅/❌
- Grafana 可视化：✅/❌
- 告警规则：✅/❌

发现问题：
1. XXX
2. XXX

性能影响：
- QPS 变化：XXX
- 平均延迟变化：XXX
```

---

## 十、参考资源

- [Prometheus 官方文档](https://prometheus.io/docs/)
- [Grafana 官方文档](https://grafana.com/docs/)
- [Micrometer 文档](https://micrometer.io/docs)
- WMT Framework README：`wmt-spring-boot-starter-prometheus-grafana/README.md`

