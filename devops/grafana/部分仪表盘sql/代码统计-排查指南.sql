-- ============================================
-- 代码统计 SQL 数据丢失排查指南
-- ============================================
-- 如果 commit_info 中的某条数据没有统计出来，按以下步骤排查：

-- ============================================
-- 步骤1: 确认 commit_info 基础数据存在
-- ============================================
-- 替换 YOUR_COMMIT_ID 为实际要排查的 commit_info.id 或 gitlab_id
SELECT 
    c.id,
    c.gitlab_id,
    c.server_id,
    c.committer_name,
    c.author_name,
    c.gitlab_user_id,
    c.create_time,
    c.total,
    c.additions,
    c.deletions
FROM yanlian_devops_scm.commit_info c
WHERE c.id = YOUR_COMMIT_ID  -- 或使用 c.gitlab_id = 'xxx'
  AND c.server_id = 'xxx';   -- 如果有 server_id

-- ============================================
-- 步骤2: 检查 sub_system_component 关联
-- ============================================
-- 问题：INNER JOIN 如果匹配不上，数据会丢失
-- 排查：检查 gitlab_id 是否在 sub_system_component 中存在
SELECT 
    c.gitlab_id,
    s.id AS component_id,
    s.component_key,
    s.component,
    s.system_id
FROM yanlian_devops_scm.commit_info c
LEFT JOIN yanlian_devops_development.sub_system_component s 
    ON c.gitlab_id = s.component_key 
    AND s.component = 'GITLAB'
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际 ID

-- 如果 s.id IS NULL，说明 gitlab_id 在 sub_system_component 中找不到匹配
-- 解决方案：检查 sub_system_component 表是否有对应的 component_key 和 component='GITLAB' 的记录

-- ============================================
-- 步骤3: 检查 devops_system 关联
-- ============================================
-- 问题：INNER JOIN 如果匹配不上，数据会丢失
-- 排查：检查 system_id 是否在 devops_system 中存在
SELECT 
    c.gitlab_id,
    s.system_id,
    d.id AS system_id_check,
    d.tenant_id,
    d.sys_code,
    d.sub_full_name_cn
FROM yanlian_devops_scm.commit_info c
INNER JOIN yanlian_devops_development.sub_system_component s 
    ON c.gitlab_id = s.component_key 
    AND s.component = 'GITLAB'
LEFT JOIN yanlian_devops_development.devops_system d 
    ON s.system_id = d.id
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际 ID

-- 如果 d.id IS NULL，说明 system_id 在 devops_system 中找不到匹配
-- 解决方案：检查 devops_system 表是否有对应的 id 记录

-- ============================================
-- 步骤4: 检查 sys_organization 关联和过滤条件
-- ============================================
-- 问题：INNER JOIN + WHERE 条件可能过滤掉数据
-- 排查：检查 tenant_id 是否在 sys_organization 中存在，且 name 不为空且不等于'样板间'
SELECT 
    c.gitlab_id,
    d.tenant_id,
    o.id AS org_id,
    o.name AS org_name,
    CASE 
        WHEN o.id IS NULL THEN '租户ID在sys_organization中不存在'
        WHEN o.name = '' THEN '租户名称为空（会被过滤）'
        WHEN o.name = '样板间' THEN '租户名称为样板间（会被过滤）'
        ELSE '通过'
    END AS org_check_result
FROM yanlian_devops_scm.commit_info c
INNER JOIN yanlian_devops_development.sub_system_component s 
    ON c.gitlab_id = s.component_key 
    AND s.component = 'GITLAB'
INNER JOIN yanlian_devops_development.devops_system d 
    ON s.system_id = d.id
LEFT JOIN yanlian_app_management.sys_organization o 
    ON d.tenant_id = o.id
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际 ID

