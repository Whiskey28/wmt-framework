下面我按“一个可视化一段 SQL”的方式给你，你在 Grafana 里新建 Panel 时：

- `Data source` 选 MySQL；
- `Query` 粘贴对应 SQL；
- Panel 类型按我写的推荐类型设置即可。

年份我先写成 `2025`，你可以改成变量或其他年份。

---

### 1. DevOps 项目覆盖率（Stat）

```sql
SELECT ROUND( IFNULL(devops_cnt,0) / NULLIF(total_cnt,0) * 100, 1) AS coverage
FROM (
  -- 全部 DevOps 项目数
  SELECT COUNT(DISTINCT p_all.id) AS total_cnt
  FROM yanlian_devops_development.devops_project p_all
) t_all
CROSS JOIN (
  -- 本年度有使用痕迹的项目数（特性 / 流水线 / 提交）
  SELECT COUNT(DISTINCT p_use.id) AS devops_cnt
  FROM yanlian_devops_development.devops_project p_use
  LEFT JOIN yanlian_devops_development.devops_feature f 
         ON f.feature_project_id = p_use.id 
        AND YEAR(f.create_time) = 2025
  LEFT JOIN yanlian_dop_pipeline.devops_job_build_info b 
         ON b.project_id = p_use.id 
        AND YEAR(b.start_time) = 2025
  LEFT JOIN yanlian_devops_scm.project_commit_relation c 
         ON c.project_id = p_use.id 
        AND YEAR(c.create_time) = 2025
  WHERE f.id IS NOT NULL 
     OR b.id IS NOT NULL 
     OR c.id IS NOT NULL
) t_use;
```

---

### 2. DevOps 部门覆盖率（Stat）

```sql
SELECT ROUND( IFNULL(use_cnt,0) / NULLIF(total_cnt,0) * 100, 1) AS coverage
FROM (
  -- 全部在职部门
  SELECT COUNT(DISTINCT o.id) AS total_cnt
  FROM yanlian_app_management.sys_organization o
  WHERE o.is_deleted = 0
) t_all
CROSS JOIN (
  -- 有项目/系统接入 DevOps 的部门
  SELECT COUNT(DISTINCT p.tenant_id) AS use_cnt
  FROM yanlian_devops_development.devops_project p
  WHERE p.tenant_id IS NOT NULL
) t_use;
```

---

### 3. 年度 DevOps 活跃用户占比（Stat）

```sql
WITH active_users AS (
  SELECT DISTINCT f.create_by AS user_id
  FROM yanlian_devops_development.devops_feature f
  WHERE YEAR(f.create_time) = 2025

  UNION

  SELECT DISTINCT b.trigger_user AS user_id
  FROM yanlian_dop_pipeline.devops_job_build_info b
  WHERE YEAR(b.start_time) = 2025

  UNION

  SELECT DISTINCT d.user_id
  FROM yanlian_devops_knowledge.knowledge_document d
  WHERE YEAR(d.create_time) = 2025
),
all_users AS (
  SELECT COUNT(DISTINCT u.id) AS cnt
  FROM yanlian_app_management.sys_user u
  WHERE u.del_flag = 0
)
SELECT ROUND(
  (SELECT COUNT(*) FROM active_users) 
  / NULLIF((SELECT cnt FROM all_users),0) * 100
, 1) AS active_ratio;
```

---

### 4. 平台活跃天数占比（Stat 或 Heatmap 另做查询）

```sql
WITH days AS (
  SELECT DATE(f.create_time) AS d
  FROM yanlian_devops_development.devops_feature f
  WHERE YEAR(f.create_time) = 2025

  UNION

  SELECT DATE(b.start_time) AS d
  FROM yanlian_dop_pipeline.devops_job_build_info b
  WHERE YEAR(b.start_time) = 2025

  UNION

  SELECT DATE(c.commit_time) AS d
  FROM yanlian_devops_scm.commit_info c
  WHERE YEAR(c.commit_time) = 2025
)
SELECT ROUND(COUNT(DISTINCT d) / 365 * 100, 1) AS active_day_ratio
FROM days;
```

---

### 5. 代码扫描覆盖率（Stat）

