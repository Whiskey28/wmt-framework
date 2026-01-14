/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_repository

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:31:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for devops_product
-- ----------------------------
DROP TABLE IF EXISTS `devops_product`;
CREATE TABLE `devops_product`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `repo_id` bigint(0) NULL DEFAULT NULL COMMENT '制品库表id，外键（devops_repository.id）',
  `repo_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品库名称(冗余)',
  `format` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品格式 tar.gz;zip;yaml;image',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品路径',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本',
  `parent_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父版本：通用制品中parent_version=path=product_version',
  `config_id` bigint(0) NULL DEFAULT NULL COMMENT '组件配置id',
  `version_timestamp` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本时间戳',
  `product_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品实际版本',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'devops平台生成的md5',
  `file_size` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '制品大小',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `last_download` datetime(0) NULL DEFAULT NULL COMMENT '最后下载时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0否 1是',
  `backup_flag` tinyint(1) NULL DEFAULT 0 COMMENT '同步标志位，0-未同步，1-已同步',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2014 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品信息主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_product_metadata_cache
-- ----------------------------
DROP TABLE IF EXISTS `devops_product_metadata_cache`;
CREATE TABLE `devops_product_metadata_cache`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `cache_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缓存类型',
  `cache_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'id',
  `metadata` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '元数据',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` tinyint(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '元数据缓存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_product_package_metadata
-- ----------------------------
DROP TABLE IF EXISTS `devops_product_package_metadata`;
CREATE TABLE `devops_product_package_metadata`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(0) NULL DEFAULT NULL COMMENT '制品库id，外键（devops_product.id）',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品版本',
  `promotion_status` int(0) NULL DEFAULT NULL COMMENT '无效字段，兼容旧版本，晋级状态：0-未晋级，1-已晋级',
  `promotion_time` datetime(0) NULL DEFAULT NULL COMMENT '晋级时间',
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线job',
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线构建',
  `env_id` bigint(0) NULL DEFAULT NULL COMMENT '环境id',
  `pms` int(0) NULL DEFAULT 0 COMMENT '0未同步，1已同步',
  `release_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  `image_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '镜像名称',
  `feature_name` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性名称',
  `feature_branch` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '特性分支',
  `merge_branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '合并后分支',
  `pipeline_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流水线名称',
  `project_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `online_time` datetime(0) NULL DEFAULT NULL COMMENT '上线时间',
  `online_status` int(0) NULL DEFAULT NULL COMMENT '上线状态：0：未上线，1：已上线',
  `source` int(0) NULL DEFAULT NULL COMMENT '来源：0：自动生成，1：手动上传',
  `arch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品架构',
  `annotations` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  `test_management` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提测单数据',
  `code_scan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '代码扫描信息',
  `commit_id` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '代码提交id',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（development.devops_system.id）',
  `subsystem_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（development.devops_sub_system.id）',
  `version_timestamp` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本时间戳',
  `feature_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '特性id列表，2.7+版本',
  `issues_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '工作项id列表，2.7+版本',
  `issues_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '工作项名称',
  `metadata` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'metadata通用json数据',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2014 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品元数据信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_promotion_instance
-- ----------------------------
DROP TABLE IF EXISTS `devops_promotion_instance`;
CREATE TABLE `devops_promotion_instance`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `strategy_id` bigint(0) NOT NULL COMMENT '策略id',
  `product_id` bigint(0) NOT NULL COMMENT '制品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '晋级实例关联关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_promotion_node
-- ----------------------------
DROP TABLE IF EXISTS `devops_promotion_node`;
CREATE TABLE `devops_promotion_node`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `strategy_id` bigint(0) NULL DEFAULT NULL COMMENT '策略id',
  `repo_id` bigint(0) NULL DEFAULT NULL COMMENT '制品库id',
  `repo_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '制品库名称',
  `sort` tinyint(0) NULL DEFAULT NULL COMMENT '排序',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `del_flag` tinyint(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '晋级节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_promotion_node_instance
-- ----------------------------
DROP TABLE IF EXISTS `devops_promotion_node_instance`;
CREATE TABLE `devops_promotion_node_instance`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `strategy_id` bigint(0) NULL DEFAULT NULL COMMENT '策略id',
  `node_id` bigint(0) NULL DEFAULT NULL COMMENT '节点id',
  `product_id` bigint(0) NULL DEFAULT NULL COMMENT '制品id',
  `promotion_status` tinyint(0) NOT NULL COMMENT '晋级状态',
  `product_status` tinyint(0) NOT NULL COMMENT '制品状态',
  `repo_id` bigint(0) NULL DEFAULT NULL COMMENT '配置库id',
  `repo_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置库名称',
  `sort` bigint(0) NULL DEFAULT NULL COMMENT '排序',
  `promotion_instance_id` bigint(0) NOT NULL COMMENT '关联信息',
  `err_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `start_time` datetime(0) NULL DEFAULT NULL,
  `end_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '晋级实例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_promotion_strategy
-- ----------------------------
DROP TABLE IF EXISTS `devops_promotion_strategy`;
CREATE TABLE `devops_promotion_strategy`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '策略名称',
  `format` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型，docker、raw',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` tinyint(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '晋级策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository`;
CREATE TABLE `devops_repository`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品库名称',
  `format` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品库格式：maven,npm,docker',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'nexus、harbor',
  `scope` int(0) NULL DEFAULT NULL COMMENT '范围',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '制品库简介',
  `config_id` bigint(0) NULL DEFAULT NULL COMMENT '组件配置id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `repository_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品库类型，hosted，group，proxy',
  `kind` tinyint(0) NULL DEFAULT NULL COMMENT '制品库种类，0->组件库，1->依赖库 2->制品库  3->生产前置库',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目id，外键（devops.project.id）',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id，外键（development.devops_sub_system.id）',
  `tenant_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组织id',
  `create_type` tinyint(0) NULL DEFAULT 0 COMMENT '创建类型 0-自动 1-手动',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id，外键（development.devops_system.id）',
  `system_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统code',
  `sub_system_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子系统编码',
  `env_config_id` int(0) NULL DEFAULT NULL COMMENT '环境配置id，外键（devops_repository_config.id）',
  `version_policy` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本策略：RELEASE；SNAPSHOT',
  `env_id` bigint(0) NULL DEFAULT NULL COMMENT '部署环境id，外键（pipeline.devops_deploy_env.id）',
  `backup_id` bigint(0) NULL DEFAULT NULL COMMENT '备份策略id，外键（devops_repository_backup.id）',
  `clear_id` bigint(0) NULL DEFAULT NULL COMMENT '清理策略id，devops_repository_clear.id',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '逻辑删除标志位：0-正常，1-删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品仓库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository_account
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository_account`;
CREATE TABLE `devops_repository_account`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `repo_id` int(0) NULL DEFAULT NULL COMMENT '制品库id，外键（devops_repository.id）',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'admin管理员账号;push推送权限账号',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '组织id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品库账号信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository_backup
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository_backup`;
CREATE TABLE `devops_repository_backup`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `repo_id` bigint(0) NULL DEFAULT NULL COMMENT '仓库id，外键（devops_repository.id）',
  `backup_flag` tinyint(1) NULL DEFAULT 0 COMMENT '备份开关；0-关闭；1-开启',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '制品备份策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository_clear
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository_clear`;
CREATE TABLE `devops_repository_clear`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `repo_id` bigint(0) NULL DEFAULT NULL COMMENT '仓库id，外键（devops_respository_clear.id）',
  `clear_flag` tinyint(1) NULL DEFAULT 0 COMMENT '备份开关；0-关闭；1-开启',
  `reserved_number` int(0) NULL DEFAULT 0 COMMENT '保留制品个数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '制品库清理策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository_config
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository_config`;
CREATE TABLE `devops_repository_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件名称',
  `repo_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '环境类型:nexus; harbor',
  `arch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品库架构: -/x86/arm三种 -表示不区分',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '制品库地址',
  `auth_type` int(0) NULL DEFAULT 0 COMMENT '认证方式：password/authorization',
  `repo_authorization` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '授权码:password模式为username:password base64加密',
  `component_version` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件版本',
  `is_system` tinyint(0) NULL DEFAULT NULL COMMENT '是否为系统组件',
  `external_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部使用地址',
  `tenant_id` bigint(0) NULL DEFAULT 0 COMMENT '租户id',
  `del_flag` tinyint(0) NULL DEFAULT NULL COMMENT '逻辑删除标志位：0-正常，1-删除',
  `create_time` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_time` timestamp(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10002 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组件环境配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository_env
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository_env`;
CREATE TABLE `devops_repository_env`  (
  `id` int(0) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '环境名称',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '环境code',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序值',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '组织id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品环境表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_repository_env_config
-- ----------------------------
DROP TABLE IF EXISTS `devops_repository_env_config`;
CREATE TABLE `devops_repository_env_config`  (
  `id` int(0) NOT NULL,
  `repo_env_id` int(0) NULL DEFAULT NULL COMMENT '制品库环境表id，devops_repository_env.id',
  `repo_config_id` int(0) NULL DEFAULT NULL COMMENT '制品库配置表id, devops_repository_config.id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '环境配置关联关系表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
