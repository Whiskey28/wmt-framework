# Docker 容器化部署规范

> 基于 WMT Framework 的业务系统 Docker 容器化部署详细指南（命令级别）

## 📋 目录

- [一、Docker 环境准备](#一docker-环境准备)
- [二、Docker 镜像构建](#二docker-镜像构建)
- [三、Docker Compose 部署](#三docker-compose-部署)
- [四、应用容器部署](#四应用容器部署)
- [五、中间件容器部署](#五中间件容器部署)
- [六、监控与日志](#六监控与日志)
- [七、运维管理](#七运维管理)

---

## 一、Docker 环境准备

### 1.1 安装 Docker

#### 1.1.1 CentOS 7+ / RHEL 7+

```bash
# 卸载旧版本
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# 安装依赖
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 添加 Docker 仓库
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 安装 Docker CE
sudo yum install -y docker-ce docker-ce-cli containerd.io

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
sudo docker --version
sudo docker run hello-world
```

#### 1.1.2 Ubuntu 18.04+

```bash
# 卸载旧版本
sudo apt remove -y docker docker-engine docker.io containerd runc

# 安装依赖
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 添加 Docker GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加 Docker 仓库
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker CE
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
sudo docker --version
sudo docker run hello-world
```

### 1.2 配置 Docker

#### 1.2.1 配置 Docker 用户组

```bash
# 创建 docker 用户组（如果不存在）
sudo groupadd docker

# 将当前用户添加到 docker 组
sudo usermod -aG docker $USER

# 重新登录或执行
newgrp docker

# 验证（无需 sudo）
docker ps
```

#### 1.2.2 配置 Docker 镜像加速

```bash
# 创建或编辑 daemon.json
sudo vi /etc/docker/daemon.json
```

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

```bash
# 重启 Docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# 验证配置
docker info
```

### 1.3 安装 Docker Compose

```bash
# 下载 Docker Compose（以 v2.20.0 为例）
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 设置执行权限
sudo chmod +x /usr/local/bin/docker-compose

# 创建软链接（可选）
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 验证安装
docker-compose --version
```

---

## 二、Docker 镜像构建

### 2.1 创建 Dockerfile

#### 2.1.1 基础 Dockerfile

```bash
# 在项目根目录创建 Dockerfile
vi Dockerfile
```

```dockerfile
# 多阶段构建：构建阶段
FROM maven:3.8.6-openjdk-8-slim AS builder

# 设置工作目录
WORKDIR /app

# 复制 pom.xml 和源代码
COPY pom.xml .
COPY src ./src

# 构建应用
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:8-jre-slim

# 设置维护者信息
LABEL maintainer="wmt-framework-team"

# 设置工作目录
WORKDIR /app

# 创建应用用户（非 root）
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 从构建阶段复制 JAR 包
COPY --from=builder /app/target/*.jar app.jar

# 创建日志目录
RUN mkdir -p /var/log/apps && \
    chown -R appuser:appuser /var/log/apps && \
    chown -R appuser:appuser /app

# 切换到非 root 用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# 启动应用
ENTRYPOINT ["java", \
    "-Xms2g", "-Xmx2g", \
    "-XX:+UseG1GC", \
    "-XX:MaxGCPauseMillis=200", \
    "-XX:+HeapDumpOnOutOfMemoryError", \
    "-XX:HeapDumpPath=/var/log/apps/heap_dump.hprof", \
    "-jar", "app.jar"]
```

#### 2.1.2 优化版 Dockerfile（Alpine）

```dockerfile
# 构建阶段
FROM maven:3.8.6-openjdk-8-alpine AS builder

WORKDIR /app

# 复制依赖文件（利用 Docker 缓存）
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY src ./src
RUN mvn clean package -DskipTests

# 运行阶段（Alpine 镜像更小）
FROM openjdk:8-jre-alpine

LABEL maintainer="wmt-framework-team"

WORKDIR /app

# 安装必要的工具（curl 用于健康检查）
RUN apk add --no-cache curl && \
    addgroup -S appuser && \
    adduser -S -G appuser appuser && \
    mkdir -p /var/log/apps && \
    chown -R appuser:appuser /var/log/apps /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", \
    "-Xms2g", "-Xmx2g", \
    "-XX:+UseG1GC", \
    "-XX:MaxGCPauseMillis=200", \
    "-XX:+HeapDumpOnOutOfMemoryError", \
    "-XX:HeapDumpPath=/var/log/apps/heap_dump.hprof", \
    "-jar", "app.jar"]
```

### 2.2 构建 Docker 镜像

```bash
# 构建镜像
docker build -t your-app:1.0.0 .

# 或指定 Dockerfile
docker build -f Dockerfile -t your-app:1.0.0 .

# 构建时传递构建参数
docker build --build-arg MAVEN_OPTS="-Xmx2g" -t your-app:1.0.0 .

# 查看镜像
docker images | grep your-app

# 查看镜像详细信息
docker inspect your-app:1.0.0

# 查看镜像构建历史
docker history your-app:1.0.0
```

### 2.3 镜像标签与推送

```bash
# 添加标签
docker tag your-app:1.0.0 registry.example.com/your-app:1.0.0
docker tag your-app:1.0.0 registry.example.com/your-app:latest

# 登录镜像仓库
docker login registry.example.com

# 推送镜像
docker push registry.example.com/your-app:1.0.0
docker push registry.example.com/your-app:latest
```

### 2.4 .dockerignore 文件

```bash
# 创建 .dockerignore 文件
vi .dockerignore
```

```
# Git
.git
.gitignore

# Maven
target/
.mvn/

# IDE
.idea/
*.iml
.vscode/

# 日志
*.log

# 临时文件
*.tmp
*.temp

# 文档
README.md
docs/

# 测试
*.test
test/
```

---

## 三、Docker Compose 部署

### 3.1 Docker Compose 文件结构

```bash
# 创建部署目录
mkdir -p docker-compose
cd docker-compose

# 目录结构
docker-compose/
├── docker-compose.yml          # 主配置文件
├── docker-compose.prod.yml      # 生产环境覆盖文件
├── .env                         # 环境变量文件
├── config/                      # 配置文件目录
│   ├── mysql/
│   ├── redis/
│   ├── nacos/
│   └── prometheus/
└── data/                        # 数据持久化目录
    ├── mysql/
    ├── redis/
    └── elasticsearch/
```

### 3.2 基础 docker-compose.yml

```bash
# 创建主配置文件
vi docker-compose.yml
```

```yaml
version: '3.8'

services:
  # MySQL 8.0
  mysql:
    image: mysql:8.0
    container_name: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      TZ: Asia/Shanghai
    ports:
      - "3306:3306"
    volumes:
      - ./data/mysql:/var/lib/mysql
      - ./config/mysql/my.cnf:/etc/mysql/conf.d/my.cnf
      - ./config/mysql/init.sql:/docker-entrypoint-initdb.d/init.sql
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
      - --default-authentication-plugin=mysql_native_password
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis 6.x
  redis:
    image: redis:6.2-alpine
    container_name: redis
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD} --appendonly yes
    ports:
      - "6379:6379"
    volumes:
      - ./data/redis:/data
      - ./config/redis/redis.conf:/usr/local/etc/redis/redis.conf
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  # Nacos
  nacos:
    image: nacos/nacos-server:v2.2.0
    container_name: nacos
    restart: always
    environment:
      MODE: standalone
      SPRING_DATASOURCE_PLATFORM: mysql
      MYSQL_SERVICE_HOST: mysql
      MYSQL_SERVICE_PORT: 3306
      MYSQL_SERVICE_DB_NAME: nacos_config
      MYSQL_SERVICE_USER: ${MYSQL_USER}
      MYSQL_SERVICE_PASSWORD: ${MYSQL_PASSWORD}
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: ${NACOS_AUTH_TOKEN}
      NACOS_AUTH_IDENTITY_KEY: serverIdentity
      NACOS_AUTH_IDENTITY_VALUE: security
      TZ: Asia/Shanghai
    ports:
      - "8848:8848"
      - "9848:9848"
    volumes:
      - ./data/nacos/logs:/home/nacos/logs
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 应用服务
  app:
    image: your-app:1.0.0
    container_name: your-app
    restart: always
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/${MYSQL_DATABASE}?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai
      SPRING_DATASOURCE_USERNAME: ${MYSQL_USER}
      SPRING_DATASOURCE_PASSWORD: ${MYSQL_PASSWORD}
      SPRING_REDIS_HOST: redis
      SPRING_REDIS_PORT: 6379
      SPRING_REDIS_PASSWORD: ${REDIS_PASSWORD}
      SPRING_CLOUD_NACOS_DISCOVERY_SERVER_ADDR: nacos:8848
      SPRING_CLOUD_NACOS_CONFIG_SERVER_ADDR: nacos:8848
      TZ: Asia/Shanghai
    ports:
      - "8080:8080"
    volumes:
      - ./logs/app:/var/log/apps
      - ./config/app/application-prod.yml:/app/config/application-prod.yml
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_healthy
      nacos:
        condition: service_healthy
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

networks:
  app-network:
    driver: bridge

volumes:
  mysql-data:
  redis-data:
  nacos-data:
```

### 3.3 环境变量文件

```bash
# 创建 .env 文件
vi .env
```

```bash
# MySQL 配置
MYSQL_ROOT_PASSWORD=RootPassword123!
MYSQL_DATABASE=your_app_db
MYSQL_USER=appuser
MYSQL_PASSWORD=YourStrongPassword123!

# Redis 配置
REDIS_PASSWORD=YourRedisPassword123!

# Nacos 配置
NACOS_AUTH_TOKEN=SecretKey012345678901234567890123456789012345678901234567890123456789
```

### 3.4 配置文件准备

#### 3.4.1 MySQL 配置

```bash
# 创建 MySQL 配置目录
mkdir -p config/mysql

# 创建 MySQL 配置文件
vi config/mysql/my.cnf
```

```ini
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
max_connections=1000
innodb_buffer_pool_size=2G
slow_query_log=1
slow_query_log_file=/var/log/mysql/slow.log
long_query_time=2
```

```bash
# 创建数据库初始化脚本（可选）
vi config/mysql/init.sql
```

```sql
-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `your_app_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `nacos_config` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 3.4.2 Redis 配置

```bash
# 创建 Redis 配置目录
mkdir -p config/redis

# 创建 Redis 配置文件
vi config/redis/redis.conf
```

```conf
bind 0.0.0.0
port 6379
protected-mode yes
requirepass YourRedisPassword123!
appendonly yes
maxmemory 2gb
maxmemory-policy allkeys-lru
```

### 3.5 启动服务

```bash
# 创建数据目录
mkdir -p data/{mysql,redis,nacos/logs}
mkdir -p logs/app
mkdir -p config/app

# 设置目录权限
chmod -R 755 data logs config

# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f app

# 查看特定服务日志
docker-compose logs -f mysql
docker-compose logs -f redis
docker-compose logs -f nacos
```

### 3.6 服务管理命令

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose stop

# 停止并删除容器
docker-compose down

# 停止并删除容器、网络、数据卷
docker-compose down -v

# 重启服务
docker-compose restart app

# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs -f [service-name]

# 进入容器
docker-compose exec app sh
docker-compose exec mysql bash

# 扩展服务（多实例）
docker-compose up -d --scale app=3

# 更新服务（重新构建镜像后）
docker-compose up -d --no-deps --build app
```

---

## 四、应用容器部署

### 4.1 单独运行应用容器

```bash
# 运行应用容器
docker run -d \
  --name your-app \
  --restart always \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/your_app_db \
  -e SPRING_DATASOURCE_USERNAME=appuser \
  -e SPRING_DATASOURCE_PASSWORD=YourStrongPassword123! \
  -e SPRING_REDIS_HOST=redis \
  -e SPRING_REDIS_PASSWORD=YourRedisPassword123! \
  -v ./logs/app:/var/log/apps \
  --network app-network \
  your-app:1.0.0

# 查看容器状态
docker ps | grep your-app

# 查看容器日志
docker logs -f your-app

# 进入容器
docker exec -it your-app sh

# 停止容器
docker stop your-app

# 删除容器
docker rm your-app
```

### 4.2 容器资源限制

```bash
# 运行容器时设置资源限制
docker run -d \
  --name your-app \
  --restart always \
  --memory="2g" \
  --cpus="2" \
  --memory-swap="4g" \
  -p 8080:8080 \
  your-app:1.0.0

# 或在 docker-compose.yml 中配置
```

```yaml
services:
  app:
    image: your-app:1.0.0
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

---

## 五、中间件容器部署

### 5.1 MySQL 容器

```bash
# 运行 MySQL 容器
docker run -d \
  --name mysql \
  --restart always \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=RootPassword123! \
  -e MYSQL_DATABASE=your_app_db \
  -e MYSQL_USER=appuser \
  -e MYSQL_PASSWORD=YourStrongPassword123! \
  -v mysql-data:/var/lib/mysql \
  -v ./config/mysql/my.cnf:/etc/mysql/conf.d/my.cnf \
  mysql:8.0

# 连接 MySQL
docker exec -it mysql mysql -u root -p
```

### 5.2 Redis 容器

```bash
# 运行 Redis 容器
docker run -d \
  --name redis \
  --restart always \
  -p 6379:6379 \
  -v redis-data:/data \
  -v ./config/redis/redis.conf:/usr/local/etc/redis/redis.conf \
  redis:6.2-alpine redis-server /usr/local/etc/redis/redis.conf

# 连接 Redis
docker exec -it redis redis-cli -a YourRedisPassword123!
```

### 5.3 Nacos 容器

```bash
# 运行 Nacos 容器（单机模式）
docker run -d \
  --name nacos \
  --restart always \
  -p 8848:8848 \
  -p 9848:9848 \
  -e MODE=standalone \
  -e SPRING_DATASOURCE_PLATFORM=mysql \
  -e MYSQL_SERVICE_HOST=mysql \
  -e MYSQL_SERVICE_PORT=3306 \
  -e MYSQL_SERVICE_DB_NAME=nacos_config \
  -e MYSQL_SERVICE_USER=appuser \
  -e MYSQL_SERVICE_PASSWORD=YourStrongPassword123! \
  -e NACOS_AUTH_ENABLE=true \
  nacos/nacos-server:v2.2.0
```

---

## 六、监控与日志

### 6.1 Prometheus 与 Grafana

详见 [监控部署指南](../monitoring/PROMETHEUS_GRAFANA.md)

### 6.2 ELK Stack

详见 [ELK 部署指南](../logging/ELK_STACK.md)

### 6.3 容器监控

```bash
# 查看容器资源使用
docker stats

# 查看特定容器资源使用
docker stats your-app

# 查看容器详细信息
docker inspect your-app

# 查看容器进程
docker top your-app
```

---

## 七、运维管理

### 7.1 日志管理

```bash
# 查看容器日志
docker logs your-app

# 实时查看日志
docker logs -f your-app

# 查看最近 100 行日志
docker logs --tail 100 your-app

# 查看指定时间范围的日志
docker logs --since "2025-01-01T00:00:00" --until "2025-01-01T23:59:59" your-app

# 导出日志
docker logs your-app > app.log 2>&1
```

### 7.2 备份与恢复

```bash
# 备份 MySQL 数据
docker exec mysql mysqldump -u root -pRootPassword123! your_app_db > backup.sql

# 恢复 MySQL 数据
docker exec -i mysql mysql -u root -pRootPassword123! your_app_db < backup.sql

# 备份 Redis 数据
docker exec redis redis-cli -a YourRedisPassword123! SAVE
docker cp redis:/data/dump.rdb ./backup/

# 备份数据卷
docker run --rm -v mysql-data:/data -v $(pwd):/backup alpine tar czf /backup/mysql-backup.tar.gz /data
```

### 7.3 更新与回滚

```bash
# 构建新镜像
docker build -t your-app:1.0.1 .

# 停止旧容器
docker-compose stop app

# 更新镜像标签
docker tag your-app:1.0.1 your-app:latest

# 启动新容器
docker-compose up -d app

# 回滚（使用旧镜像）
docker tag your-app:1.0.0 your-app:latest
docker-compose up -d app
```

### 7.4 清理资源

```bash
# 清理停止的容器
docker container prune

# 清理未使用的镜像
docker image prune

# 清理未使用的数据卷
docker volume prune

# 清理所有未使用的资源
docker system prune -a

# 查看磁盘使用
docker system df
```

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

