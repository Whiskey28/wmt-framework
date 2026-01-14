/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_dop_pipeline

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:31:54
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for devops_access_controller
-- ----------------------------
DROP TABLE IF EXISTS `devops_access_controller`;
CREATE TABLE `devops_access_controller`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(0) NOT NULL COMMENT '表devops_jenkins_job的id',
  `build_number` int(0) NOT NULL COMMENT '构建次数',
  `input_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '卡点的id',
  `time_out` int(0) NULL DEFAULT NULL COMMENT '超时时间',
  `notify_user` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '通知人员',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '状态 0-开启 1-关闭',
  `notify_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '通知状态 0-没有通知 1-已经通知 2-通知失败',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '门禁控制表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_agent_image
-- ----------------------------
DROP TABLE IF EXISTS `devops_agent_image`;
CREATE TABLE `devops_agent_image`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `e_id` int(0) NOT NULL COMMENT '表devops_env_info的id',
  `image_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '镜像名称',
  `image_describe` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `image_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '镜像地址',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '修改人',
  `tenant_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'agent镜像列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_agent_template
-- ----------------------------
DROP TABLE IF EXISTS `devops_agent_template`;
CREATE TABLE `devops_agent_template`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `template_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `remark` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '镜像名称',
  `template_yaml` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模板yaml',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'agent模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_build_deploy_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_build_deploy_rel`;
CREATE TABLE `devops_build_deploy_rel`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '表devops_jenkins_job的id',
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '表devops_job_build_info的id',
  `start_time` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开始时间',
  `deploy_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部署类型',
  `stage_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部署所属阶段（暂时未使用）',
  `product_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部署所关联的制品',
  `deploy_env` int(0) NULL DEFAULT NULL COMMENT '部署环境',
  `host_id` varchar(400) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部署的主机或者集群（逗号分隔）',
  `deploy_from` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上传文件',
  `deploy_to` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上传的目录',
  `command` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '部署执行的命令',
  `status` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `resource_info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '配置文件信息',
  `descript` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `namespace` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称空间',
  `deploy_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部署名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2820 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_build_report_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_build_report_rel`;
CREATE TABLE `devops_build_report_rel`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线运行记录表devops_job_build_info的id',
  `report_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通用报告名称',
  `report_dir` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通用报告路径',
  `report_files` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通用报告入口文件',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '报告时间',
  `report_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '报告类型0-jenkins报告 1-代码扫描报告 2-依赖分析报告 3-制品分析报告',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流水线构建记录与通用报告关联信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_build_sonar_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_build_sonar_rel`;
CREATE TABLE `devops_build_sonar_rel`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '构建id',
  `server_id` bigint(0) NULL DEFAULT NULL,
  `gitlab_id` int(0) NULL DEFAULT NULL,
  `standard_task_id` bigint(0) NULL DEFAULT NULL,
  `standard_history_id` bigint(0) NULL DEFAULT NULL,
  `vulne_task_id` bigint(0) NULL DEFAULT NULL,
  `vulne_history_id` bigint(0) NULL DEFAULT NULL,
  `sensit_task_id` bigint(0) NULL DEFAULT NULL,
  `sensit_history_id` bigint(0) NULL DEFAULT NULL,
  `dependency_id` bigint(0) NULL DEFAULT NULL COMMENT '依赖分析id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 259 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_build_stage_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_build_stage_rel`;
