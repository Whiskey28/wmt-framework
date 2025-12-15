# Grafana 权限控制设计方案

## 一、需求分析

### 1.1 核心需求
- 不同用户根据权限查看不同的 Grafana Dashboard
- 与现有用户/权限模块集成
- 支持多租户数据隔离
- 支持基于角色的访问控制（RBAC）

### 1.2 技术挑战
- Grafana 是独立服务，需要代理或 API 集成
- 需要将业务系统的用户权限映射到 Grafana
- 需要实现动态 Dashboard 权限控制

---

## 二、方案设计

### 方案 A：反向代理 + 权限拦截（推荐）

**架构**：
```
业务系统用户 → Spring Security 权限校验 → Grafana 反向代理 → Grafana
```

**优点**：
- 无需修改 Grafana 配置
- 完全由业务系统控制权限
- 可以动态控制 Dashboard 访问
- 支持多租户隔离

**缺点**：
- 需要维护 Grafana API 的代理
- 性能略低于直接访问

**实现方式**：
1. 在业务系统中创建 Grafana 代理 Controller
2. 拦截所有 Grafana API 请求
3. 根据用户权限决定是否允许访问
4. 转发请求到 Grafana，并注入权限过滤

---

### 方案 B：Grafana API Key + 动态用户管理

**架构**：
```
业务系统用户 → 生成 Grafana Session → 重定向到 Grafana
```

**优点**：
- 利用 Grafana 原生权限系统
- 用户体验好（直接访问 Grafana）

**缺点**：
- 需要同步用户到 Grafana
- 权限管理分散（业务系统 + Grafana）
- 多租户隔离复杂

---

### 方案 C：嵌入式 Grafana（iframe + 代理）

**架构**：
```
业务系统页面 → iframe 嵌入 Grafana → 代理层权限控制
```

**优点**：
- 用户体验统一（在业务系统中查看）
- 权限控制集中

**缺点**：
- iframe 安全限制
- 需要处理跨域问题

---

## 三、推荐方案详细设计（方案 A）

### 3.1 架构图

```
┌─────────────────────────────────────────────────────────┐
│                    业务系统用户                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  /admin-api/grafana/dashboards                   │  │
│  │  /admin-api/grafana/dashboards/{id}              │  │
│  │  /admin-api/grafana/datasources                  │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│              Spring Security 权限拦截                    │
│  ┌──────────────────────────────────────────────────┐  │
│  │  @PreAuthorize("hasPermission('grafana:view')")  │  │
│  │  @PreAuthorize("hasPermission('grafana:admin')") │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│            Grafana 代理 Controller                       │
│  ┌──────────────────────────────────────────────────┐  │
│  │  1. 获取当前用户权限                               │  │
│  │  2. 过滤 Dashboard 列表                           │  │
│  │  3. 注入租户/用户标签到查询                       │  │
│  │  4. 转发请求到 Grafana API                        │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│                    Grafana API                          │
│  http://grafana:3000/api/...                            │
└─────────────────────────────────────────────────────────┘
```

---

### 3.2 权限设计

#### 权限码定义

```java
public class GrafanaPermissionConstants {
    
    // 基础权限
    public static final String GRAFANA_VIEW = "grafana:view";           // 查看 Grafana
    public static final String GRAFANA_DASHBOARD_VIEW = "grafana:dashboard:view";  // 查看 Dashboard
    public static final String GRAFANA_DASHBOARD_CREATE = "grafana:dashboard:create";  // 创建 Dashboard
    public static final String GRAFANA_DASHBOARD_EDIT = "grafana:dashboard:edit";    // 编辑 Dashboard
    public static final String GRAFANA_DASHBOARD_DELETE = "grafana:dashboard:delete";  // 删除 Dashboard
    
    // 数据源权限
    public static final String GRAFANA_DATASOURCE_VIEW = "grafana:datasource:view";
    
    // 管理权限
    public static final String GRAFANA_ADMIN = "grafana:admin";  // 管理员权限
}
```

#### Dashboard 权限映射

```sql
-- Dashboard 权限表
CREATE TABLE grafana_dashboard_permission (
    id BIGINT PRIMARY KEY,
    dashboard_uid VARCHAR(255) NOT NULL,  -- Grafana Dashboard UID
    permission_code VARCHAR(255) NOT NULL,  -- 权限码
    role_id BIGINT,  -- 角色 ID（可选）
    user_id BIGINT,  -- 用户 ID（可选）
    tenant_id BIGINT,  -- 租户 ID（多租户隔离）
    created_time DATETIME
);
```