```sql
SELECT ROUND( IFNULL(scan_cnt,0) / NULLIF(repo_cnt,0) * 100, 1) AS coverage
FROM (
  SELECT COUNT(DISTINCT r.id) AS repo_cnt
  FROM yanlian_devops_code_inspect.code_repository r
) t_all
CROSS JOIN (
  SELECT COUNT(DISTINCT h.repository_id) AS scan_cnt
  FROM yanlian_devops_code_inspect.scan_history h
  WHERE YEAR(h.scan_time) = 2025
) t_scan;
```

---

### 6. 可信扫描覆盖应用占比（Stat）

```sql
SELECT ROUND( IFNULL(scan_app_cnt,0) / NULLIF(app_cnt,0) * 100, 1) AS coverage
FROM (
  SELECT COUNT(DISTINCT a.id) AS app_cnt
  FROM yanlian_devops_trustworthy.devops_app a
) t_all
CROSS JOIN (
  SELECT COUNT(DISTINCT h.app_id) AS scan_app_cnt
  FROM yanlian_devops_trustworthy.devops_app_scan_history h
  WHERE YEAR(h.scan_time) = 2025
) t_scan;
```

---

### 7. 质量红线通过率（Stat）

```sql
SELECT ROUND(
  SUM(CASE WHEN h.quality_gate_status = 'PASS' THEN 1 ELSE 0 END)
  / NULLIF(COUNT(*),0) * 100
, 1) AS pass_ratio
FROM yanlian_devops_code_inspect.scan_history h
WHERE h.quality_gate_id IS NOT NULL
  AND YEAR(h.scan_time) = 2025;
```

---

### 8. 高危问题处理率（Stat）

```sql
SELECT ROUND( IFNULL(fixed_cnt,0) / NULLIF(new_cnt,0) * 100, 1) AS fix_ratio
FROM (
  SELECT COUNT(*) AS new_cnt
  FROM yanlian_devops_trustworthy.devops_leak l
  WHERE l.severity IN ('HIGH','CRITICAL')
    AND YEAR(l.create_time) = 2025
) t_new
CROSS JOIN (
  SELECT COUNT(*) AS fixed_cnt
  FROM yanlian_devops_trustworthy.devops_leak l
  WHERE l.severity IN ('HIGH','CRITICAL')
    AND l.status IN ('RESOLVED','CLOSED')
    AND YEAR(l.resolved_time) = 2025
) t_fixed;
```

---

### 9. 部署频率趋势（今年 vs 去年）（Time series）

**查询 1：今年**

```sql
SELECT 
  DATE_SUB(DATE(b.start_time), INTERVAL (WEEKDAY(b.start_time)) DAY) AS time,
  COUNT(*) AS deploy_cnt
FROM yanlian_dop_pipeline.devops_build_deploy_rel b
WHERE b.status = 'SUCCESS'
  AND YEAR(b.start_time) = 2025
GROUP BY time
ORDER BY time;
```

**查询 2：去年**

```sql
SELECT 
  DATE_SUB(DATE(b.start_time), INTERVAL (WEEKDAY(b.start_time)) DAY) AS time,
  COUNT(*) AS deploy_cnt
FROM yanlian_dop_pipeline.devops_build_deploy_rel b
WHERE b.status = 'SUCCESS'
  AND YEAR(b.start_time) = 2024
GROUP BY time
ORDER BY time;
```

（在同一个 Time series 面板里配置两个查询，分别 alias 成“本年”“去年”）

---

### 10. 代码扫描覆盖率（月度）（Time series）

```sql
WITH repo_cnt AS (
  SELECT COUNT(DISTINCT r.id) AS c 
  FROM yanlian_devops_code_inspect.code_repository r
)
SELECT 
  DATE_FORMAT(h.scan_time, '%Y-%m-01') AS time,
  ROUND(
    COUNT(DISTINCT h.repository_id) 
    / NULLIF((SELECT c FROM repo_cnt),0) * 100
  , 1) AS coverage
FROM yanlian_devops_code_inspect.scan_history h
WHERE YEAR(h.scan_time) = 2025
GROUP BY time
ORDER BY time;
```

---

### 11. 可信扫描覆盖应用占比（按业务线）（Bar chart）

