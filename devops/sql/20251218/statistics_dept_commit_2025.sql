-- ============================================
-- 2025年度各部门代码提交情况统计SQL
-- ============================================
-- 说明：
-- 1. 统计2025年1月1日至12月31日的代码提交情况
-- 2. 按部门维度进行统计
-- 3. 包含提交次数、新增行数、删除行数、总变更行数等指标
-- ============================================

-- ============================================
-- 方案一：基础统计（推荐使用）
-- ============================================
-- 统计各部门的提交次数、代码行数等基础指标
SELECT 
    COALESCE(d.dept_name, '未分配部门') AS dept_name,
    COUNT(DISTINCT c.id) AS commit_count,                    -- 提交次数
    COUNT(DISTINCT c.gitlab_user_id) AS committer_count,      -- 提交人数
    SUM(c.additions) AS total_additions,                      -- 总新增行数
    SUM(c.deletions) AS total_deletions,                      -- 总删除行数
    SUM(c.total) AS total_changes,                            -- 总变更行数
    ROUND(AVG(c.total), 2) AS avg_changes_per_commit,        -- 平均每次提交变更行数
    ROUND(SUM(c.additions) / NULLIF(COUNT(DISTINCT c.id), 0), 2) AS avg_additions_per_commit,  -- 平均每次提交新增行数
    ROUND(SUM(c.deletions) / NULLIF(COUNT(DISTINCT c.id), 0), 2) AS avg_deletions_per_commit    -- 平均每次提交删除行数
FROM 
    yanlian_devops_scm.commit_info c
    LEFT JOIN yanlian_devops_scm.amp_gitlab_user_relation agur 
        ON c.gitlab_user_id = agur.gitlab_user_id 
        AND c.server_id = agur.server_id
    LEFT JOIN yanlian_app_management.sys_user_department sud 
        ON agur.amp_user_id = sud.user_id
    LEFT JOIN yanlian_app_management.sys_department d 
        ON sud.dept_id = d.id 
        AND sud.organ_id = d.organization_id
WHERE 
    c.create_time >= '2025-01-01 00:00:00'
    AND c.create_time < '2026-01-01 00:00:00'
    AND (d.is_deleted = 0 OR d.is_deleted IS NULL)
GROUP BY 
    d.id, d.dept_name
ORDER BY 
    commit_count DESC, total_changes DESC;


-- ============================================
-- 方案二：按月统计各部门提交情况
-- ============================================
-- 按月份和部门进行统计，便于查看趋势
SELECT 
    DATE_FORMAT(c.create_time, '%Y-%m') AS month,
    COALESCE(d.dept_name, '未分配部门') AS dept_name,
    COUNT(DISTINCT c.id) AS commit_count,
    COUNT(DISTINCT c.gitlab_user_id) AS committer_count,
    SUM(c.additions) AS total_additions,
    SUM(c.deletions) AS total_deletions,
    SUM(c.total) AS total_changes
FROM 
    yanlian_devops_scm.commit_info c
    LEFT JOIN yanlian_devops_scm.amp_gitlab_user_relation agur 
        ON c.gitlab_user_id = agur.gitlab_user_id 
        AND c.server_id = agur.server_id
    LEFT JOIN yanlian_app_management.sys_user_department sud 
        ON agur.amp_user_id = sud.user_id
    LEFT JOIN yanlian_app_management.sys_department d 
        ON sud.dept_id = d.id 
        AND sud.organ_id = d.organization_id
WHERE 
    c.create_time >= '2025-01-01 00:00:00'
    AND c.create_time < '2026-01-01 00:00:00'
    AND (d.is_deleted = 0 OR d.is_deleted IS NULL)
GROUP BY 
    DATE_FORMAT(c.create_time, '%Y-%m'), d.id, d.dept_name
ORDER BY 
    month DESC, commit_count DESC;


-- ============================================
-- 方案三：详细统计（包含用户信息）
-- ============================================
-- 统计各部门下每个用户的提交情况
SELECT 
    COALESCE(d.dept_name, '未分配部门') AS dept_name,
    u.name AS user_name,
    u.username AS username,
    COUNT(DISTINCT c.id) AS commit_count,
    SUM(c.additions) AS total_additions,
    SUM(c.deletions) AS total_deletions,
    SUM(c.total) AS total_changes,
    MIN(c.create_time) AS first_commit_time,
    MAX(c.create_time) AS last_commit_time
FROM 
    yanlian_devops_scm.commit_info c
    LEFT JOIN yanlian_devops_scm.amp_gitlab_user_relation agur 
        ON c.gitlab_user_id = agur.gitlab_user_id 
        AND c.server_id = agur.server_id
    LEFT JOIN yanlian_app_management.sys_user u 
        ON agur.amp_user_id = u.id
    LEFT JOIN yanlian_app_management.sys_user_department sud 
        ON u.id = sud.user_id
    LEFT JOIN yanlian_app_management.sys_department d 
        ON sud.dept_id = d.id 
        AND sud.organ_id = d.organization_id
WHERE 
    c.create_time >= '2025-01-01 00:00:00'
    AND c.create_time < '2026-01-01 00:00:00'
    AND (u.is_deleted = 0 OR u.is_deleted IS NULL)
    AND (d.is_deleted = 0 OR d.is_deleted IS NULL)