-- ============================================
-- 步骤5: 检查用户匹配（committer_name）
-- ============================================
-- 问题：用户匹配不上可能导致 WHERE 条件过滤
-- 排查：检查 committer_name 是否能匹配到 sys_user
SELECT 
    c.committer_name,
    c.author_name,
    ua.id AS user_id_by_username,
    ua.name AS user_name_by_username,
    ua.username AS username_match,
    ub.id AS user_id_by_name,
    ub.name AS user_name_by_name,
    COALESCE(ua.id, ub.id) AS final_user_id,
    COALESCE(ua.name, ub.name) AS final_user_name
FROM yanlian_devops_scm.commit_info c
LEFT JOIN yanlian_app_management.sys_user ua 
    ON c.committer_name = ua.username
LEFT JOIN yanlian_app_management.sys_user ub 
    ON c.committer_name = ub.name
    AND ua.username IS NULL
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际 ID

-- 如果 final_user_id IS NULL，说明 committer_name 在 sys_user 中找不到匹配
-- 解决方案：检查 sys_user 表中是否有 username 或 name 等于 committer_name 的记录

-- ============================================
-- 步骤6: 检查用户组织关联（sys_user_organization）
-- ============================================
-- 问题：WHERE 条件要求用户必须在指定组织中
-- 排查：检查用户是否在 sys_user_organization 中
SELECT 
    c.committer_name,
    COALESCE(ua.id, ub.id) AS user_id,
    COALESCE(ua.name, ub.name) AS user_name,
    suo.organ_id,
    o.name AS org_name,
    CASE 
        WHEN COALESCE(ua.id, ub.id) IS NULL THEN '用户未匹配到'
        WHEN suo.user_id IS NULL THEN '用户不在指定组织中（会被过滤）'
        ELSE '通过'
    END AS org_user_check_result
FROM yanlian_devops_scm.commit_info c
LEFT JOIN yanlian_app_management.sys_user ua 
    ON c.committer_name = ua.username
LEFT JOIN yanlian_app_management.sys_user ub 
    ON c.committer_name = ub.name
    AND ua.username IS NULL
LEFT JOIN yanlian_app_management.sys_user_organization suo 
    ON suo.user_id = COALESCE(ua.id, ub.id)
    AND suo.organ_id = '3267284931239067648'  -- 替换为实际的组织ID
LEFT JOIN yanlian_app_management.sys_organization o
    ON suo.organ_id = o.id
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际 ID

-- ============================================
-- 步骤7: 检查 WHERE 条件过滤
-- ============================================
-- 问题：多个 WHERE 条件可能过滤掉数据
-- 排查：逐一检查每个 WHERE 条件
SELECT 
    c.id,
    c.gitlab_user_id,
    c.create_time,
    COALESCE(ua.name, ub.name) AS user_name,
    CASE 
        WHEN c.gitlab_user_id IS NULL THEN 'gitlab_user_id 为 NULL（会被过滤）'
        WHEN c.create_time < '2025-09-01' THEN '创建时间早于 2025-09-01（会被过滤）'
        WHEN COALESCE(ua.name, ub.name) IN ('葛健平','杨林') THEN '用户被排除（会被过滤）'
        WHEN COALESCE(ua.id, ub.id) NOT IN (
            SELECT suo.user_id 
            FROM yanlian_app_management.sys_user_organization suo 
            WHERE suo.organ_id = '3267284931239067648'
        ) THEN '用户不在指定组织中（会被过滤）'
        ELSE '通过所有WHERE条件'
    END AS where_condition_check
FROM yanlian_devops_scm.commit_info c
LEFT JOIN yanlian_app_management.sys_user ua 
    ON c.committer_name = ua.username
LEFT JOIN yanlian_app_management.sys_user ub 
    ON c.committer_name = ub.name
    AND ua.username IS NULL
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际 ID

