# Dashboard "No Data" 问题排查指南

当 Grafana 数据源连接正常，但 Dashboard 显示 "No data" 时，按以下步骤排查。

---

## 一、快速诊断步骤

### 步骤 1：在 Grafana Explore 中验证基础指标

1. 点击左侧菜单 **Explore（指南针图标）**
2. 确保数据源选择为 **Prometheus**
3. 依次执行以下查询，记录哪些有数据、哪些没有：

#### 查询 1：验证应用在线状态
```promql
up{job="wmt-application"}
```
**预期**：应该返回 `1`（如果返回空，说明 Prometheus 没有抓取到该 job）

#### 查询 2：查看所有可用指标
```promql
{job="wmt-application"}
```
**预期**：应该返回大量指标列表（如果为空，说明 Prometheus 中没有该 job 的指标）

#### 查询 3：JVM 内存指标（最基础的指标）
```promql
jvm_memory_used_bytes{job="wmt-application"}
```
**预期**：应该返回多个时间序列（不同内存池）

#### 查询 4：JVM 线程指标
```promql
jvm_threads_live_threads{job="wmt-application"}
```
**预期**：应该返回一个数值（活跃线程数）

#### 查询 5：HTTP 请求指标（可能为空，如果应用没有收到请求）
```promql
http_server_requests_seconds_count{job="wmt-application"}
```
**预期**：如果有 HTTP 请求，应该有数据；如果没有请求，返回空是正常的

---

### 步骤 2：检查指标名称是否正确

Spring Boot 不同版本的 Actuator 可能使用不同的指标名称。检查实际指标名称：

#### 方法 1：在 Prometheus UI 中查看

1. 访问 Prometheus UI：http://localhost:9090
2. 进入 **Graph** 页面
3. 输入以下查询，查看所有指标：
   ```promql
   {job="wmt-application"}
   ```
4. 在结果中搜索以下关键词：
   - `http` - 查找 HTTP 相关指标
   - `jvm` - 查找 JVM 相关指标
   - `memory` - 查找内存相关指标

#### 方法 2：直接访问指标端点

访问业务系统的指标端点：
```
http://172.20.10.4:48028/actuator/prometheus
```

在返回的文本中搜索以下指标名称：
- `http_server_requests_seconds` 或 `http_server_requests_duration_seconds`
- `jvm_memory_used_bytes`
- `jvm_threads_live_threads`

**注意**：不同版本的 Spring Boot Actuator 可能使用不同的指标名称：
- Spring Boot 2.x: `http_server_requests_seconds`
- Spring Boot 3.x: `http_server_requests_seconds`（相同）
- 某些版本可能使用：`http_server_requests_duration_seconds`

---

### 步骤 3：验证查询语句

在 Grafana Explore 中，将 Dashboard 的查询语句复制过来，直接替换 `$job` 为 `wmt-application` 测试：

#### 测试 JVM 堆使用率查询
```promql
sum(jvm_memory_used_bytes{area="heap",job="wmt-application"}) / sum(jvm_memory_max_bytes{area="heap",job="wmt-application"})
```

#### 测试线程数查询
```promql
jvm_threads_live_threads{job="wmt-application"}
```

#### 测试 HTTP 请求查询（如果应用有请求）
```promql
histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket{job="wmt-application",status!~"5.."}[5m])) by (le))
```

---

## 二、常见问题及解决方案

### 问题 1：HTTP 指标无数据（正常情况）

**原因**：应用可能还没有收到 HTTP 请求，或者指标名称不匹配

**解决方案**：

1. **触发一些 HTTP 请求**：
   - 访问应用的 API 接口
   - 或使用 curl 发送请求：
     ```bash
     curl http://172.20.10.4:48028/actuator/health
     ```

2. **检查指标名称**：
   - 在 `/actuator/prometheus` 端点中搜索 `http_server`
   - 确认实际的指标名称

3. **修改 Dashboard 查询**（如果指标名称不同）：
   - 点击 Panel → Edit
   - 修改查询语句中的指标名称

---

### 问题 2：JVM 指标无数据

**原因**：可能指标名称或标签不匹配

**排查步骤**：

1. **在 Explore 中测试简化查询**：
   ```promql
   # 不指定 area 标签
   jvm_memory_used_bytes{job="wmt-application"}
   
   # 查看所有 JVM 内存相关指标
   {job="wmt-application",__name__=~"jvm.*"}
   ```

2. **检查标签值**：
   ```promql
   # 查看 area 标签的所有可能值
   label_values(jvm_memory_used_bytes{job="wmt-application"}, area)
   ```

3. **如果 area 标签不存在，修改查询**：
   ```promql
   # 移除 area 标签过滤
   sum(jvm_memory_used_bytes{job="wmt-application"}) / sum(jvm_memory_max_bytes{job="wmt-application"})
   ```

---

### 问题 3：时间范围问题

**现象**：查询在 Explore 中有数据，但 Dashboard 显示 "No data"