GROUP BY 
    d.id, d.dept_name, u.id, u.name, u.username
ORDER BY 
    d.dept_name, commit_count DESC;


-- ============================================
-- 方案四：按季度统计
-- ============================================
-- 按季度统计各部门提交情况
SELECT 
    CONCAT(YEAR(c.create_time), '-Q', QUARTER(c.create_time)) AS quarter,
    COALESCE(d.dept_name, '未分配部门') AS dept_name,
    COUNT(DISTINCT c.id) AS commit_count,
    COUNT(DISTINCT c.gitlab_user_id) AS committer_count,
    SUM(c.additions) AS total_additions,
    SUM(c.deletions) AS total_deletions,
    SUM(c.total) AS total_changes
FROM 
    yanlian_devops_scm.commit_info c
    LEFT JOIN yanlian_devops_scm.amp_gitlab_user_relation agur 
        ON c.gitlab_user_id = agur.gitlab_user_id 
        AND c.server_id = agur.server_id
    LEFT JOIN yanlian_app_management.sys_user_department sud 
        ON agur.amp_user_id = sud.user_id
    LEFT JOIN yanlian_app_management.sys_department d 
        ON sud.dept_id = d.id 
        AND sud.organ_id = d.organization_id
WHERE 
    c.create_time >= '2025-01-01 00:00:00'
    AND c.create_time < '2026-01-01 00:00:00'
    AND (d.is_deleted = 0 OR d.is_deleted IS NULL)
GROUP BY 
    QUARTER(c.create_time), d.id, d.dept_name
ORDER BY 
    quarter DESC, commit_count DESC;


-- ============================================
-- 方案五：Top N 统计
-- ============================================
-- 统计提交量最多的前N个部门
SELECT 
    COALESCE(d.dept_name, '未分配部门') AS dept_name,
    COUNT(DISTINCT c.id) AS commit_count,
    SUM(c.total) AS total_changes,
    ROUND(SUM(c.total) * 100.0 / (SELECT SUM(total) FROM yanlian_devops_scm.commit_info WHERE create_time >= '2025-01-01' AND create_time < '2026-01-01'), 2) AS percentage
FROM 
    yanlian_devops_scm.commit_info c
    LEFT JOIN yanlian_devops_scm.amp_gitlab_user_relation agur 
        ON c.gitlab_user_id = agur.gitlab_user_id 
        AND c.server_id = agur.server_id
    LEFT JOIN yanlian_app_management.sys_user_department sud 
        ON agur.amp_user_id = sud.user_id
    LEFT JOIN yanlian_app_management.sys_department d 
        ON sud.dept_id = d.id 
        AND sud.organ_id = d.organization_id
WHERE 
    c.create_time >= '2025-01-01 00:00:00'
    AND c.create_time < '2026-01-01 00:00:00'
    AND (d.is_deleted = 0 OR d.is_deleted IS NULL)
GROUP BY 
    d.id, d.dept_name
ORDER BY 
    commit_count DESC
LIMIT 10;  -- 修改LIMIT值可以调整显示前N个部门


-- ============================================
-- 方案六：包含未匹配用户的统计
-- ============================================
-- 统计包含未匹配到GitLab用户的提交情况
SELECT 
    CASE 
        WHEN agur.amp_user_id IS NULL THEN '未匹配用户'
        WHEN d.dept_name IS NULL THEN '未分配部门'
        ELSE d.dept_name
    END AS dept_name,
    COUNT(DISTINCT c.id) AS commit_count,
    COUNT(DISTINCT c.gitlab_user_id) AS committer_count,
    SUM(c.additions) AS total_additions,
    SUM(c.deletions) AS total_deletions,
    SUM(c.total) AS total_changes
FROM 
    yanlian_devops_scm.commit_info c
    LEFT JOIN yanlian_devops_scm.amp_gitlab_user_relation agur 
        ON c.gitlab_user_id = agur.gitlab_user_id 
        AND c.server_id = agur.server_id
    LEFT JOIN yanlian_app_management.sys_user_department sud 
        ON agur.amp_user_id = sud.user_id
    LEFT JOIN yanlian_app_management.sys_department d 
        ON sud.dept_id = d.id 
        AND sud.organ_id = d.organization_id
WHERE 
    c.create_time >= '2025-01-01 00:00:00'
    AND c.create_time < '2026-01-01 00:00:00'
    AND (d.is_deleted = 0 OR d.is_deleted IS NULL)
GROUP BY 
    CASE 
        WHEN agur.amp_user_id IS NULL THEN '未匹配用户'
        WHEN d.dept_name IS NULL THEN '未分配部门'
        ELSE d.dept_name
    END
ORDER BY 
    commit_count DESC;


-- ============================================
-- 使用说明
-- ============================================
-- 1. 如果所有表在同一个数据库中，可以去掉数据库前缀（如 yanlian_devops_scm.）
-- 2. 如果用户可能属于多个部门，方案一可能会重复统计，建议使用方案三查看详细情况
-- 3. 可以根据实际需求调整时间范围
-- 4. 如果 commit_info 表中有 server_id 字段，建议在关联时也加上 server_id 条件
-- 5. 如果部门表有逻辑删除字段，已添加 is_deleted = 0 的过滤条件
-- ============================================

