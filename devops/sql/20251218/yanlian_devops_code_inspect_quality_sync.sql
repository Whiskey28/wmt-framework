/*
 代码质量数据表数据同步SQL脚本
  
 说明：本脚本提供了从现有表同步数据到代码质量数据表的SQL
 数据来源：
 - scan_history (扫描历史表)
 - scan_issue (扫描问题表)
 - scan_task (扫描任务表)
 - code_repository (代码仓库表)
 
 实际使用时，建议通过定时任务或触发器自动执行
*/

-- ============================================
-- 1. 同步代码仓库质量统计表（code_repository_quality）
-- 说明：从 scan_history 表获取最新扫描记录，更新或插入到 code_repository_quality 表
-- ============================================

INSERT INTO `code_repository_quality` (
    `repository_id`,
    `repository_url`,
    `branch`,
    `project_key`,
    `scan_task_id`,
    `latest_scan_history_id`,
    `latest_scan_time`,
    `quality_score`,
    `bug_count`,
    `vulnerability_count`,
    `code_smell_count`,
    `blocker_count`,
    `critical_count`,
    `major_count`,
    `minor_count`,
    `coverage`,
    `duplication`,
    `quality_gate_status`,
    `quality_gate_id`,
    `scan_plan_id`,
    `language`,
    `tenant_id`,
    `creator`,
    `updater`
)
SELECT 
    cr.id AS repository_id,
    sh.repository_url,
    sh.branch,
    st.project_key,
    sh.scan_task_id,
    sh.id AS latest_scan_history_id,
    sh.scan_time AS latest_scan_time,
    sh.score AS quality_score,
    COALESCE(sh.bug, 0) AS bug_count,
    COALESCE(sh.vulnerability, 0) AS vulnerability_count,
    COALESCE(sh.code_smell, 0) AS code_smell_count,
    COALESCE(issue_stats.blocker_count, 0) AS blocker_count,
    COALESCE(issue_stats.critical_count, 0) AS critical_count,
    COALESCE(issue_stats.major_count, 0) AS major_count,
    COALESCE(issue_stats.minor_count, 0) AS minor_count,
    sh.coverage,
    sh.repetition AS duplication,
    COALESCE(sh.result, 0) AS quality_gate_status,
    sh.quality_gate_id,
    sh.scan_plan_id,
    st.language,
    sh.tenant_id,
    CAST(sh.create_by AS CHAR) AS creator,
    CAST(sh.update_by AS CHAR) AS updater