```sql
SELECT 
  o.name AS org_name,
  ROUND( 
    COUNT(DISTINCT h.app_id) 
    / NULLIF(COUNT(DISTINCT a.id),0) * 100
  , 1) AS coverage
FROM yanlian_devops_trustworthy.devops_app a
LEFT JOIN yanlian_devops_trustworthy.devops_app_scan_history h 
       ON h.app_id = a.id 
      AND YEAR(h.scan_time) = 2025
LEFT JOIN yanlian_app_management.sys_organization o 
       ON o.id = a.tenant_id
WHERE o.is_deleted = 0
GROUP BY o.name
ORDER BY coverage DESC
LIMIT 10;
```

---

### 12. 高危问题处理及时性分布（Bar chart）

```sql
SELECT bucket AS time_bucket, COUNT(*) AS cnt
FROM (
  SELECT CASE 
           WHEN TIMESTAMPDIFF(DAY, l.create_time, l.resolved_time) <= 7 THEN '7日内'
           WHEN TIMESTAMPDIFF(DAY, l.create_time, l.resolved_time) <= 30 THEN '30日内'
           ELSE '超过30日' 
         END AS bucket
  FROM yanlian_devops_trustworthy.devops_leak l
  WHERE l.severity IN ('HIGH','CRITICAL')
    AND l.status IN ('RESOLVED','CLOSED')
    AND YEAR(l.create_time) = 2025
) t
GROUP BY bucket
ORDER BY CASE bucket 
           WHEN '7日内' THEN 1 
           WHEN '30日内' THEN 2 
           ELSE 3 
         END;
```

---

### 13. 有知识空间的项目占比（Stat）

```sql
SELECT ROUND( IFNULL(with_space,0) / NULLIF(total_proj,0) * 100, 1) AS ratio
FROM (
  SELECT COUNT(DISTINCT p.id) AS total_proj
  FROM yanlian_devops_development.devops_project p
) t_all
CROSS JOIN (
  SELECT COUNT(DISTINCT s.project_id) AS with_space
  FROM yanlian_devops_knowledge.knowledge_space s
  WHERE s.project_id IS NOT NULL
) t_space;
```

---

### 14. 知识参与度（有评论/收藏的文档占比）（Stat）

```sql
SELECT ROUND( IFNULL(active_doc,0) / NULLIF(total_doc,0) * 100, 1) AS ratio
FROM (
  SELECT COUNT(DISTINCT d.id) AS total_doc
  FROM yanlian_devops_knowledge.knowledge_document d
) t_all
CROSS JOIN (
  SELECT COUNT(DISTINCT d.id) AS active_doc
  FROM yanlian_devops_knowledge.knowledge_document d
  LEFT JOIN yanlian_devops_knowledge.knowledge_comment c 
         ON c.document_id = d.id
  LEFT JOIN yanlian_devops_knowledge.knowledge_user_collect uc 
         ON uc.document_id = d.id
  WHERE c.ID IS NOT NULL OR uc.ID IS NOT NULL
) t_active;
```

---

### 15. 安全漏洞风险 Top3 应用（Table）

```sql
SELECT 
  a.app_name,
  o.name AS org_name,
  COUNT(*) AS open_high_leak_cnt,
  ROUND(
    AVG(
      TIMESTAMPDIFF(
        DAY, 
        l.create_time, 
        IFNULL(l.resolved_time, NOW())
      )
    )
  , 1) AS avg_days_to_fix
FROM yanlian_devops_trustworthy.devops_leak l
JOIN yanlian_devops_trustworthy.devops_app a 
  ON a.id = l.app_id
LEFT JOIN yanlian_app_management.sys_organization o 
  ON o.id = a.tenant_id
WHERE l.severity IN ('HIGH','CRITICAL')
  AND l.status NOT IN ('RESOLVED','CLOSED')
  AND YEAR(l.create_time) = 2025
GROUP BY a.id, a.app_name, o.name
ORDER BY open_high_leak_cnt DESC, avg_days_to_fix DESC
LIMIT 3;
```

---

如果你在某个面板的表名/字段名上遇到不对应，可以把实际表结构片段贴给我，我帮你把对应 SQL 调整到可以直接跑通的程度。