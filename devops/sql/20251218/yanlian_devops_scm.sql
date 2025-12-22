/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_scm

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:31:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for amp_gitlab_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `amp_gitlab_user_relation`;
CREATE TABLE `amp_gitlab_user_relation`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `amp_user_id` bigint(0) NOT NULL COMMENT 'amp用户ID',
  `gitlab_user_id` int(0) NOT NULL COMMENT 'gitlab用户ID',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  `gitlab_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'gitlab_username',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `amp_x_gitlab_x_server`(`amp_user_id`, `gitlab_user_id`, `server_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4143800030502375425 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for commit_info
-- ----------------------------
DROP TABLE IF EXISTS `commit_info`;
CREATE TABLE `commit_info`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `gitlab_id` int(0) NOT NULL COMMENT 'gitlab代码项目Id',
  `commit_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提交记录ID',
  `total` int(0) UNSIGNED NULL DEFAULT 0 COMMENT '提交变更总行数 = deletions + additions',
  `deletions` int(0) UNSIGNED NULL DEFAULT 0 COMMENT '提交删除的行数',
  `additions` int(0) UNSIGNED NULL DEFAULT 0 COMMENT '提交新增的行数',
  `committer_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提交人名称',
  `author_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '作者名称',
  `commit_msg` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '提交信息',
  `gitlab_user_id` int(0) NULL DEFAULT NULL COMMENT '提交用户的gitlab userId',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交人邮箱',
  `is_gitlab_user_found` tinyint(0) NULL DEFAULT 0 COMMENT '是否匹配到gitlab用户，0未匹配到，1匹配到',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_commit_id_unique`(`commit_id`, `server_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15174 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_env
-- ----------------------------
DROP TABLE IF EXISTS `config_env`;
CREATE TABLE `config_env`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `config_id` bigint(0) NOT NULL COMMENT '配置库id',
  `env` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境名称',
  `create_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3404494079243939841 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_code_config
-- ----------------------------
DROP TABLE IF EXISTS `devops_code_config`;
CREATE TABLE `devops_code_config`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `server_id` bigint(0) NOT NULL COMMENT '服务id',
  `gitlab_id` int(0) NOT NULL COMMENT '仓库id',
  `project_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `tenant_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户',
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统Id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3401708808437854209 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_code_config_item
-- ----------------------------
DROP TABLE IF EXISTS `devops_code_config_item`;
CREATE TABLE `devops_code_config_item`  (
  `id` bigint(0) NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `privacy` tinyint(1) NOT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `del_flag` tinyint(1) NOT NULL DEFAULT 0,
  `create_time` datetime(0) NOT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `gitlab_id` int(0) NOT NULL,
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '类型，true是镜像占位符，false其他',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_code_config_placeholder
-- ----------------------------
DROP TABLE IF EXISTS `devops_code_config_placeholder`;
CREATE TABLE `devops_code_config_placeholder`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `placeholder` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '占位符',
  `config_id` bigint(0) UNSIGNED NOT NULL COMMENT '配置库ID',
  `env` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分支名称',
  `file_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '占位符的值',
  `default_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '占位符的值',
  `is_template` tinyint(0) NULL DEFAULT 0 COMMENT '是不是默认分支的占位符，1是0不是',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '描述信息',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `del_flag` tinyint(0) NOT NULL DEFAULT 0 COMMENT '1->删除 0->正常',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uqidx`(`config_id`, `env`, `file_path`, `placeholder`) USING BTREE,
  INDEX `idx_placeholder`(`placeholder`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_code_config_relation
-- ----------------------------
DROP TABLE IF EXISTS `devops_code_config_relation`;
CREATE TABLE `devops_code_config_relation`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `config_item_id` bigint(0) NULL DEFAULT NULL COMMENT '配置项id',
  `env` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '环境名称，中文',
  `file_name` int(0) NULL DEFAULT NULL COMMENT '文件名称\n',
  `system_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '研发协同子系统编码',
  `value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置项value\n',
  `config_id` bigint(0) NULL DEFAULT NULL COMMENT '配置库id',
  `file_path` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件当中占位符名称',
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '类型，true是镜像占位符，false其他',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_code_scan_set
-- ----------------------------
DROP TABLE IF EXISTS `devops_code_scan_set`;
CREATE TABLE `devops_code_scan_set`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `scan_behavior` tinyint(0) NULL DEFAULT NULL COMMENT '扫描行为 1-代码提交 2-代码合并',
  `is_scan` tinyint(0) NULL DEFAULT 0 COMMENT '是否扫描：0-是 1-否',
  `merge_is_check` tinyint(0) NULL DEFAULT 0 COMMENT '代码合并时是否校验扫描结果通过\n',
  `scan_mode` tinyint(0) NULL DEFAULT NULL COMMENT '代码扫描方式 1-全量 2-增量',
  `scan_plan_id` bigint(0) NULL DEFAULT NULL COMMENT '代码扫描方案表ID',
  `quality_gate_id` bigint(0) NULL DEFAULT NULL COMMENT '质量门禁表ID',
  `scan_type` tinyint(0) NULL DEFAULT NULL COMMENT '扫描类型1-安全漏洞 2-开发规范 3-敏感信息',
  `quality_gate_is_open` tinyint(0) NULL DEFAULT 0 COMMENT '是否开启质量门禁 0-是 1-否',
  `scan_task_id` bigint(0) NULL DEFAULT NULL COMMENT '扫描任务表ID',
  `project_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '任务/项目的key',
  `scan_task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '代码扫描任务名称',
  `code_repo_id` int(0) NULL DEFAULT NULL COMMENT '代码仓库ID',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `exclusion_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `base_line` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '增量对比基线',
  `server_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 769 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '代码扫描设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_commit_check_rule
-- ----------------------------
DROP TABLE IF EXISTS `devops_commit_check_rule`;
CREATE TABLE `devops_commit_check_rule`  (
  `id` bigint(0) NOT NULL COMMENT 'Id',
  `rule` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '校验规则，正则表达式',
  `gitlab_app_id` int(0) NULL DEFAULT NULL COMMENT '代码仓库id',
  `create_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  `server_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_server_x_gitlab`(`server_id`, `gitlab_app_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_import_record
-- ----------------------------
DROP TABLE IF EXISTS `devops_import_record`;
CREATE TABLE `devops_import_record`  (
  `id` bigint(0) NOT NULL COMMENT 'id',
  `origin_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '原仓库url路径',
  `origin_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '原仓库path路径',
  `target_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '导入目标url',
  `target_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '导入目标path',
  `project_id` int(0) NULL DEFAULT NULL COMMENT 'Gitlab仓库id',
  `mode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '导入方式',
  `platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '导入平台',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '导入用户名',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '1-导入中2成功-3-失败',
  `other` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '导入结果额外说明',
  `create_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '删除标记,1:已删除,0:正常\n',
  `server_id` bigint(0) NULL DEFAULT NULL,
  `import_user_id` bigint(0) NOT NULL COMMENT '导入人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`import_user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '代码仓库外部导入记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_job_hook
-- ----------------------------
DROP TABLE IF EXISTS `devops_job_hook`;
CREATE TABLE `devops_job_hook`  (
  `id` bigint(0) NOT NULL,
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水心id',
  `server_id` bigint(0) NULL DEFAULT NULL COMMENT '服务器id',
  `project_id` int(0) NULL DEFAULT NULL COMMENT '项目id',
  `hook_id` int(0) NULL DEFAULT NULL COMMENT '项目的webhookid',
  `type` tinyint(0) NULL DEFAULT NULL COMMENT 'Hook触发类型：0-流水线 1-代码提交触发扫描',
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `server_id_index`(`server_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_request
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_request`;
CREATE TABLE `devops_merge_request`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `server_id` bigint(0) NOT NULL COMMENT '应用id',
  `gitlab_app_id` int(0) NOT NULL COMMENT 'gitlab应用id',
  `merge_id` int(0) NOT NULL COMMENT '合并请求id---对应gitlab.iid',
  `assign_result` tinyint(1) NULL DEFAULT 0 COMMENT 'devops平台评审结果\n0初始状态1通过待合并2审批拒绝\n3合并通过 4合并关闭',
  `assign_rule` tinyint(1) NULL DEFAULT NULL,
  `assignee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `least_number` int(0) NULL DEFAULT 0,
  `required_discussions_resolved` tinyint(0) NOT NULL DEFAULT 0,
  `priority` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'IMPORTANT',
  `mr_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '标题',
  `source_branch` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '源分支',
  `target_branch` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '目标分支',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4213262922758541313 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'gitlab合并请求详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_request_assignee
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_request_assignee`;
CREATE TABLE `devops_merge_request_assignee`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `gitlab_merge_request_id` bigint(0) NOT NULL COMMENT '关联表id',
  `assignee` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评审者',
  `result` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0初始状态1通过2拒绝',
  `assign_time` datetime(0) NULL DEFAULT NULL COMMENT '审批时间',
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `gitlab_id` int(0) NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  `devops_merge_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3690179482759441478 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_request_scan
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_request_scan`;
CREATE TABLE `devops_merge_request_scan`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `merge_request_id` bigint(0) NOT NULL COMMENT 'merge_request表id',
  `task_id` bigint(0) NULL DEFAULT NULL COMMENT '扫描任务id',
  `scan_type` tinyint(0) NOT NULL COMMENT '扫描类型1-安全漏洞 2-开发规范 3-敏感信息',
  `history_id` bigint(0) NULL DEFAULT NULL COMMENT '扫描历史id',
  `merge_check` tinyint(0) NOT NULL DEFAULT 0 COMMENT '合并是否需要校验门禁：0-不需要，1-需要',
  `del_flag` tinyint(0) NOT NULL DEFAULT 0,
  `server_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1874 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '合并请求-扫描任务关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_request_setting
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_request_setting`;
CREATE TABLE `devops_merge_request_setting`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `assignee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '评审人员列表',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '评审描述配置名称',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '评审描述配置内容',
  `gitlab_id` int(0) NULL DEFAULT NULL COMMENT 'gitlab应用id',
  `del_flag` tinyint(0) NULL DEFAULT 0,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `least_number` int(0) NULL DEFAULT NULL,
  `required_discussions_resolved` tinyint(0) NOT NULL DEFAULT 0,
  `server_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4186860468555010049 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '代码审批表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_task
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_task`;
CREATE TABLE `devops_merge_task`  (
  `id` bigint(0) NOT NULL COMMENT '主键',
  `group_id` bigint(0) NULL DEFAULT NULL COMMENT '规则id',
  `source_branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '基础分支',
  `source_commit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '基础分支commitid',
  `target_branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '目标分支',
  `target_commit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '目标分支commit',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新人',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '任务状态0-未开始1-执行中2-阻塞中3-已取消4-成功5-失败',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '错误信息',
  `server_id` bigint(0) NULL DEFAULT NULL,
  `is_target_dynamic` tinyint(1) NULL DEFAULT 0 COMMENT '本次任务是否是动态分支策略',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_task_branch
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_task_branch`;
CREATE TABLE `devops_merge_task_branch`  (
  `id` bigint(0) NOT NULL COMMENT '自增主键',
  `task_id` bigint(0) NULL DEFAULT NULL COMMENT '合并任务id',
  `branch_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '分支名',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态：0-未合并；1-已合并；2-有冲突',
  `commit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT 'commitId',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新人',
  `merge_request_id` int(0) NULL DEFAULT NULL COMMENT '合并请求id',
  `status_change_time` datetime(0) NULL DEFAULT NULL COMMENT '状态变更时间',
  `server_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_merge_task_group
-- ----------------------------
DROP TABLE IF EXISTS `devops_merge_task_group`;
CREATE TABLE `devops_merge_task_group`  (
  `id` bigint(0) NOT NULL COMMENT '自增主键',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新人',
  `gitlab_id` int(0) NULL DEFAULT NULL COMMENT '仓库id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '分组名称',
  `target` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '目标',
  `is_target_dynamic` tinyint(1) NULL DEFAULT NULL COMMENT '是否动态分支',
  `source_branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '基础分支',
  `server_id` bigint(0) NULL DEFAULT NULL,
  `external_job_id` bigint(0) NULL DEFAULT NULL COMMENT '研发工作台id/流水线id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_server
-- ----------------------------
DROP TABLE IF EXISTS `devops_server`;
CREATE TABLE `devops_server`  (
  `id` bigint(0) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `admin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `admin_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `admin_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `system_flag1` tinyint(1) NULL DEFAULT 0 COMMENT '标识是否系统自带gitlab',
  `system_flag` tinyint(1) NULL DEFAULT 0 COMMENT '标识是否系统自带gitlab',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID,用于对接租户自建Gitlab',
  `tenant_default` tinyint(0) NULL DEFAULT 0 COMMENT '是否是租户默认',
  `external_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '外部访问地址',
  `external_ssh_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '对外暴露的ssh地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_setting
-- ----------------------------
DROP TABLE IF EXISTS `devops_setting`;
CREATE TABLE `devops_setting`  (
  `id` bigint(0) NOT NULL COMMENT '自增主键',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '设置标识',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态：0-关闭，1-开启',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `value` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '配置值',
  `del_flag` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  `flag` int(0) NULL DEFAULT 0 COMMENT '变更状态：0-未变更，1-变更中',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_user_token
-- ----------------------------
DROP TABLE IF EXISTS `devops_user_token`;
CREATE TABLE `devops_user_token`  (
  `id` bigint(0) NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `del_flag` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `server_username_uqidx`(`server_id`, `username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_webhook_token
-- ----------------------------
DROP TABLE IF EXISTS `devops_webhook_token`;
CREATE TABLE `devops_webhook_token`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `gitlab_id` int(0) NOT NULL COMMENT '服务器id',
  `hook_id` int(0) NOT NULL COMMENT 'webhook的Id',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'webhook的token',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_commit_relation
-- ----------------------------
DROP TABLE IF EXISTS `project_commit_relation`;
CREATE TABLE `project_commit_relation`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `task_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求任务编码',
  `commit_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提交ID',
  `server_id` bigint(0) NULL DEFAULT NULL COMMENT 'gitlab serverId',
  `gitlab_id` int(0) NOT NULL COMMENT '代码库ID',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `commit_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交人名称',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `task_code_idx`(`task_code`) USING BTREE,
  INDEX `commit_id_idx`(`commit_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3769884946804154369 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tenant_group_relation
-- ----------------------------
DROP TABLE IF EXISTS `tenant_group_relation`;
CREATE TABLE `tenant_group_relation`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_id` bigint(0) NOT NULL COMMENT '租户ID',
  `group_id` int(0) NOT NULL COMMENT 'gitlab groupId',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  `group_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'CONFIG or CODE',
  `group_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'gitlab group full path',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_tenant_x_group_server`(`tenant_id`, `group_id`, `server_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tenant_project_relation
-- ----------------------------
DROP TABLE IF EXISTS `tenant_project_relation`;
CREATE TABLE `tenant_project_relation`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_id` bigint(0) NOT NULL COMMENT '租户ID',
  `project_id` int(0) NOT NULL COMMENT 'gitlab project_id',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `server_id` bigint(0) NULL DEFAULT NULL,
  `project_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'gitlab project full path',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenant_x_project`(`tenant_id`, `project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4186860468722782209 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
