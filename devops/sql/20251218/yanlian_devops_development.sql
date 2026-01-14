/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_development

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:31:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for autotest_management
-- ----------------------------
DROP TABLE IF EXISTS `autotest_management`;
CREATE TABLE `autotest_management`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自动化测试编号',
  `test_code_ids` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '版本测试单id列表',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '自动化测试描述',
  `test_status` tinyint(0) NULL DEFAULT NULL COMMENT '测试状态：1-待测试，2-测试中，5-测试结束',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `director_id` bigint(0) NULL DEFAULT NULL COMMENT '测试负责人id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '提交时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '逻辑删除标志位：0-未删除，1-删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自动化测试管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for build_instance
-- ----------------------------
DROP TABLE IF EXISTS `build_instance`;
CREATE TABLE `build_instance`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id,外键（devops_system.id）',
  `stage_env_id` bigint(0) NULL DEFAULT NULL COMMENT '阶段环境id，外键（devops_stage_env.id）',
  `version_id` bigint(0) NULL DEFAULT NULL COMMENT '版本id，外键（version_instance.id）',
  `major_version_id` bigint(0) NULL DEFAULT NULL COMMENT '版本id',
  `merge_id` bigint(0) NULL DEFAULT NULL COMMENT '分支合并器分组id, 外键（scm.devops_merge_task_group.id）',
  `merge_task_id` bigint(0) NULL DEFAULT NULL COMMENT '分支合并器 合并实例id，外键（scm.devops_merge_task.id）',
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线job id，外键（pipeline.devops_jenkins_job.id）',
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT 'job build id，外键（pipeline.devops_job_build_info.id）',
  `features` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '特性列表列表，devops_feature.id',
  `source_branches` varchar(4096) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '源分支信息',
  `build_branch` bigint(0) NULL DEFAULT NULL COMMENT '构建分支',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '环境构建实例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_feature