---

### 3.3 核心实现

#### 3.3.1 Grafana 代理 Controller

```java
@RestController
@RequestMapping("/admin-api/grafana")
@Tag(name = "管理后台 - Grafana 监控")
@PreAuthorize("hasPermission('grafana:view')")
public class GrafanaProxyController {

    @Autowired
    private GrafanaProxyService grafanaProxyService;
    
    @Autowired
    private SecurityFrameworkService securityFrameworkService;

    /**
     * 获取 Dashboard 列表（根据权限过滤）
     */
    @GetMapping("/dashboards")
    @Operation(summary = "获取 Dashboard 列表")
    @PreAuthorize("hasPermission('grafana:dashboard:view')")
    public CommonResult<List<GrafanaDashboardVO>> listDashboards() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        List<GrafanaDashboardVO> dashboards = grafanaProxyService.listDashboards(userId);
        return CommonResult.success(dashboards);
    }

    /**
     * 获取 Dashboard 详情
     */
    @GetMapping("/dashboards/{uid}")
    @Operation(summary = "获取 Dashboard 详情")
    @PreAuthorize("hasPermission('grafana:dashboard:view')")
    public CommonResult<GrafanaDashboardVO> getDashboard(@PathVariable String uid) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        // 权限校验：检查用户是否有权限查看该 Dashboard
        if (!grafanaProxyService.hasDashboardPermission(userId, uid)) {
            throw new ServiceException(GlobalErrorCodeConstants.FORBIDDEN.getCode(), "无权访问该 Dashboard");
        }
        GrafanaDashboardVO dashboard = grafanaProxyService.getDashboard(uid, userId);
        return CommonResult.success(dashboard);
    }

    /**
     * 获取 Grafana 访问 Token（用于前端直接访问 Grafana）
     */
    @PostMapping("/token")
    @Operation(summary = "获取 Grafana 访问 Token")
    public CommonResult<String> generateToken() {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        String token = grafanaProxyService.generateViewerToken(userId);
        return CommonResult.success(token);
    }
}
```

#### 3.3.2 Grafana 代理 Service

```java
@Service
@Slf4j
public class GrafanaProxyService {

    @Autowired
    private GrafanaApiClient grafanaApiClient;
    
    @Autowired
    private GrafanaDashboardPermissionService permissionService;
    
    @Autowired
    private SecurityFrameworkService securityFrameworkService;

    /**
     * 获取用户有权限的 Dashboard 列表
     */
    public List<GrafanaDashboardVO> listDashboards(Long userId) {
        // 1. 从 Grafana 获取所有 Dashboard
        List<GrafanaDashboardVO> allDashboards = grafanaApiClient.searchDashboards();
        
        // 2. 根据权限过滤
        return allDashboards.stream()
            .filter(dashboard -> hasDashboardPermission(userId, dashboard.getUid()))
            .collect(Collectors.toList());
    }

    /**
     * 检查用户是否有 Dashboard 权限
     */
    public boolean hasDashboardPermission(Long userId, String dashboardUid) {
        // 1. 管理员拥有所有权限
        if (securityFrameworkService.hasPermission(GrafanaPermissionConstants.GRAFANA_ADMIN)) {
            return true;
        }
        
        // 2. 检查 Dashboard 权限配置
        return permissionService.hasPermission(userId, dashboardUid);
    }

    /**
     * 获取 Dashboard（注入租户/用户标签过滤）
     */
    public GrafanaDashboardVO getDashboard(String uid, Long userId) {
        GrafanaDashboardVO dashboard = grafanaApiClient.getDashboard(uid);
        
        // 注入租户/用户标签到查询中（数据隔离）
        LoginUser loginUser = SecurityFrameworkUtils.getLoginUser();
        if (loginUser != null && loginUser.getTenantId() != null) {
            dashboard = injectTenantFilter(dashboard, loginUser.getTenantId());
        }
        
        return dashboard;
    }

    /**
     * 为 Dashboard 查询注入租户标签过滤
     */
    private GrafanaDashboardVO injectTenantFilter(GrafanaDashboardVO dashboard, Long tenantId) {
        // 修改 Dashboard 中所有 Panel 的查询，添加 tenant_id 标签过滤
        // 例如：{job="wmt-application"} -> {job="wmt-application", tenant_id="123"}
        // 实现细节：解析 Dashboard JSON，修改 targets 中的 expr
        return dashboard;
    }

    /**
     * 生成 Grafana Viewer Token（用于前端直接访问）
     */
    public String generateViewerToken(Long userId) {
        // 使用 Grafana API 创建临时 Token
        // 注意：需要配置 Grafana 允许 API Key 认证
        return grafanaApiClient.createApiKey("viewer", userId);
    }
}
```