-- ============================================
-- 步骤8: 完整链路检查（综合排查）
-- ============================================
-- 一次性检查所有环节，找出数据丢失的原因
SELECT 
    c.id AS commit_id,
    c.gitlab_id,
    c.committer_name,
    c.create_time,
    -- 步骤1: sub_system_component 检查
    CASE 
        WHEN s.id IS NULL THEN '❌ gitlab_id 在 sub_system_component 中不存在'
        ELSE '✓ sub_system_component 匹配成功'
    END AS step1_component,
    -- 步骤2: devops_system 检查
    CASE 
        WHEN d.id IS NULL THEN '❌ system_id 在 devops_system 中不存在'
        ELSE '✓ devops_system 匹配成功'
    END AS step2_system,
    -- 步骤3: sys_organization 检查
    CASE 
        WHEN o.id IS NULL THEN '❌ tenant_id 在 sys_organization 中不存在'
        WHEN o.name = '' THEN '❌ 租户名称为空'
        WHEN o.name = '样板间' THEN '❌ 租户名称为样板间'
        ELSE '✓ sys_organization 匹配成功'
    END AS step3_organization,
    -- 步骤4: 用户匹配检查
    CASE 
        WHEN COALESCE(ua.id, ub.id) IS NULL THEN '❌ committer_name 无法匹配到 sys_user'
        ELSE CONCAT('✓ 用户匹配成功: ', COALESCE(ua.name, ub.name))
    END AS step4_user,
    -- 步骤5: 用户组织检查
    CASE 
        WHEN suo.user_id IS NULL THEN '❌ 用户不在指定组织中'
        ELSE '✓ 用户在指定组织中'
    END AS step5_user_org,
    -- 步骤6: WHERE 条件检查
    CASE 
        WHEN c.gitlab_user_id IS NULL THEN '❌ gitlab_user_id 为 NULL'
        WHEN c.create_time < '2025-09-01' THEN '❌ 创建时间不在范围内'
        WHEN COALESCE(ua.name, ub.name) IN ('葛健平','杨林') THEN '❌ 用户被排除'
        ELSE '✓ 通过所有WHERE条件'
    END AS step6_where_condition,
    -- 最终结果
    CASE 
        WHEN s.id IS NOT NULL 
         AND d.id IS NOT NULL 
         AND o.id IS NOT NULL 
         AND o.name != '' 
         AND o.name != '样板间'
         AND COALESCE(ua.id, ub.id) IS NOT NULL
         AND suo.user_id IS NOT NULL
         AND c.gitlab_user_id IS NOT NULL
         AND c.create_time >= '2025-09-01'
         AND COALESCE(ua.name, ub.name) NOT IN ('葛健平','杨林')
        THEN '✅ 数据应该能统计出来'
        ELSE '❌ 数据会被过滤，请查看上述具体原因'
    END AS final_result
FROM yanlian_devops_scm.commit_info c
LEFT JOIN yanlian_devops_development.sub_system_component s 
    ON c.gitlab_id = s.component_key 
    AND s.component = 'GITLAB'
LEFT JOIN yanlian_devops_development.devops_system d 
    ON s.system_id = d.id
LEFT JOIN yanlian_app_management.sys_organization o 
    ON d.tenant_id = o.id
LEFT JOIN yanlian_app_management.sys_user ua 
    ON c.committer_name = ua.username
LEFT JOIN yanlian_app_management.sys_user ub 
    ON c.committer_name = ub.name
    AND ua.username IS NULL
LEFT JOIN yanlian_app_management.sys_user_organization suo 
    ON suo.user_id = COALESCE(ua.id, ub.id)
    AND suo.organ_id = '3267284931239067648'  -- 替换为实际的组织ID
WHERE c.id = YOUR_COMMIT_ID;  -- 替换为实际要排查的 commit_info.id

-- ============================================
-- 使用说明：
-- ============================================
-- 1. 将 YOUR_COMMIT_ID 替换为实际要排查的 commit_info.id
-- 2. 将 '3267284931239067648' 替换为实际的组织ID（如果不同）
-- 3. 按步骤执行，找出数据丢失的具体环节
-- 4. 根据排查结果，修复对应的数据或调整 SQL 逻辑