-- ----------------------------
DROP TABLE IF EXISTS `devops_feature`;
CREATE TABLE `devops_feature`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL COMMENT '跟踪事项id，外键（track-issus.issues.id）',
  `feature_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性名称',
  `feature_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '特性描述',
  `feature_type` tinyint(0) NULL DEFAULT NULL COMMENT '特性类型：0-特性，缺陷',
  `branch_model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'CONTROLLED' COMMENT '分支模型：分支模型 GENERAL-普通   CONTROLLED-受控',
  `feature_status` tinyint(0) NULL DEFAULT NULL COMMENT '特性状态：0-开发中；1-已完成；2-测试中；3-已发布；4-测试我那成；5-已清理',
  `event_no` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '缺陷编号',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `feature_project_id` bigint(0) NULL DEFAULT NULL COMMENT '特性项目id，外键（devops.project.id）',
  `project_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性项目名称',
  `complete_data` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性完成时间',
  `feature_number` int(0) NULL DEFAULT NULL COMMENT '特性编号',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `source` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源 0-自有；1-巨像',
  `director` bigint(0) NULL DEFAULT NULL COMMENT '负责人',
  `branch_desc` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性分支描述',
  `integration_flag` tinyint(0) NULL DEFAULT NULL COMMENT '是否参与集成：0-不参与；1-参与',
  `feature_code` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性编码',
  `del_flag` tinyint(0) NULL DEFAULT NULL COMMENT '逻辑删除标志位：0-不删除；1-删除',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `clear_flag` tinyint(0) NULL DEFAULT 0 COMMENT '清理标志位：0-不清理，1-待清理，2-已清理',
  `release_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '特性管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_stage
-- ----------------------------
DROP TABLE IF EXISTS `devops_stage`;
CREATE TABLE `devops_stage`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `stage_dict_id` bigint(0) NULL DEFAULT NULL COMMENT '阶段字典id，外键（system_dict.id）',
  `env_id` int(0) NULL DEFAULT NULL COMMENT '部署环境id，外键（pipeline.devops_deploy_env.id）',
  `sort` tinyint(0) NULL DEFAULT NULL COMMENT '排序',
  `config_status` tinyint(0) NULL DEFAULT NULL COMMENT '配置状态：0-未配置；1-已配置；2-已跳过',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简介',
  `raw_repo_id` bigint(0) NULL DEFAULT NULL COMMENT '通用制品库id，外键（repository.devops_respository.id）',
  `container_repo_id` bigint(0) NULL DEFAULT NULL COMMENT '容器制品库id，外键（repository.devops_repository.id）',
  `stage_name` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阶段名称',
  `access_feature_status` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '准入功能分支',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 403 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '子系统阶段配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_stage_env
-- ----------------------------
DROP TABLE IF EXISTS `devops_stage_env`;
CREATE TABLE `devops_stage_env`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `stage_id` bigint(0) NULL DEFAULT NULL COMMENT '阶段id，外键（devops_stage.id）',
  `stage_dict_id` bigint(0) NULL DEFAULT NULL COMMENT '阶段字典id，外键（system_dict.id）',
  `env_name` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '环境名称',
  `stage_env_code` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阶段环境编码',
  `deploy_type` tinyint(0) NULL DEFAULT NULL COMMENT '部署类型：1-虚拟机；4-k8s类型',
  `cluster_id` int(0) NULL DEFAULT NULL COMMENT '容器资源，环境管理集群资源id，外键（pipeline.devops_deploy_host.id）',
  `namespace` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群命名空间',
  `host_id` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主机资源，环境管理主机资源id，外键（pipeline.devops_deploy_host.id）',
  `address` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '环境访问地址',
  `del_flag` tinyint(0) NULL DEFAULT NULL COMMENT '逻辑删除标志位：0-不删除；1-删除',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '子系统阶段环境信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_stage_env_feature
-- ----------------------------
DROP TABLE IF EXISTS `devops_stage_env_feature`;
CREATE TABLE `devops_stage_env_feature`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `stage_env_id` bigint(0) NULL DEFAULT NULL COMMENT '阶段环境id，外表（devops_stage_env.id）',
  `feature_id` bigint(0) NULL DEFAULT NULL COMMENT '特性id，外表（devops_feature.id）',
  `version_id` bigint(0) NULL DEFAULT NULL COMMENT '版本id，外表（devops_version.id）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '阶段环境特性关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_sub_system
-- ----------------------------
DROP TABLE IF EXISTS `devops_sub_system`;
CREATE TABLE `devops_sub_system`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL COMMENT '跟踪事项id，外键（track-issues.issues.id）',
  `full_name_cn` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子系统中文全称',
  `name_cn` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子系统中文简称',
  `sub_code` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子系统编码',
  `sub_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子系统英文全称',
  `sub_desc_cn` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子系统描述',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `tech_director` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开发负责人',
  `ops_director` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运维负责人',
  `run_level` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '重要等级',
  `project_info` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工程信息',
  `busi_dept` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务部门',
  `projectdirectorid` bigint(0) NULL DEFAULT NULL COMMENT '负责人id',
  `ops_director_id` bigint(0) NULL DEFAULT NULL COMMENT '运维负责人id',
  `tech_director_id` bigint(0) NULL DEFAULT NULL COMMENT '开发负责人id',
  `out_code` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '英文编码',
  `source` tinyint(0) NULL DEFAULT NULL COMMENT '来源 0-自有；1-巨像',
  `technology` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '技术栈',
  `del_flag` tinyint(0) NULL DEFAULT NULL COMMENT '逻辑删除标志位：0-不删除；1-删除',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 453 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '子系统表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_system
