/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_issues_track_v2

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:31:17
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for advance_config
-- ----------------------------
DROP TABLE IF EXISTS `advance_config`;
CREATE TABLE `advance_config`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置名称',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置唯一标识',
  `config` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置描述',
  `del_flag` tinyint(0) NOT NULL DEFAULT 0 COMMENT '配置内容json',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ahc_oa_hours
-- ----------------------------
DROP TABLE IF EXISTS `ahc_oa_hours`;
CREATE TABLE `ahc_oa_hours`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
  `工时发起人` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `工时发起部门` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时发起时间` date NULL DEFAULT NULL,
  `工时牵头部门` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时本年初日期` date NULL DEFAULT NULL,
  `工时本周出日期` date NULL DEFAULT NULL,
  `工时本年第周数` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时年` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时年1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时月份` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时日期` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时工作内容` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `核定工时` bigint(0) NULL DEFAULT NULL,
  `核定工时原因` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `工时系统日期` date NULL DEFAULT NULL,
  `工时项目名称` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时项目编号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工时项目经理` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ahc_oa_milestone
-- ----------------------------
DROP TABLE IF EXISTS `ahc_oa_milestone`;
CREATE TABLE `ahc_oa_milestone`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `里程碑名称` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `工作内容` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `交付成果物` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `负责人` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `计划开始时间` date NULL DEFAULT NULL,
  `计划结束时间` date NULL DEFAULT NULL,
  `里程碑备注` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `计划变更原因` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `计划变更日期` date NULL DEFAULT NULL,
  `实际开始日期` date NULL DEFAULT NULL,
  `实际结束日期` date NULL DEFAULT NULL,
  `里程碑状态` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `维护状态时间` date NULL DEFAULT NULL,
  `备注` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `产出物` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `系统日期` date NULL DEFAULT NULL,
  `阶段逾期原因` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `阶段逾期天数` int(0) NULL DEFAULT NULL,
  `是否提交` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `逾期汇报原因` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `逾期汇报天数` int(0) NULL DEFAULT NULL,
  `调表日期` date NULL DEFAULT NULL,
  `项目编号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `项目经理` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `牵头部门` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `项目名称` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `项目类型` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `项目状态` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `最新维护日期` date NULL DEFAULT NULL,
  `项目状态异常项目` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `申请部门` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ahc_oa_projects
