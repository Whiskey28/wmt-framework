/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_app_management

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:29:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app_app
-- ----------------------------
DROP TABLE IF EXISTS `app_app`;
CREATE TABLE `app_app`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编号',
  `url` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '应用首页地址',
  `icon` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `left_icon` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '左侧栏图标',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `frame_control` tinyint(0) NULL DEFAULT 1 COMMENT '子应用菜单是否由主框架控制 0-否 1-是',
  `type` int(0) NULL DEFAULT NULL COMMENT '类型： 1 前台 2 后台',
  `cloudservice_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '云服务名称',
  `workspace_type` int(0) NULL DEFAULT NULL COMMENT '工作空间类型 1:项目切换 0:不支持 仅对前台应用有',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '应用表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for app_app_web
-- ----------------------------
DROP TABLE IF EXISTS `app_app_web`;
CREATE TABLE `app_app_web`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `app_id` bigint(0) NOT NULL COMMENT '应用id',
  `web_id` bigint(0) NOT NULL COMMENT '微前端id',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `permission_id` bigint(0) NOT NULL COMMENT '菜单id',
  `permission_level` tinyint(1) NOT NULL COMMENT '菜单等级 1.开放 2.授权',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '应用微前端关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for app_web
-- ----------------------------
DROP TABLE IF EXISTS `app_web`;
CREATE TABLE `app_web`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编号',
  `route` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '前端路由',
  `url` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运行地址',
  `type` tinyint(0) NULL DEFAULT NULL COMMENT '微前端类型：1.vue 2.react',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `is_need_return` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '需要返回的前端路由',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `cloudservice_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '云服务名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '微前端表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attachment
-- ----------------------------
DROP TABLE IF EXISTS `attachment`;
CREATE TABLE `attachment`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `bucket_name` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'minio的存储空间名称',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '附件名称',
  `size` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '大小,单位Byte',
  `url` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件地址',
  `image_flow` mediumblob NULL COMMENT '二进制图片流',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3160652967905378307 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cloudservice_message_type
-- ----------------------------
DROP TABLE IF EXISTS `cloudservice_message_type`;
CREATE TABLE `cloudservice_message_type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `cloudservice_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '云服务名称',
  `message_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息类型',
  `message_type_alias` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息类型别名',
  `is_root` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否为根',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父级id',
  `support_robot` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否支持机器人',
  `subscribe_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订阅途径',
  `tips` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户云服务消息类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cloudservice_robot_subscription
-- ----------------------------
DROP TABLE IF EXISTS `cloudservice_robot_subscription`;
CREATE TABLE `cloudservice_robot_subscription`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `message_type_id` int(0) NOT NULL COMMENT '云服务消息类型Id',
  `robot_id` bigint(0) NOT NULL COMMENT '机器人Id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户云服务机器人订阅表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_category
