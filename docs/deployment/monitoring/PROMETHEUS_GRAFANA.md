# Prometheus + Grafana 监控部署指南

> 基于 WMT Framework 的业务系统监控部署详细指南（命令级别）

## 📋 目录

- [一、Prometheus 部署](#一prometheus-部署)
- [二、Grafana 部署](#二grafana-部署)
- [三、应用监控配置](#三应用监控配置)
- [四、告警配置](#四告警配置)

---

## 一、Prometheus 部署

### 1.1 二进制部署

#### 1.1.1 下载与安装

```bash
# 创建 Prometheus 目录
sudo mkdir -p /opt/prometheus
sudo useradd -r -s /bin/false prometheus
sudo chown prometheus:prometheus /opt/prometheus

# 下载 Prometheus（以 v2.45.0 为例）
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz

# 解压
tar -xzf prometheus-2.45.0.linux-amd64.tar.gz
cd prometheus-2.45.0.linux-amd64

# 复制文件
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles console_libraries /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus
```

#### 1.1.2 配置文件

```bash
# 创建配置文件
sudo vi /etc/prometheus/prometheus.yml
```

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'
    replica: '0'

# Alertmanager 配置
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - localhost:9093

# 告警规则
rule_files:
  - "/etc/prometheus/rules/*.yml"

# 抓取配置
scrape_configs:
  # Prometheus 自身监控
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Spring Boot 应用监控
  - job_name: 'your-app'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:8080']
        labels:
          application: 'your-app'
          environment: 'production'

  # MySQL Exporter（如果使用）
  - job_name: 'mysql'
    static_configs:
      - targets: ['localhost:9104']

  # Redis Exporter（如果使用）
  - job_name: 'redis'
    static_configs:
      - targets: ['localhost:9121']

  # Node Exporter（系统监控）
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

#### 1.1.3 创建 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/prometheus.service
```

```ini
[Unit]
Description=Prometheus
After=network.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --storage.tsdb.retention.time=30d \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 创建数据目录
sudo mkdir -p /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# 启动服务
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# 验证
sudo systemctl status prometheus
curl http://localhost:9090/-/healthy
```

### 1.2 Docker 部署

```bash
# 创建 Prometheus 配置目录
mkdir -p prometheus/{config,data}

# 创建配置文件
vi prometheus/config/prometheus.yml
# （内容同上）

# 运行 Prometheus 容器
docker run -d \
  --name prometheus \
  --restart always \
  -p 9090:9090 \
  -v $(pwd)/prometheus/config/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus-data:/prometheus \
  prom/prometheus:v2.45.0 \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --storage.tsdb.retention.time=30d \
  --web.enable-lifecycle
```

### 1.3 Kubernetes 部署

```bash
# 创建 Prometheus ConfigMap
vi k8s/prometheus-configmap.yaml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']
      
      - job_name: 'your-app'
        kubernetes_sd_configs:
          - role: pod
            namespaces:
              names:
                - wmt-app
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_label_app]
            action: keep
            regex: your-app
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
            action: replace
            regex: ([^:]+)(?::\d+)?;(\d+)
            replacement: $1:$2
            target_label: __address__
```

```bash
# 创建 Prometheus Deployment
vi k8s/prometheus-deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:v2.45.0
        ports:
        - containerPort: 9090
        args:
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--storage.tsdb.path=/prometheus'
          - '--storage.tsdb.retention.time=30d'
          - '--web.enable-lifecycle'
        volumeMounts:
        - name: config
          mountPath: /etc/prometheus
        - name: storage
          mountPath: /prometheus
        resources:
          requests:
            memory: "2Gi"
            cpu: "500m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
      volumes:
      - name: config
        configMap:
          name: prometheus-config
      - name: storage
        persistentVolumeClaim:
          claimName: prometheus-pvc
```

---

## 二、Grafana 部署

### 2.1 二进制部署

#### 2.1.1 下载与安装

```bash
# 下载 Grafana（以 v10.0.0 为例）
cd /tmp
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-10.0.0.linux-amd64.tar.gz

# 解压
tar -xzf grafana-enterprise-10.0.0.linux-amd64.tar.gz
sudo mv grafana-10.0.0 /opt/grafana

# 创建用户
sudo useradd -r -s /bin/false grafana
sudo chown -R grafana:grafana /opt/grafana
```

#### 2.1.2 配置文件

```bash
# 编辑配置文件
sudo vi /opt/grafana/conf/defaults.ini
```

```ini
[server]
http_port = 3000
domain = localhost

[database]
type = sqlite3
path = grafana.db

[security]
admin_user = admin
admin_password = AdminPassword123!

[datasources]
default = true
```

#### 2.1.3 创建 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/grafana.service
```

```ini
[Unit]
Description=Grafana
After=network.target

[Service]
Type=simple
User=grafana
Group=grafana
ExecStart=/opt/grafana/bin/grafana-server -homepath /opt/grafana
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl start grafana
sudo systemctl enable grafana

# 验证
sudo systemctl status grafana
curl http://localhost:3000/api/health
```

### 2.2 Docker 部署

```bash
# 运行 Grafana 容器
docker run -d \
  --name grafana \
  --restart always \
  -p 3000:3000 \
  -e GF_SECURITY_ADMIN_USER=admin \
  -e GF_SECURITY_ADMIN_PASSWORD=AdminPassword123! \
  -v grafana-data:/var/lib/grafana \
  grafana/grafana:10.0.0
```

### 2.3 Kubernetes 部署

```bash
# 创建 Grafana Deployment
vi k8s/grafana-deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:10.0.0
        ports:
        - containerPort: 3000
        env:
        - name: GF_SECURITY_ADMIN_USER
          value: "admin"
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: "AdminPassword123!"
        - name: GF_SERVER_ROOT_URL
          value: "http://localhost:3000"
        volumeMounts:
        - name: storage
          mountPath: /var/lib/grafana
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: grafana-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
spec:
  ports:
  - port: 3000
    targetPort: 3000
  selector:
    app: grafana
```

### 2.4 配置数据源

```bash
# 访问 Grafana
# http://localhost:3000
# 用户名：admin
# 密码：AdminPassword123!

# 添加 Prometheus 数据源
# 1. 进入 Configuration -> Data Sources
# 2. 点击 Add data source
# 3. 选择 Prometheus
# 4. URL: http://prometheus:9090（容器内）或 http://localhost:9090（二进制）
# 5. 点击 Save & Test
```

### 2.5 导入仪表盘

```bash
# 常用仪表盘 ID
# JVM 监控：4701
# Spring Boot：11378
# MySQL：7362
# Redis：11835
# Node Exporter：1860

# 在 Grafana 中导入：
# 1. 进入 Dashboards -> Import
# 2. 输入仪表盘 ID
# 3. 选择 Prometheus 数据源
# 4. 点击 Import
```

---

## 三、应用监控配置

### 3.1 Spring Boot Actuator 配置

```yaml
# application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus,metrics
  endpoint:
    health:
      show-details: always
      probes:
        enabled: true
  metrics:
    export:
      prometheus:
        enabled: true
    tags:
      application: ${spring.application.name}
      environment: ${spring.profiles.active}
```

### 3.2 自定义指标

```java
// 示例：自定义业务指标
@Service
public class OrderService {
    
    private final Counter orderCounter;
    private final Timer orderTimer;
    
    public OrderService(MeterRegistry meterRegistry) {
        this.orderCounter = Counter.builder("orders.total")
            .description("Total number of orders")
            .tag("application", "your-app")
            .register(meterRegistry);
        
        this.orderTimer = Timer.builder("orders.duration")
            .description("Order processing duration")
            .register(meterRegistry);
    }
    
    public void createOrder(Order order) {
        Timer.Sample sample = Timer.start();
        try {
            // 业务逻辑
            orderCounter.increment();
        } finally {
            sample.stop(orderTimer);
        }
    }
}
```

---

## 四、告警配置

### 4.1 告警规则

```bash
# 创建告警规则目录
sudo mkdir -p /etc/prometheus/rules

# 创建告警规则文件
sudo vi /etc/prometheus/rules/app-alerts.yml
```

```yaml
groups:
- name: app_alerts
  interval: 30s
  rules:
  # JVM 内存使用率告警
  - alert: HighJVMMemoryUsage
    expr: (jvm_memory_used_bytes / jvm_memory_max_bytes) * 100 > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "JVM 内存使用率过高"
      description: "应用 {{ $labels.instance }} 的 JVM 内存使用率为 {{ $value }}%"

  # 应用不可用告警
  - alert: ApplicationDown
    expr: up{job="your-app"} == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "应用不可用"
      description: "应用 {{ $labels.instance }} 已下线超过 1 分钟"

  # 响应时间告警
  - alert: HighResponseTime
    expr: http_server_requests_seconds{quantile="0.95"} > 1
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "响应时间过高"
      description: "应用 {{ $labels.instance }} 的 95 分位响应时间为 {{ $value }} 秒"
```

### 4.2 Alertmanager 配置

```bash
# 下载 Alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-amd64.tar.gz

# 配置 Alertmanager
vi alertmanager.yml
```

```yaml
global:
  resolve_timeout: 5m

# 路由配置
route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'web.hook'
  routes:
  - match:
      severity: critical
    receiver: 'critical-alerts'

# 接收器配置
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://localhost:5001/webhook'

- name: 'critical-alerts'
  email_configs:
  - to: 'admin@example.com'
    from: 'alertmanager@example.com'
    smarthost: 'smtp.example.com:587'
    auth_username: 'alertmanager@example.com'
    auth_password: 'password'
```

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

