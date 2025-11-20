# VMware 虚拟机访问 Windows 主机配置指南

本文档专门针对 **Prometheus/Grafana 运行在 VMware CentOS7 虚拟机，Java 应用运行在 Windows 主机 IDEA** 的场景。

---

## 一、网络架构说明

```
┌─────────────────────────────────────┐
│         Windows 主机                 │
│  ┌──────────────────────────────┐   │
│  │  IDEA (Java 应用 :8080)      │   │
│  └──────────────────────────────┘   │
│           ↕ 网络通信                 │
│  ┌──────────────────────────────┐   │
│  │  VMware 网络适配器            │   │
│  │  IP: 192.168.x.1 (NAT)       │   │
│  │  或 192.168.1.100 (桥接)     │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
           ↕
┌─────────────────────────────────────┐
│    VMware 虚拟机 (CentOS7)           │
│  ┌──────────────────────────────┐   │
│  │  Docker Compose               │   │
│  │  - Prometheus :9090           │   │
│  │  - Grafana :3000             │   │
│  └──────────────────────────────┘   │
│  IP: 192.168.x.2 (NAT)               │
│  或 192.168.1.101 (桥接)             │
└─────────────────────────────────────┘
```

---

## 二、确定 Windows 主机 IP

### 方式 1：在 CentOS7 虚拟机中查看

```bash
# 查看默认网关（通常是 Windows 主机 IP）
ip route | grep default

# 输出示例：
# default via 192.168.137.1 dev ens33
# 说明 Windows 主机 IP 是 192.168.137.1

# 或者查看所有网络接口
ip addr show
```

### 方式 2：在 Windows 中查看

打开 PowerShell：

```powershell
# 查看 VMware 网络适配器的 IP
ipconfig

# 找到类似以下输出：
# VMware Network Adapter VMnet8:
#   IPv4 地址 . . . . . . . . . . . : 192.168.137.1
#   子网掩码  . . . . . . . . . . . : 255.255.255.0
```

### 方式 3：VMware NAT 默认地址

如果使用 VMware 默认 NAT 配置，Windows 主机 IP 通常是：
- `10.0.2.2`（VMware 默认 NAT 网关）

---

## 三、测试网络连通性

### 在 CentOS7 虚拟机中测试

```bash
# 方式 1：使用 curl 测试 HTTP 端点
curl http://192.168.137.1:8080/actuator/prometheus

# 如果返回 Prometheus 指标数据，说明网络连通正常

# 方式 2：使用 telnet 测试端口
telnet 192.168.137.1 8080

# 如果连接成功，说明端口可访问

# 方式 3：使用 ping 测试基本连通性
ping 192.168.137.1
```

### 在 Windows 中测试

```powershell
# 测试 Java 应用是否监听所有接口
netstat -an | findstr :8080

# 应该看到类似：
# TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING
# 如果是 127.0.0.1:8080，需要修改为 0.0.0.0:8080
```

---

## 四、配置 Windows 防火墙

### 方式 1：PowerShell 命令（推荐）

以管理员身份运行 PowerShell：

```powershell
# 允许 8080 端口入站
New-NetFirewallRule -DisplayName "Allow Java App 8080 for Prometheus" `
    -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow

# 验证规则是否创建成功
Get-NetFirewallRule -DisplayName "Allow Java App 8080*"
```

### 方式 2：图形界面

1. 打开 **控制面板** → **Windows Defender 防火墙**
2. 点击 **高级设置**
3. 选择 **入站规则** → **新建规则**
4. 选择 **端口** → **TCP** → **特定本地端口：8080**
5. 选择 **允许连接**
6. 应用到所有配置文件
7. 命名为 "Allow Java App 8080 for Prometheus"

### 方式 3：临时关闭防火墙（仅用于测试）

```powershell
# 临时关闭防火墙（不推荐，仅用于快速测试）
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 测试完成后重新启用
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
```

---

## 五、配置 Java 应用监听地址

### 修改 application.yml

```yaml
server:
  # 重要：必须监听 0.0.0.0，不能是 127.0.0.1
  address: 0.0.0.0
  port: 8080