-- ----------------------------
DROP TABLE IF EXISTS `hms_category`;
CREATE TABLE `hms_category`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织ID',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '编号',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模块名称',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '功能模块表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_ding_account
-- ----------------------------
DROP TABLE IF EXISTS `hms_ding_account`;
CREATE TABLE `hms_ding_account`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `type` int(0) NOT NULL COMMENT '钉钉类型 1普通钉 2专有钉',
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公司名称',
  `annotation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `allow_login` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否开启第三方登录',
  `allow_message_notice` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否开启消息通知',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专有钉域名',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户钉钉企业表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_record
-- ----------------------------
DROP TABLE IF EXISTS `hms_record`;
CREATE TABLE `hms_record`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '消息内容',
  `send_time` datetime(0) NOT NULL COMMENT '发送时间',
  `send_type` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类别 1代表邮件 2 代表短信 3 站内信  4 钉钉',
  `status` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送状态 1-未发，2-已发，3-发送失败',
  `receiver` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人用户id',
  `template_id` bigint(0) NULL DEFAULT NULL COMMENT '模板id',
  `sender` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送者名称',
  `send_mode` tinyint(0) NULL DEFAULT NULL COMMENT '发送机制  1-定时 2-实时',
  `source` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消息来源 1-系统新增 2-后台服务发送',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_record_item
-- ----------------------------
DROP TABLE IF EXISTS `hms_record_item`;
CREATE TABLE `hms_record_item`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `send_type` tinyint(0) NULL DEFAULT NULL COMMENT '类别 1代表邮件 2 代表短信 3 站内信  4 钉钉',
  `record_id` bigint(0) NULL DEFAULT NULL COMMENT '消息id',
  `status` tinyint(0) NULL DEFAULT NULL COMMENT '消息状态 2-SUCCESS 3-FAILED',
  `msg_id` bigint(0) NULL DEFAULT NULL COMMENT '短信 msgId',
  `send_time` datetime(0) NOT NULL COMMENT '发送时间',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息细项' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_server_config
-- ----------------------------
DROP TABLE IF EXISTS `hms_server_config`;
CREATE TABLE `hms_server_config`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `tenant_id` bigint(0) NOT NULL COMMENT '租户ID',
  `host` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱服务器',
  `port` int(0) NULL DEFAULT NULL COMMENT '端口',
  `type` tinyint(0) NOT NULL COMMENT '类别 字典管理 code = sendType',
  `app_id` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用标识',
  `app_secret` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用密钥',
  `username` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户',
  `password` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `token` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '令牌',
  `sender` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送人',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '调用外部api',
  `method` tinyint(0) NULL DEFAULT NULL COMMENT '请求方式 1.GET 2.POST 3.PUT 4.DELETE',
  `param` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参数',
  `extract_expression` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提取表达式',
  `compare` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对比关系',
  `success_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '调用成功返回值',
  `is_anonymous` tinyint(0) NULL DEFAULT NULL COMMENT '是否匿名 1-是 2-否',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  `ding_related_id` bigint(0) NULL DEFAULT NULL COMMENT '钉钉关联表ID',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息服务器' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_template
-- ----------------------------
DROP TABLE IF EXISTS `hms_template`;
CREATE TABLE `hms_template`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `send_type` tinyint(0) NULL DEFAULT NULL COMMENT '类别 1代表邮件 2 代表短信 3 站内信  4 钉钉',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '模板内容',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  `template_id` bigint(0) NULL DEFAULT NULL COMMENT '模板Id',
  `template_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板键值',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消息标题',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `content_keys` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '消息模内容键值',
  `category_id` bigint(0) NULL DEFAULT NULL COMMENT '功能模块ID',
  `trigger_id` bigint(0) NULL DEFAULT NULL COMMENT '触发事件ID',
  `receive_group` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接收组',
  `send_all` tinyint(0) NULL DEFAULT 0 COMMENT '发送所有人 0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息模板信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hms_trigger
-- ----------------------------
DROP TABLE IF EXISTS `hms_trigger`;
CREATE TABLE `hms_trigger`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `category_id` bigint(0) NULL DEFAULT NULL COMMENT '功能模块ID',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '编号',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '触发事件名称',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '触发事件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notice_message_inbox
-- ----------------------------
DROP TABLE IF EXISTS `notice_message_inbox`;
CREATE TABLE `notice_message_inbox`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `send_id` bigint(0) NOT NULL COMMENT '发送者ID',
  `receive_id` bigint(0) NOT NULL COMMENT '接受者ID，0表示接受者为所有人',
  `text_id` bigint(0) NOT NULL COMMENT '消息ID',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态0 未读 1已读 2已删除',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `push_count` int(0) NULL DEFAULT 0 COMMENT '推送次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息收件箱' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notice_message_outbox
-- ----------------------------
DROP TABLE IF EXISTS `notice_message_outbox`;
CREATE TABLE `notice_message_outbox`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `send_id` bigint(0) NOT NULL COMMENT '发送者ID',
  `receive_id` bigint(0) NOT NULL COMMENT '接受者ID，0表示接受者为所有人',
  `text_id` bigint(0) NOT NULL COMMENT '消息ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `is_published` tinyint(0) NOT NULL DEFAULT 0 COMMENT '是否发布',
  `publish_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  `receiver_type` int(0) NULL DEFAULT NULL COMMENT '接受对象类型 1组织 2项目 3用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息发件箱' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notice_message_text
