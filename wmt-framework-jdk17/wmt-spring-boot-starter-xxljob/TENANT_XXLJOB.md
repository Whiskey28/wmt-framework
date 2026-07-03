# XXL-Job 多租户任务规范

## 概述

业务系统从 Quartz `JobHandler` 迁移至 `@XxlJob` 后，多租户仍可通过 `wmt-spring-boot-starter-biz-tenant` 提供的 `@TenantJob` 注解实现「按租户逐个执行」。

## 用法

```java
@Component
public class DemoJob {

    @XxlJob("demoJob")
    @TenantJob
    public void execute() {
        String param = XxlJobHelper.getJobParam();
        XxlJobHelper.log("当前租户：{}", TenantContextHolder.getTenantId());
        // 业务逻辑（已在 TenantUtils.execute 上下文中）
    }
}
```

## 注意事项

1. **幂等性**：某租户失败重试时，已成功租户可能再次执行，任务逻辑须幂等。
2. **与 `@TenantIgnore` 互斥**：全局任务（如日志清理）使用 `@TenantIgnore`，不要叠加 `@TenantJob`。
3. **日志**：调度日志使用 `XxlJobHelper.log()`，便于在 XXL-Job Admin 查看。
4. **Admin 配置**：JobHandler 名称须与 `@XxlJob` 值完全一致（区分大小写）。

## 与 Quartz 差异

| 项 | Quartz JobHandler | XXL-Job |
|---|---|---|
| 任务注册 | infra 后台 / DB | XXL-Job Admin |
| 参数 | `execute(String param)` | `XxlJobHelper.getJobParam()` |
| 返回值 | `String` | `void`（日志用 XxlJobHelper） |
| 多租户 | `@TenantJob` on `execute` | `@TenantJob` on `@XxlJob` 方法 |
