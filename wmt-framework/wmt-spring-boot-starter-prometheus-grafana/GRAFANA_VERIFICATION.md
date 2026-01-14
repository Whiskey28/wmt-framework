# Grafana 验证指南

当 Prometheus 已成功抓取指标，但 Grafana 显示 "No data" 时，按以下步骤排查。

---

## 一、快速验证步骤

### 步骤 1：验证 Grafana 数据源连接

1. 登录 Grafana（http://localhost:3000）
2. 进入 **Configuration（齿轮图标）** → **Data Sources**
3. 点击 **Prometheus** 数据源
4. 点击底部的 **Save & Test** 按钮
5. 应该显示 **"Data source is working"** ✅

如果显示错误，检查：
- Prometheus URL 是否正确（通常是 `http://prometheus:9090` 或 `http://localhost:9090`）
- 网络连通性（Grafana 容器能否访问 Prometheus）

---

### 步骤 2：在 Grafana Explore 中测试查询

1. 点击左侧菜单 **Explore（指南针图标）**
2. 确保数据源选择为 **Prometheus**
3. 在查询框中输入以下 PromQL 查询，逐个测试：

#### 测试 1：验证 job 是否存在

```promql
up{job="wmt-application"}
```

**预期结果**：应该返回 `1`（表示该 job 的 target 是 UP 状态）

#### 测试 2：查询 JVM 内存指标

```promql
jvm_memory_used_bytes{job="wmt-application", area="heap"}
```

**预期结果**：应该返回多个时间序列（不同内存池的数据）

#### 测试 3：查询 HTTP 请求指标

```promql
http_server_requests_seconds_count{job="wmt-application"}
```

**预期结果**：如果有 HTTP 请求，应该返回数据；如果没有请求，可能为空（这是正常的）

#### 测试 4：查询所有可用指标

```promql
{job="wmt-application"}
```

**预期结果**：应该返回所有带 `job="wmt-application"` 标签的指标

---

### 步骤 3：修正 Dashboard 的 job 变量

**问题**：Dashboard 顶部选择了 `job="prometheus"`，应该选择 `job="wmt-application"`

**解决方法**：

1. 在 Dashboard 页面，点击右上角的 **变量下拉框**
2. 找到 **job** 变量，点击下拉菜单
3. 选择 **wmt-application**（而不是 `prometheus`）
4. Dashboard 应该自动刷新并显示数据

---

### 步骤 4：验证基础指标是否存在

在 Prometheus UI（http://localhost:9090）中验证：

1. 进入 **Graph** 页面
2. 输入以下查询，逐个测试：

```promql
# 1. 验证 target 状态
up{job="wmt-application"}

# 2. 查询 JVM 指标
jvm_memory_used_bytes{job="wmt-application"}

# 3. 查询 HTTP 指标
http_server_requests_seconds_count{job="wmt-application"}

# 4. 查询所有指标（查看指标列表）
{job="wmt-application"}
```

**预期结果**：每个查询都应该返回数据（如果没有 HTTP 请求，HTTP 指标可能为空，这是正常的）

---

## 二、详细排查流程

### 场景 A：Explore 中有数据，但 Dashboard 显示 "No data"

**原因**：Dashboard 的查询语句或变量配置有问题

**解决步骤**：

1. **检查 Dashboard 变量**：
   - 确保 `job` 变量选择了 `wmt-application`
   - 检查变量查询是否正确：`label_values(up, job)`

2. **检查 Panel 查询语句**：
   - 点击 Panel 标题 → **Edit**
   - 查看查询语句中的 `job="$job"` 是否正确替换
   - 尝试将 `$job` 直接替换为 `wmt-application` 测试

3. **检查时间范围**：
   - 确保时间范围选择合理（如 **Last 5 minutes**）
   - 如果应用刚启动，选择 **Last 1 hour** 查看历史数据

---

### 场景 B：Explore 中也显示 "No data"

**原因**：Prometheus 中没有该 job 的指标，或指标名称不匹配

**排查步骤**：

1. **验证 Prometheus Target 状态**：
   - 在 Prometheus UI 的 **Status → Targets** 中
   - 确认 `wmt-application` 状态为 **UP**
   - 如果为 DOWN，参考 `TESTING_GUIDE.md` 排查网络问题

2. **验证指标端点**：
   - 直接访问业务系统的指标端点：
     ```
     http://172.20.10.4:48028/actuator/prometheus
     ```
   - 应该能看到大量指标数据（以 `# HELP` 和 `# TYPE` 开头）

3. **检查指标名称**：
   - 在 Prometheus UI 的 **Graph** 页面输入：
     ```promql
     {job="wmt-application"}
     ```
   - 查看返回的指标列表，确认指标名称是否正确

4. **检查标签匹配**：
   - 在 Prometheus UI 中查看指标的完整标签：
     ```promql
     up{job="wmt-application"}
     ```
   - 确认 `job` 标签的值确实是 `wmt-application`

---

### 场景 C：部分 Panel 有数据，部分没有

**原因**：某些指标可能不存在或查询语句有问题

**排查步骤**：

1. **JVM 指标无数据**：
   - 检查应用是否启用了 Actuator
   - 验证查询：`jvm_memory_used_bytes{job="wmt-application"}`