-- ----------------------------
DROP TABLE IF EXISTS `notice_message_text`;
CREATE TABLE `notice_message_text`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `is_published` tinyint(0) NOT NULL DEFAULT 0 COMMENT '是否发布',
  `message_type` int(0) NULL DEFAULT NULL COMMENT '消息类型 0公告 1通知 2 私信',
  `publish_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除 0正常 1删除',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `message_from` int(0) NULL DEFAULT NULL COMMENT '消息类型Id',
  `status` int(0) NULL DEFAULT NULL COMMENT '状态 0-待发送 1-已发送 2-已撤回',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息内容' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_app_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_app_role`;
CREATE TABLE `sys_app_role`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `source_app_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源应用code',
  `source_resource_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源资源编号',
  `source_role_id` bigint(0) NULL DEFAULT NULL COMMENT '来源角色id',
  `source_role_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源角色编号',
  `target_app_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '目标应用code',
  `target_resource_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '目标资源编号',
  `target_role_id` bigint(0) NULL DEFAULT NULL COMMENT '目标角色id',
  `target_role_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '目标角色编号',
  `annotations` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源之间的角色的关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_associated_problem_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_associated_problem_user`;
CREATE TABLE `sys_associated_problem_user`  (
  `ID` bigint(0) NOT NULL,
  `UNIQUE_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '钉钉用户id',
  `EXCEPTION_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '异常类型 ',
  `CREATE_TIME` datetime(0) NOT NULL COMMENT '创建时间',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '钉钉关联异常用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_browse_count
-- ----------------------------
DROP TABLE IF EXISTS `sys_browse_count`;
CREATE TABLE `sys_browse_count`  (
  `id` bigint(0) NOT NULL COMMENT '主键id 采用雪花算法生成',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `organ_id` bigint(0) NOT NULL COMMENT '组织ID',
  `count_type` tinyint(0) NOT NULL COMMENT '统计类型',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统计类型描述',
  `count_times` int(0) NOT NULL COMMENT '统计次数',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '逻辑删除  0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '浏览统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '父级ID',
  `unique_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '唯一编码',
  `organization_id` bigint(0) NOT NULL COMMENT '组织ID',
  `is_root` bigint(0) NOT NULL DEFAULT 0 COMMENT '是否是跟部门 0-否 1-是',
  `dept_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `dept_description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sort_id` int(0) NULL DEFAULT 0 COMMENT '排序号',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `sys_dictionary`;
CREATE TABLE `sys_dictionary`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `parent_id` bigint(0) NOT NULL COMMENT '父级ID',
  `code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字典码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '显示名',
  `value` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `is_editable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否可改 0不可 1可以',
  `is_deletable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否可删 0不可 1可以',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `app_id` bigint(0) NULL DEFAULT NULL COMMENT '应用ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_ding_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_ding_user`;
CREATE TABLE `sys_ding_user`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `ding_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '钉钉id',
  `ding_account_id` bigint(0) NOT NULL COMMENT '钉钉企业id',
  `user_type` int(0) NULL DEFAULT NULL COMMENT '账号类型 0-部门 1-用户',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名字',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `parent_dept_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '父部门id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户钉钉部门人员账号表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `path` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '存储路径',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '附件名称',
  `unique_key` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '存储系统的唯一键',
  `size` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '大小,单位字节',
  `link` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '在线附件地址',
  `version` int(0) NOT NULL DEFAULT 1 COMMENT '版本号',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人id',
  `del_flg` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 133 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_group_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_group_user`;
CREATE TABLE `sys_group_user`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `group_id` bigint(0) NOT NULL COMMENT '用户组ID',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织ID',
  `resource_id` bigint(0) NULL DEFAULT NULL COMMENT '资源id',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与用户组的关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_object_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_object_permission`;
