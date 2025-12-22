/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_code_inspect

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:30:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for code_repository
-- ----------------------------
DROP TABLE IF EXISTS `code_repository`;
CREATE TABLE `code_repository`  (
  `id` bigint(0) NOT NULL,
  `scan_task_id` bigint(0) NOT NULL,
  `code_type` tinyint(0) NULL DEFAULT 0 COMMENT '代码获取渠道,1:git,2:svn,3:zip',
  `repository_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '仓库地址目录',
  `branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '仓库分支',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `exclusion_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '排除目录',
  `compare_branch` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '增量对比基线',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `repo_type` tinyint(1) NULL DEFAULT 0 COMMENT '仓库类型，0-内部，1-外部',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码仓库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_code_score_config
-- ----------------------------
DROP TABLE IF EXISTS `devops_code_score_config`;
CREATE TABLE `devops_code_score_config`  (
  `id` bigint(0) NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '打分指标的编码',
  `weight` int(0) NULL DEFAULT NULL COMMENT '打分指标的权重',
  `threshold1` decimal(10, 4) NULL DEFAULT NULL COMMENT '该打分指标只有一个阈值时，在该字段设置；如有最大最小阈值时，设置最小阈值',
  `threshold2` decimal(10, 4) NULL DEFAULT NULL COMMENT '该打分指标有最大最小阈值时，设置最大阈值',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '打分指标的描述',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码打分配置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pipeline_scan_job
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_scan_job`;
CREATE TABLE `pipeline_scan_job`  (
  `job_id` bigint(0) NULL DEFAULT NULL,
  `env_id` bigint(0) NULL DEFAULT NULL COMMENT '环境id',
  `job_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流水线名称'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '流水线代码扫描job信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for problem_solution
-- ----------------------------
DROP TABLE IF EXISTS `problem_solution`;
CREATE TABLE `problem_solution`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `matter` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题描述',
  `sonar_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'sonar编码',
  `sug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题建议',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `create_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'ProblemSolution问题修改意见' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for quality_gate
-- ----------------------------
DROP TABLE IF EXISTS `quality_gate`;
CREATE TABLE `quality_gate`  (
  `id` bigint(0) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '质量门襟名',
  `gate_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'sonar服务器质量门襟id',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '质量门襟描述',
  `condition_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '质量门襟配置的条件',
  `status` tinyint(0) NULL DEFAULT 0 COMMENT '状态，0：停用，1：启用',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '质量门襟信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rule_info
-- ----------------------------
DROP TABLE IF EXISTS `rule_info`;
CREATE TABLE `rule_info`  (
  `id` bigint(0) NOT NULL,
  `rule_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则key',
  `rule_language` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规则适用于语言',
  `desc_cn` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '中文描述',
  `repair_sug` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '修复建议',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '自定义标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扫描规则详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rule_tag_mapping
-- ----------------------------
DROP TABLE IF EXISTS `rule_tag_mapping`;
CREATE TABLE `rule_tag_mapping`  (
  `id` bigint(0) NOT NULL,
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '自定义规则',
  `tag_CN` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '自定义规则中文',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扫描规则标签映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_history
-- ----------------------------
DROP TABLE IF EXISTS `scan_history`;
CREATE TABLE `scan_history`  (
  `id` bigint(0) NOT NULL,
  `scan_task_id` bigint(0) NOT NULL,
  `scan_num` int(0) NULL DEFAULT NULL COMMENT '扫描序号',
  `scan_time` datetime(0) NOT NULL COMMENT '执行扫描时间',
  `status` tinyint(0) NULL DEFAULT 0 COMMENT '扫描状态，0：扫描中，1：已完成,2:扫描异常,3:排队中',
  `result` tinyint(0) NULL DEFAULT NULL COMMENT '扫描结果，0：未通过门禁，1：通过门襟',
  `score` double NULL DEFAULT NULL COMMENT '平台打分分值',
  `bug` int(0) NULL DEFAULT 0 COMMENT 'bug数',
  `code_smell` int(0) NULL DEFAULT 0 COMMENT 'code_smell数',
  `vulnerability` int(0) NULL DEFAULT 0 COMMENT '漏洞数',
  `coverage` double NULL DEFAULT 0 COMMENT '覆盖率',
  `repetition` double NULL DEFAULT 0 COMMENT '重复率',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `repository_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '代码仓库',
  `branch` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '仓库分支',
  `commit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'commitId',
  `code_type` tinyint(0) NULL DEFAULT 1 COMMENT '代码仓库类型',
  `cost_second` int(0) NULL DEFAULT NULL COMMENT '扫描耗时',
  `trigger_type` tinyint(0) NULL DEFAULT 1 COMMENT '触发扫描类型，0-代码提交，1-代码合并,2-流水线,3-其他',
  `gate_condition_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '质量门禁记录值',
  `base_line` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '增量对比基线',
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线构建id',
  `score_detail` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '平台评分详情',
  `quality_gate_id` bigint(0) NULL DEFAULT NULL COMMENT '质量门襟id',
  `scan_plan_id` bigint(0) NULL DEFAULT NULL COMMENT '扫描方案ID',
  `scan_plan_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '扫描方案名称',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scan_history_scan_task_id_index`(`scan_task_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务扫描记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_history_detail
-- ----------------------------
DROP TABLE IF EXISTS `scan_history_detail`;
CREATE TABLE `scan_history_detail`  (
  `id` bigint(0) NOT NULL,
  `history_id` bigint(0) NOT NULL,
  `result` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '扫描详情',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scan_history_detail_history_id_index`(`history_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务扫描记录详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_history_file
-- ----------------------------
DROP TABLE IF EXISTS `scan_history_file`;
CREATE TABLE `scan_history_file`  (
  `id` bigint(0) NOT NULL,
  `scan_task_id` bigint(0) NULL DEFAULT NULL,
  `scan_history_id` bigint(0) NULL DEFAULT NULL,
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线构建记录',
  `file` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成文件名',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '生成文件状态,0-初始状态，1-成功，2-失败',
  `file_type` int(0) NULL DEFAULT 0 COMMENT '文件类型,0 excel 1 pdf',
  `version` int(0) NULL DEFAULT 0 COMMENT '用于 CAS',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scan_history_file_scan_history_id_index`(`scan_history_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扫描历史数据生成报告详细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_issue
-- ----------------------------
DROP TABLE IF EXISTS `scan_issue`;
CREATE TABLE `scan_issue`  (
  `id` bigint(0) NOT NULL,
  `history_id` bigint(0) NOT NULL COMMENT '扫描历史id',
  `file_id` bigint(0) NOT NULL COMMENT '所属文件d',
  `issue_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题key',
  `issue_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题类型',
  `severity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '严重程度',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题状态',
  `text_range` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '问题定位坐标',
  `rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所匹配的扫描规则',
  `rule_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '问题提示信息',
  `hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'hash',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `ignore_flag` tinyint(1) NULL DEFAULT 0 COMMENT '忽略标记，0-未忽略，1-忽略',
  `ignore_message` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '忽略原因',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题所对应的规则自定义标签',
  `sys_tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题所对应的规则系统标签',
  `commit_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题代码引入作者',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_history_id`(`history_id`) USING BTREE,
  INDEX `scan_issue_del_flag_file_id_index`(`del_flag`, `file_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描问题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_issue_copy1
-- ----------------------------
DROP TABLE IF EXISTS `scan_issue_copy1`;
CREATE TABLE `scan_issue_copy1`  (
  `id` bigint(0) NOT NULL,
  `history_id` bigint(0) NOT NULL COMMENT '扫描历史id',
  `file_id` bigint(0) NOT NULL COMMENT '所属文件d',
  `issue_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题key',
  `issue_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题类型',
  `severity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '严重程度',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题状态',
  `text_range` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '问题定位坐标',
  `rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所匹配的扫描规则',
  `rule_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '问题提示信息',
  `hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'hash',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `ignore_flag` tinyint(1) NULL DEFAULT 0 COMMENT '忽略标记，0-未忽略，1-忽略',
  `ignore_message` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '忽略原因',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题所对应的规则自定义标签',
  `sys_tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题所对应的规则系统标签',
  `commit_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问题代码引入作者',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_history_id`(`history_id`) USING BTREE,
  INDEX `scan_issue_del_flag_file_id_index`(`del_flag`, `file_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描问题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_issue_file
-- ----------------------------
DROP TABLE IF EXISTS `scan_issue_file`;
CREATE TABLE `scan_issue_file`  (
  `id` bigint(0) NOT NULL,
  `history_id` bigint(0) NOT NULL COMMENT '扫描历史id',
  `component` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '扫描文件key',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文件源',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_history_id`(`history_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描问题文件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_issue_statistics
-- ----------------------------
DROP TABLE IF EXISTS `scan_issue_statistics`;
CREATE TABLE `scan_issue_statistics`  (
  `id` bigint(0) NOT NULL,
  `blocker` int(0) NULL DEFAULT 0 COMMENT '致命问题数量',
  `critical` int(0) NULL DEFAULT 0 COMMENT '错误问题数量',
  `major` int(0) NULL DEFAULT 0 COMMENT '警告问题数量',
  `minor` int(0) NULL DEFAULT 0 COMMENT '提示问题数量',
  `project_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目key',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scan_issue_statistics_project_key_IDX`(`project_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描问题统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_plan
-- ----------------------------
DROP TABLE IF EXISTS `scan_plan`;
CREATE TABLE `scan_plan`  (
  `id` bigint(0) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '扫描方案名称',
  `plan_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'sonar服务器扫描方案id',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '扫描方案描述',
  `language` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '扫描方案针对的语言',
  `status` tinyint(0) NULL DEFAULT 0 COMMENT '状态，0：停用，1：启用',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `sonar_default` tinyint(0) NULL DEFAULT 0 COMMENT 'sonar默认扫描规则，0：否，1：是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描方案信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_plan_active_rule
-- ----------------------------
DROP TABLE IF EXISTS `scan_plan_active_rule`;
CREATE TABLE `scan_plan_active_rule`  (
  `id` bigint(0) NOT NULL,
  `plan_id` bigint(0) NOT NULL COMMENT '扫描方案id',
  `rule_package_id` bigint(0) NULL DEFAULT NULL,
  `rule_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '扫描规则key',
  `rule_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `rule_repo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `severity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '严重程度',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` tinyint(0) NULL DEFAULT 1 COMMENT '0-关闭，1-开启',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scan_plan_package_id_index`(`plan_id`, `rule_package_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '激活规则记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_plan_package_relation
-- ----------------------------
DROP TABLE IF EXISTS `scan_plan_package_relation`;
CREATE TABLE `scan_plan_package_relation`  (
  `plan_id` bigint(0) NOT NULL COMMENT '扫描方案id',
  `package_id` bigint(0) NOT NULL COMMENT '扫描规则包id',
  `language` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则包语言',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '启用标志，0：不启用，1：启用',
  `tenant_id` bigint(0) NULL DEFAULT NULL,
  `del_flag` tinyint(0) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `version` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `plan_idx`(`plan_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3781479898565091329 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扫描方案与规则包关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_rule_package
-- ----------------------------
DROP TABLE IF EXISTS `scan_rule_package`;
CREATE TABLE `scan_rule_package`  (
  `id` bigint(0) NOT NULL,
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则包名称',
  `package_key` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sonarqube端扫描方案key',
  `language` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则包语言',
  `description` tinytext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '启用标志，0：不启用，1：启用',
  `is_template` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否模版，0：否，1：是',
  `del_flag` tinyint(0) NOT NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `tenant_id` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `quality_profile_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扫描规则包' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_task
-- ----------------------------
DROP TABLE IF EXISTS `scan_task`;
CREATE TABLE `scan_task`  (
  `id` bigint(0) NOT NULL,
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '扫描任务名称',
  `project_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务/项目 key',
  `language` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '针对扫描语言',
  `scan_plan_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '扫描方案id',
  `quality_gate_id` bigint(0) NOT NULL COMMENT '质量门襟id',
  `server_id` bigint(0) NULL DEFAULT NULL COMMENT '代码仓库id',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目id',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `source` tinyint(1) NULL DEFAULT 0 COMMENT '扫描任务创建方式，0-通用，1-流水线',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scan_task_queue
-- ----------------------------
DROP TABLE IF EXISTS `scan_task_queue`;
CREATE TABLE `scan_task_queue`  (
  `id` bigint(0) NOT NULL,
  `scan_task_id` bigint(0) NOT NULL COMMENT '任务id',
  `scan_history_id` bigint(0) NOT NULL COMMENT '扫描历史id',
  `scan_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行扫描请求体',
  `priority` tinyint(0) NULL DEFAULT 0 COMMENT '优先级，数字越小优先级越高',
  `version` int(0) NULL DEFAULT 0,
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `del_flag` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描任务队列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for webhook_history
-- ----------------------------
DROP TABLE IF EXISTS `webhook_history`;
CREATE TABLE `webhook_history`  (
  `id` bigint(0) NOT NULL,
  `history_id` bigint(0) NOT NULL COMMENT '扫描记录id',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0-触发回调，1-回调完成，2-回调失败',
  `webhook_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '回调体',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '回调处理失败信息，只有status为2时才有数据',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '回调记录表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