2. **HTTP 指标无数据**：
   - 如果没有 HTTP 请求，指标可能为空（这是正常的）
   - 尝试调用一个业务接口，然后重新查询
   - 验证查询：`http_server_requests_seconds_count{job="wmt-application"}`

3. **业务指标无数据**：
   - 确认已调用 `DomainMetricPublisher` 的埋点代码
   - 检查指标名称是否正确（小写+下划线）
   - 在 `/actuator/prometheus` 端点中搜索指标名称

---

## 三、常见查询示例

### 基础系统指标

```promql
# 1. 应用是否在线
up{job="wmt-application"}

# 2. JVM 堆内存使用（字节）
jvm_memory_used_bytes{job="wmt-application", area="heap"}

# 3. JVM 堆内存使用率
sum(jvm_memory_used_bytes{job="wmt-application", area="heap"}) 
/ 
sum(jvm_memory_max_bytes{job="wmt-application", area="heap"})

# 4. 活跃线程数
jvm_threads_live_threads{job="wmt-application"}

# 5. HTTP 请求总数
sum(rate(http_server_requests_seconds_count{job="wmt-application"}[5m]))

# 6. HTTP 错误率（5xx）
sum(rate(http_server_requests_seconds_count{job="wmt-application", status=~"5.."}[5m]))
/
sum(rate(http_server_requests_seconds_count{job="wmt-application"}[5m]))
```

### 业务指标查询

```promql
# 1. 业务计数器（假设指标名为 biz_order_create_total）
sum(rate(biz_order_create_total{job="wmt-application"}[5m]))

# 2. 业务计数器按标签分组
sum(rate(biz_order_create_total{job="wmt-application"}[5m])) by (channel)

# 3. 业务耗时 P95（假设指标名为 biz_order_query_duration_seconds）
histogram_quantile(0.95, 
  sum(rate(biz_order_query_duration_seconds_bucket{job="wmt-application"}[5m])) by (le)
)

# 4. 业务 Gauge 指标（假设指标名为 biz_inventory_count）
biz_inventory_count{job="wmt-application"}
```

---

## 四、Dashboard 修复步骤

如果 Dashboard 一直显示 "No data"，可以手动修复：

### 方法 1：修改 job 变量

1. 点击 Dashboard 右上角的 **齿轮图标（Dashboard settings）**
2. 选择 **Variables** 标签
3. 找到 `job` 变量，点击 **Edit**
4. 在 **Query** 框中输入：
   ```promql
   label_values(up, job)
   ```
5. 点击 **Update**，然后 **Save dashboard**

### 方法 2：直接修改 Panel 查询

1. 点击 Panel 标题 → **Edit**
2. 在查询语句中，将 `job="$job"` 替换为 `job="wmt-application"`
3. 点击 **Apply** 保存

### 方法 3：重新导入 Dashboard

如果 Dashboard 配置有问题，可以重新导入：

1. 进入 **Dashboards** → **Import**
2. 上传 `default-app.json` 文件
3. 选择数据源为 **Prometheus**
4. 选择 job 为 **wmt-application**

---

## 五、验证清单

完成以下检查，确保 Grafana 正常工作：

- [ ] Grafana 数据源连接测试通过（**Configuration → Data Sources → Test**）
- [ ] 在 **Explore** 中能查询到 `up{job="wmt-application"}` 返回 `1`
- [ ] 在 **Explore** 中能查询到 JVM 指标（如 `jvm_memory_used_bytes`）
- [ ] Dashboard 的 `job` 变量选择了 `wmt-application`（不是 `prometheus`）
- [ ] Dashboard 的时间范围选择合理（如 **Last 5 minutes**）
- [ ] 在 Prometheus UI 中能查询到相同指标
- [ ] 业务系统的 `/actuator/prometheus` 端点可访问

---

## 六、快速测试脚本

在 Grafana Explore 中依次执行以下查询，验证各项功能：

```promql
# 1. 基础连通性
up{job="wmt-application"}

# 2. JVM 内存
jvm_memory_used_bytes{job="wmt-application", area="heap"}

# 3. JVM 线程
jvm_threads_live_threads{job="wmt-application"}

# 4. HTTP 请求（如果有请求）
http_server_requests_seconds_count{job="wmt-application"}

# 5. 所有指标（查看完整列表）
{job="wmt-application"}
```

如果以上查询都能返回数据，说明 Grafana 配置正确，问题可能在于 Dashboard 的变量或查询语句。

---

## 七、故障排查流程图

```
Grafana 显示 "No data"
    ↓
检查数据源连接
    ↓
[失败] → 修复 Prometheus URL 或网络问题
    ↓
[成功]
    ↓
在 Explore 中测试查询
    ↓
[无数据] → 检查 Prometheus Target 状态和指标端点
    ↓
[有数据]
    ↓
检查 Dashboard job 变量
    ↓
[错误] → 修改为 wmt-application
    ↓
[正确]
    ↓
检查 Panel 查询语句
    ↓
[错误] → 修复查询语句
    ↓
[正确] → 检查时间范围
    ↓
应该能看到数据了 ✅
```

---

## 八、联系支持

如果按照以上步骤仍无法解决问题，请提供：

1. Grafana 数据源测试结果截图
2. Explore 中查询 `up{job="wmt-application"}` 的结果
3. Prometheus Target 状态截图
4. Dashboard 的变量配置截图
5. 业务系统 `/actuator/prometheus` 端点的部分输出