CREATE TABLE `sys_object_permission`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `object_id` bigint(0) NOT NULL COMMENT '角色ID',
  `permission_id` bigint(0) NOT NULL COMMENT '权限ID',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织ID',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `resource_id` bigint(0) NULL DEFAULT 0 COMMENT '资源id',
  `type` tinyint(0) NULL DEFAULT NULL COMMENT '种类 1.角色 2.用户 3.用户组',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_operation_audit
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_audit`;
CREATE TABLE `sys_operation_audit`  (
  `id` bigint(0) NOT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '跟踪编号',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织id',
  `app_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用编码',
  `app_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用名称',
  `operation_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作事项实体编号',
  `operation_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审计实体主键值',
  `ip_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `operation_start_time` datetime(0) NULL DEFAULT NULL COMMENT '操作开始时间',
  `operation_end_time` datetime(0) NULL DEFAULT NULL COMMENT '操作结束时间',
  `operation_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作用户ID',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '参数',
  `request_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求类型POST/GET',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'URL',
  `class_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类名',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '方法名',
  `operation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作名称',
  `response_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '返回HTTP code',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '返回json',
  `result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作结果',
  `extend_param` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '自定义扩展字段',
  `is_deleted` tinyint(0) NULL DEFAULT 0 COMMENT '是否删除',
  `attrib_operation` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性审计',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_operation_audit_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_audit_config`;