FROM (
    -- 获取每个扫描任务的最新扫描记录
    SELECT 
        sh1.*
    FROM scan_history sh1
    INNER JOIN (
        SELECT 
            scan_task_id,
            MAX(scan_time) AS max_scan_time
        FROM scan_history
        WHERE del_flag = 0
        GROUP BY scan_task_id
    ) sh2 ON sh1.scan_task_id = sh2.scan_task_id 
         AND sh1.scan_time = sh2.max_scan_time
    WHERE sh1.del_flag = 0
) sh
LEFT JOIN scan_task st ON sh.scan_task_id = st.id
LEFT JOIN code_repository cr ON st.id = cr.scan_task_id
LEFT JOIN (
    -- 统计每个扫描历史的问题数量（按严重程度）
    SELECT 
        history_id,
        COUNT(CASE WHEN severity = 'BLOCKER' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS blocker_count,
        COUNT(CASE WHEN severity = 'CRITICAL' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS critical_count,
        COUNT(CASE WHEN severity = 'MAJOR' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS major_count,
        COUNT(CASE WHEN severity = 'MINOR' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS minor_count
    FROM scan_issue
    GROUP BY history_id
) issue_stats ON sh.id = issue_stats.history_id
WHERE cr.id IS NOT NULL
  AND sh.tenant_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    `repository_url` = VALUES(`repository_url`),
    `branch` = VALUES(`branch`),
    `project_key` = VALUES(`project_key`),
    `scan_task_id` = VALUES(`scan_task_id`),
    `latest_scan_history_id` = VALUES(`latest_scan_history_id`),
    `latest_scan_time` = VALUES(`latest_scan_time`),
    `quality_score` = VALUES(`quality_score`),
    `bug_count` = VALUES(`bug_count`),
    `vulnerability_count` = VALUES(`vulnerability_count`),
    `code_smell_count` = VALUES(`code_smell_count`),
    `blocker_count` = VALUES(`blocker_count`),
    `critical_count` = VALUES(`critical_count`),
    `major_count` = VALUES(`major_count`),
    `minor_count` = VALUES(`minor_count`),
    `coverage` = VALUES(`coverage`),
    `duplication` = VALUES(`duplication`),
    `quality_gate_status` = VALUES(`quality_gate_status`),
    `quality_gate_id` = VALUES(`quality_gate_id`),
    `scan_plan_id` = VALUES(`scan_plan_id`),
    `language` = VALUES(`language`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW();

-- ============================================
-- 2. 同步代码仓库质量历史表（code_repository_quality_history）
-- 说明：从 scan_history 表同步所有扫描记录到历史表
-- ============================================

INSERT INTO `code_repository_quality_history` (
    `repository_id`,
    `repository_url`,
    `branch`,
    `project_key`,
    `scan_task_id`,
    `scan_history_id`,
    `scan_time`,
    `quality_score`,
    `bug_count`,
    `vulnerability_count`,
    `code_smell_count`,
    `blocker_count`,
    `critical_count`,
    `major_count`,
    `minor_count`,
    `coverage`,
    `duplication`,
    `quality_gate_status`,
    `quality_gate_id`,
    `scan_plan_id`,
    `language`,
    `trigger_type`,
    `commit_id`,
    `build_id`,
    `tenant_id`,
    `creator`,
    `updater`
)
SELECT 
    cr.id AS repository_id,
    sh.repository_url,
    sh.branch,
    st.project_key,
    sh.scan_task_id,
    sh.id AS scan_history_id,
    sh.scan_time,
    sh.score AS quality_score,
    COALESCE(sh.bug, 0) AS bug_count,
    COALESCE(sh.vulnerability, 0) AS vulnerability_count,
    COALESCE(sh.code_smell, 0) AS code_smell_count,
    COALESCE(issue_stats.blocker_count, 0) AS blocker_count,
    COALESCE(issue_stats.critical_count, 0) AS critical_count,
    COALESCE(issue_stats.major_count, 0) AS major_count,
    COALESCE(issue_stats.minor_count, 0) AS minor_count,
    sh.coverage,
    sh.repetition AS duplication,
    COALESCE(sh.result, 0) AS quality_gate_status,
    sh.quality_gate_id,
    sh.scan_plan_id,
    st.language,
    COALESCE(sh.trigger_type, 1) AS trigger_type,
    sh.commit_id,
    sh.build_id,
    sh.tenant_id,
    CAST(sh.create_by AS CHAR) AS creator,
    CAST(sh.update_by AS CHAR) AS updater
FROM scan_history sh
LEFT JOIN scan_task st ON sh.scan_task_id = st.id
LEFT JOIN code_repository cr ON st.id = cr.scan_task_id
LEFT JOIN (
    -- 统计每个扫描历史的问题数量（按严重程度）
    SELECT 
        history_id,
        COUNT(CASE WHEN severity = 'BLOCKER' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS blocker_count,
        COUNT(CASE WHEN severity = 'CRITICAL' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS critical_count,
        COUNT(CASE WHEN severity = 'MAJOR' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS major_count,
        COUNT(CASE WHEN severity = 'MINOR' AND del_flag = 0 AND ignore_flag = 0 THEN 1 END) AS minor_count
    FROM scan_issue
    GROUP BY history_id
) issue_stats ON sh.id = issue_stats.history_id
WHERE sh.del_flag = 0
  AND cr.id IS NOT NULL
  AND sh.tenant_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 
      FROM code_repository_quality_history h 
      WHERE h.scan_history_id = sh.id
        AND h.tenant_id = sh.tenant_id
  );

-- ============================================
-- 3. 生成代码仓库质量趋势表（code_repository_quality_trend）
-- 说明：按天/周/月维度统计质量趋势数据
-- ============================================

-- 3.1 按天统计（stat_type = 0）
INSERT INTO `code_repository_quality_trend` (
    `repository_id`,
    `repository_url`,
    `project_key`,
    `stat_date`,
    `stat_type`,
    `scan_count`,
    `avg_quality_score`,
    `max_quality_score`,
    `min_quality_score`,
    `total_bug_count`,
    `total_vulnerability_count`,
    `total_code_smell_count`,
    `avg_coverage`,
    `avg_duplication`,
    `quality_gate_pass_rate`,
    `quality_improvement`,
    `tenant_id`,
    `creator`,
    `updater`
)
SELECT 
    h.repository_id,
    h.repository_url,
    h.project_key,
    DATE(h.scan_time) AS stat_date,
    0 AS stat_type,  -- 按天
    COUNT(*) AS scan_count,
    AVG(h.quality_score) AS avg_quality_score,
    MAX(h.quality_score) AS max_quality_score,
    MIN(h.quality_score) AS min_quality_score,
    SUM(h.bug_count) AS total_bug_count,
    SUM(h.vulnerability_count) AS total_vulnerability_count,
    SUM(h.code_smell_count) AS total_code_smell_count,
    AVG(h.coverage) AS avg_coverage,
    AVG(h.duplication) AS avg_duplication,
    CASE 
        WHEN COUNT(*) > 0 THEN (COUNT(CASE WHEN h.quality_gate_status = 1 THEN 1 END) * 100.0 / COUNT(*))
        ELSE 0
    END AS quality_gate_pass_rate,
    NULL AS quality_improvement,  -- 需要与上一周期对比计算
    h.tenant_id,
    '' AS creator,
    '' AS updater
FROM code_repository_quality_history h
WHERE h.deleted = 0
GROUP BY h.repository_id, h.repository_url, h.project_key, DATE(h.scan_time), h.tenant_id
ON DUPLICATE KEY UPDATE
    `scan_count` = VALUES(`scan_count`),
    `avg_quality_score` = VALUES(`avg_quality_score`),
    `max_quality_score` = VALUES(`max_quality_score`),
    `min_quality_score` = VALUES(`min_quality_score`),
    `total_bug_count` = VALUES(`total_bug_count`),
    `total_vulnerability_count` = VALUES(`total_vulnerability_count`),
    `total_code_smell_count` = VALUES(`total_code_smell_count`),
    `avg_coverage` = VALUES(`avg_coverage`),
    `avg_duplication` = VALUES(`avg_duplication`),
    `quality_gate_pass_rate` = VALUES(`quality_gate_pass_rate`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW();

-- 3.2 按周统计（stat_type = 1）
-- 注意：使用周一作为周的开始日期
INSERT INTO `code_repository_quality_trend` (
    `repository_id`,
    `repository_url`,
    `project_key`,
    `stat_date`,
    `stat_type`,
    `scan_count`,
    `avg_quality_score`,
    `max_quality_score`,
    `min_quality_score`,
    `total_bug_count`,
    `total_vulnerability_count`,
    `total_code_smell_count`,
    `avg_coverage`,
    `avg_duplication`,
    `quality_gate_pass_rate`,
    `quality_improvement`,
    `tenant_id`,
    `creator`,
    `updater`
)
SELECT 
    h.repository_id,
    h.repository_url,
    h.project_key,
    DATE_SUB(DATE(h.scan_time), INTERVAL WEEKDAY(h.scan_time) DAY) AS stat_date,  -- 周一作为周的开始
    1 AS stat_type,  -- 按周
    COUNT(*) AS scan_count,
    AVG(h.quality_score) AS avg_quality_score,
    MAX(h.quality_score) AS max_quality_score,
    MIN(h.quality_score) AS min_quality_score,
    SUM(h.bug_count) AS total_bug_count,
    SUM(h.vulnerability_count) AS total_vulnerability_count,
    SUM(h.code_smell_count) AS total_code_smell_count,
    AVG(h.coverage) AS avg_coverage,
    AVG(h.duplication) AS avg_duplication,
    CASE 
        WHEN COUNT(*) > 0 THEN (COUNT(CASE WHEN h.quality_gate_status = 1 THEN 1 END) * 100.0 / COUNT(*))
        ELSE 0
    END AS quality_gate_pass_rate,
    NULL AS quality_improvement,
    h.tenant_id,
    '' AS creator,
    '' AS updater
FROM code_repository_quality_history h
WHERE h.deleted = 0
GROUP BY h.repository_id, h.repository_url, h.project_key, DATE_SUB(DATE(h.scan_time), INTERVAL WEEKDAY(h.scan_time) DAY), h.tenant_id
ON DUPLICATE KEY UPDATE
    `scan_count` = VALUES(`scan_count`),
    `avg_quality_score` = VALUES(`avg_quality_score`),
    `max_quality_score` = VALUES(`max_quality_score`),
    `min_quality_score` = VALUES(`min_quality_score`),
    `total_bug_count` = VALUES(`total_bug_count`),
    `total_vulnerability_count` = VALUES(`total_vulnerability_count`),
    `total_code_smell_count` = VALUES(`total_code_smell_count`),
    `avg_coverage` = VALUES(`avg_coverage`),
    `avg_duplication` = VALUES(`avg_duplication`),
    `quality_gate_pass_rate` = VALUES(`quality_gate_pass_rate`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW();

-- 3.3 按月统计（stat_type = 2）
INSERT INTO `code_repository_quality_trend` (
    `repository_id`,
    `repository_url`,
    `project_key`,
    `stat_date`,
    `stat_type`,
    `scan_count`,
    `avg_quality_score`,
    `max_quality_score`,
    `min_quality_score`,
    `total_bug_count`,
    `total_vulnerability_count`,
    `total_code_smell_count`,
    `avg_coverage`,
    `avg_duplication`,
    `quality_gate_pass_rate`,
    `quality_improvement`,
    `tenant_id`,
    `creator`,
    `updater`
)
SELECT 
    h.repository_id,
    h.repository_url,
    h.project_key,
    DATE_FORMAT(h.scan_time, '%Y-%m-01') AS stat_date,  -- 每月1号
    2 AS stat_type,  -- 按月
    COUNT(*) AS scan_count,
    AVG(h.quality_score) AS avg_quality_score,
    MAX(h.quality_score) AS max_quality_score,
    MIN(h.quality_score) AS min_quality_score,
    SUM(h.bug_count) AS total_bug_count,
    SUM(h.vulnerability_count) AS total_vulnerability_count,
    SUM(h.code_smell_count) AS total_code_smell_count,
    AVG(h.coverage) AS avg_coverage,
    AVG(h.duplication) AS avg_duplication,
    CASE 
        WHEN COUNT(*) > 0 THEN (COUNT(CASE WHEN h.quality_gate_status = 1 THEN 1 END) * 100.0 / COUNT(*))
        ELSE 0
    END AS quality_gate_pass_rate,
    NULL AS quality_improvement,
    h.tenant_id,
    '' AS creator,
    '' AS updater
FROM code_repository_quality_history h
WHERE h.deleted = 0
GROUP BY h.repository_id, h.repository_url, h.project_key, DATE_FORMAT(h.scan_time, '%Y-%m-01'), h.tenant_id
ON DUPLICATE KEY UPDATE
    `scan_count` = VALUES(`scan_count`),
    `avg_quality_score` = VALUES(`avg_quality_score`),
    `max_quality_score` = VALUES(`max_quality_score`),
    `min_quality_score` = VALUES(`min_quality_score`),
    `total_bug_count` = VALUES(`total_bug_count`),
    `total_vulnerability_count` = VALUES(`total_vulnerability_count`),
    `total_code_smell_count` = VALUES(`total_code_smell_count`),
    `avg_coverage` = VALUES(`avg_coverage`),
    `avg_duplication` = VALUES(`avg_duplication`),
    `quality_gate_pass_rate` = VALUES(`quality_gate_pass_rate`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW();

-- ============================================
-- 4. 查询示例（注释掉的SQL，供参考）
-- ============================================

-- 4.1 查询租户下所有代码仓库的最新质量数据
-- SELECT 
--     rq.*,
--     cr.repository_url,
--     cr.branch
-- FROM code_repository_quality rq
-- LEFT JOIN code_repository cr ON rq.repository_id = cr.id
-- WHERE rq.tenant_id = ? 
--   AND rq.deleted = 0
-- ORDER BY rq.latest_scan_time DESC;

-- 4.2 查询指定代码仓库的质量历史趋势（最近30条）
-- SELECT 
--     scan_time,
--     quality_score,
--     bug_count,
--     vulnerability_count,
--     code_smell_count,
--     coverage,
--     duplication
-- FROM code_repository_quality_history
-- WHERE repository_id = ?
--   AND tenant_id = ?
--   AND deleted = 0
-- ORDER BY scan_time DESC
-- LIMIT 30;

-- 4.3 查询代码仓库质量趋势（按月，最近12个月）
-- SELECT 
--     stat_date,
--     avg_quality_score,
--     total_bug_count,
--     total_vulnerability_count,
--     quality_gate_pass_rate
-- FROM code_repository_quality_trend
-- WHERE repository_id = ?
--   AND stat_type = 2  -- 按月
--   AND tenant_id = ?
--   AND deleted = 0
-- ORDER BY stat_date DESC
-- LIMIT 12;

-- 4.4 查询租户下质量评分低于阈值的代码仓库
-- SELECT 
--     rq.*,
--     cr.repository_url
-- FROM code_repository_quality rq
-- LEFT JOIN code_repository cr ON rq.repository_id = cr.id
-- WHERE rq.tenant_id = ?
--   AND rq.quality_score < 60  -- 质量评分低于60分
--   AND rq.deleted = 0
-- ORDER BY rq.quality_score ASC;
