-- ============================================
-- Grafana 代码质量项目排行SQL
-- 参考用户代码贡献排行的逻辑，查询租户中的项目所对应的代码质量数据
-- ============================================

SELECT 
  COALESCE(o.name, '未分配租户') AS org_name,
  st.project_key AS project_key,
  st.task_name AS task_name,
  st.language AS language,
  COUNT(DISTINCT sh.id) AS scan_count,
  MAX(sh.scan_time) AS latest_scan_time,
  ROUND(AVG(sh.score), 2) AS avg_quality_score,
  MAX(sh.score) AS max_quality_score,
  MIN(sh.score) AS min_quality_score,
  SUM(sh.bug) AS total_bug_count,
  SUM(sh.vulnerability) AS total_vulnerability_count,
  SUM(sh.code_smell) AS total_code_smell_count,
  ROUND(AVG(sh.coverage), 2) AS avg_coverage,
  ROUND(AVG(sh.repetition), 2) AS avg_duplication,
  COUNT(CASE WHEN sh.result = 1 THEN 1 END) AS quality_gate_pass_count,
  COUNT(CASE WHEN sh.result = 0 THEN 1 END) AS quality_gate_fail_count,
  ROUND(COUNT(CASE WHEN sh.result = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS quality_gate_pass_rate
FROM yanlian_devops_code_inspect.scan_history sh
LEFT JOIN yanlian_devops_code_inspect.scan_task st
  ON sh.scan_task_id = st.id
  AND st.del_flag = 0
LEFT JOIN yanlian_devops_code_inspect.code_repository cr
  ON st.id = cr.scan_task_id
  AND cr.del_flag = 0
LEFT JOIN yanlian_devops_development.sub_system_component ssc
  ON ssc.component = 'GITLAB'
  AND ssc.del_flag = 0
  AND ssc.component_key = CAST(st.project_id AS CHAR)
LEFT JOIN yanlian_devops_development.devops_system ds
  ON ssc.system_id = ds.id
LEFT JOIN yanlian_app_management.sys_organization o
  ON ds.tenant_id = o.id
  AND o.is_deleted = 0
WHERE sh.del_flag = 0
  AND sh.scan_time IS NOT NULL
  AND YEAR(sh.scan_time) IN (${year:csv})
  AND DATE_FORMAT(sh.scan_time, '%m') IN (${months:csv})
  AND (${tenantId:csv} = '0' OR FIND_IN_SET(ds.tenant_id, '${tenantId:csv}') > 0)
GROUP BY ds.tenant_id, o.name, st.project_key, st.task_name, st.language
ORDER BY avg_quality_score DESC;

-- ============================================
-- 查询租户下各项目的代码质量排行（按项目维度，显示最新扫描质量数据）
-- ============================================
SELECT 
  COALESCE(o.name, '未分配租户') AS org_name,
  st.project_key AS project_key,
  st.task_name AS task_name,
  st.language AS language,
  sh.repository_url AS repository_url,
  sh.branch AS branch,
  sh.scan_time AS latest_scan_time,
  sh.score AS quality_score,
  sh.bug AS bug_count,
  sh.vulnerability AS vulnerability_count,
  sh.code_smell AS code_smell_count,
  sh.coverage AS coverage,
  sh.repetition AS duplication,
  CASE WHEN sh.result = 1 THEN '通过' ELSE '未通过' END AS quality_gate_status,
  sh.quality_gate_id AS quality_gate_id,
  sh.scan_plan_name AS scan_plan_name
FROM yanlian_devops_code_inspect.scan_history sh
INNER JOIN (
    -- 获取每个扫描任务的最新扫描记录
    SELECT scan_task_id, MAX(scan_time) AS max_scan_time
    FROM yanlian_devops_code_inspect.scan_history
    WHERE del_flag = 0
    GROUP BY scan_task_id
) latest ON sh.scan_task_id = latest.scan_task_id 
    AND sh.scan_time = latest.max_scan_time
LEFT JOIN yanlian_devops_code_inspect.scan_task st
  ON sh.scan_task_id = st.id
  AND st.del_flag = 0
LEFT JOIN yanlian_devops_code_inspect.code_repository cr
  ON st.id = cr.scan_task_id
  AND cr.del_flag = 0
LEFT JOIN yanlian_devops_development.sub_system_component ssc
  ON ssc.component = 'GITLAB'
  AND ssc.del_flag = 0
  AND ssc.component_key = CAST(st.project_id AS CHAR)
LEFT JOIN yanlian_devops_development.devops_system ds
  ON ssc.system_id = ds.id
LEFT JOIN yanlian_app_management.sys_organization o
  ON ds.tenant_id = o.id
  AND o.is_deleted = 0
WHERE sh.del_flag = 0
  AND sh.scan_time IS NOT NULL
  AND YEAR(sh.scan_time) IN (${year:csv})
  AND DATE_FORMAT(sh.scan_time, '%m') IN (${months:csv})
  AND (${tenantId:csv} = '0' OR FIND_IN_SET(ds.tenant_id, '${tenantId:csv}') > 0)
ORDER BY sh.score DESC;

-- ============================================
-- 查询租户下各项目的代码质量排行（包含问题统计，按严重程度分类）
-- ============================================
SELECT 
  COALESCE(o.name, '未分配租户') AS org_name,
  st.project_key AS project_key,
  st.task_name AS task_name,
  st.language AS language,
  sh.repository_url AS repository_url,
  sh.branch AS branch,
  sh.scan_time AS latest_scan_time,
  sh.score AS quality_score,
  sh.bug AS bug_count,
  sh.vulnerability AS vulnerability_count,
  sh.code_smell AS code_smell_count,
  COALESCE(issue_stats.blocker_count, 0) AS blocker_count,
  COALESCE(issue_stats.critical_count, 0) AS critical_count,
  COALESCE(issue_stats.major_count, 0) AS major_count,
  COALESCE(issue_stats.minor_count, 0) AS minor_count,
  sh.coverage AS coverage,
  sh.repetition AS duplication,
  CASE WHEN sh.result = 1 THEN '通过' ELSE '未通过' END AS quality_gate_status
FROM yanlian_devops_code_inspect.scan_history sh
INNER JOIN (
    -- 获取每个扫描任务的最新扫描记录
    SELECT scan_task_id, MAX(scan_time) AS max_scan_time
    FROM yanlian_devops_code_inspect.scan_history
    WHERE del_flag = 0
    GROUP BY scan_task_id
) latest ON sh.scan_task_id = latest.scan_task_id 
    AND sh.scan_time = latest.max_scan_time
LEFT JOIN (
    -- 统计每个扫描历史的问题数量（按严重程度）
    SELECT 
        history_id,
        COUNT(CASE WHEN severity = 'BLOCKER' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS blocker_count,
        COUNT(CASE WHEN severity = 'CRITICAL' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS critical_count,
        COUNT(CASE WHEN severity = 'MAJOR' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS major_count,
        COUNT(CASE WHEN severity = 'MINOR' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS minor_count
    FROM yanlian_devops_code_inspect.scan_issue
    GROUP BY history_id
) issue_stats ON sh.id = issue_stats.history_id
LEFT JOIN yanlian_devops_code_inspect.scan_task st
  ON sh.scan_task_id = st.id
  AND st.del_flag = 0
LEFT JOIN yanlian_devops_code_inspect.code_repository cr
  ON st.id = cr.scan_task_id
  AND cr.del_flag = 0
LEFT JOIN yanlian_devops_development.sub_system_component ssc
  ON ssc.component = 'GITLAB'
  AND ssc.del_flag = 0
  AND ssc.component_key = CAST(st.project_id AS CHAR)
LEFT JOIN yanlian_devops_development.devops_system ds
  ON ssc.system_id = ds.id
LEFT JOIN yanlian_app_management.sys_organization o
  ON ds.tenant_id = o.id
  AND o.is_deleted = 0
WHERE sh.del_flag = 0
  AND sh.scan_time IS NOT NULL
  AND YEAR(sh.scan_time) IN (${year:csv})
  AND DATE_FORMAT(sh.scan_time, '%m') IN (${months:csv})
  AND (${tenantId:csv} = '0' OR FIND_IN_SET(ds.tenant_id, '${tenantId:csv}') > 0)
ORDER BY sh.score DESC;



-- 查询某个租户（部门）下所有子系统/项目的最新代码质量指标
SELECT
  o.id                      AS tenant_id,
  o.name                    AS tenant_name,
  ds.id                     AS system_id,
  ds.sys_desc_cn                   AS system_name,
  st.id                     AS scan_task_id,
  st.project_key,
  st.task_name,
  st.language,
  cr.repository_url,
  sh.scan_time              AS latest_scan_time,
  sh.score                  AS quality_score,
  sh.bug                    AS bug_count,
  sh.vulnerability          AS vulnerability_count,
  sh.code_smell             AS code_smell_count,
  sh.coverage               AS coverage,
  sh.repetition             AS duplication,
  sh.result                 AS quality_gate_status,   -- 0 未通过, 1 通过
  sh.quality_gate_id,
  sh.scan_plan_id,
  sh.scan_plan_name
FROM yanlian_devops_code_inspect.scan_task st
JOIN yanlian_devops_code_inspect.code_repository cr
  ON cr.scan_task_id = st.id AND cr.del_flag = 0
JOIN yanlian_devops_development.sub_system_component ssc
  ON ssc.component = 'GITLAB'
 AND ssc.del_flag = 0
 AND ssc.component_key = CAST(st.project_id AS CHAR)   -- 用 project_id 对应 GitLab project_id
JOIN yanlian_devops_development.devops_system ds
  ON ds.id = ssc.system_id
JOIN yanlian_app_management.sys_organization o
  ON o.id = ds.tenant_id AND o.is_deleted = 0
JOIN yanlian_devops_code_inspect.scan_history sh
  ON sh.scan_task_id = st.id
 AND sh.del_flag = 0
-- 取每个任务的最新一次扫描
AND sh.scan_time = (
    SELECT MAX(sh2.scan_time)
    FROM yanlian_devops_code_inspect.scan_history sh2
    WHERE sh2.scan_task_id = st.id
      AND sh2.del_flag = 0
)
WHERE st.del_flag = 0        -- 这里替换成目标部门/租户ID，Grafana 可用变量
  -- 可选：限制时间范围
  AND sh.scan_time IS NOT NULL
ORDER BY sh.scan_time DESC;