CREATE TABLE `sys_operation_audit_config`  (
  `id` bigint(0) NOT NULL,
  `operation_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作事项实体编号',
  `clearance_cycle` int(0) NULL DEFAULT NULL COMMENT '记录清除周期 单位:天',
  `archive` int(0) NULL DEFAULT NULL COMMENT '是否归档 0-是 1-否',
  `config_type` int(0) NULL DEFAULT NULL COMMENT '设置类型 0-通用类型 1-操作事项',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审计日志配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_operation_audit_history
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_audit_history`;
CREATE TABLE `sys_operation_audit_history`  (
  `audit_id` bigint(0) NOT NULL,
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '跟踪编号',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织id',
  `app_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用编码',
  `app_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用名称',
  `operation_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作事项实体编号',
  `operation_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审计实体主键值',
  `ip_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `operation_start_time` datetime(0) NULL DEFAULT NULL COMMENT '操作开始时间',
  `operation_end_time` datetime(0) NULL DEFAULT NULL COMMENT '操作结束时间',
  `operation_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作用户ID',
  `param` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参数',
  `request_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求类型POST/GET',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'URL',
  `class_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类名',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '方法名',
  `operation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作名称',
  `response_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '返回HTTP code',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '返回json',
  `result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作结果',
  `extend_param` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '自定义扩展字段',
  `is_deleted` tinyint(0) NULL DEFAULT 0 COMMENT '是否删除',
  `attrib_operation` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性审计',
  PRIMARY KEY (`audit_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审计日志历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_organization
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization`;
CREATE TABLE `sys_organization`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `code` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编码',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父级id',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `annotations` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  `white_ip_flag` tinyint(0) NOT NULL DEFAULT 0 COMMENT '白名单开关 0-关 1-开',
  `ip_forced_control` int(0) NULL DEFAULT 0 COMMENT 'ip强制管控 0-否 1-是',
  `gitlab_forced_control` int(0) NULL DEFAULT 0 COMMENT 'gitlab强制管控 0-否 1-是',
  `jenkins_forced_control` int(0) NULL DEFAULT 0 COMMENT 'jenkins强制管控 0-否 1-是',
  `contact_person` bigint(0) NULL DEFAULT NULL COMMENT '租户联系人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_organization_ip
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization_ip`;
CREATE TABLE `sys_organization_ip`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `organ_id` bigint(0) NOT NULL COMMENT '组织ID',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '白名单ip',
  `min_ip` bigint(0) NOT NULL COMMENT '网段最小值',
  `max_ip` bigint(0) NOT NULL COMMENT '网段最大值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '租户ip白名单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_organization_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization_role`;
CREATE TABLE `sys_organization_role`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `organ_id` bigint(0) NOT NULL COMMENT '组织ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `resource_id` bigint(0) NULL DEFAULT 0 COMMENT '资源id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机构角色关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_organization_user_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization_user_group`;
CREATE TABLE `sys_organization_user_group`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `group_id` bigint(0) NOT NULL COMMENT '用户组ID',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织ID',
  `resource_id` bigint(0) NULL DEFAULT NULL COMMENT '资源id',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织与用户组的关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_owner_resource
-- ----------------------------
DROP TABLE IF EXISTS `sys_owner_resource`;
CREATE TABLE `sys_owner_resource`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `resource_id` bigint(0) NOT NULL COMMENT '资源字典表的唯一编号',
  `resource_owner_id` bigint(0) NOT NULL COMMENT '子应用资源拥有者id',
  `organ_id` bigint(0) NOT NULL COMMENT '组织id',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源拥有者实例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `parent_id` bigint(0) NOT NULL COMMENT '父级ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编码',
  `type` tinyint(0) NOT NULL COMMENT '类型 1.菜单 2.页面元素',
  `kind` tinyint(0) NOT NULL COMMENT '种类 1.平台菜单 2.组织管理菜单 3.应用菜单',
  `app_id` bigint(0) NULL DEFAULT NULL COMMENT '应用ID',
  `icon` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `method` tinyint(0) NOT NULL DEFAULT 1 COMMENT '请求方式 1.GET 2.POST 3.PUT 4.DELETE',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接口列表',
  `visible` tinyint(0) NULL DEFAULT 1 COMMENT '0-不可见 1-可见',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `annotations` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  `is_iframe` tinyint(1) NULL DEFAULT 0,
  `iframe_url` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `resource_type_code` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源类型编码',
  `single_organ` tinyint(0) NULL DEFAULT 3 COMMENT '菜单是否为单组织菜单 1-多 2-单 3-单/多',
  `api` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接口',
  `cloudservice_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '云服务名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_relate_tag
-- ----------------------------
DROP TABLE IF EXISTS `sys_relate_tag`;
CREATE TABLE `sys_relate_tag`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `tag_id` bigint(0) NOT NULL COMMENT '标签id ',
  `relate_id` bigint(0) NOT NULL COMMENT '关联对象id',
  `type` tinyint(0) NOT NULL DEFAULT 0 COMMENT '标签类型 1.应用标签 2.角色标签 3.菜单标签',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_resource_instance
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_instance`;
CREATE TABLE `sys_resource_instance`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `organ_id` bigint(0) NOT NULL COMMENT '组织id',
  `resource_type_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '资源类型编号',
  `resource_instance_id` bigint(0) NOT NULL COMMENT '应用资源id',
  `resource_instance_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '应用资源名称',
  `sri_sort` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `sri_description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `extend_field` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '扩展字段',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '父类id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_RESOURCE_INSTANCE`(`organ_id`, `resource_type_code`, `resource_instance_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源实例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_resource_owner_instance
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_owner_instance`;
CREATE TABLE `sys_resource_owner_instance`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `type_dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字典表的resource_owner的下属value',
  `resource_owner_instance_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '应用资源拥有者id',
  `resource_owner_instance_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '子应用资源拥有者名称',
  `organ_id` bigint(0) NOT NULL COMMENT '组织id',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '资源拥有者状态',
  `roi_sort` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `roi_description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `extend_field` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '扩展字段',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `UK_RESOURCE_OWNER_INSTANCE`(`organ_id`, `type_dict_value`, `resource_owner_instance_id`) USING BTREE COMMENT '唯一索引'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源拥有者实例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_resource_screening
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_screening`;
CREATE TABLE `sys_resource_screening`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `resource_id` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '资源',
  `screening_field` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '筛选字段',
  `screening_value` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字段值',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `INDEX_RESOURCE_SCREENING`(`screening_field`, `screening_value`) USING BTREE COMMENT '筛选索引'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源筛选表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_resource_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_type`;
CREATE TABLE `sys_resource_type`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `app_id` bigint(0) NOT NULL COMMENT '应用id',
  `srt_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '编码',
  `srt_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `left_show` tinyint(0) NULL DEFAULT 1 COMMENT '左侧切换展示 0-否 1-是',
  `redirect_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转url',
  `parent_permission_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父类菜单编号',
  `srt_sort` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `srt_description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `extend_field` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '扩展字段',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '父类id',
  `species` bigint(0) NULL DEFAULT NULL COMMENT '包含类',
  `cloudservice_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '云服务名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_RESOURCE_TYPE`(`app_id`, `srt_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_robot
-- ----------------------------
DROP TABLE IF EXISTS `sys_robot`;
CREATE TABLE `sys_robot`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `robot_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '机器人名称',
  `robot_plat` int(0) NULL DEFAULT NULL COMMENT '机器人平台 0-钉钉 1-专有钉',
  `ding_account_id` bigint(0) NULL DEFAULT NULL COMMENT '钉钉账号id',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '机器人状态',
  `webhook` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'webhook',
  `secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密钥',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户机器人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编码',
  `type` tinyint(0) NULL DEFAULT NULL COMMENT '角色类型 1.平台角色 2.组织共享角色 3.全局角色 4.资源类型角色 5.组织角色',
  `organ_id` bigint(0) NOT NULL DEFAULT 1 COMMENT '组织id',
  `is_editable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否可改 0不可 1可以',
  `is_deletable` tinyint(0) NULL DEFAULT 1 COMMENT '是否能删除 0-否 1-是',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `annotations` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  `is_admin` tinyint(1) NOT NULL DEFAULT 0 COMMENT ' 是否是管理员 0-否 1-是',
  `resource_type_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源类型编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_tag
-- ----------------------------
DROP TABLE IF EXISTS `sys_tag`;
CREATE TABLE `sys_tag`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `classification_id` bigint(0) NULL DEFAULT NULL,
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `colour` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签颜色',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织id',
  `type_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源id',
  `instance_id` bigint(0) NULL DEFAULT NULL COMMENT '资源id',
  `scope` bigint(0) NOT NULL DEFAULT 1 COMMENT '1-平台及以下 2-组织及以下 3-资源及以下',
  `code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签编号',
  `app_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'devops' COMMENT '应用code',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_tag_classification
-- ----------------------------
DROP TABLE IF EXISTS `sys_tag_classification`;
CREATE TABLE `sys_tag_classification`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT '排序号',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织id',
  `scope` bigint(0) NOT NULL DEFAULT 1 COMMENT '1-平台及以下 2-组织及以下 3-资源及以下',
  `code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类编号',
  `type_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源id',
  `instance_id` bigint(0) NULL DEFAULT NULL COMMENT '资源id',
  `app_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'devops' COMMENT '应用code',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '标签分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_tag_relate
-- ----------------------------
DROP TABLE IF EXISTS `sys_tag_relate`;
CREATE TABLE `sys_tag_relate`  (
  `id` bigint(0) NOT NULL,
  `tag_id` bigint(0) NOT NULL COMMENT '标签id',
  `relate_type_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '关联类型',
  `relate_instance_id` bigint(0) NULL DEFAULT NULL COMMENT '关联实例id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账户名',
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `gender` tinyint(0) NULL DEFAULT NULL COMMENT '性别 0女 1男',
  `age` tinyint(0) NULL DEFAULT NULL COMMENT '年龄',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `mobile` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `ic_type` tinyint(0) NULL DEFAULT NULL COMMENT '证件类型 0身份证 1户口簿；2护照 3军官证 4士兵证 5港澳居民来往内地通行证 6台湾同胞来往内地通行证 7临时身份证 8外国人居留证 9警官证 10其他证件',
  `ic_number` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '证件号码',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0.正常 1.锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `annotations` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  `update_password_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '最后更新密码时间',
  `user_type` tinyint(1) NULL DEFAULT 1 COMMENT '用户类型 0-公司用户 1-外部用户',
  `first_login` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否首次登录 0-否 1-是',
  `salt` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码盐',
  `is_editable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可改 0不可 1可以',
  `position` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职位信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_department`;
CREATE TABLE `sys_user_department`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `dept_id` bigint(0) NOT NULL COMMENT '部门ID',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `organ_id` bigint(0) NOT NULL COMMENT '组织ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_event
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_event`;
CREATE TABLE `sys_user_event`  (
  `id` bigint(0) NOT NULL,
  `organ_id` bigint(0) NOT NULL COMMENT '租户id',
  `user_id` bigint(0) NULL DEFAULT NULL COMMENT '用户id',
  `event_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事件类型',
  `event_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '事件类型',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_group`;
CREATE TABLE `sys_user_group`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编码',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织ID',
  `resource_id` bigint(0) NULL DEFAULT NULL COMMENT '资源id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_message_subscription
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_message_subscription`;
CREATE TABLE `sys_user_message_subscription`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `message_type_id` int(0) NOT NULL COMMENT '云服务消息类型Id',
  `user_id` bigint(0) NOT NULL COMMENT '用户Id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户用户消息类型订阅表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_organization
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_organization`;
CREATE TABLE `sys_user_organization`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `organ_id` bigint(0) NOT NULL COMMENT '组织ID',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `resource_id` bigint(0) NULL DEFAULT 0 COMMENT '资源id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织用户关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `organ_id` bigint(0) NULL DEFAULT NULL COMMENT '组织ID',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `resource_id` bigint(0) NULL DEFAULT 0 COMMENT '资源id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_wide
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_wide`;
CREATE TABLE `sys_user_wide`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `type` tinyint(0) NOT NULL COMMENT '外部应用类型 1-钉钉',
  `unique_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '外部应用类型 1-钉钉',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户外部应用关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_wide_copy
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_wide_copy`;
CREATE TABLE `sys_user_wide_copy`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `type` tinyint(0) NOT NULL COMMENT '外部应用类型 1-钉钉',
  `unique_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外部应用id',
  `unique_account_id` bigint(0) NULL DEFAULT NULL COMMENT '外部应用账号id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户外部应用关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_webhook
-- ----------------------------
DROP TABLE IF EXISTS `sys_webhook`;
CREATE TABLE `sys_webhook`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发事件编号',
  `safety_level` tinyint(1) NOT NULL DEFAULT 3 COMMENT '安全等级 1-隐藏 2-只读 3-读写',
  `api` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接口地址',
  `description` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(0) NOT NULL DEFAULT 0 COMMENT '状态 0.正常 1.锁定',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0正常 1删除',
  `annotations` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'webhook回调表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_webhook_logs
-- ----------------------------
DROP TABLE IF EXISTS `sys_webhook_logs`;
CREATE TABLE `sys_webhook_logs`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'webhook code',
  `result` tinyint(1) NOT NULL DEFAULT 0 COMMENT '执行结果：0-成功｜1-失败',
  `api` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'webhook调用地址',
  `request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求信息',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '响应结果',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4215325858733633537 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'webhook执行记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '-- part of primary key /*id*/',
  `config_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置名',
  `config_value` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `config_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置类型',
  `create_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '修改人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `config_name_index`(`config_name`) USING BTREE COMMENT 'config_name索引'
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门户系统配置表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