-- ----------------------------
DROP TABLE IF EXISTS `devops_system`;
CREATE TABLE `devops_system`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL COMMENT '跟踪事项id，外键（track-issues.issues.id）',
  `sys_name_cn` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统中文简称',
  `sys_code` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统编码',
  `sys_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统英文全称',
  `sys_desc_cn` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统描述',
  `tech_dept` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开发部门',
  `busi_dept` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务部门',
  `director` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人名称',
  `architect` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '架构师',
  `source` tinyint(0) NULL DEFAULT NULL COMMENT '来源：0-自有；1-巨像',
  `admin_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统管理员id',
  `admin_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统管理员名称',
  `online_time` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上线时间',
  `sub_full_name_cn` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统中文名全称',
  `branch_model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'GENERAL' COMMENT '分支模型：分支模型 GENERAL-普通   CONTROLLED-受控',
  `projectdirector` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目负责人',
  `projectdirectorid` bigint(0) NULL DEFAULT NULL COMMENT '项目负责人id',
  `directorid` bigint(0) NULL DEFAULT NULL COMMENT '负责人id',
  `architectid` bigint(0) NULL DEFAULT NULL COMMENT '架构师id',
  `del_flag` tinyint(0) NULL DEFAULT NULL COMMENT '逻辑删除标志位：0-不删除；1-删除',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `top_sort` int(0) NULL DEFAULT 0 COMMENT '置顶排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 175 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for feature_branch
-- ----------------------------
DROP TABLE IF EXISTS `feature_branch`;
CREATE TABLE `feature_branch`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `branch_model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'CONTROLLED' COMMENT '分支模型：分支模型 GENERAL-普通   CONTROLLED-受控',
  `branch_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分支名称',
  `branch_dev_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分支类型',
  `code_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '代码库名称',
  `feature_id` bigint(0) NOT NULL COMMENT '特性任务id，外键（devops_feature.id）',
  `sub_system_id` bigint(0) NOT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `del_flag` tinyint(1) NULL DEFAULT NULL COMMENT '删除标志，0正常，1逻辑删除',
  `source_ref` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源ref',
  `source_commit` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源commitId',
  `clear_commit` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '清理时 commit',
  `clear_dev_commit` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '清理时开发分支 commit',
  `is_clear` tinyint(0) NULL DEFAULT NULL COMMENT '0-否  1-是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '特性关联分支表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for feature_label
-- ----------------------------
DROP TABLE IF EXISTS `feature_label`;
CREATE TABLE `feature_label`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `instance_id` bigint(0) NULL DEFAULT NULL COMMENT '实例id',
  `label_id` bigint(0) NULL DEFAULT NULL COMMENT '标签id，外键（amp.sys_tag.id）',
  `classification_code` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类编码：feature-特性；development-system-研发协同系统；',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '特性标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for feature_star
-- ----------------------------
DROP TABLE IF EXISTS `feature_star`;
CREATE TABLE `feature_star`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `feature_id` bigint(0) NULL DEFAULT NULL COMMENT '特性id，外键（devops_feature.id）',
  `user_id` bigint(0) NULL DEFAULT NULL COMMENT '用户id',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '特性收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for feature_status
-- ----------------------------
DROP TABLE IF EXISTS `feature_status`;
CREATE TABLE `feature_status`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `feature_id` bigint(0) NOT NULL COMMENT '特性id，外键（devops_feature.id）',
  `context` enum('sit','uat','main') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境',
  `develop_status` tinyint(1) NULL DEFAULT NULL COMMENT '开发测试状态：0-开发中；1-开发完成。',
  `test_status` tinyint(1) NULL DEFAULT NULL COMMENT '测试状态：0-测试中；1-测试完成',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序字段',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` tinyint(1) NULL DEFAULT NULL COMMENT '删除标志，0正常，1逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UNIONKEY`(`feature_id`, `context`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '特性测试状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for feature_task
-- ----------------------------
DROP TABLE IF EXISTS `feature_task`;
CREATE TABLE `feature_task`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `feature_id` bigint(0) NULL DEFAULT NULL COMMENT '特性id，外键（devops_feature.id）',
  `task_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作项编号, 外键（track-issues.issues.id）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自动化测试管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for major_version
-- ----------------------------
DROP TABLE IF EXISTS `major_version`;
CREATE TABLE `major_version`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `sub_system_id` bigint(0) NOT NULL COMMENT '子系统id',
  `director_id` bigint(0) NULL DEFAULT NULL COMMENT '负责人id',
  `version_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大版本号',
  `sub_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子版本号',
  `version_status` tinyint(0) NULL DEFAULT NULL COMMENT '0-未开始；1-开发中；2-测试中；3-已发布',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `description` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本简介',
  `del_flag` tinyint(1) NULL DEFAULT NULL COMMENT '逻辑删除，0代表未删除，1已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 268 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '大版本' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for online_order