CREATE TABLE `devops_build_stage_rel`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '表devops_job_build_info的id',
  `stage_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阶段名称',
  `stage_type` tinyint(1) NULL DEFAULT NULL COMMENT 'stage的失败消息类型 1-merge失败',
  `stage_message` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'stage的失败具体展示字段',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流水线stage的对外失败消息展示表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_credentials
-- ----------------------------
DROP TABLE IF EXISTS `devops_credentials`;
CREATE TABLE `devops_credentials`  (
  `ID` int(0) NOT NULL AUTO_INCREMENT COMMENT 'credetials的自增id',
  `PROJECT_ID` int(0) NULL DEFAULT NULL COMMENT '组织id（暂时未使用）',
  `CREDENTIAL_NAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证名称',
  `CREDENTIAL_ID` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证id',
  `CREDENTIAL_TYPE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证类型， 0用户名密码,1ssh，2、token类型 3、kubeconfig类型',
  `CREDENTIAL_DESC` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证描述',
  `NAME` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '用户名密码凭据的或者ssh凭据的用户名称',
  `PASSWORD` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '用户名密码凭据的密码，ssh凭据的私匙，token凭据的token，kubeconfig凭据的kubeconfig文件内容（会进行RSA对称加密）',
  `CREATE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `created_by` bigint(0) NULL DEFAULT NULL COMMENT '用户id',
  `updated_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `UPDATE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `TENANT_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '租户',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 130 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '构建环境和部署环境凭证表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_deploy_cluster
-- ----------------------------
DROP TABLE IF EXISTS `devops_deploy_cluster`;
CREATE TABLE `devops_deploy_cluster`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键自增id',
  `cluster_id` int(0) NOT NULL COMMENT '集群id',
  `token` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'token信息（已经废弃，token信息加密存放在表devops_credentials）',
  `namespace` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'namespace',
  `openshift_image_repository_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'openshift内部的镜像仓库地址',
  `env_id` int(0) NULL DEFAULT NULL COMMENT '环境id',
  `container_id` int(0) NULL DEFAULT NULL COMMENT '环境id',
  `container_cluster_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '集群id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '保存集群的拓展信息(token,namespace)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_deploy_env
-- ----------------------------
DROP TABLE IF EXISTS `devops_deploy_env`;
CREATE TABLE `devops_deploy_env`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '环境名称',
  `created_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `created_by` bigint(0) NULL DEFAULT NULL COMMENT '用户id',
  `updated_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `project_id` int(0) NULL DEFAULT NULL COMMENT '项目Id（未使用）',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `tenant_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '租户',
  `credential_id` int(0) NULL DEFAULT NULL COMMENT '表devops_credentials的id（暂时废弃）',
  `env_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '环境编码',
  `system_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '研发协同的系统id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部署资源环境表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_deploy_host
-- ----------------------------
DROP TABLE IF EXISTS `devops_deploy_host`;
CREATE TABLE `devops_deploy_host`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `port` int(0) NULL DEFAULT 22 COMMENT '端口',
  `type` tinyint(0) NULL DEFAULT NULL COMMENT '资源类型，见devops_lov:type=1',
  `app_id` int(0) NULL DEFAULT NULL COMMENT '应用id（未使用）',
  `credential_id` int(0) NULL DEFAULT NULL COMMENT '凭据表devops_credentials的id',
  `env_id` int(0) NULL DEFAULT NULL COMMENT '部署环境表devops_deploy_env的id',
  `created_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `created_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `updated_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `pwd_type` tinyint(0) NOT NULL DEFAULT 4 COMMENT '密码类型0-用户名密码1-ssh2-token3-kubeconfig4-凭据',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部署环境下的资源信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_env_info
-- ----------------------------
DROP TABLE IF EXISTS `devops_env_info`;
CREATE TABLE `devops_env_info`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `env_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '环境名称',
  `url` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'jenkins地址',
  `jenkins_type` tinyint(0) NULL DEFAULT 0 COMMENT '类型：0:NORMAL 1:K8S',
  `env_detail` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '环境详情',
  `jenkins_user` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'jenkins用户名（已废弃，改为使用凭据）',
  `jenkins_passwd` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'jenkins密码（已废弃，改为使用凭据）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `jenkins_credential_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '凭据表devops_credentials的id，关联jenkins用户名密码',
  `tenant_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '构建环境信息主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_env_variable
-- ----------------------------
DROP TABLE IF EXISTS `devops_env_variable`;
CREATE TABLE `devops_env_variable`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `e_id` int(0) NOT NULL COMMENT '部署环境表devops_env_info的id',
  `var_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '变量key',
  `var_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变量值',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变量描述',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `default_flag` tinyint(0) NULL DEFAULT NULL COMMENT '删除标志',
  `container_id` int(0) NULL DEFAULT NULL COMMENT '容器id（暂未使用）',
  `harbor_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'harbor仓库id（暂未使用）',
  `is_relate_container` tinyint(0) NULL DEFAULT NULL COMMENT '是否关联容器（暂未使用）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '构建环境变量管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_free_point