**解决方案**：

1. **调整时间范围**：
   - 将时间范围改为 **Last 5 minutes** 或 **Last 1 hour**
   - 确保时间范围覆盖应用运行的时间

2. **检查时间对齐**：
   - 确保 Grafana 和 Prometheus 的时间同步

---

### 问题 4：rate() 函数在短时间内无数据

**原因**：`rate()` 函数需要至少 2 个数据点才能计算，如果时间范围太短或数据点太少，可能返回空

**解决方案**：

1. **增加时间范围**：
   - 将 `[5m]` 改为 `[15m]` 或更长

2. **使用 `increase()` 替代**（仅用于测试）：
   ```promql
   # 原查询
   rate(http_server_requests_seconds_count{job="wmt-application"}[5m])
   
   # 测试用（显示总增量）
   increase(http_server_requests_seconds_count{job="wmt-application"}[5m])
   ```

---

## 三、修复 Dashboard 的步骤

### 方法 1：逐个 Panel 修复

1. **修复 JVM 堆使用率 Panel**：
   - 点击 Panel 标题 → **Edit**
   - 在查询框中，先测试简化查询：
     ```promql
     jvm_memory_used_bytes{job="wmt-application"}
     ```
   - 如果有数据，再测试完整查询
   - 如果 `area="heap"` 标签不存在，移除该过滤条件

2. **修复线程数 Panel**：
   - 点击 Panel 标题 → **Edit**
   - 测试查询：
     ```promql
     jvm_threads_live_threads{job="wmt-application"}
     ```
   - 如果无数据，检查指标名称是否正确

3. **修复 HTTP 指标 Panel**：
   - 先触发一些 HTTP 请求
   - 测试基础查询：
     ```promql
     http_server_requests_seconds_count{job="wmt-application"}
     ```
   - 如果有数据，再测试复杂的 `histogram_quantile` 查询

---

### 方法 2：使用更健壮的查询（推荐）

创建一个新的 Panel，使用更宽松的查询条件：

#### JVM 堆使用率（容错版本）
```promql
# 如果 area 标签存在
sum(jvm_memory_used_bytes{area="heap",job="wmt-application"}) / sum(jvm_memory_max_bytes{area="heap",job="wmt-application"})
# 如果 area 标签不存在，使用这个
sum(jvm_memory_used_bytes{job="wmt-application"}) / sum(jvm_memory_max_bytes{job="wmt-application"})
```

#### HTTP 请求耗时 P95（容错版本）
```promql
# 原查询（需要至少有一些请求）
histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket{job="wmt-application",status!~"5.."}[5m])) by (le))

# 如果无数据，先测试基础查询
http_server_requests_seconds_count{job="wmt-application"}
```

---

## 四、快速测试脚本

在 Grafana Explore 中依次执行，找出哪些指标存在：

```promql
# 1. 基础连通性
up{job="wmt-application"}

# 2. 所有指标（查看列表）
{job="wmt-application"}

# 3. JVM 内存（不指定 area）
jvm_memory_used_bytes{job="wmt-application"}

# 4. JVM 内存（指定 area=heap）
jvm_memory_used_bytes{area="heap",job="wmt-application"}

# 5. JVM 线程
jvm_threads_live_threads{job="wmt-application"}

# 6. HTTP 请求计数
http_server_requests_seconds_count{job="wmt-application"}

# 7. HTTP 请求 bucket（用于计算分位数）
http_server_requests_seconds_bucket{job="wmt-application"}
```

---

## 五、创建测试 Dashboard

如果原 Dashboard 一直有问题，可以创建一个简单的测试 Dashboard：

1. 进入 **Dashboards** → **New Dashboard**
2. 添加以下 Panel：

#### Panel 1：应用在线状态
```promql
up{job="wmt-application"}
```

#### Panel 2：JVM 内存使用（简化）
```promql
jvm_memory_used_bytes{job="wmt-application"}
```

#### Panel 3：JVM 线程数
```promql
jvm_threads_live_threads{job="wmt-application"}
```

#### Panel 4：HTTP 请求总数
```promql
sum(rate(http_server_requests_seconds_count{job="wmt-application"}[5m]))
```

如果这些简单查询都有数据，说明问题在于原 Dashboard 的复杂查询语句。

---

## 六、联系支持时提供的信息

如果以上步骤都无法解决问题，请提供：

1. **Explore 测试结果**：
   - `up{job="wmt-application"}` 的结果
   - `{job="wmt-application"}` 返回的指标列表（截图）

2. **指标端点输出**：
   - `/actuator/prometheus` 的部分输出（包含指标名称）

3. **Spring Boot 版本**：
   - 在 `pom.xml` 中查看 Spring Boot 版本

4. **Prometheus Target 信息**：
   - Prometheus UI 中 `wmt-application` target 的详细信息

5. **Dashboard 查询错误信息**：
   - 点击 Panel → Edit → 查看查询结果是否有错误提示

