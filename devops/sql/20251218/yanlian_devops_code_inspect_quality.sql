/*
 Navicat Premium Data Transfer

 Source Server         : MySQL 8.0
 Source Server Type    : MySQL
 Source Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025
 Description: 代码质量数据表SQL脚本
 基于现有表结构分析设计：
 - code_repository (代码仓库表)
 - scan_task (扫描任务表)
 - scan_history (扫描历史表)
 - scan_issue (扫描问题表)
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for code_repository_quality
-- 代码仓库质量统计表（存储每个代码仓库的最新质量指标数据）
-- 数据来源：scan_history (最新记录) + scan_issue (统计)
-- ----------------------------
DROP TABLE IF EXISTS `code_repository_quality`;
CREATE TABLE `code_repository_quality` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `repository_id` bigint NOT NULL COMMENT '代码仓库ID（关联code_repository.id）',
  `repository_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '代码仓库地址',
  `branch` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '仓库分支',
  `project_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目key（关联scan_task.project_key）',
  `scan_task_id` bigint NULL DEFAULT NULL COMMENT '扫描任务ID（关联scan_task.id）',
  `latest_scan_history_id` bigint NULL DEFAULT NULL COMMENT '最新扫描历史ID（关联scan_history.id）',
  `latest_scan_time` datetime NULL DEFAULT NULL COMMENT '最新扫描时间',
  `quality_score` decimal(10,2) NULL DEFAULT NULL COMMENT '质量评分（0-100分，来源scan_history.score）',
  `bug_count` int NULL DEFAULT 0 COMMENT 'Bug数量（来源scan_history.bug或scan_issue统计）',
  `vulnerability_count` int NULL DEFAULT 0 COMMENT '漏洞数量（来源scan_history.vulnerability或scan_issue统计）',
  `code_smell_count` int NULL DEFAULT 0 COMMENT '代码异味数量（来源scan_history.code_smell或scan_issue统计）',
  `blocker_count` int NULL DEFAULT 0 COMMENT '致命问题数量（来源scan_issue统计，severity=BLOCKER）',
  `critical_count` int NULL DEFAULT 0 COMMENT '严重问题数量（来源scan_issue统计，severity=CRITICAL）',
  `major_count` int NULL DEFAULT 0 COMMENT '主要问题数量（来源scan_issue统计，severity=MAJOR）',
  `minor_count` int NULL DEFAULT 0 COMMENT '次要问题数量（来源scan_issue统计，severity=MINOR）',
  `coverage` decimal(10,2) NULL DEFAULT NULL COMMENT '代码覆盖率（百分比，0-100，来源scan_history.coverage）',
  `duplication` decimal(10,2) NULL DEFAULT NULL COMMENT '代码重复率（百分比，0-100，来源scan_history.repetition）',
  `quality_gate_status` tinyint NULL DEFAULT 0 COMMENT '质量门禁状态（0-未通过，1-通过，来源scan_history.result）',
  `quality_gate_id` bigint NULL DEFAULT NULL COMMENT '质量门禁ID（关联scan_history.quality_gate_id）',
  `scan_plan_id` bigint NULL DEFAULT NULL COMMENT '扫描方案ID（关联scan_history.scan_plan_id）',
  `language` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '主要编程语言（来源scan_task.language）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除（0-未删除，1-已删除）',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号（来源scan_history.tenant_id）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_repository_tenant` (`repository_id`, `tenant_id`) USING BTREE COMMENT '仓库+租户唯一索引',
  INDEX `idx_repository_id` (`repository_id`) USING BTREE COMMENT '代码仓库ID索引',
  INDEX `idx_project_key` (`project_key`) USING BTREE COMMENT '项目key索引',
  INDEX `idx_tenant_id` (`tenant_id`) USING BTREE COMMENT '租户编号索引',
  INDEX `idx_latest_scan_time` (`latest_scan_time`) USING BTREE COMMENT '最新扫描时间索引',
  INDEX `idx_quality_score` (`quality_score`) USING BTREE COMMENT '质量评分索引',
  INDEX `idx_deleted` (`deleted`) USING BTREE COMMENT '删除标记索引'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码仓库质量统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for code_repository_quality_history
-- 代码仓库质量历史表（存储每个代码仓库的历史质量指标数据）
-- 数据来源：scan_history + scan_issue (统计)
-- ----------------------------
DROP TABLE IF EXISTS `code_repository_quality_history`;
CREATE TABLE `code_repository_quality_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `repository_id` bigint NOT NULL COMMENT '代码仓库ID（通过scan_task关联code_repository.id）',
  `repository_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '代码仓库地址（来源scan_history.repository_url）',
  `branch` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '仓库分支（来源scan_history.branch）',
  `project_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目key（来源scan_task.project_key）',
  `scan_task_id` bigint NULL DEFAULT NULL COMMENT '扫描任务ID（来源scan_history.scan_task_id）',
  `scan_history_id` bigint NOT NULL COMMENT '扫描历史ID（关联scan_history.id）',
  `scan_time` datetime NOT NULL COMMENT '扫描时间（来源scan_history.scan_time）',
  `quality_score` decimal(10,2) NULL DEFAULT NULL COMMENT '质量评分（0-100分，来源scan_history.score）',
  `bug_count` int NULL DEFAULT 0 COMMENT 'Bug数量（来源scan_history.bug）',
  `vulnerability_count` int NULL DEFAULT 0 COMMENT '漏洞数量（来源scan_history.vulnerability）',
  `code_smell_count` int NULL DEFAULT 0 COMMENT '代码异味数量（来源scan_history.code_smell）',
  `blocker_count` int NULL DEFAULT 0 COMMENT '致命问题数量（来源scan_issue统计，severity=BLOCKER）',
  `critical_count` int NULL DEFAULT 0 COMMENT '严重问题数量（来源scan_issue统计，severity=CRITICAL）',
  `major_count` int NULL DEFAULT 0 COMMENT '主要问题数量（来源scan_issue统计，severity=MAJOR）',
  `minor_count` int NULL DEFAULT 0 COMMENT '次要问题数量（来源scan_issue统计，severity=MINOR）',
  `coverage` decimal(10,2) NULL DEFAULT NULL COMMENT '代码覆盖率（百分比，0-100，来源scan_history.coverage）',
  `duplication` decimal(10,2) NULL DEFAULT NULL COMMENT '代码重复率（百分比，0-100，来源scan_history.repetition）',
  `quality_gate_status` tinyint NULL DEFAULT 0 COMMENT '质量门禁状态（0-未通过，1-通过，来源scan_history.result）',
  `quality_gate_id` bigint NULL DEFAULT NULL COMMENT '质量门禁ID（来源scan_history.quality_gate_id）',
  `scan_plan_id` bigint NULL DEFAULT NULL COMMENT '扫描方案ID（来源scan_history.scan_plan_id）',
  `language` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '主要编程语言（来源scan_task.language）',
  `trigger_type` tinyint NULL DEFAULT 1 COMMENT '触发类型（0-代码提交，1-代码合并，2-流水线，3-其他，来源scan_history.trigger_type）',
  `commit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '提交ID（来源scan_history.commit_id）',
  `build_id` bigint NULL DEFAULT NULL COMMENT '构建ID（来源scan_history.build_id）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者（来源scan_history.create_by）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（来源scan_history.create_time）',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者（来源scan_history.update_by）',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间（来源scan_history.update_time）',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除（0-未删除，1-已删除，来源scan_history.del_flag）',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号（来源scan_history.tenant_id）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_scan_history` (`scan_history_id`, `tenant_id`) USING BTREE COMMENT '扫描历史+租户唯一索引',
  INDEX `idx_repository_id` (`repository_id`) USING BTREE COMMENT '代码仓库ID索引',
  INDEX `idx_scan_history_id` (`scan_history_id`) USING BTREE COMMENT '扫描历史ID索引',
  INDEX `idx_project_key` (`project_key`) USING BTREE COMMENT '项目key索引',
  INDEX `idx_tenant_id` (`tenant_id`) USING BTREE COMMENT '租户编号索引',
  INDEX `idx_scan_time` (`scan_time`) USING BTREE COMMENT '扫描时间索引',
  INDEX `idx_repository_scan_time` (`repository_id`, `scan_time`) USING BTREE COMMENT '仓库+扫描时间联合索引',
  INDEX `idx_deleted` (`deleted`) USING BTREE COMMENT '删除标记索引'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码仓库质量历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for code_repository_quality_trend
-- 代码仓库质量趋势表（存储每个代码仓库的质量趋势数据，按天/周/月维度统计）
-- 数据来源：code_repository_quality_history (聚合统计)
-- ----------------------------
DROP TABLE IF EXISTS `code_repository_quality_trend`;
CREATE TABLE `code_repository_quality_trend` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `repository_id` bigint NOT NULL COMMENT '代码仓库ID',
  `repository_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '代码仓库地址',
  `project_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目key',
  `stat_date` date NOT NULL COMMENT '统计日期（按天：DATE(scan_time)，按周：周一的日期，按月：每月1号）',
  `stat_type` tinyint NOT NULL COMMENT '统计类型（0-按天，1-按周，2-按月）',
  `scan_count` int NULL DEFAULT 0 COMMENT '扫描次数（统计周期内的扫描次数）',
  `avg_quality_score` decimal(10,2) NULL DEFAULT NULL COMMENT '平均质量评分（AVG(quality_score)）',
  `max_quality_score` decimal(10,2) NULL DEFAULT NULL COMMENT '最高质量评分（MAX(quality_score)）',
  `min_quality_score` decimal(10,2) NULL DEFAULT NULL COMMENT '最低质量评分（MIN(quality_score)）',
  `total_bug_count` int NULL DEFAULT 0 COMMENT '累计Bug数量（SUM(bug_count)）',
  `total_vulnerability_count` int NULL DEFAULT 0 COMMENT '累计漏洞数量（SUM(vulnerability_count)）',
  `total_code_smell_count` int NULL DEFAULT 0 COMMENT '累计代码异味数量（SUM(code_smell_count)）',
  `avg_coverage` decimal(10,2) NULL DEFAULT NULL COMMENT '平均代码覆盖率（AVG(coverage)）',
  `avg_duplication` decimal(10,2) NULL DEFAULT NULL COMMENT '平均代码重复率（AVG(duplication)）',
  `quality_gate_pass_rate` decimal(10,2) NULL DEFAULT NULL COMMENT '质量门禁通过率（百分比，0-100，COUNT(quality_gate_status=1) / COUNT(*) * 100）',
  `quality_improvement` decimal(10,2) NULL DEFAULT NULL COMMENT '质量改善度（本期avg_quality_score - 上期avg_quality_score）',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除（0-未删除，1-已删除）',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_repository_stat` (`repository_id`, `stat_date`, `stat_type`, `tenant_id`) USING BTREE COMMENT '仓库+统计日期+统计类型+租户唯一索引',
  INDEX `idx_repository_id` (`repository_id`) USING BTREE COMMENT '代码仓库ID索引',
  INDEX `idx_project_key` (`project_key`) USING BTREE COMMENT '项目key索引',
  INDEX `idx_tenant_id` (`tenant_id`) USING BTREE COMMENT '租户编号索引',
  INDEX `idx_stat_date` (`stat_date`) USING BTREE COMMENT '统计日期索引',
  INDEX `idx_stat_type` (`stat_type`) USING BTREE COMMENT '统计类型索引',
  INDEX `idx_deleted` (`deleted`) USING BTREE COMMENT '删除标记索引',
  INDEX `idx_repository_stat_date` (`repository_id`, `stat_date`, `stat_type`) USING BTREE COMMENT '仓库+统计日期+统计类型联合索引'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码仓库质量趋势表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