#### 3.3.3 Dashboard 权限 Service

```java
@Service
@Slf4j
public class GrafanaDashboardPermissionService {

    @Autowired
    private GrafanaDashboardPermissionMapper permissionMapper;
    
    @Autowired
    private SecurityFrameworkService securityFrameworkService;

    /**
     * 检查用户是否有 Dashboard 权限
     */
    public boolean hasPermission(Long userId, String dashboardUid) {
        // 1. 管理员拥有所有权限
        if (securityFrameworkService.hasPermission(GrafanaPermissionConstants.GRAFANA_ADMIN)) {
            return true;
        }
        
        // 2. 检查用户直接权限
        if (permissionMapper.existsByUserIdAndDashboardUid(userId, dashboardUid)) {
            return true;
        }
        
        // 3. 检查角色权限
        // 获取用户角色，检查角色是否有权限
        // ...
        
        return false;
    }

    /**
     * 分配 Dashboard 权限给用户
     */
    public void assignPermission(Long userId, String dashboardUid, String permissionCode) {
        GrafanaDashboardPermissionDO permission = new GrafanaDashboardPermissionDO();
        permission.setUserId(userId);
        permission.setDashboardUid(dashboardUid);
        permission.setPermissionCode(permissionCode);
        permissionMapper.insert(permission);
    }
}
```

---

### 3.4 数据隔离实现

#### 3.4.1 指标标签注入

在 Prometheus 指标中自动添加租户/用户标签：

```java
// 在 WmtPrometheusGrafanaAutoConfiguration 中
@Bean
public MeterRegistryCustomizer<MeterRegistry> tenantTagCustomizer() {
    return registry -> {
        LoginUser loginUser = SecurityFrameworkUtils.getLoginUser();
        if (loginUser != null && loginUser.getTenantId() != null) {
            registry.config().commonTags(
                Tag.of("tenant_id", String.valueOf(loginUser.getTenantId())),
                Tag.of("user_id", String.valueOf(loginUser.getId()))
            );
        }
    };
}
```

#### 3.4.2 Dashboard 查询自动过滤

在 Grafana 代理层，自动为所有查询添加租户过滤：

```java
private GrafanaDashboardVO injectTenantFilter(GrafanaDashboardVO dashboard, Long tenantId) {
    // 解析 Dashboard JSON
    JSONObject dashboardJson = JSON.parseObject(dashboard.getJson());
    JSONArray panels = dashboardJson.getJSONArray("panels");
    
    for (int i = 0; i < panels.size(); i++) {
        JSONObject panel = panels.getJSONObject(i);
        JSONArray targets = panel.getJSONArray("targets");
        
        for (int j = 0; j < targets.size(); j++) {
            JSONObject target = targets.getJSONObject(j);
            String expr = target.getString("expr");
            
            // 为查询添加 tenant_id 标签过滤
            // 例如：{job="wmt-application"} -> {job="wmt-application", tenant_id="123"}
            String newExpr = addTenantFilter(expr, tenantId);
            target.put("expr", newExpr);
        }
    }
    
    dashboard.setJson(dashboardJson.toJSONString());
    return dashboard;
}

private String addTenantFilter(String promql, Long tenantId) {
    // 简单的正则替换（实际需要更复杂的 PromQL 解析）
    // 将 {job="xxx"} 替换为 {job="xxx", tenant_id="123"}
    return promql.replaceAll("\\{([^}]+)\\}",
        "{$1, tenant_id=\"" + tenantId + "\"}");
}
```

---

## 四、实施计划

### 阶段 1：基础代理功能（1-2 周）

