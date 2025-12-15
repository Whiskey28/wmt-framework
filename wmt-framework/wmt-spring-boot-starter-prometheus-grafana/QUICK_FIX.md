# Dashboard "No Data" 快速修复指南

## 立即执行的 3 个步骤

### 步骤 1：在 Grafana Explore 中验证指标是否存在

1. 点击左侧菜单 **Explore（指南针图标）**
2. 数据源选择 **Prometheus**
3. 执行以下查询，**记录哪些有数据**：

```promql
# 查询 1：应用是否在线
up{job="wmt-application"}

# 查询 2：JVM 内存（不指定 area）
jvm_memory_used_bytes{job="wmt-application"}

# 查询 3：JVM 内存（指定 area=heap）
jvm_memory_used_bytes{area="heap",job="wmt-application"}

# 查询 4：JVM 线程
jvm_threads_live_threads{job="wmt-application"}

# 查询 5：HTTP 请求（可能为空，如果应用没有收到请求）
http_server_requests_seconds_count{job="wmt-application"}
```

---

### 步骤 2：根据测试结果修复 Dashboard

#### 情况 A：JVM 指标有数据，但 Dashboard 显示 "No data"

**问题**：可能是 `area="heap"` 标签不存在

**修复方法**：

1. 点击 **JVM 堆使用率** Panel → **Edit**
2. 在查询框中，将查询改为：
   ```promql
   sum(jvm_memory_used_bytes{job="wmt-application"}) / sum(jvm_memory_max_bytes{job="wmt-application"})
   ```
   （移除 `area="heap"` 过滤条件）
3. 点击 **Apply**

#### 情况 B：HTTP 指标无数据

**原因**：应用可能还没有收到 HTTP 请求

**解决方法**：

1. **触发一些请求**：
   ```bash
   # 在 CentOS7 虚拟机中执行
   curl http://172.20.10.4:48028/actuator/health
   curl http://172.20.10.4:48028/actuator/info
   ```

2. **等待 1-2 分钟后，刷新 Dashboard**

3. **如果仍然无数据**，检查指标名称：
   - 访问 `http://172.20.10.4:48028/actuator/prometheus`
   - 搜索 `http_server`，查看实际的指标名称

#### 情况 C：所有指标都无数据

**问题**：Prometheus 可能没有抓取到指标，或指标名称完全不匹配

**排查步骤**：

1. **在 Prometheus UI 中验证**：
   - 访问 http://localhost:9090
   - 进入 **Graph** 页面
   - 输入：`{job="wmt-application"}`
   - 查看返回的指标列表

2. **检查指标端点**：
   - 访问：`http://172.20.10.4:48028/actuator/prometheus`
   - 应该能看到大量指标数据

3. **如果指标端点有数据，但 Prometheus 没有**：
   - 检查 Prometheus Target 状态
   - 查看 Prometheus 日志

---

### 步骤 3：修复线程数 Panel（如果无数据）

1. 点击 **线程活跃数** Panel → **Edit**
2. 测试查询：
   ```promql
   jvm_threads_live_threads{job="wmt-application"}
   ```
3. 如果 Explore 中有数据，但 Panel 中无数据：
   - 检查时间范围（改为 **Last 5 minutes**）
   - 检查 Panel 的 **Format** 设置（应该是 **Time series**）

---

## 快速测试清单

完成以下检查，找出问题所在：

- [ ] 在 Explore 中，`up{job="wmt-application"}` 返回 `1`
- [ ] 在 Explore 中，`jvm_memory_used_bytes{job="wmt-application"}` 有数据
- [ ] 在 Explore 中，`jvm_threads_live_threads{job="wmt-application"}` 有数据
- [ ] 在 Explore 中，`http_server_requests_seconds_count{job="wmt-application"}` 有数据（如果没有请求，这个可能为空，是正常的）
- [ ] Dashboard 时间范围设置为 **Last 5 minutes** 或 **Last 1 hour**
- [ ] 如果应用刚启动，确保时间范围覆盖启动时间

---

## 如果以上步骤都无法解决

请提供以下信息：

1. **Explore 测试结果截图**（显示哪些查询有数据、哪些没有）
2. **Prometheus UI 中的指标列表**（Graph 页面输入 `{job="wmt-application"}` 的结果）
3. **指标端点输出**（`/actuator/prometheus` 的部分内容，特别是包含 `jvm_` 和 `http_` 的部分）