-- ----------------------------
DROP TABLE IF EXISTS `devops_free_point`;
CREATE TABLE `devops_free_point`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线id',
  `job_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流水线名称',
  `build_id` bigint(0) NULL DEFAULT NULL COMMENT '构建id',
  `run_user` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '运行人',
  `confirmor` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '确认人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '卡点数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkins_agent_cache
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkins_agent_cache`;
CREATE TABLE `devops_jenkins_agent_cache`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线表devops_jenkins_job的id',
  `depend_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'pvc名称',
  `depend_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '挂载到构建镜像的路径',
  `open_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缓存是否开启0-关闭1-开启',
  `cache_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '缓存类型1-自定义2-maven2-gradle3-npm5-yarn',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_cache_jobid_dependname`(`job_id`, `depend_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 654 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流水线的缓存关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkins_build
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkins_build`;
CREATE TABLE `devops_jenkins_build`  (
  `id` bigint(0) NOT NULL,
  `job_id` bigint(0) NOT NULL COMMENT '流水线 id',
  `build_num` bigint(0) NULL DEFAULT NULL COMMENT '流水线构建id',
  `DURATION` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '持续时长',
  `BUILD_ON` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开始时间',
  `TRIGGERS` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '触发人',
  `RESULT` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '构建结果',
  `jenkins_id` bigint(0) NULL DEFAULT 0 COMMENT '流水新表devops_jenkins_job的id',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Job构建记录（已经废弃，下版本删除）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkins_credentials
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkins_credentials`;
CREATE TABLE `devops_jenkins_credentials`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `env_id` int(0) NOT NULL COMMENT '构建环境devops_env_info的id',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码（已废弃）',
  `credentials_id` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'jenkins生成的凭证',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '基于用户名密码克隆在jenkins创建的凭证管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkins_job
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkins_job`;
CREATE TABLE `devops_jenkins_job`  (
  `id` bigint(0) NOT NULL,
  `job_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'job名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `label` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '流水线标签',
  `job_type` tinyint(0) NULL DEFAULT 0 COMMENT '流水线类型0-容器1-固定节点',
  `env_id` bigint(0) NULL DEFAULT 0 COMMENT '构建环境devops_env_info的id',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本（暂未使用）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `tenant` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '租户',
  `system_id` bigint(0) NULL DEFAULT NULL COMMENT '系统id',
  `sub_system_id` bigint(0) NULL DEFAULT NULL COMMENT '子系统id',
  `host_labels` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '主机环境标签',
  `un_concur_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '不允许并发标志0-不允许并发1-允许并发',
  `update_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '需要同步到jenkins的状态位0-运行流水线前先同步jenkinsfile1-运行流水线前不同步jenkinsfile',
  `draft_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '草稿状态 0-流水线 1-流水线草稿 2-模版草稿',
  `stage_choice_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '阶段运行选择标志 0-关闭 1-开启',
  `run_time` datetime(0) NULL DEFAULT NULL COMMENT '最近运行时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'jenkins流水线' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkins_job_config
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkins_job_config`;
CREATE TABLE `devops_jenkins_job_config`  (
  `id` bigint(0) NOT NULL,
  `job_id` bigint(0) NOT NULL COMMENT '流水线表devops_jenkins_job的id',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '流水线描述（未使用）',
  `start_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '流水线启动变量',
  `env_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '流水线环境变量',
  `project` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '流水线所属项目（未使用）',
  `trigger_type` tinyint(0) NULL DEFAULT 0 COMMENT '流水线触发类型（未使用）',
  `builds_num` int(0) NULL DEFAULT 0 COMMENT '流水线最大保存记录数（未使用）',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本号（未使用）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `build_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '额外动态信息的json数据',
  `open_flag` tinyint(1) NULL DEFAULT 0 COMMENT '开启标志，0:未删除，1:删除',
  `branch_flag` tinyint(1) NULL DEFAULT 0 COMMENT '分支触发，0:分支，1:tag',
  `branch_str` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '分支或者tag表达式',
  `merge_flag` tinyint(1) NULL DEFAULT 0 COMMENT '合并规则 每位关闭为0 开启为1 ',
  `tag_flag` tinyint(1) NULL DEFAULT 0 COMMENT 'tag标志',
  `merge_str` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '合并匹配',
  `time_controller` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间控制',
  `time_controller_str` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '允许运行时间段配置',
  `guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '流水线的使用指南',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `job_config_index_job_id`(`job_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'jenkins流水线配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkinsfile
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkinsfile`;
CREATE TABLE `devops_jenkinsfile`  (
  `id` bigint(0) NOT NULL,
  `job_id` bigint(0) NOT NULL COMMENT '流水线表devops_jenkins_job的 id',
  `template_id` bigint(0) NULL DEFAULT NULL COMMENT '模版表devops_jenkinsfile_template的id',
  `pipeline_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'pipeline 图形结构',
  `pipeline_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'pipeline文本',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本（未使用）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `asny_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '同步状态（未使用）',
  `agent_id` int(0) NULL DEFAULT NULL COMMENT 'agent模板的id（已废弃）',
  `build_record_max` int(0) NULL DEFAULT NULL COMMENT '最大保存日志数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `jenkinsfile_index_job_id`(`job_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线的jenkinsfile信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkinsfile_stage_component
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkinsfile_stage_component`;
CREATE TABLE `devops_jenkinsfile_stage_component`  (
  `id` bigint(0) NOT NULL,
  `kind_id` bigint(0) NOT NULL COMMENT '子步骤类型表devops_jenkinsfile_stage_component_kind的id',
  `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子步骤名称',
  `struct` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子步骤页面渲染结构',
  `step_shell` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子步骤 json字符串',
  `step_shell_normal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子步骤的常用类型的字符串（已经废弃）',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本（未使用）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `step_func` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子步骤方法',
  `step_env` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '子步骤环境1-模版2-子系统3-流水线',
  `step_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '插件状态 1-调试状态 0-草稿状态 2-上线状态',
  `step_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '子步骤类型 0-自定义插件 1-三方插件 2-系统内置插件',
  `step_groovy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子步骤的groovy脚本',
  `groovy_chang` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '子步骤的groovy是否同步到sharedLibrary 0->未同步 1->同步失败 2->同步成功',
  `component_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '插件版本',
  `use_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '使用标志（未使用）',
  `tenant_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线子步骤信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkinsfile_stage_component_kind
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkinsfile_stage_component_kind`;
CREATE TABLE `devops_jenkinsfile_stage_component_kind`  (
  `id` bigint(0) NOT NULL,
  `kind_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子步骤类型名称',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本（未使用）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `tenant_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线子步骤类型分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_jenkinsfile_template
-- ----------------------------
DROP TABLE IF EXISTS `devops_jenkinsfile_template`;
CREATE TABLE `devops_jenkinsfile_template`  (
  `id` bigint(0) NOT NULL,
  `template_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模版名称',
  `pipeline_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'pipeline 图形化结构',
  `pipeline_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'pipeline文本',
  `start_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '启动参数',
  `env_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '运行参数',
  `state` tinyint(0) NULL DEFAULT 0 COMMENT '启停用标识，0：启用，1：停用（废弃）',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模版标签',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本（废弃）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '模板类型 0-NORMAL 1-K8S（废弃）',
  `build_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'stage中的信息',
  `icon_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标类型',
  `form_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '模版动态表单',
  `guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '帮助指引',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'jenkinsfile模版' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_job_build_info
-- ----------------------------
DROP TABLE IF EXISTS `devops_job_build_info`;
CREATE TABLE `devops_job_build_info`  (
  `id` bigint(0) NOT NULL,
  `job_id` bigint(0) NOT NULL COMMENT '流水线表devops_jenkins_job的 id',
  `start_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '启动变量',
  `env_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '环境变量',
  `run_trigger` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '触发方式',
  `run_describe` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '描述',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '启动时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '结束时间',
  `duration` bigint(0) NULL DEFAULT NULL COMMENT '持续时间（毫秒）',
  `queue_duration` bigint(0) NULL DEFAULT NULL COMMENT '对列等待时间（毫秒）',
  `pause_duration` bigint(0) NULL DEFAULT NULL COMMENT '卡点等待时间（毫秒）',
  `build_num` bigint(0) NULL DEFAULT NULL COMMENT '流水线构建num',
  `build_detail` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '流水线阶段可视化结构',
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '流水线构建状态',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本（未使用）',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(20) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '更新人',
  `build_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '额外流水线信息json',
  `sonar_result` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '漏洞扫描结果 0-没有扫描 1-扫描中   2-扫描没通过 3-扫描通过',
  `depend_safe_result` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '可信源扫描结果 0-没有扫描 1-扫描中   2-扫描没通过 3-扫描通过',
  `jenkinsfile` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '构建时的流水线脚本',
  `trigger_user` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '触发人',
  `replay_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0-不是重试 1-是重试',
  `can_replay` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0-可以重试 1-不可以重试（历史数据处理不允许重试）',
  `env_id` int(0) NULL DEFAULT NULL COMMENT '构建环境',
  `tenant_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `devops_job_build_info`(`job_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线构建历史记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_job_draft_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_job_draft_rel`;
CREATE TABLE `devops_job_draft_rel`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(0) NULL DEFAULT NULL COMMENT '流水线表devops_jenkins_job的id',
  `draft_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '草稿信息json',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流水线草稿信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_job_notify
-- ----------------------------
DROP TABLE IF EXISTS `devops_job_notify`;
CREATE TABLE `devops_job_notify`  (
  `id` bigint(0) NOT NULL DEFAULT 0,
  `job_id` bigint(0) NOT NULL COMMENT '流水线表devops_jenkins_job的id',
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '通知人id',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '通知人名称',
  `notify_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '通知类型 0-完成后通知 1-失败后通知',
  `msg_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '消息类型：1:邮件 2:短信 3:站内信 4:钉钉通知',
  `open_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '通知开启标志0-开启1-关闭',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线消息通知配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_job_schedule
-- ----------------------------
DROP TABLE IF EXISTS `devops_job_schedule`;
CREATE TABLE `devops_job_schedule`  (
  `id` bigint(0) NOT NULL,
  `job_id` bigint(0) NOT NULL COMMENT '流水线表devops_jenkins_job的id',
  `cron_expression` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '定时任务cron表达式',
  `repeat_flag` tinyint(1) NULL DEFAULT NULL COMMENT '触发方式0-单次触发1-周期触发',
  `weekend_str` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '周信息',
  `interval_str` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '间隔时间',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '结束时间',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '流水线定时调度配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_lov
-- ----------------------------
DROP TABLE IF EXISTS `devops_lov`;
CREATE TABLE `devops_lov`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `type` int(0) NULL DEFAULT NULL COMMENT '资源类型：1-主机类型2-容器类型',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型名称',
  `is_delete` tinyint(1) NULL DEFAULT NULL COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部署环境的部署资源的类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_metadata
-- ----------------------------
DROP TABLE IF EXISTS `devops_metadata`;
CREATE TABLE `devops_metadata`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(0) NOT NULL COMMENT '流水线表id',
  `metadata_type` tinyint(0) NOT NULL COMMENT '元数据类型1-系统;2-子系统',
  `metadata_params` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '元数据参数',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流水线相关元数据表（已废弃，下个版本删除）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_pipeline_variable
-- ----------------------------
DROP TABLE IF EXISTS `devops_pipeline_variable`;
CREATE TABLE `devops_pipeline_variable`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `e_id` int(0) NOT NULL COMMENT '构建环境表devops_env_info的id',
  `var_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '变量key',
  `var_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变量值',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '构建环境变量管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_sql_info
-- ----------------------------
DROP TABLE IF EXISTS `devops_sql_info`;
CREATE TABLE `devops_sql_info`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '环境名称',
  `sql_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '1-mysql 2-oracle 3-dameng',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '地址',
  `credential_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '凭证id',
  `tenant_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'jenkins用户名',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `env_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部署环境表devops_deploy_env的id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部署环境下数据库连接信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_stage_component_image_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_stage_component_image_rel`;
CREATE TABLE `devops_stage_component_image_rel`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `stage_component_id` bigint(0) NOT NULL COMMENT '表devops_stage_component_relation的id',
  `agent_image_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'agent镜像id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '子步骤与镜像关联表（已废弃，下个版本删除）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_stage_component_relation
-- ----------------------------
DROP TABLE IF EXISTS `devops_stage_component_relation`;
CREATE TABLE `devops_stage_component_relation`  (
  `id` bigint(0) NOT NULL,
  `o_id` bigint(0) NOT NULL COMMENT '存储对象id',
  `component_id` bigint(0) NOT NULL COMMENT '子步骤id',
  `stage_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '流水线stage名称',
  `struct_with_argument` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子步骤页面渲染结构（包含用户输入的数据）',
  `step_sequence` int(0) NULL DEFAULT 0 COMMENT '子步骤顺序',
  `o_type` tinyint(0) NOT NULL DEFAULT 0 COMMENT '存储对象类型，0:流水线，1:流水线模版',
  `version` int(0) NULL DEFAULT 0 COMMENT '版本',
  `del_flag` tinyint(0) NULL DEFAULT 0 COMMENT '删除标记，0:未删除，1:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `step_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子步骤名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线子步骤form表单信息表（已废弃，下个版本删除）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_stage_info
-- ----------------------------
DROP TABLE IF EXISTS `devops_stage_info`;
CREATE TABLE `devops_stage_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `stage_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'stage名称',
  `o_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '任务id',
  `agent_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'agent信息',
  `agent_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'agent镜像',
  `artificial_confirmation` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '手动确认 0-不确认 1-确认',
  `stage_describe` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `notify_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '通知方式 0-',
  `notify_user` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '通知人员',
  `o_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '0-流水线 1-模板',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '0-正常 1-删除',
  `confirmation_user` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '确认人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '流水线的stage详细信息（已废弃，下个版本删除）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_tool_path_rel
-- ----------------------------
DROP TABLE IF EXISTS `devops_tool_path_rel`;
CREATE TABLE `devops_tool_path_rel`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `e_id` int(0) NOT NULL COMMENT '构建环境devops_env_info的id',
  `tool_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工具名称',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '版本',
  `path` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '绝对路径',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'agent工具与路径关联（已废弃，下个版本删除）' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