- [ ] 创建 Grafana API Client
- [ ] 实现 Grafana 代理 Controller
- [ ] 实现基础权限拦截
- [ ] 测试 Dashboard 列表和详情接口

### 阶段 2：权限控制（1-2 周）

- [ ] 设计权限表结构
- [ ] 实现 Dashboard 权限 Service
- [ ] 实现权限分配接口
- [ ] 集成 Spring Security 权限校验

### 阶段 3：数据隔离（1 周）

- [ ] 实现指标标签自动注入
- [ ] 实现 Dashboard 查询自动过滤
- [ ] 测试多租户数据隔离

### 阶段 4：前端集成（1 周）

- [ ] 创建 Grafana 访问页面
- [ ] 实现权限控制 UI
- [ ] 实现 Dashboard 列表展示

---

## 五、配置示例

### 5.1 application.yml

```yaml
wmt:
  prometheus:
    grafana:
      # Grafana 配置
      base-url: http://grafana:3000
      admin-user: admin
      admin-password: admin123
      
      # 权限配置
      permission:
        enabled: true
        # 默认权限（所有用户都可以查看）
        default-dashboards:
          - "default-app"
        # 需要特定权限的 Dashboard
        restricted-dashboards:
          - uid: "business-metrics"
            permission: "grafana:dashboard:view:business"
```

### 5.2 权限配置表

```sql
-- 示例：为角色分配 Dashboard 权限
INSERT INTO grafana_dashboard_permission (dashboard_uid, permission_code, role_id) VALUES
('default-app', 'grafana:dashboard:view', 1),  -- 所有用户
('business-metrics', 'grafana:dashboard:view:business', 2);  -- 仅业务角色
```

---

## 六、API 设计

### 6.1 Dashboard 管理接口

```java
// 获取 Dashboard 列表
GET /admin-api/grafana/dashboards
Response: CommonResult<List<GrafanaDashboardVO>>

// 获取 Dashboard 详情
GET /admin-api/grafana/dashboards/{uid}
Response: CommonResult<GrafanaDashboardVO>

// 创建 Dashboard
POST /admin-api/grafana/dashboards
@PreAuthorize("hasPermission('grafana:dashboard:create')")

// 更新 Dashboard
PUT /admin-api/grafana/dashboards/{uid}
@PreAuthorize("hasPermission('grafana:dashboard:edit')")

// 删除 Dashboard
DELETE /admin-api/grafana/dashboards/{uid}
@PreAuthorize("hasPermission('grafana:dashboard:delete')")
```

### 6.2 权限管理接口

```java
// 分配 Dashboard 权限
POST /admin-api/grafana/dashboards/{uid}/permissions
Body: {
    "userId": 123,
    "permissionCode": "grafana:dashboard:view"
}

// 获取 Dashboard 权限列表
GET /admin-api/grafana/dashboards/{uid}/permissions

// 移除 Dashboard 权限
DELETE /admin-api/grafana/dashboards/{uid}/permissions/{permissionId}
```

---

## 七、注意事项

### 7.1 安全性

1. **Token 安全**：
   - Grafana API Key 需要定期轮换
   - 使用短期 Token（如 1 小时）

2. **权限校验**：
   - 所有接口都需要权限校验
   - 防止越权访问

3. **数据隔离**：
   - 确保多租户数据完全隔离
   - 防止 SQL 注入（PromQL 注入）

### 7.2 性能优化

1. **缓存 Dashboard 列表**：
   - 使用 Redis 缓存用户有权限的 Dashboard 列表
   - 缓存时间：5-10 分钟

2. **批量权限检查**：
   - 避免逐个检查 Dashboard 权限
   - 使用批量查询优化

### 7.3 扩展性

1. **支持自定义 Dashboard**：
   - 允许用户创建自己的 Dashboard
   - 支持 Dashboard 模板

2. **支持告警规则权限**：
   - 不同用户查看不同的告警规则
   - 告警通知权限控制

---

## 八、后续优化方向

1. **Dashboard 模板系统**：
   - 预定义常用 Dashboard 模板
   - 支持一键创建 Dashboard

2. **指标权限控制**：
   - 细粒度控制用户可查看的指标
   - 支持指标级别的权限

3. **审计日志**：
   - 记录用户访问 Dashboard 的日志
   - 支持审计查询

4. **性能监控**：
   - 监控 Grafana 代理性能
   - 优化慢查询