```

### 验证监听地址

启动 Java 应用后，在 Windows PowerShell 中执行：

```powershell
netstat -an | findstr :8080
```

应该看到：
```
TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING
```

如果看到 `127.0.0.1:8080`，说明只监听本地，需要修改配置。

---

## 六、配置 Prometheus

### 编辑 prometheus.yml

```yaml
scrape_configs:
  - job_name: 'wmt-application'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 15s
    static_configs:
      # 替换为实际的 Windows 主机 IP
      - targets: ['192.168.137.1:8080']  # 或 10.0.2.2（VMware NAT 默认）
        labels:
          application: 'wmt-love'
          service: 'love-service'
          host: 'windows-idea'
          environment: 'dev'
```

### 重启 Prometheus

```bash
docker-compose restart prometheus
```

---

## 七、验证配置

### 步骤 1：检查 Prometheus Target 状态

1. 在 CentOS7 虚拟机中访问：`http://localhost:9090`
2. 进入 **Status → Targets**
3. 查看 `wmt-application` 的状态：
   - **UP**：配置成功 ✅
   - **DOWN**：继续排查

### 步骤 2：查看抓取错误

如果状态为 DOWN，点击 Target 名称查看错误信息：

- `connection refused`：端口不可访问，检查防火墙和监听地址
- `no route to host`：网络不通，检查 IP 地址是否正确
- `timeout`：网络延迟或防火墙拦截

### 步骤 3：测试指标查询

在 Prometheus **Graph** 页面输入：

```promql
up{job="wmt-application"}
```

如果返回 `1`，说明抓取成功。

---

## 八、常见问题

### Q1：无法 ping 通 Windows 主机

**原因**：Windows 防火墙默认阻止 ICMP（ping）

**解决**：
```powershell
# 允许 ICMP 入站（可选，仅用于测试）
New-NetFirewallRule -DisplayName "Allow ICMP" `
    -Direction Inbound -Protocol ICMPv4 -Action Allow
```

### Q2：curl 返回 connection refused

**原因**：Java 应用只监听 `127.0.0.1`

**解决**：修改 `application.yml` 中 `server.address: 0.0.0.0`

### Q3：telnet 连接超时

**原因**：Windows 防火墙阻止 8080 端口

**解决**：按照第四步配置防火墙规则

### Q4：Prometheus 显示 "no route to host"

**原因**：IP 地址配置错误

**解决**：
1. 在 CentOS7 中执行 `ip route | grep default` 确认网关 IP
2. 或使用 `10.0.2.2`（VMware NAT 默认网关）

### Q5：使用桥接模式还是 NAT 模式？

**推荐**：
- **开发环境**：桥接模式（虚拟机有独立 IP，更直观）
- **生产环境**：NAT 模式（更安全，隔离网络）

---

## 九、快速检查清单

- [ ] Windows 主机 IP 已确定（`ip route | grep default` 或 `ipconfig`）
- [ ] Java 应用监听 `0.0.0.0:8080`（不是 `127.0.0.1:8080`）
- [ ] Windows 防火墙允许 8080 端口入站
- [ ] 在 CentOS7 中可以 `curl http://[Windows IP]:8080/actuator/prometheus`
- [ ] Prometheus 配置中的 `targets` 使用正确的 Windows IP
- [ ] Prometheus Target 状态为 UP

---

## 十、参考配置示例

### 完整 prometheus.yml（VMware NAT 模式）

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'wmt-application'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['10.0.2.2:8080']  # VMware NAT 默认网关
        labels:
          application: 'wmt-love'
          environment: 'dev'
```

### 完整 prometheus.yml（桥接模式）

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'wmt-application'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['192.168.1.100:8080']  # Windows 主机局域网 IP
        labels:
          application: 'wmt-love'
          environment: 'dev'
```

