# WMT Framework 部署规范文档

> 基于 WMT Framework 的业务系统完整部署规范

## 📚 文档目录

### 核心部署文档

1. **[二进制部署规范](./BINARY_DEPLOYMENT.md)**
   - 传统 JAR 包直接部署方式
   - 包含详细的环境准备、中间件部署、应用部署步骤
   - 适用于单机或少量服务器部署

2. **[Docker 容器化部署规范](./DOCKER_DEPLOYMENT.md)**
   - 基于 Docker 的单机/多机部署
   - 包含 Dockerfile、docker-compose 配置
   - 适用于容器化环境部署

3. **[Kubernetes 部署规范](./KUBERNETES_DEPLOYMENT.md)**
   - 基于 K8s 的云原生部署
   - 包含完整的 K8s YAML 配置
   - 适用于大规模容器编排环境

### 监控与日志

4. **[Prometheus + Grafana 监控部署](./monitoring/PROMETHEUS_GRAFANA.md)**
   - Prometheus 监控系统部署
   - Grafana 可视化配置
   - 应用监控指标配置

5. **[ELK Stack 日志部署](./logging/ELK_STACK.md)**
   - Elasticsearch、Logstash、Kibana 部署
   - 应用日志收集与查询
   - Filebeat 日志采集配置

### CI/CD 与工具

6. **[CI/CD 部署示例](./CI_CD_EXAMPLES.md)**
   - GitHub Actions 配置示例
   - GitLab CI 配置示例
   - Jenkins Pipeline 示例

### 模板文件

7. **[部署脚本模板](./templates/)**
   - `start.sh` - 应用启动脚本
   - `stop.sh` - 应用停止脚本
   - `Dockerfile` - Docker 镜像构建文件
   - `docker-compose.yml` - Docker Compose 编排文件
   - `application-prod.yml.example` - 生产环境配置示例

---

## 🚀 快速开始

### 选择部署方式

根据您的环境选择合适的部署方式：

- **二进制部署**：适合传统服务器环境，单机或少量服务器
- **Docker 部署**：适合容器化环境，单机或多机 Docker 环境
- **Kubernetes 部署**：适合云原生环境，大规模容器编排

### 部署前准备

1. **环境要求**
   - JDK 8+
   - Maven 3.6+
   - 操作系统：Linux（CentOS 7+ / Ubuntu 18.04+）

2. **中间件要求**
   - MySQL 8.0
   - Redis 6.x
   - Nacos 2.2.0（配置中心）

3. **监控与日志（可选但推荐）**
   - Prometheus + Grafana
   - ELK Stack

### 部署步骤

1. **阅读对应部署文档**
   - 根据选择的部署方式，阅读相应的详细文档

2. **准备配置文件**
   - 参考模板文件，准备应用配置文件
   - 配置数据库、Redis、Nacos 连接信息

3. **执行部署**
   - 按照文档中的命令步骤执行部署
   - 验证部署结果

---

## 📋 部署检查清单

### 部署前检查

- [ ] 服务器资源充足（CPU、内存、磁盘）
- [ ] JDK 已安装并配置环境变量
- [ ] 中间件（MySQL、Redis、Nacos）已部署
- [ ] 网络端口已开放
- [ ] 防火墙规则已配置
- [ ] 配置文件已准备

### 部署后检查

- [ ] 应用启动成功
- [ ] 健康检查通过
- [ ] 数据库连接正常
- [ ] Redis 连接正常
- [ ] Nacos 连接正常
- [ ] 日志输出正常
- [ ] 监控指标正常（如已配置）

---

## 🔧 常见问题

### 1. 应用无法启动

- 检查 Java 版本：`java -version`
- 检查端口占用：`netstat -tlnp | grep 8080`
- 查看应用日志：`tail -f /var/log/apps/your-app/application.log`

### 2. 数据库连接失败

- 检查 MySQL 服务状态：`systemctl status mysql`
- 测试数据库连接：`mysql -u appuser -p -h localhost your_app_db`
- 检查防火墙规则

### 3. Redis 连接失败

- 检查 Redis 服务状态：`systemctl status redis`
- 测试 Redis 连接：`redis-cli -a YourRedisPassword123! ping`
- 检查 Redis 密码配置

---

## 📞 支持与反馈

如有问题或建议，请通过以下方式联系：

- 提交 Issue：https://github.com/Wmt/wmt-framework/issues
- 邮箱：support@wmt.com

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

