# 二进制部署规范

> 基于 WMT Framework 的业务系统二进制部署详细指南（命令级别）

## 📋 目录

- [一、环境准备](#一环境准备)
- [二、中间件部署](#二中间件部署)
- [三、应用构建与打包](#三应用构建与打包)
- [四、应用部署](#四应用部署)
- [五、运维管理](#五运维管理)
- [六、监控与日志](#六监控与日志)
- [七、故障排查](#七故障排查)

---

## 一、环境准备

### 1.1 服务器要求

#### 1.1.1 硬件要求

```bash
# 最低配置
CPU: 2 核
内存: 4GB
磁盘: 50GB（SSD 推荐）

# 推荐配置
CPU: 4 核及以上
内存: 8GB 及以上
磁盘: 100GB 及以上（SSD）
```

#### 1.1.2 操作系统要求

**CentOS 7+ / RHEL 7+**
```bash
# 查看系统版本
cat /etc/redhat-release

# 更新系统
sudo yum update -y
```

**Ubuntu 18.04+**
```bash
# 查看系统版本
lsb_release -a

# 更新系统
sudo apt update && sudo apt upgrade -y
```

### 1.2 JDK 安装与配置

#### 1.2.1 安装 JDK 8

**CentOS/RHEL:**
```bash
# 方式一：使用 yum 安装 OpenJDK
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

# 方式二：安装 Oracle JDK（需要手动下载）
# 下载 JDK 8 安装包
wget https://download.oracle.com/java/8/latest/jdk-8-linux-x64.tar.gz

# 解压
tar -xzf jdk-8-linux-x64.tar.gz -C /opt/

# 创建软链接
sudo ln -s /opt/jdk1.8.0_xxx /opt/java
```

**Ubuntu:**
```bash
# 安装 OpenJDK 8
sudo apt install -y openjdk-8-jdk

# 或者安装 Oracle JDK（需要添加 PPA）
sudo add-apt-repository ppa:webupd8team/java
sudo apt update
sudo apt install -y oracle-java8-installer
```

#### 1.2.2 配置环境变量

```bash
# 编辑 /etc/profile 或 ~/.bashrc
sudo vi /etc/profile

# 添加以下内容
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk  # 或 /opt/java
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH

# 使配置生效
source /etc/profile

# 验证安装
java -version
javac -version
```

#### 1.2.3 验证 JDK 安装

```bash
# 检查 Java 版本
java -version
# 输出示例：openjdk version "1.8.0_xxx"

# 检查 JAVA_HOME
echo $JAVA_HOME

# 检查 Java 编译器
javac -version
```

### 1.3 创建应用用户

```bash
# 创建应用用户（非 root）
sudo useradd -m -s /bin/bash appuser

# 设置密码（可选）
sudo passwd appuser

# 创建应用目录
sudo mkdir -p /opt/apps
sudo chown -R appuser:appuser /opt/apps

# 创建日志目录
sudo mkdir -p /var/log/apps
sudo chown -R appuser:appuser /var/log/apps
```

### 1.4 网络配置

#### 1.4.1 端口规划

| 服务 | 端口 | 说明 |
|------|------|------|
| 应用服务 | 8080 | 业务应用端口 |
| MySQL | 3306 | 数据库端口 |
| Redis | 6379 | Redis 端口 |
| Nacos | 8848 | Nacos 服务端口 |
| Nacos | 9848 | Nacos 客户端 gRPC 端口 |
| Prometheus | 9090 | Prometheus 端口 |
| Grafana | 3000 | Grafana 端口 |
| Elasticsearch | 9200 | Elasticsearch HTTP 端口 |
| Elasticsearch | 9300 | Elasticsearch 传输端口 |
| Logstash | 5044 | Logstash Beats 端口 |
| Kibana | 5601 | Kibana 端口 |

#### 1.4.2 防火墙配置

**CentOS 7+ (firewalld):**
```bash
# 启动防火墙
sudo systemctl start firewalld
sudo systemctl enable firewalld

# 开放端口
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --permanent --add-port=6379/tcp
sudo firewall-cmd --permanent --add-port=8848/tcp
sudo firewall-cmd --permanent --add-port=9090/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=9200/tcp
sudo firewall-cmd --permanent --add-port=5601/tcp

# 重载防火墙
sudo firewall-cmd --reload

# 查看开放的端口
sudo firewall-cmd --list-ports
```

**Ubuntu (ufw):**
```bash
# 启用防火墙
sudo ufw enable

# 开放端口
sudo ufw allow 8080/tcp
sudo ufw allow 3306/tcp
sudo ufw allow 6379/tcp
sudo ufw allow 8848/tcp
sudo ufw allow 9090/tcp
sudo ufw allow 3000/tcp
sudo ufw allow 9200/tcp
sudo ufw allow 5601/tcp

# 查看防火墙状态
sudo ufw status
```

---

## 二、中间件部署

### 2.1 MySQL 8.0 部署

#### 2.1.1 安装 MySQL 8.0

**CentOS 7+ / RHEL 7+:**
```bash
# 下载 MySQL 8.0 Yum 仓库
wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

# 安装仓库
sudo rpm -ivh mysql80-community-release-el7-3.noarch.rpm

# 安装 MySQL
sudo yum install -y mysql-community-server

# 启动 MySQL
sudo systemctl start mysqld
sudo systemctl enable mysqld
```

**Ubuntu 18.04+:**
```bash
# 更新包索引
sudo apt update

# 安装 MySQL
sudo apt install -y mysql-server

# 启动 MySQL
sudo systemctl start mysql
sudo systemctl enable mysql
```

#### 2.1.2 初始化 MySQL

```bash
# 获取临时 root 密码（CentOS/RHEL）
sudo grep 'temporary password' /var/log/mysqld.log

# 安全初始化（Ubuntu 或首次安装）
sudo mysql_secure_installation

# 登录 MySQL
mysql -u root -p

# 在 MySQL 中执行以下命令
```

```sql
-- 创建数据库
CREATE DATABASE `your_app_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建应用用户
CREATE USER 'appuser'@'%' IDENTIFIED BY 'YourStrongPassword123!';

-- 授权
GRANT ALL PRIVILEGES ON `your_app_db`.* TO 'appuser'@'%';

-- 刷新权限
FLUSH PRIVILEGES;

-- 查看用户
SELECT user, host FROM mysql.user;

-- 退出
EXIT;
```

#### 2.1.3 配置 MySQL

```bash
# 编辑 MySQL 配置文件
sudo vi /etc/my.cnf  # CentOS/RHEL
# 或
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf  # Ubuntu
```

```ini
[mysqld]
# 基础配置
port = 3306
bind-address = 0.0.0.0
datadir = /var/lib/mysql
socket = /var/lib/mysql/mysql.sock

# 字符集配置
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect = 'SET NAMES utf8mb4'

# 连接配置
max_connections = 1000
max_connect_errors = 10000
wait_timeout = 28800
interactive_timeout = 28800

# 缓冲池配置（根据内存调整，建议为总内存的 50-70%）
innodb_buffer_pool_size = 2G
innodb_buffer_pool_instances = 4

# 日志配置
log-error = /var/log/mysqld.log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2

# 二进制日志（用于主从复制）
log-bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7
max_binlog_size = 100M

# InnoDB 配置
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size = 256M
innodb_log_buffer_size = 64M

[mysql]
default-character-set = utf8mb4

[client]
default-character-set = utf8mb4
```

```bash
# 重启 MySQL
sudo systemctl restart mysqld  # CentOS/RHEL
sudo systemctl restart mysql  # Ubuntu

# 验证配置
mysql -u root -p -e "SHOW VARIABLES LIKE 'character%';"
```

#### 2.1.4 数据库初始化

```bash
# 执行数据库初始化脚本（如果有）
mysql -u appuser -p your_app_db < /path/to/init.sql

# 或手动执行
mysql -u appuser -p your_app_db
```

```sql
-- 示例：创建表结构
-- 根据实际业务需求执行相应的 SQL 脚本
```

### 2.2 Redis 6.x 部署

#### 2.2.1 安装 Redis 6.x

**CentOS 7+ / RHEL 7+:**
```bash
# 安装 EPEL 仓库
sudo yum install -y epel-release

# 安装 Redis
sudo yum install -y redis

# 如果版本不够，使用源码编译
wget https://download.redis.io/releases/redis-6.2.7.tar.gz
tar -xzf redis-6.2.7.tar.gz
cd redis-6.2.7
make
sudo make install
```

**Ubuntu 18.04+:**
```bash
# 安装 Redis
sudo apt install -y redis-server

# 或使用最新版本
sudo apt update
sudo apt install -y redis-server
```

#### 2.2.2 配置 Redis

```bash
# 编辑 Redis 配置文件
sudo vi /etc/redis/redis.conf  # CentOS/RHEL
# 或
sudo vi /etc/redis/redis.conf  # Ubuntu
```

```conf
# 网络配置
bind 0.0.0.0
port 6379
protected-mode yes

# 认证配置
requirepass YourRedisPassword123!

# 持久化配置
# RDB 快照
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/lib/redis

# AOF 持久化
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 内存配置
maxmemory 2gb
maxmemory-policy allkeys-lru

# 日志配置
loglevel notice
logfile /var/log/redis/redis.log

# 其他配置
tcp-backlog 511
timeout 0
tcp-keepalive 300
```

```bash
# 创建日志目录
sudo mkdir -p /var/log/redis
sudo chown redis:redis /var/log/redis

# 启动 Redis
sudo systemctl start redis
sudo systemctl enable redis

# 验证 Redis
redis-cli -a YourRedisPassword123! ping
# 应返回：PONG
```

#### 2.2.3 Redis 测试

```bash
# 连接 Redis
redis-cli -a YourRedisPassword123!

# 测试命令
127.0.0.1:6379> SET test_key "test_value"
127.0.0.1:6379> GET test_key
127.0.0.1:6379> EXIT
```

### 2.3 Nacos 部署

#### 2.3.1 下载 Nacos

```bash
# 创建 Nacos 目录
sudo mkdir -p /opt/nacos
sudo chown -R appuser:appuser /opt/nacos

# 切换到应用用户
su - appuser

# 下载 Nacos（以 2.2.0 为例）
cd /opt/nacos
wget https://github.com/alibaba/nacos/releases/download/2.2.0/nacos-server-2.2.0.tar.gz

# 解压
tar -xzf nacos-server-2.2.0.tar.gz
cd nacos
```

#### 2.3.2 配置 Nacos

```bash
# 编辑配置文件
vi conf/application.properties
```

```properties
# 数据库配置（使用 MySQL 存储，单机模式）
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://127.0.0.1:3306/nacos_config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user.0=appuser
db.password.0=YourStrongPassword123!

# 服务端口
server.port=8848

# 认证配置
nacos.core.auth.enabled=true
nacos.core.auth.server.identity.key=serverIdentity
nacos.core.auth.server.identity.value=security
nacos.core.auth.plugin.nacos.token.secret.key=SecretKey012345678901234567890123456789012345678901234567890123456789
nacos.core.auth.plugin.nacos.token.expire.seconds=18000
```

```bash
# 创建 Nacos 数据库
mysql -u root -p

# 在 MySQL 中执行
```

```sql
CREATE DATABASE `nacos_config` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nacos_config;

-- 执行 Nacos 初始化 SQL（从 Nacos 安装包中）
-- source /opt/nacos/nacos/conf/mysql-schema.sql
```

```bash
# 如果 Nacos 包中没有 SQL 文件，从 GitHub 下载
cd /opt/nacos/nacos/conf
wget https://raw.githubusercontent.com/alibaba/nacos/2.2.0/distribution/conf/mysql-schema.sql
mysql -u appuser -p nacos_config < mysql-schema.sql
```

#### 2.3.3 启动 Nacos

```bash
# 单机模式启动
cd /opt/nacos/nacos/bin
sh startup.sh -m standalone

# 查看日志
tail -f /opt/nacos/nacos/logs/start.out

# 验证 Nacos 是否启动
curl http://localhost:8848/nacos/
```

#### 2.3.4 配置 Nacos 为系统服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/nacos.service
```

```ini
[Unit]
Description=Nacos Server
After=network.target mysql.service

[Service]
Type=forking
User=appuser
Group=appuser
ExecStart=/opt/nacos/nacos/bin/startup.sh -m standalone
ExecStop=/opt/nacos/nacos/bin/shutdown.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 重载 systemd
sudo systemctl daemon-reload

# 启动 Nacos 服务
sudo systemctl start nacos
sudo systemctl enable nacos

# 查看状态
sudo systemctl status nacos
```

---

## 三、应用构建与打包

### 3.1 Maven 构建

#### 3.1.1 构建命令

```bash
# 进入项目目录
cd /path/to/your-project

# 清理并打包（跳过测试）
mvn clean package -DskipTests

# 或使用完整构建（包含测试）
mvn clean install -DskipTests

# 指定环境打包
mvn clean package -DskipTests -Pprod

# 使用代码混淆打包（可选）
mvn clean package -DskipTests -Pobfuscate
```

#### 3.1.2 构建产物

```bash
# 构建产物位置
ls -lh target/*.jar

# 通常生成的文件
# - your-app-1.0.0.jar（可执行 JAR）
# - your-app-1.0.0-sources.jar（源码，如果启用）
# - your-app-1.0.0-javadoc.jar（文档，如果启用）
```

### 3.2 配置文件准备

#### 3.2.1 配置文件结构

```bash
# 创建配置目录
mkdir -p /opt/apps/your-app/config

# 配置文件结构
/opt/apps/your-app/config/
├── application.yml          # 基础配置
├── application-prod.yml     # 生产环境配置
└── logback-spring.xml       # 日志配置（可选）
```

#### 3.2.2 生产环境配置示例

```bash
# 创建生产环境配置文件
vi /opt/apps/your-app/config/application-prod.yml
```

```yaml
spring:
  application:
    name: your-app
  profiles:
    active: prod
  
  # 数据源配置
  datasource:
    dynamic:
      primary: master
      datasource:
        master:
          name: master
          url: jdbc:mysql://localhost:3306/your_app_db?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
          username: appuser
          password: YourStrongPassword123!
          driver-class-name: com.mysql.cj.jdbc.Driver
  
  # Redis 配置
  data:
    redis:
      host: localhost
      port: 6379
      password: YourRedisPassword123!
      database: 0
      timeout: 3000ms
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 0
          max-wait: -1ms

# Nacos 配置
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        namespace: prod
        group: DEFAULT_GROUP
      config:
        server-addr: localhost:8848
        namespace: prod
        group: DEFAULT_GROUP
        file-extension: yml
        shared-configs:
          - data-id: common-config.yml
            group: DEFAULT_GROUP
            refresh: true

# 监控配置
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus,metrics
  endpoint:
    health:
      show-details: always
  metrics:
    export:
      prometheus:
        enabled: true

# 日志配置
logging:
  level:
    root: INFO
    com.wmt: DEBUG
  file:
    name: /var/log/apps/your-app/application.log
  pattern:
    file: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n"
```

---

## 四、应用部署

### 4.1 部署目录结构

```bash
# 创建应用目录结构
sudo mkdir -p /opt/apps/your-app/{bin,config,lib,logs,data,temp}
sudo chown -R appuser:appuser /opt/apps/your-app

# 目录结构
/opt/apps/your-app/
├── bin/              # 启动/停止脚本
├── config/            # 配置文件
├── lib/               # JAR 包
├── logs/              # 日志文件
├── data/              # 数据文件（可选）
└── temp/              # 临时文件
```

### 4.2 部署应用文件

```bash
# 切换到应用用户
su - appuser

# 复制 JAR 包
cp target/your-app-1.0.0.jar /opt/apps/your-app/lib/

# 复制配置文件
cp config/application-prod.yml /opt/apps/your-app/config/

# 设置权限
chmod 755 /opt/apps/your-app/lib/*.jar
chmod 644 /opt/apps/your-app/config/*.yml
```

### 4.3 创建启动脚本

```bash
# 创建启动脚本
vi /opt/apps/your-app/bin/start.sh
```

```bash
#!/bin/bash

# 应用配置
APP_NAME="your-app"
APP_JAR="/opt/apps/your-app/lib/your-app-1.0.0.jar"
APP_HOME="/opt/apps/your-app"
CONFIG_DIR="${APP_HOME}/config"
LOG_DIR="/var/log/apps/${APP_NAME}"
PID_FILE="${APP_HOME}/temp/${APP_NAME}.pid"

# JVM 参数
JVM_OPTS="-Xms2g -Xmx2g"
JVM_OPTS="${JVM_OPTS} -XX:+UseG1GC"
JVM_OPTS="${JVM_OPTS} -XX:MaxGCPauseMillis=200"
JVM_OPTS="${JVM_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
JVM_OPTS="${JVM_OPTS} -XX:HeapDumpPath=${LOG_DIR}/heap_dump.hprof"
JVM_OPTS="${JVM_OPTS} -XX:+PrintGCDetails"
JVM_OPTS="${JVM_OPTS} -XX:+PrintGCDateStamps"
JVM_OPTS="${JVM_OPTS} -Xloggc:${LOG_DIR}/gc.log"
JVM_OPTS="${JVM_OPTS} -XX:+UseGCLogFileRotation"
JVM_OPTS="${JVM_OPTS} -XX:NumberOfGCLogFiles=10"
JVM_OPTS="${JVM_OPTS} -XX:GCLogFileSize=10M"

# Spring Boot 参数
SPRING_OPTS="--spring.config.location=classpath:/,file:${CONFIG_DIR}/"
SPRING_OPTS="${SPRING_OPTS} --spring.profiles.active=prod"
SPRING_OPTS="${SPRING_OPTS} --server.port=8080"
SPRING_OPTS="${SPRING_OPTS} --logging.file.name=${LOG_DIR}/application.log"

# 创建必要目录
mkdir -p ${LOG_DIR}
mkdir -p ${APP_HOME}/temp

# 检查是否已运行
if [ -f "${PID_FILE}" ]; then
    PID=$(cat ${PID_FILE})
    if ps -p ${PID} > /dev/null 2>&1; then
        echo "${APP_NAME} is already running (PID: ${PID})"
        exit 1
    else
        rm -f ${PID_FILE}
    fi
fi

# 启动应用
echo "Starting ${APP_NAME}..."
nohup java ${JVM_OPTS} \
    -jar ${APP_JAR} \
    ${SPRING_OPTS} \
    > ${LOG_DIR}/startup.log 2>&1 &

# 保存 PID
echo $! > ${PID_FILE}

# 等待启动
sleep 5

# 检查启动状态
if [ -f "${PID_FILE}" ]; then
    PID=$(cat ${PID_FILE})
    if ps -p ${PID} > /dev/null 2>&1; then
        echo "${APP_NAME} started successfully (PID: ${PID})"
        echo "Logs: ${LOG_DIR}/application.log"
    else
        echo "${APP_NAME} failed to start"
        exit 1
    fi
else
    echo "${APP_NAME} failed to start"
    exit 1
fi
```

```bash
# 创建停止脚本
vi /opt/apps/your-app/bin/stop.sh
```

```bash
#!/bin/bash

APP_NAME="your-app"
APP_HOME="/opt/apps/your-app"
PID_FILE="${APP_HOME}/temp/${APP_NAME}.pid"

if [ ! -f "${PID_FILE}" ]; then
    echo "${APP_NAME} is not running"
    exit 1
fi

PID=$(cat ${PID_FILE})

if ! ps -p ${PID} > /dev/null 2>&1; then
    echo "${APP_NAME} is not running"
    rm -f ${PID_FILE}
    exit 1
fi

echo "Stopping ${APP_NAME} (PID: ${PID})..."

# 优雅停止（发送 SIGTERM）
kill ${PID}

# 等待进程结束（最多 30 秒）
for i in {1..30}; do
    if ! ps -p ${PID} > /dev/null 2>&1; then
        echo "${APP_NAME} stopped successfully"
        rm -f ${PID_FILE}
        exit 0
    fi
    sleep 1
done

# 强制停止
if ps -p ${PID} > /dev/null 2>&1; then
    echo "Force stopping ${APP_NAME}..."
    kill -9 ${PID}
    rm -f ${PID_FILE}
    echo "${APP_NAME} force stopped"
fi
```

```bash
# 设置脚本权限
chmod +x /opt/apps/your-app/bin/*.sh
```

### 4.4 配置 systemd 服务

```bash
# 创建 systemd 服务文件
sudo vi /etc/systemd/system/your-app.service
```

```ini
[Unit]
Description=Your App Service
After=network.target mysql.service redis.service nacos.service

[Service]
Type=forking
User=appuser
Group=appuser
WorkingDirectory=/opt/apps/your-app
ExecStart=/opt/apps/your-app/bin/start.sh
ExecStop=/opt/apps/your-app/bin/stop.sh
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

# 资源限制
LimitNOFILE=65535
LimitNPROC=65535

[Install]
WantedBy=multi-user.target
```

```bash
# 重载 systemd
sudo systemctl daemon-reload

# 启动服务
sudo systemctl start your-app
sudo systemctl enable your-app

# 查看状态
sudo systemctl status your-app

# 查看日志
sudo journalctl -u your-app -f
```

### 4.5 验证部署

```bash
# 检查进程
ps aux | grep your-app

# 检查端口
netstat -tlnp | grep 8080
# 或
ss -tlnp | grep 8080

# 检查健康端点
curl http://localhost:8080/actuator/health

# 检查应用日志
tail -f /var/log/apps/your-app/application.log
```

---

## 五、运维管理

### 5.1 日志管理

#### 5.1.1 配置日志轮转

```bash
# 创建 logrotate 配置
sudo vi /etc/logrotate.d/your-app
```

```
/var/log/apps/your-app/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0644 appuser appuser
    sharedscripts
    postrotate
        /bin/kill -HUP `cat /opt/apps/your-app/temp/your-app.pid 2> /dev/null` 2> /dev/null || true
    endscript
}
```

```bash
# 测试 logrotate 配置
sudo logrotate -d /etc/logrotate.d/your-app

# 手动执行轮转
sudo logrotate -f /etc/logrotate.d/your-app
```

### 5.2 监控配置

详见 [监控与日志](#六监控与日志) 章节。

### 5.3 备份策略

```bash
# 创建备份脚本
vi /opt/apps/your-app/bin/backup.sh
```

```bash
#!/bin/bash

BACKUP_DIR="/opt/backups/your-app"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p ${BACKUP_DIR}

# 备份配置文件
tar -czf ${BACKUP_DIR}/config_${DATE}.tar.gz /opt/apps/your-app/config

# 备份数据库（需要配置 MySQL 密码）
mysqldump -u appuser -p'YourStrongPassword123!' your_app_db > ${BACKUP_DIR}/db_${DATE}.sql
gzip ${BACKUP_DIR}/db_${DATE}.sql

# 删除 30 天前的备份
find ${BACKUP_DIR} -type f -mtime +30 -delete

echo "Backup completed: ${DATE}"
```

```bash
# 设置执行权限
chmod +x /opt/apps/your-app/bin/backup.sh

# 添加到 crontab（每天凌晨 2 点执行）
crontab -e
# 添加：0 2 * * * /opt/apps/your-app/bin/backup.sh >> /var/log/apps/backup.log 2>&1
```

---

## 六、监控与日志

### 6.1 Prometheus 部署

详见 [监控部署指南](../monitoring/PROMETHEUS_GRAFANA.md)

### 6.2 ELK Stack 部署

详见 [ELK 部署指南](../logging/ELK_STACK.md)

---

## 七、故障排查

### 7.1 常见问题

#### 7.1.1 应用无法启动

```bash
# 检查 Java 版本
java -version

# 检查端口占用
netstat -tlnp | grep 8080

# 检查日志
tail -100 /var/log/apps/your-app/application.log
tail -100 /var/log/apps/your-app/startup.log

# 检查 JVM 参数
ps aux | grep your-app
```

#### 7.1.2 数据库连接失败

```bash
# 测试数据库连接
mysql -u appuser -p -h localhost your_app_db

# 检查 MySQL 状态
sudo systemctl status mysql

# 检查 MySQL 日志
sudo tail -100 /var/log/mysqld.log
```

#### 7.1.3 Redis 连接失败

```bash
# 测试 Redis 连接
redis-cli -a YourRedisPassword123! ping

# 检查 Redis 状态
sudo systemctl status redis

# 检查 Redis 日志
sudo tail -100 /var/log/redis/redis.log
```

### 7.2 性能调优

#### 7.2.1 JVM 调优

根据实际负载调整 JVM 参数：

```bash
# 查看 GC 日志
tail -f /var/log/apps/your-app/gc.log

# 分析堆转储
jmap -heap <PID>
jmap -dump:format=b,file=heap.bin <PID>
```

#### 7.2.2 数据库调优

```sql
-- 查看慢查询
SHOW VARIABLES LIKE 'slow_query%';
SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 10;

-- 查看连接数
SHOW STATUS LIKE 'Threads_connected';
SHOW VARIABLES LIKE 'max_connections';
```

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