-- ----------------------------
DROP TABLE IF EXISTS `online_order`;
CREATE TABLE `online_order`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `online_name` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '检修单名称',
  `build_instance_id` bigint(0) NULL DEFAULT NULL COMMENT '构建实例id，外键（build_instance.id）',
  `online_code` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '检修单编码',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '检修开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '检修结束时间',
  `influence_scope` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '影响范围',
  `description` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '检修原因',
  `apply_status` tinyint(0) NULL DEFAULT NULL COMMENT '审批状态：0-草稿；1-审批中；2-审批通过；3-已撤回；4-已驳回',
  `online_status` tinyint(0) NULL DEFAULT NULL COMMENT '检修状态：1-待检修；2-检修中；3-检修成功；4-检修失败；5-检修取消',
  `del_flag` tinyint(0) NULL DEFAULT NULL COMMENT '逻辑删除标志位：0-不删除；1-删除',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '检修单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for online_order_feature
-- ----------------------------
DROP TABLE IF EXISTS `online_order_feature`;
CREATE TABLE `online_order_feature`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(0) NULL DEFAULT NULL COMMENT '上机单id， 外键（online_order.id）',
  `feature_id` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '特性id， 外键（devops_feature.id）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '检修单关联特性' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for online_order_subsystem
-- ----------------------------
DROP TABLE IF EXISTS `online_order_subsystem`;
CREATE TABLE `online_order_subsystem`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(0) NULL DEFAULT NULL COMMENT '上机单id，外键（online_order.id）',
  `subsystem_id` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '系统id，外键（devops_sub_system.id）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '检修单关联系统' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for product_promotion_strategy
