# ELK Stack 日志部署指南

> 基于 WMT Framework 的业务系统 ELK Stack 日志部署详细指南（命令级别）

## 📋 目录

- [一、Elasticsearch 部署](#一elasticsearch-部署)
- [二、Logstash 部署](#二logstash-部署)
- [三、Kibana 部署](#三kibana-部署)
- [四、应用日志配置](#四应用日志配置)
- [五、Filebeat 部署](#五filebeat-部署)

---

## 一、Elasticsearch 部署

### 1.1 二进制部署

#### 1.1.1 下载与安装

```bash
# 创建 Elasticsearch 用户
sudo useradd -r -s /bin/false elasticsearch

# 下载 Elasticsearch（以 8.8.0 为例）
cd /tmp
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.8.0-linux-x86_64.tar.gz

# 解压
tar -xzf elasticsearch-8.8.0-linux-x86_64.tar.gz
sudo mv elasticsearch-8.8.0 /opt/elasticsearch
sudo chown -R elasticsearch:elasticsearch /opt/elasticsearch

# 创建数据目录
sudo mkdir -p /var/lib/elasticsearch
sudo chown -R elasticsearch:elasticsearch /var/lib/elasticsearch

# 创建日志目录
sudo mkdir -p /var/log/elasticsearch
sudo chown -R elasticsearch:elasticsearch /var/log/elasticsearch
```

#### 1.1.2 配置文件

```bash
# 编辑配置文件
sudo vi /opt/elasticsearch/config/elasticsearch.yml
```

```yaml
cluster.name: wmt-cluster
node.name: node-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node

# 安全配置（生产环境）
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl.enabled: false
xpack.security.transport.ssl.enabled: false
```

#### 1.1.3 系统配置

```bash
# 设置 JVM 堆内存（编辑 jvm.options）
sudo vi /opt/elasticsearch/config/jvm.options

# 修改以下行（根据服务器内存调整）
-Xms2g
-Xmx2g

# 设置系统限制
sudo vi /etc/security/limits.conf
```

```
elasticsearch soft nofile 65536
elasticsearch hard nofile 65536
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
```

```bash
# 设置虚拟内存
sudo vi /etc/sysctl.conf
```

```
vm.max_map_count=262144
```

```bash
# 应用配置
sudo sysctl -p
```

#### 1.1.4 创建 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/elasticsearch.service
```

```ini
[Unit]
Description=Elasticsearch
After=network.target

[Service]
Type=simple
User=elasticsearch
Group=elasticsearch
Environment="ES_HOME=/opt/elasticsearch"
Environment="JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk"
ExecStart=/opt/elasticsearch/bin/elasticsearch
Restart=always
RestartSec=10
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# 验证
sudo systemctl status elasticsearch
curl http://localhost:9200
```

### 1.2 Docker 部署

```bash
# 运行 Elasticsearch 容器
docker run -d \
  --name elasticsearch \
  --restart always \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=false" \
  -e "ES_JAVA_OPTS=-Xms2g -Xmx2g" \
  -v elasticsearch-data:/usr/share/elasticsearch/data \
  elasticsearch:8.8.0
```

### 1.3 Kubernetes 部署

```bash
# 使用 Helm 部署 Elasticsearch
helm repo add elastic https://helm.elastic.co
helm repo update

helm install elasticsearch elastic/elasticsearch \
  --namespace logging \
  --create-namespace \
  --set replicas=1 \
  --set resources.requests.memory=2Gi \
  --set resources.requests.cpu=1000m
```

---

## 二、Logstash 部署

### 2.1 二进制部署

#### 2.1.1 下载与安装

```bash
# 下载 Logstash（以 8.8.0 为例）
cd /tmp
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.8.0-linux-x86_64.tar.gz

# 解压
tar -xzf logstash-8.8.0-linux-x86_64.tar.gz
sudo mv logstash-8.8.0 /opt/logstash
sudo chown -R root:root /opt/logstash
```

#### 2.1.2 配置文件

```bash
# 创建配置文件目录
sudo mkdir -p /etc/logstash/conf.d

# 创建主配置文件
sudo vi /etc/logstash/logstash.yml
```

```yaml
http.host: "0.0.0.0"
path.data: /var/lib/logstash
path.logs: /var/log/logstash
```

```bash
# 创建管道配置
sudo vi /etc/logstash/conf.d/app-log.conf
```

```ruby
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][application] == "your-app" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} \[%{DATA:thread}\] %{LOGLEVEL:level} %{DATA:logger} - %{GREEDYDATA:message}" }
    }
    
    date {
      match => [ "timestamp", "yyyy-MM-dd HH:mm:ss.SSS" ]
    }
    
    if [level] == "ERROR" {
      mutate {
        add_tag => [ "error" ]
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "your-app-%{+YYYY.MM.dd}"
  }
}
```

#### 2.1.3 创建 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/logstash.service
```

```ini
[Unit]
Description=Logstash
After=network.target elasticsearch.service

[Service]
Type=simple
User=logstash
Group=logstash
Environment="LS_HOME=/opt/logstash"
Environment="JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk"
ExecStart=/opt/logstash/bin/logstash -f /etc/logstash/conf.d
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### 2.2 Docker 部署

```bash
# 创建 Logstash 配置
mkdir -p logstash/config
vi logstash/config/logstash.conf
# （内容同上）

# 运行 Logstash 容器
docker run -d \
  --name logstash \
  --restart always \
  -p 5044:5044 \
  -v $(pwd)/logstash/config/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
  logstash:8.8.0
```

---

## 三、Kibana 部署

### 3.1 二进制部署

#### 3.1.1 下载与安装

```bash
# 下载 Kibana（以 8.8.0 为例）
cd /tmp
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.8.0-linux-x86_64.tar.gz

# 解压
tar -xzf kibana-8.8.0-linux-x86_64.tar.gz
sudo mv kibana-8.8.0 /opt/kibana
sudo chown -R kibana:kibana /opt/kibana
```

#### 3.1.2 配置文件

```bash
# 编辑配置文件
sudo vi /opt/kibana/config/kibana.yml
```

```yaml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
```

#### 3.1.3 创建 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/kibana.service
```

```ini
[Unit]
Description=Kibana
After=network.target elasticsearch.service

[Service]
Type=simple
User=kibana
Group=kibana
Environment="KIBANA_HOME=/opt/kibana"
ExecStart=/opt/kibana/bin/kibana
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl start kibana
sudo systemctl enable kibana

# 验证
sudo systemctl status kibana
curl http://localhost:5601/api/status
```

### 3.2 Docker 部署

```bash
# 运行 Kibana 容器
docker run -d \
  --name kibana \
  --restart always \
  -p 5601:5601 \
  -e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" \
  --link elasticsearch:elasticsearch \
  kibana:8.8.0
```

---

## 四、应用日志配置

### 4.1 Logback 配置

```xml
<!-- logback-spring.xml -->
<configuration>
    <include resource="org/springframework/boot/logging/logback/defaults.xml"/>
    
    <springProfile name="prod">
        <!-- 控制台输出 -->
        <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            </encoder>
        </appender>
        
        <!-- 文件输出 -->
        <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>/var/log/apps/your-app/application.log</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>/var/log/apps/your-app/application-%d{yyyy-MM-dd}.log</fileNamePattern>
                <maxHistory>30</maxHistory>
                <totalSizeCap>10GB</totalSizeCap>
            </rollingPolicy>
            <encoder>
                <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            </encoder>
        </appender>
        
        <!-- 发送到 Logstash -->
        <appender name="LOGSTASH" class="net.logstash.logback.appender.LogstashTcpAppender">
            <destination>logstash:5044</destination>
            <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
                <providers>
                    <timestamp/>
                    <version/>
                    <logLevel/>
                    <message/>
                    <mdc/>
                    <stackTrace/>
                </providers>
            </encoder>
        </appender>
        
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
            <appender-ref ref="FILE"/>
            <appender-ref ref="LOGSTASH"/>
        </root>
    </springProfile>
</configuration>
```

### 4.2 添加依赖

```xml
<!-- pom.xml -->
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>7.3</version>
</dependency>
```

---

## 五、Filebeat 部署

### 5.1 二进制部署

#### 5.1.1 下载与安装

```bash
# 下载 Filebeat（以 8.8.0 为例）
cd /tmp
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.8.0-linux-x86_64.tar.gz

# 解压
tar -xzf filebeat-8.8.0-linux-x86_64.tar.gz
sudo mv filebeat-8.8.0-linux-x86_64 /opt/filebeat
```

#### 5.1.2 配置文件

```bash
# 编辑配置文件
sudo vi /etc/filebeat/filebeat.yml
```

```yaml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/apps/your-app/*.log
  fields:
    application: your-app
    environment: production
  fields_under_root: true
  multiline.pattern: '^\d{4}-\d{2}-\d{2}'
  multiline.negate: true
  multiline.match: after

output.logstash:
  hosts: ["localhost:5044"]

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
```

#### 5.1.3 创建 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/filebeat.service
```

```ini
[Unit]
Description=Filebeat
After=network.target

[Service]
Type=simple
User=root
ExecStart=/opt/filebeat/filebeat -c /etc/filebeat/filebeat.yml
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl start filebeat
sudo systemctl enable filebeat
```

### 5.2 Docker 部署

```bash
# 运行 Filebeat 容器
docker run -d \
  --name filebeat \
  --restart always \
  --user root \
  -v /var/log/apps:/var/log/apps:ro \
  -v $(pwd)/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro \
  docker.elastic.co/beats/filebeat:8.8.0
```

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