-- ----------------------------
DROP TABLE IF EXISTS `ahc_oa_projects`;
CREATE TABLE `ahc_oa_projects`  (
  `ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `FIELD0009` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目编号',
  `FIELD0022` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目经理',
  `FIELD0016` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申请部门',
  `FIELD0017` date NULL DEFAULT NULL COMMENT '申请日期',
  `FIELD0018` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `FIELD0019` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户名称',
  `FIELD0020` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '牵头部门',
  `FIELD0023` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目类型',
  `FIELD0095` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目状态',
  `FIELD0058` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目性质',
  `FIELD0025` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '重要程度',
  `FIELD0054` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收益结算',
  `FIELD0031` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目金额',
  `FIELD0033` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否需要外包',
  `FIELD0035` date NULL DEFAULT NULL COMMENT '计划开始时间',
  `FIELD0036` date NULL DEFAULT NULL COMMENT '计划完成时间',
  `FIELD0037` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目计划周期',
  `FIELD0038` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '计划总人天',
  `FIELD0049` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '总工作量',
  `FIELD0123` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目预算',
  `FIELD0124` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本年',
  `FIELD0125` date NULL DEFAULT NULL COMMENT '本周初日期',
  `FIELD0126` date NULL DEFAULT NULL COMMENT '本年初日期',
  `FIELD0127` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日期差',
  `FIELD0128` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本年初星期几',
  `FIELD0129` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '周',
  `FIELD0132` bigint(0) NULL DEFAULT NULL COMMENT '软件采购成本',
  `FIELD0133` bigint(0) NULL DEFAULT NULL COMMENT '预计项目利润',
  `FIELD0134` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '硬件采购成本',
  `FIELD0135` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交状态',
  `FIELD0138` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否投标项目',
  `FIELD0143` bigint(0) NULL DEFAULT NULL COMMENT '合同金额',
  `FIELD0152` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户类型',
  `FIELD0164` bigint(0) NULL DEFAULT NULL COMMENT '确认收入',
  `FIELD0174` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人部门',
  `FIELD0175` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `FIELD0176` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attachments
-- ----------------------------
DROP TABLE IF EXISTS `attachments`;
CREATE TABLE `attachments`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型id',
  `issues_id` bigint(0) NOT NULL COMMENT '问题ID',
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'amp附件id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名称',
  `size` int(0) NOT NULL COMMENT '大小单位Byte',
  `resource_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '资源类型',
  `instance_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实例id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL DEFAULT 1 COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `type` int(0) NOT NULL DEFAULT 0 COMMENT '文件类型1原型',
  `tenant_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户ID',
  `ext_content` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '事项类型是阶段计划/里程碑时，关联的检查单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 125 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attachments_version
-- ----------------------------
DROP TABLE IF EXISTS `attachments_version`;
CREATE TABLE `attachments_version`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `attachment_id` bigint(0) NOT NULL COMMENT '关联的附件id',
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'amp附件id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名称',
  `size` int(0) NULL DEFAULT NULL COMMENT '大小单位Byte',
  `resource_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '资源类型',
  `instance_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实例id',
  `version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本号',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL DEFAULT 1 COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '附件-版本关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for autoflow_rule
-- ----------------------------
DROP TABLE IF EXISTS `autoflow_rule`;
CREATE TABLE `autoflow_rule`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `desp` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `event` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发事件',
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '规则配置',
  `action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '执行动作',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '启动状态 1开0关',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `tag_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 154 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '自动化规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for autoflow_rule_logs
-- ----------------------------
DROP TABLE IF EXISTS `autoflow_rule_logs`;
CREATE TABLE `autoflow_rule_logs`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `autoflow_rule_id` bigint(0) NOT NULL COMMENT '自动化规则ID',
  `retry` int(0) NOT NULL DEFAULT 0 COMMENT '重试次数',
  `result` tinyint(1) NOT NULL DEFAULT 0 COMMENT '执行结果：0-成功｜1-失败',
  `request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求信息',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应结果',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型id',
  `event` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发事件',
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '规则配置',
  `action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '执行动作',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 779 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '自动化规则执行记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for browse_history
-- ----------------------------
DROP TABLE IF EXISTS `browse_history`;
CREATE TABLE `browse_history`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户id',
  `subject_type_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '业务主体类型：project、sprint、milestone...',
  `subject_id` bigint(0) NOT NULL COMMENT '业务主体id:project_id、sprint_id、milestone_id...',
  `tenant_id` bigint(0) NOT NULL COMMENT '租户id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL COMMENT '创建者',
  `del_flag` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标志',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1439 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '浏览历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_id` bigint(0) NOT NULL COMMENT '问题ID',
  `auth_id` bigint(0) NOT NULL COMMENT '作者ID',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评论内容',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '评论父级id',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for custom_fields
-- ----------------------------
DROP TABLE IF EXISTS `custom_fields`;
CREATE TABLE `custom_fields`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性名称',
  `is_system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统类型',
  `field_format` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '控件类型：单行文本-shortText｜多行文本-longText｜单选框-singleCheckBox｜复选框-multiCheckBox｜单选列表-singleList｜多选列表-multiList｜日期-date｜时间-time｜文件-file｜整数-number｜浮点数-decimal｜单选成员-singlePersonnel｜多选成员-multiPersonnel｜链接-link｜单选部门-singleDepartment｜多选部门-multiDepartment',
  `role_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色ids',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `option_source` tinyint(0) NULL DEFAULT NULL COMMENT '选项来源：1-自定义｜2-数据字典｜3-远程接口',
  `source_type` int(0) NULL DEFAULT NULL COMMENT '数据来源：1-用户|2-部门|3-项目|4-系统（已弃用）',
  `interface_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口地址',
  `reg_exp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '正则表达式',
  `max_length` int(0) NULL DEFAULT NULL COMMENT '最大长度',
  `like_search` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否模糊查询 1 是 0  否',
  `value_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '属性值选项',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `prompt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '属性提示',
  `file_template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件模版',
  `decimal_precision` int(0) NULL DEFAULT NULL COMMENT '精度',
  `max_value` bigint(0) NULL DEFAULT NULL COMMENT '最大值',
  `min_value` bigint(0) NULL DEFAULT NULL COMMENT '最小值',
  `ext` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '拓展字段',
  `is_parse` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否转义',
  `parse_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '转义服务地址',
  `query_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '筛选参数',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `ux_cus_field_code`(`code`, `del_flag`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1015 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '自定义属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for custom_group
-- ----------------------------
DROP TABLE IF EXISTS `custom_group`;
CREATE TABLE `custom_group`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分组库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for daily_record
-- ----------------------------
DROP TABLE IF EXISTS `daily_record`;
CREATE TABLE `daily_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目id',
  `type` tinyint(0) NULL DEFAULT NULL COMMENT '报告类型 1-测试日报',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `template_id` bigint(0) NULL DEFAULT NULL COMMENT '模版id',
  `daily_record_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日志内容',
  `follow_people` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关注人',
  `file_ids` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送附件',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '修改人',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `del_flag` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ext_ddl_logs
-- ----------------------------
DROP TABLE IF EXISTS `ext_ddl_logs`;
CREATE TABLE `ext_ddl_logs`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型id',
  `ddl_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ddl语句',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除字段：0-未删除 | 1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扩展表DDL日志记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for interceptor_rule
-- ----------------------------
DROP TABLE IF EXISTS `interceptor_rule`;
CREATE TABLE `interceptor_rule`  (
  `ID` bigint(0) UNSIGNED NOT NULL COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `desp` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `interceptor_type` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '拦截器类型',
  `business_code` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务编码',
  `predicate` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '断言',
  `action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '执行动作',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '启动状态 1开0关',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '拦截器规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues
-- ----------------------------
DROP TABLE IF EXISTS `issues`;
CREATE TABLE `issues`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `business_id` bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '业务id',
  `business_type` tinyint(0) UNSIGNED NULL DEFAULT NULL COMMENT '业务类型',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型id',
  `parent_id` bigint(0) NULL DEFAULT NULL COMMENT '父事项id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `status_id` bigint(0) NOT NULL COMMENT '状态id',
  `priority_id` bigint(0) NULL DEFAULT NULL COMMENT '优先级id',
  `assigned_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '责任人',
  `start_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '计划完成日期',
  `close_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际完成时间',
  `progress` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0.00' COMMENT '进度(%)',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `tenant_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户ID',
  `real_start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际开始时间',
  `biz_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务编号',
  `tag_info_json` json NULL,
  `share_projects_json` json NULL,
  `assigned_ids_json` json NULL,
  `belong_to_project_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_issues_type`(`issues_type_id`, `del_flag`) USING BTREE,
  INDEX `idx_issues_business`(`business_id`, `business_type`) USING BTREE,
  INDEX `idx_issues_parent`(`parent_id`, `del_flag`) USING BTREE,
  INDEX `idx_issues_title`(`title`) USING BTREE,
  INDEX `idx_issues_status`(`status_id`) USING BTREE,
  INDEX `idx_issues_priority`(`priority_id`) USING BTREE,
  INDEX `idx_issues_assigned`(`assigned_ids`) USING BTREE,
  INDEX `idx_issues_start`(`start_date`) USING BTREE,
  INDEX `idx_issues_end`(`end_date`) USING BTREE,
  INDEX `idx_issues_close`(`close_time`) USING BTREE,
  INDEX `idx_issues_progress`(`progress`) USING BTREE,
  INDEX `idx_issues_cr_time`(`create_time`) USING BTREE,
  INDEX `idx_issues_cr_by`(`create_by`) USING BTREE,
  INDEX `idx_issues_up_time`(`update_time`) USING BTREE,
  INDEX `idx_issues_up_by`(`update_by`) USING BTREE,
  INDEX `idx_belong_to_project`(`belong_to_project_id`) USING BTREE,
  INDEX `idx_assigned_ids`() USING BTREE,
  INDEX `idx_tag_ids`() USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5052 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_enum
-- ----------------------------
DROP TABLE IF EXISTS `issues_enum`;
CREATE TABLE `issues_enum`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '父级ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `position` int(0) NOT NULL DEFAULT 0 COMMENT '位置',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `ext_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拓展内容',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_enum_code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 139 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '跟踪事项枚举值表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_event
-- ----------------------------
DROP TABLE IF EXISTS `issues_event`;
CREATE TABLE `issues_event`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_id` bigint(0) NOT NULL COMMENT '事项ID',
  `type` tinyint(0) NOT NULL DEFAULT 0 COMMENT '类型：0-触发事件｜1-通知事件',
  `event` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事件',
  `old_fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '更新前的字段',
  `new_fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '更新后的字段',
  `retry` int(0) NOT NULL DEFAULT 0 COMMENT '执行次数',
  `ext_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拓展内容',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '跟踪事项触发事件记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_logs
-- ----------------------------
DROP TABLE IF EXISTS `issues_logs`;
CREATE TABLE `issues_logs`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_id` bigint(0) NULL DEFAULT NULL COMMENT '问题ID',
  `property_id` bigint(0) NULL DEFAULT NULL COMMENT '属性id',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '行为(创建/编辑...)',
  `property_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '被更新的属性名称',
  `property_value_id_before` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '属性值更新之前关联id，用于跳转',
  `property_value_name_before` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '属性值更新之前的值',
  `property_value_id_after` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '属性值更新之后关联id，用于跳转',
  `property_value_name_after` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '属性值更新之后的值',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `issues_id_index`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10023 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '动态/操作记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_relations
-- ----------------------------
DROP TABLE IF EXISTS `issues_relations`;
CREATE TABLE `issues_relations`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `from_id` bigint(0) NOT NULL COMMENT 'fromID',
  `to_id` bigint(0) NOT NULL COMMENT 'toID',
  `relation_type` bigint(0) NULL DEFAULT 100 COMMENT '关联类型',
  `ext_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拓展内容',
  `ext_content2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拓展内容',
  `ext_content3` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拓展内容',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 197 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '问题关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_status
-- ----------------------------
DROP TABLE IF EXISTS `issues_status`;
CREATE TABLE `issues_status`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_system` tinyint(1) NOT NULL COMMENT '是否系统状态：1-是｜0-不是',
  `type` tinyint(0) NOT NULL COMMENT '状态阶段：0-未开始|1-进行中|2-已完成|3-已关闭',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态颜色',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7927 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '事项状态' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_tag
-- ----------------------------
DROP TABLE IF EXISTS `issues_tag`;
CREATE TABLE `issues_tag`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tag_ids` bigint(0) NOT NULL COMMENT '标签id ',
  `tag_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标签名',
  `tag_color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签颜色',
  `issues_id` bigint(0) NOT NULL COMMENT '关联事项id',
  `issues_type_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事项类型编码',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_by` bigint(0) NULL DEFAULT NULL,
  `instance_id` bigint(0) NULL DEFAULT NULL COMMENT '资源实例id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_issues_tag`(`tag_ids`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '事项标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type
-- ----------------------------
DROP TABLE IF EXISTS `issues_type`;
CREATE TABLE `issues_type`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事项类型编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事项类型名称',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `default_status_id` bigint(0) NULL DEFAULT NULL COMMENT '默认状态',
  `function_plug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '功能插件',
  `detail_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '前端详情页面路径',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_system` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否系统状态：1-是｜0-不是',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `is_general_page` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '事项类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_custom_fields
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_custom_fields`;
CREATE TABLE `issues_type_custom_fields`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型ID',
  `custom_fields` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性ID，系统属性默认为null(customFieldId)、属性名称(name)、系统类型(isSystem)、控件类型(fieldFormat)、位置(position)、默认值(defaultValue)、是否创建时填写(created)、是否必填(required)、是否列表上展示(viewList)、是否作为搜索条件(searchable)',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_itcf_issues_type_id`(`issues_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '自定义属性 | 系统属性和事项类型关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_business_goal
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_business_goal`;
CREATE TABLE `issues_type_ext_business_goal`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_business_goal_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务目标表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_checklist
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_checklist`;
CREATE TABLE `issues_type_ext_checklist`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_checklist_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '检查清单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_demand_chanage
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_demand_chanage`;
CREATE TABLE `issues_type_ext_demand_chanage`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  `demand_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求类别',
  `business_demand_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求来源',
  `develop_style` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '研发方式',
  `requirement_proposer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求提出人',
  `affiliated_business_dep` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属营业部',
  `assigner_department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人部门',
  `expect_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预计工时',
  `prototype` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '原型',
  `demand_of_department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求提出部门',
  `file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '附件',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '变更原因',
  `involves_changes` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否涉及关联系统变更',
  `involves_changes_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '影响关联系统内容',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_demand_chanage_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '需求变更单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_demand_pool
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_demand_pool`;
CREATE TABLE `issues_type_ext_demand_pool`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `belong_to_module` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  `business_demand_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求来源',
  `demand_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求类别',
  `develop_style` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '研发方式',
  `requirement_proposer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求提出人',
  `assigner_department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人所属部门',
  `expect_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预计工时',
  `demand_of_department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求所属部门',
  `demand_stage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求阶段',
  `is_change` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '是否变更0原始1变更',
  `file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '附件',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `prototype` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '原型',
  `dm` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '技术经理',
  `task_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_demand_pool_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 202 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '需求池表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_detail_recode
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_detail_recode`;
CREATE TABLE `issues_type_ext_detail_recode`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_detail_recode_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '详情页改造表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_devops_project
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_devops_project`;
CREATE TABLE `issues_type_ext_devops_project`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `system_name_en` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '英文名称',
  `resource_type_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目类型编码',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属模块',
  `oa_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'OA对应项目',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_project_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 259 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_func_feature
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_func_feature`;
CREATE TABLE `issues_type_ext_func_feature`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '共享项目',
  `belong_app` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属应用',
  `devops_system_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '研发系统id',
  `branch_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分支名称',
  `devops_feature_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分支id',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_func_feature_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '功能分支表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm`;
CREATE TABLE `issues_type_ext_pm`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `template_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模版id',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目协同表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm_bug
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm_bug`;
CREATE TABLE `issues_type_ext_pm_bug`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `sprint` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '冲刺',
  `bug_level` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '严重等级',
  `bug_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '缺陷类型',
  `bug_solution` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '解决方案',
  `is_shared` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否是共享事项',
  `source_project` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '原始的项目',
  `share_projects` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `is_reopen` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否重新打开',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  `release_production` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否发布生产环境',
  `update_mirror` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否更新镜像',
  `reopen_count` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '重新打开次数',
  `reopen_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '重新打开日期',
  `close_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关闭人',
  `close_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关闭日期',
  `bug_kind` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '缺陷类别',
  `version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '目标版本',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_bug_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 139 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目管理-缺陷表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm_demand
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm_demand`;
CREATE TABLE `issues_type_ext_pm_demand`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `sprint` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '冲刺',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  `tag_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `demand_stage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求阶段',
  `is_shared` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否是共享事项',
  `source_project` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '原始的项目',
  `file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '附件',
  `demand_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求类别',
  `prototype` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '原型',
  `share_projects` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `expect_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预估工时',
  `rework` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否返工',
  `working_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际工时',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_demand_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2786 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目管理-需求表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm_sprint
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm_sprint`;
CREATE TABLE `issues_type_ext_pm_sprint`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `sprint_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '版本号',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `is_locked` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否锁定',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_sprint_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目管理-冲刺表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm_task
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm_task`;
CREATE TABLE `issues_type_ext_pm_task`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `sprint` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '冲刺',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `task_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务类型',
  `is_shared` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否是共享事项',
  `source_project` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '原始的项目',
  `share_projects` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `expect_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预计工时',
  `working_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际工时',
  `rework` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否返工',
  `remain_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '剩余工时',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_task_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 593 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目管理-任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm_test
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm_test`;
CREATE TABLE `issues_type_ext_pm_test`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_test_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_pm_version
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_pm_version`;
CREATE TABLE `issues_type_ext_pm_version`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `relation_sprint` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联迭代',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `is_locked` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否锁定',
  `release_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '发布说明',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_pm_version_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_project_milestone
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_project_milestone`;
CREATE TABLE `issues_type_ext_project_milestone`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `real_start_time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际开始时间',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_project_milestone_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '里程碑表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_project_plan
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_project_plan`;
CREATE TABLE `issues_type_ext_project_plan`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `plane_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '项目计划类型',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `real_start_time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际开始时间',
  `belong_project_plan` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属计划阶段',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_project_plan_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目计划表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_project_risk_manage
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_project_risk_manage`;
CREATE TABLE `issues_type_ext_project_risk_manage`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `risk_level` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风险等级',
  `risk_question_category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风险问题类型',
  `share_projects` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_project_risk_manage_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '风险管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_project_set
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_project_set`;
CREATE TABLE `issues_type_ext_project_set`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_project_set_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目集表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_proto_demand
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_proto_demand`;
CREATE TABLE `issues_type_ext_proto_demand`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `demand_department` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求归口部门',
  `related_person` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关人',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_proto_demand_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '原始诉求表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_ptb_task
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_ptb_task`;
CREATE TABLE `issues_type_ext_ptb_task`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `bm` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品经理',
  `online_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上线日期',
  `dm` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '技术经理',
  `tm` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试经理',
  `operations_team_reviewer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运营团队审核人',
  `work_level_assess` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作等级评估',
  `valuator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评估人',
  `assess_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评估日期',
  `product_retest_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品复测日期',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `test_pass_flag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试是否通过',
  `test_case_step` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '测试用例文本描述',
  `train_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '培训日期',
  `trained_person` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参加培训人员',
  `qc_team_assess_flag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '质量管理团队是否评估',
  `demand_person` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求申请人',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_ptb_task_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台办任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_release_order
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_release_order`;
CREATE TABLE `issues_type_ext_release_order`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_release_order_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发布单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_test_case
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_test_case`;
CREATE TABLE `issues_type_ext_test_case`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `review_result` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '评审结果 1-待评审 2-通过 3-不通过',
  `file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '附件',
  `belong_to_test_set` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属测试集',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `step` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '测试步骤',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `expected_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '预期结果',
  `precondition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '前置条件',
  `test_module` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试模块',
  `test_input` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试输入',
  `test_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试编号',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_test_case_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 755 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试用例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_test_plan
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_test_plan`;
CREATE TABLE `issues_type_ext_test_plan`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `sprint` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '迭代',
  `passing_rate` decimal(10, 2) NULL DEFAULT NULL COMMENT '通过率',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `plan_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '计划类型',
  `test_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试类型',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_test_plan_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试计划表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_test_set
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_test_set`;
CREATE TABLE `issues_type_ext_test_set`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `seq` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '顺序',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_test_set_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试集合表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_test_sheet
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_test_sheet`;
CREATE TABLE `issues_type_ext_test_sheet`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `test_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试类型',
  `belong_to_test_plan` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属测试计划',
  `version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '目标版本',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_test_sheet_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提测单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_testreport
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_testreport`;
CREATE TABLE `issues_type_ext_testreport`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `testreportsource` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试报告来源',
  `file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '附件',
  `actual_start_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实际开始日期',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `belong_to_test_plan` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属测试计划',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_testreport_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试报告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_ext_working_hours
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_ext_working_hours`;
CREATE TABLE `issues_type_ext_working_hours`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `issues_id` bigint(0) NULL DEFAULT NULL,
  `working_hours` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工时',
  `registration_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登记日期',
  `belong_to_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属项目',
  `share_projects` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享项目',
  `reject_reason` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核拒绝理由',
  `belong_to_module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_ext_working_hours_issues_id`(`issues_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工时表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_fields_status_roles
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_fields_status_roles`;
CREATE TABLE `issues_type_fields_status_roles`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色id,0全部-1负责人-2创建人',
  `status_id` bigint(0) NOT NULL COMMENT '问题状态ID',
  `custom_field_id` bigint(0) NULL DEFAULT NULL COMMENT '字段id',
  `permission` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'read_and_write' COMMENT '读写、只读、隐藏',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `position` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1812 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字段权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_function
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_function`;
CREATE TABLE `issues_type_function`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型ID',
  `function_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '功能插件编码',
  `config_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '功能插件数据 JSON',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `ext_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拓展字段',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_itfun_issues_type_id`(`issues_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 534 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '事项类型-功能插件配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_status
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_status`;
CREATE TABLE `issues_type_status`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型ID',
  `status_id` bigint(0) NOT NULL COMMENT '问题状态ID',
  `position` int(0) NOT NULL COMMENT '排序字段',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_its_issues_type_id`(`issues_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1746 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '事项类型状态关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_type_status_config
-- ----------------------------
DROP TABLE IF EXISTS `issues_type_status_config`;
CREATE TABLE `issues_type_status_config`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_type_id` bigint(0) NOT NULL COMMENT '事项类型ID',
  `old_status_id` bigint(0) NOT NULL COMMENT '旧状态ID',
  `new_status_id` bigint(0) NOT NULL COMMENT '新状态ID',
  `role_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色id,0全部-1负责人-2创建人',
  `assignee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '责任人',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作者',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_itsc_issues_type_id`(`issues_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1158 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作流程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for issues_workflow
-- ----------------------------
DROP TABLE IF EXISTS `issues_workflow`;
CREATE TABLE `issues_workflow`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `issues_id` bigint(0) UNSIGNED NOT NULL COMMENT '事项id',
  `model_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程模版key',
  `model_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程模版名称',
  `instance_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程id',
  `status_id` int(0) NULL DEFAULT NULL COMMENT '当前状态：审批中1、通过2、不通过3、已取消4',
  `instance_create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程发起人',
  `instance_approver` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程当前节点审批人',
  `instance_create_time` datetime(0) NULL DEFAULT NULL COMMENT '流程发起时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `instance_end_time` datetime(0) NULL DEFAULT NULL COMMENT '流程结束时间',
  `instance_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程实例名称',
  `issues_type_id` bigint(0) NULL DEFAULT NULL COMMENT '事项类型ID',
  `tenant_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作项流程关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for man_hour
-- ----------------------------
DROP TABLE IF EXISTS `man_hour`;
CREATE TABLE `man_hour`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issue_id` bigint(0) NOT NULL COMMENT '问题ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `hours` decimal(10, 1) NOT NULL COMMENT '小时',
  `spent_on` date NOT NULL COMMENT '日期，天',
  `office_way` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '现场办公|远程办公',
  `activity_id` bigint(0) NULL DEFAULT NULL COMMENT '活动ID',
  `leader_id` bigint(0) NULL DEFAULT NULL COMMENT '领导ID',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_man_hour_issues_id`(`issue_id`) USING BTREE,
  INDEX `idx_man_hour_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工时表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notice_config
-- ----------------------------
DROP TABLE IF EXISTS `notice_config`;
CREATE TABLE `notice_config`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通知名称',
  `notice_detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通知描述',
  `issues_type_id` bigint(0) NULL DEFAULT NULL COMMENT '事项类型id',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作：update_property 更新，create_issues 新建，delete_issues 删除',
  `template_id` bigint(0) NULL DEFAULT NULL COMMENT '消息模板id',
  `notice_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消息类型：1-邮件，2-短信，3-站内信，4-钉钉，5-飞书机器人',
  `notice_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消息类型名称',
  `custom_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '指定属性',
  `notice_for` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通知对象',
  `notice_for_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通知对象名',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '事项类型-通知配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '项目名称',
  `space_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '空间名称，只能是英文',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '描述',
  `status` bigint(0) NULL DEFAULT 1,
  `user_ids` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `resource_type_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '项目类型，跟amp那边保持一致',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `tenant_id` bigint(0) NOT NULL COMMENT '租户id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL COMMENT '创建人id',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `code` varchar(125) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '项目编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 194 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_charge_administrative
-- ----------------------------
DROP TABLE IF EXISTS `project_charge_administrative`;
CREATE TABLE `project_charge_administrative`  (
  `id` bigint(0) NOT NULL,
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '租户id',
  `admin_id` bigint(0) NULL DEFAULT NULL COMMENT '行政组织id',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_module
-- ----------------------------
DROP TABLE IF EXISTS `project_module`;
CREATE TABLE `project_module`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_id` bigint(0) NOT NULL COMMENT '项目id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模块名称',
  `parent_id` bigint(0) NOT NULL COMMENT '父模块id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL COMMENT '创建人id',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  `seq` int(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '项目模块表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_plan_template
-- ----------------------------
DROP TABLE IF EXISTS `project_plan_template`;
CREATE TABLE `project_plan_template`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_template_id` bigint(0) NULL DEFAULT 1 COMMENT '项目模版id:1敏捷，2瀑布',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `delay_start_days` int(0) NULL DEFAULT NULL COMMENT '预计项目开始后几天开始，用于初始化阶段计划的计划开始时间',
  `delay_end_days` int(0) UNSIGNED NULL DEFAULT NULL COMMENT '预计项目开始后几天完成，用于初始化阶段计划的计划完成时间',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '父阶段id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL COMMENT '创建者',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新者',
  `del_flag` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '1删除0有效',
  `tenant_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户ID',
  `type` int(0) NOT NULL DEFAULT 1 COMMENT '1模版2项目阶段3项目计划',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目计划模版' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_template
-- ----------------------------
DROP TABLE IF EXISTS `project_template`;
CREATE TABLE `project_template`  (
  `id` bigint(0) NOT NULL COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模版名称',
  `resource_type_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型编号，跟amp的资源类型编号保持一致',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL COMMENT '创建人',
  `update_by` bigint(0) NOT NULL COMMENT '修改人',
  `update_time` datetime(0) NOT NULL COMMENT '修改时间',
  `del_flag` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for project_top
-- ----------------------------
DROP TABLE IF EXISTS `project_top`;
CREATE TABLE `project_top`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `project_id` bigint(0) NOT NULL COMMENT '项目id',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '置顶表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for public_holiday
-- ----------------------------
DROP TABLE IF EXISTS `public_holiday`;
CREATE TABLE `public_holiday`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期',
  `type` int(0) NOT NULL COMMENT '类型 1：节假日；2：调休',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `date_unique_index`(`date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 340 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for report_send_record
-- ----------------------------
DROP TABLE IF EXISTS `report_send_record`;
CREATE TABLE `report_send_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `record_id` bigint(0) NULL DEFAULT NULL COMMENT '日志id',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT '项目id',
  `receiver_ids` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关注人',
  `send_type` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送类型 1-邮件',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目日志发送记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sprint_issues_record
-- ----------------------------
DROP TABLE IF EXISTS `sprint_issues_record`;
CREATE TABLE `sprint_issues_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `sprint_id` bigint(0) NOT NULL COMMENT '迭代id',
  `record_time` date NOT NULL COMMENT '事项类型id',
  `close_bug_number` bigint(0) NOT NULL DEFAULT 0 COMMENT '关闭bug总数',
  `close_task_number` bigint(0) NOT NULL DEFAULT 0 COMMENT '关闭任务总数',
  `close_demand_number` bigint(0) NOT NULL DEFAULT 0 COMMENT '关闭需求总数',
  `total_bug_number` bigint(0) NOT NULL DEFAULT 0 COMMENT 'bug总数',
  `total_task_number` bigint(0) NULL DEFAULT 0 COMMENT '任务总数',
  `total_demand_number` bigint(0) NULL DEFAULT 0 COMMENT '需求总数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 843 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '迭代工作项统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_id` bigint(0) UNSIGNED NOT NULL COMMENT '项目id',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '团队名称',
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '团队描述',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NOT NULL DEFAULT 1 COMMENT '创建人id',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '1删除0有效',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '团队' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team_user
-- ----------------------------
DROP TABLE IF EXISTS `team_user`;
CREATE TABLE `team_user`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `team_id` bigint(0) NOT NULL COMMENT '团队id',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `create_by` bigint(0) NOT NULL COMMENT '创建人',
  `create_time` timestamp(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '团队成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_case_operation_record
-- ----------------------------
DROP TABLE IF EXISTS `test_case_operation_record`;
CREATE TABLE `test_case_operation_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `case_id` bigint(0) NULL DEFAULT NULL COMMENT '测试用例id',
  `plan_id` bigint(0) NULL DEFAULT NULL COMMENT '测试计划id',
  `exec_result` tinyint(0) NULL DEFAULT NULL COMMENT '执行结果',
  `exec_time` datetime(0) NULL DEFAULT NULL COMMENT '执行时间',
  `exec_user_id` bigint(0) NULL DEFAULT NULL COMMENT '执行人id',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '测试用例操作记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_plan_bug_record
-- ----------------------------
DROP TABLE IF EXISTS `test_plan_bug_record`;
CREATE TABLE `test_plan_bug_record`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `test_plan_id` bigint(0) NOT NULL,
  `date` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `close_count` int(0) NULL DEFAULT NULL,
  `not_close_count` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2038 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_plan_case
-- ----------------------------
DROP TABLE IF EXISTS `test_plan_case`;
CREATE TABLE `test_plan_case`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `plan_id` bigint(0) NOT NULL COMMENT '计划ID',
  `set_id` bigint(0) NULL DEFAULT NULL COMMENT '测试集ID',
  `case_id` bigint(0) NULL DEFAULT NULL COMMENT '测试集ID',
  `exec_result` tinyint(0) NOT NULL DEFAULT 1 COMMENT '执行结果 1-待执行 2-通过 3-不通过',
  `exec_user_id` bigint(0) NULL DEFAULT NULL COMMENT '执行人',
  `exec_time` datetime(0) NULL DEFAULT NULL COMMENT '执行时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试计划测试用例关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_plan_case_bug
-- ----------------------------
DROP TABLE IF EXISTS `test_plan_case_bug`;
CREATE TABLE `test_plan_case_bug`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `plan_id` bigint(0) NOT NULL COMMENT '计划ID',
  `case_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '测试集ID',
  `bug_id` bigint(0) NOT NULL COMMENT '缺陷id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试计划测试用例缺陷关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_report
-- ----------------------------
DROP TABLE IF EXISTS `test_report`;
CREATE TABLE `test_report`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `plan_id` bigint(0) NOT NULL DEFAULT 0,
  `scenarios` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试方案',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '测试总结',
  `suggestion` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '建议',
  `background` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '背景介绍',
  `pm_opinion` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目经理意见',
  `ba_opinion` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需求负责人意见',
  `dev_opinion` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开发负责人意见',
  `tl_opinion` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试负责人意见',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试报告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for views
-- ----------------------------
DROP TABLE IF EXISTS `views`;
CREATE TABLE `views`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `issues_type_code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '事项类型code',
  `space_type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目内视图(数据维度)project，项目外user',
  `view_type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型list/new/detial',
  `view_scope` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'public公共,personal个人',
  `is_system_view` tinyint(0) NULL DEFAULT NULL COMMENT '是否是系统视图',
  `project_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目id',
  `tenant_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '租户id',
  `user_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'schema',
  `sort` int(0) NULL DEFAULT NULL COMMENT '视图排序字段',
  `version` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '版本',
  `del_flag` tinyint(0) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 191 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for views_sync_issues_record
-- ----------------------------
DROP TABLE IF EXISTS `views_sync_issues_record`;
CREATE TABLE `views_sync_issues_record`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型',
  `field` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性',
  `issues_type_code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '事项类型code',
  `user_id` bigint(0) NULL DEFAULT NULL COMMENT '用户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `del_flag` tinyint(0) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `is_wash_data` tinyint(0) NULL DEFAULT 0 COMMENT '洗数据',
  `fail_ids` json NULL COMMENT '数据清洗失败的views_ids',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for watchers
-- ----------------------------
DROP TABLE IF EXISTS `watchers`;
CREATE TABLE `watchers`  (
  `ID` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_id` bigint(0) NOT NULL COMMENT '问题ID',
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人id',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4472 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '关注者表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for working_hours_record
-- ----------------------------
DROP TABLE IF EXISTS `working_hours_record`;
CREATE TABLE `working_hours_record`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issues_id` bigint(0) NULL DEFAULT NULL COMMENT '工时id',
  `reject_reason` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核意见',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核状态',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '审核人id',
  `checker` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '审核时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标记：1已删除，0正常',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工时审核记录' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