-- ----------------------------
DROP TABLE IF EXISTS `product_promotion_strategy`;
CREATE TABLE `product_promotion_strategy`  (
  `strategy_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '策略id',
  `strategy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '策略名称',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `env_id_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境id的列表',
  PRIMARY KEY (`strategy_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品晋级策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_management
-- ----------------------------
DROP TABLE IF EXISTS `project_management`;
CREATE TABLE `project_management`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '项目名称',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目管理id，外键（devops.project.id）',
  `sub_system_id` bigint(0) NOT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `system_id` bigint(0) NOT NULL COMMENT '系统id，外键（devops_system.id）',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '项目描述',
  `status` tinyint(0) NULL DEFAULT 0 COMMENT '项目状态：0-进行中，1-已完成',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '项目开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '项目结束时间',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '逻辑删除标志位：0-未删除；1-删除。',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `director_id` bigint(0) NULL DEFAULT NULL COMMENT '负责人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '项目管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `role_id` bigint(0) NULL DEFAULT NULL COMMENT '角色id，外键（amp.sys_role.id）',
  `permission_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限编码',
  `check_flag` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否有权限：0-没有；1-有',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '初始化角色权限配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scm_merge_resource
-- ----------------------------
DROP TABLE IF EXISTS `scm_merge_resource`;
CREATE TABLE `scm_merge_resource`  (
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `env_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '环境编码',
  `feature_id` bigint(0) NULL DEFAULT NULL COMMENT '特性id，外键（devops_feature.id）',
  `branch_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分支名称',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目id，外键（devops.project.id）'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '测试环境代码合并关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for scm_merge_task
-- ----------------------------
DROP TABLE IF EXISTS `scm_merge_task`;
CREATE TABLE `scm_merge_task`  (
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `env_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '环境编码',
  `merge_type` int(0) NULL DEFAULT NULL COMMENT '0-表示分支合并器，1-合并审批',
  `merge_task_id` bigint(0) NULL DEFAULT NULL COMMENT '分支合并器id，外键（scm.devops_merge_task.id）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '阶段环境分支合器关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sub_system_component
-- ----------------------------
DROP TABLE IF EXISTS `sub_system_component`;
CREATE TABLE `sub_system_component`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件名称',
  `component_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件唯一键',
  `key_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '唯一键类型',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志位：0-有效；1-删除',
  `old_component_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '老组件唯一键',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 430 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '子系统组件信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sub_system_config
-- ----------------------------
DROP TABLE IF EXISTS `sub_system_config`;
CREATE TABLE `sub_system_config`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '应用id',
  `clear_temporary_branch_flag` tinyint(1) NULL DEFAULT NULL COMMENT '是否清理临时分支：0-关闭；1-清理',
  `clear_temporary_branch_time` int(0) NULL DEFAULT NULL COMMENT '清理时间:单位 天',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '应用配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sub_system_env
-- ----------------------------
DROP TABLE IF EXISTS `sub_system_env`;
CREATE TABLE `sub_system_env`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `env_id` int(0) NULL DEFAULT NULL COMMENT '环境名称，外表（pipeline.devops_deploy_env.id）',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '子系统环境表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sub_system_pipeline
-- ----------------------------
DROP TABLE IF EXISTS `sub_system_pipeline`;
CREATE TABLE `sub_system_pipeline`  (
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `pipeline_job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线jobid，外键（devops_jenkind_job.id）',
  `view_type` tinyint(1) NULL DEFAULT 0 COMMENT '展示类型；0-子系统展示；1-工作台展示',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '子系统流水线关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sub_system_variable
-- ----------------------------
DROP TABLE IF EXISTS `sub_system_variable`;
CREATE TABLE `sub_system_variable`  (
  `id` bigint(0) NOT NULL COMMENT '自增主键',
  `e_id` bigint(0) NULL DEFAULT NULL COMMENT '环境id，外键（sub_system_env.id）',
  `var_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变量值',
  `var_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变量key',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `relate_id` int(0) NULL DEFAULT NULL COMMENT '关联id，外键（pipeline.devops_jenkins_job.id）',
  `default_flag` tinyint(1) NULL DEFAULT 0 COMMENT '是否环境默认变量',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '子系统环境变量表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_component
-- ----------------------------
DROP TABLE IF EXISTS `system_component`;
CREATE TABLE `system_component`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件名称',
  `component_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件唯一key',
  `key_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '唯一键类型',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '逻辑删除标志位：0-有效；1-删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统组件表，存储系统和其他组件的关联关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_dict
-- ----------------------------
DROP TABLE IF EXISTS `system_dict`;
CREATE TABLE `system_dict`  (
  `id` bigint(0) NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典分类',
  `dict_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典编码',
  `dict_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典名称',
  `dict_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典类型',
  `dict_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典值',
  `dict_sort` int(0) NULL DEFAULT NULL COMMENT '字典排序',
  `dict_customize_param` json NULL COMMENT '字典自定义字段',
  `description` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简介',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_file
-- ----------------------------
DROP TABLE IF EXISTS `system_file`;
CREATE TABLE `system_file`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `file_subject` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属分类',
  `subject_key` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类主键',
  `save_type` tinyint(0) NULL DEFAULT NULL COMMENT '保存类型 1：minio',
  `server_url` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务地址',
  `bucket` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分组',
  `file_key` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件id',
  `file_name` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_project
-- ----------------------------
DROP TABLE IF EXISTS `system_project`;
CREATE TABLE `system_project`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目id',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 215 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统项目关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_management
-- ----------------------------
DROP TABLE IF EXISTS `test_management`;
CREATE TABLE `test_management`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `test_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试记录编号',
  `patch_number` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '补丁号（拼接环境测试编号后）',
  `test_env` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试环境',
  `component_ids` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'main环境为version_instance_id,其他环境为feature_id，以“,”分割',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（devops_sub_system.id）',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `director_id` bigint(0) NULL DEFAULT NULL COMMENT '测试负责人id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '提测时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `test_status` tinyint(0) NULL DEFAULT NULL COMMENT '环境测试状态:待测试=1,测试中=2,测试通过=3,测试失败=4',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标志：0-未删,1-已删',
  `test_env_vm` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试环境（虚机）',
  `test_env_container` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试环境（容器）',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试描述',
  `sql_update_flag` tinyint(0) NULL DEFAULT 0 COMMENT '涉及sql更新标识：0-不更新，1-更新',
  `autotest_flag` tinyint(0) NULL DEFAULT 0 COMMENT '是否开启自动化测试：0-不开启；1-开启',
  `test_result` tinyint(0) NULL DEFAULT 1 COMMENT '测试结果：3-测试成功，4-测试失败',
  `test_result_description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试结果描述',
  `promotion_status` tinyint(0) NULL DEFAULT 0 COMMENT '制品自动晋级：0-关闭，1-开启',
  `test_report_urls` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试报告urls（多个URL用逗号分隔）',
  `stage_env_id` bigint(0) NULL DEFAULT NULL COMMENT '阶段环境id',
  `build_instance_id` bigint(0) NULL DEFAULT NULL COMMENT '协同实例id',
  `manual_result` tinyint(0) NULL DEFAULT NULL COMMENT '手动测试结果',
  `autotest_result` tinyint(0) NULL DEFAULT NULL COMMENT '自动测试结果',
  `manual_report` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手动测试文件',
  `autotest_report` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自动化测试文件',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '测试管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_management_env_status
-- ----------------------------
DROP TABLE IF EXISTS `test_management_env_status`;
CREATE TABLE `test_management_env_status`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `test_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试单号',
  `test_status` tinyint(0) NULL DEFAULT 1 COMMENT '测试状态：1-待测试，2-测试中，5，测试结束',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '提测单环境状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for version_component
-- ----------------------------
DROP TABLE IF EXISTS `version_component`;
CREATE TABLE `version_component`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id',
  `version_id` bigint(0) NULL DEFAULT NULL COMMENT '版本id',
  `component` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组成类型',
  `component_key` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件id',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `subordination` bigint(0) NULL DEFAULT NULL COMMENT '从属于',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本组件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for version_instance
-- ----------------------------
DROP TABLE IF EXISTS `version_instance`;
CREATE TABLE `version_instance`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `sub_version_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子版本名称',
  `sub_patch_number` bigint(0) NULL DEFAULT NULL COMMENT '补丁号，注意子版本号与补丁号需要/衔接',
  `version_id` bigint(0) NULL DEFAULT NULL COMMENT '版本id，外键（version_management.id）',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '所属子系统id，外键（devops_sub_system.id）',
  `pipeline_job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线id，外键（pipeline.devops_jenkins_job.id）',
  `pipeline_build_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线构建实例id，外键（pipeline.devops_job_build_info.id）',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本实例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for version_management
-- ----------------------------
DROP TABLE IF EXISTS `version_management`;
CREATE TABLE `version_management`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `sub_system_id` bigint(0) NOT NULL COMMENT '所属子系统id，外键（devops_sub_system.id）',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（devops_system.id）',
  `director_id` bigint(0) NULL DEFAULT NULL COMMENT '负责人id',
  `major_version_id` bigint(0) NOT NULL COMMENT '大版本id',
  `version_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大版本号',
  `sub_version_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子版本号',
  `total_version_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼接版本号',
  `version_type` tinyint(0) NULL DEFAULT 1 COMMENT '类型：1-日期版本；2自定义版本号',
  `patch_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '补丁号',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `version_status` tinyint(0) NULL DEFAULT NULL COMMENT '版本状态，0-未开始；1-开发中；2-测试中；3-已发布',
  `switch_status` tinyint(0) NULL DEFAULT NULL COMMENT '版本开启或关闭（0版本开启，1版本关闭）',
  `update_area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新区域',
  `update_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新类型',
  `delete_status` tinyint(1) NULL DEFAULT NULL COMMENT '逻辑删除，0代表未删除，1已删除',
  `tar_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '普通包名',
  `yaml_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'yaml包名',
  `description` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本简介',
  `release_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 268 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本信息主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for version_promotion
-- ----------------------------
DROP TABLE IF EXISTS `version_promotion`;
CREATE TABLE `version_promotion`  (
  `version_instance_id` bigint(0) NULL DEFAULT NULL COMMENT '版本实例id，外键（version_instance.id）',
  `promotion_strategy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '晋级策略'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本实例晋级策略表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
