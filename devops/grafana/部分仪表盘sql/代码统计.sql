SELECT 
    IF(ua.username IS NOT NULL, ua.name, ub.name) AS '提交用户名',
    o.name AS '代码系统所属部门',
    d.sys_code AS '仓库编码',
    d.sub_full_name_cn AS '系统名称',
    COUNT(1) AS '提交次数',
    SUM(c.total) AS '变更代码行',
    SUM(c.deletions) AS '删除代码行', 
    SUM(c.additions) AS '新增代码行'
FROM yanlian_devops_scm.commit_info c
INNER JOIN yanlian_devops_development.sub_system_component s 
    ON c.gitlab_id = s.component_key 
    AND s.component = 'GITLAB'
INNER JOIN yanlian_devops_development.devops_system d 
    ON s.system_id = d.id
INNER JOIN yanlian_app_management.sys_organization o 
    ON d.tenant_id = o.id
    AND o.name != '' 
    AND o.name != '样板间'
LEFT JOIN yanlian_app_management.sys_user ua 
    ON c.committer_name = ua.username
LEFT JOIN yanlian_app_management.sys_user ub 
    ON c.committer_name = ub.name
    AND ua.username IS NULL  -- 避免重复匹配
WHERE c.gitlab_user_id IS NOT null
and coalesce (ua.id,ub.id) in (select suo.user_id from yanlian_app_management.sys_user_organization suo 
where suo.organ_id = '3267284931239067648'
)
-- 临时框定范围
AND c.create_time >= '2025-09-01'
and coalesce (ua.name,ub.name) not in ('葛健平','杨林')
-- 当前年度范围
-- AND c.create_time >= DATE_FORMAT(NOW(), '%Y-01-01')
    -- AND c.create_time < DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-01'), INTERVAL 1 MONTH)
GROUP BY 
    o.name,
    d.sys_code,
    d.sub_full_name_cn,
    IF(ua.username IS NOT NULL, ua.name, ub.name)
ORDER BY 
    `提交用户名` DESC,
    SUM(c.additions) DESC,
    MAX(c.create_time) DESC
    ;
    
 