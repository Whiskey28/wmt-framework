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

 Date: 14/01/2025 17:10:46
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
-- Records of autotest_management
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '环境构建实例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of build_instance
-- ----------------------------
INSERT INTO `build_instance` VALUES (1, 8, 1, 1, 1, NULL, NULL, 3269643232346185728, 3269805723743232000, '', NULL, NULL, 1, '2024-03-05 17:40:09');
INSERT INTO `build_instance` VALUES (2, 8, 2, 1, 1, NULL, NULL, 3268423816287690752, 3269807866931912704, '', NULL, NULL, 1, '2024-03-05 17:42:17');
INSERT INTO `build_instance` VALUES (3, 8, 1, 1, 1, 3269838518102036480, 3269839193520562176, 3269643232346185728, 3269838520834924544, '2', NULL, NULL, 1, '2024-03-05 18:12:44');
INSERT INTO `build_instance` VALUES (4, 8, 1, 1, 1, 3269838518102036480, 3270876515045302272, 3269643232346185728, 3270875907203604480, '2,4', NULL, NULL, 1, '2024-03-06 11:23:17');
INSERT INTO `build_instance` VALUES (5, 8, 1, 6, 6, NULL, NULL, 3268423816287690752, 3308495874414202880, '', NULL, NULL, 1, '2024-04-01 10:15:22');
INSERT INTO `build_instance` VALUES (6, 12, 7, 7, 7, NULL, NULL, 3301578929360515072, 3319009416896696320, '6', NULL, NULL, 1, '2024-04-08 16:19:38');
INSERT INTO `build_instance` VALUES (7, 12, 7, 8, 8, NULL, NULL, 3301578929360515072, 3322945890520256512, '', NULL, NULL, 1, '2024-04-11 09:30:10');
INSERT INTO `build_instance` VALUES (8, 13, 8, 9, 9, NULL, NULL, 3304541119128129536, 3322954835242635264, '', NULL, NULL, 1, '2024-04-11 09:39:03');
INSERT INTO `build_instance` VALUES (9, 13, 8, 9, 9, NULL, NULL, 3304541119128129536, 3322963364745695232, '', NULL, NULL, 1, '2024-04-11 09:47:31');
INSERT INTO `build_instance` VALUES (10, 10, 10, 10, 10, NULL, NULL, 3294361419540246528, 3323237130608431104, '', NULL, NULL, 1, '2024-04-11 14:19:29');
INSERT INTO `build_instance` VALUES (11, 10, 10, 10, 10, NULL, NULL, 3294361419540246528, 3323241790966714368, '', NULL, NULL, 1, '2024-04-11 14:24:07');
INSERT INTO `build_instance` VALUES (12, 15, 11, 11, 11, NULL, NULL, 3334633259006808064, 3334958127715831808, '', NULL, NULL, 1, '2024-04-19 16:23:15');
INSERT INTO `build_instance` VALUES (13, 18, 12, 12, 12, NULL, NULL, 3335006453865762816, 3335023426150453248, '', NULL, NULL, 1, '2024-04-19 17:28:07');
INSERT INTO `build_instance` VALUES (14, 13, 8, 14, 14, NULL, NULL, 3304541119128129536, 3343565267040849920, '', NULL, NULL, 1, '2024-04-25 14:53:40');
INSERT INTO `build_instance` VALUES (15, 12, 7, 15, 15, NULL, NULL, 3301578929360515072, 3343572420812197888, '', NULL, NULL, 1, '2024-04-25 15:00:47');
INSERT INTO `build_instance` VALUES (16, 8, 1, 6, 6, NULL, NULL, 3268423816287690752, 3343658637012619264, '4,3,14', NULL, NULL, 1, '2024-04-25 16:26:26');
INSERT INTO `build_instance` VALUES (17, 32, 14, 26, 26, NULL, NULL, 3366796210320822272, 3366804399078625280, '', NULL, NULL, 1, '2024-05-11 15:39:41');
INSERT INTO `build_instance` VALUES (18, 32, 14, 26, 26, NULL, NULL, 3366796210320822272, 3366810322962599936, '', NULL, NULL, 1, '2024-05-11 15:45:34');
INSERT INTO `build_instance` VALUES (19, 8, 1, 6, 6, 3269838518102036480, 3369391906085400576, 3268423816287690752, 3369391560776863744, '4,3,14', NULL, NULL, 1, '2024-05-13 10:29:47');
INSERT INTO `build_instance` VALUES (20, 10, 10, 30, 30, NULL, NULL, 3294361419540246528, 3372305423423885312, '16', NULL, NULL, 3267307713708539904, '2024-05-15 10:44:27');
INSERT INTO `build_instance` VALUES (21, 10, 10, 30, 30, NULL, NULL, 3294361419540246528, 3372310784868470784, '16', NULL, NULL, 3267307713708539904, '2024-05-15 10:49:47');
INSERT INTO `build_instance` VALUES (22, 10, 10, 30, 30, NULL, NULL, 3294361419540246528, 3372314740650790912, '16', NULL, NULL, 1, '2024-05-15 10:53:42');
INSERT INTO `build_instance` VALUES (23, 10, 10, 30, 30, NULL, NULL, 3294361419540246528, 3372326540469456896, '16', NULL, NULL, 1, '2024-05-15 11:05:26');
INSERT INTO `build_instance` VALUES (24, 12, 7, 25, 25, NULL, NULL, 3319012819869749248, 3372637609951875072, '15', NULL, NULL, 3267307713708539904, '2024-05-15 16:14:27');
INSERT INTO `build_instance` VALUES (25, 12, 7, 25, 25, NULL, NULL, 3319012819869749248, 3372637911639773184, '15', NULL, NULL, 3267307713708539904, '2024-05-15 16:14:45');
INSERT INTO `build_instance` VALUES (26, 12, 7, 25, 25, NULL, NULL, 3319012819869749248, 3373629505050365952, '15', NULL, NULL, 3267307713708539904, '2024-05-16 08:39:49');
INSERT INTO `build_instance` VALUES (27, 12, 7, 25, 25, NULL, NULL, 3319012819869749248, 3373631011879243776, '15', NULL, NULL, 3267307713708539904, '2024-05-16 08:41:18');
INSERT INTO `build_instance` VALUES (28, 12, 7, 25, 25, NULL, NULL, 3301578929360515072, 3373633108712476672, '15', NULL, NULL, 3267307713708539904, '2024-05-16 08:43:23');
INSERT INTO `build_instance` VALUES (29, 12, 7, 25, 25, NULL, NULL, 3301578929360515072, 3373633596459700224, '15', NULL, NULL, 3267307713708539904, '2024-05-16 08:43:52');
INSERT INTO `build_instance` VALUES (30, 12, 7, 25, 25, NULL, NULL, 3301578929360515072, 3373729689105190912, '15', NULL, NULL, 3267307713708539904, '2024-05-16 10:19:20');
INSERT INTO `build_instance` VALUES (31, 12, 7, 25, 25, NULL, NULL, 3301578929360515072, 3373733771001843712, '15', NULL, NULL, 3267307713708539904, '2024-05-16 10:23:23');
INSERT INTO `build_instance` VALUES (32, 12, 7, 25, 25, NULL, NULL, 3301578929360515072, 3373736253492940800, '15', NULL, NULL, 3267307713708539904, '2024-05-16 10:25:51');
INSERT INTO `build_instance` VALUES (33, 12, 7, 25, 25, NULL, NULL, 3371310723678195712, 3373739146656731136, '15', NULL, NULL, 3267307713708539904, '2024-05-16 10:28:44');
INSERT INTO `build_instance` VALUES (34, 12, 7, 25, 25, NULL, NULL, 3319012819869749248, 3373740738931970048, '15', NULL, NULL, 3267307713708539904, '2024-05-16 10:30:19');
INSERT INTO `build_instance` VALUES (35, 12, 7, 25, 25, NULL, NULL, 3319012819869749248, 3373744608714280960, '15', NULL, NULL, 3267307713708539904, '2024-05-16 10:34:09');
INSERT INTO `build_instance` VALUES (36, 13, 8, 27, 27, NULL, NULL, 3373750862236995584, 3373752658019864576, '', NULL, NULL, 3267307713708539904, '2024-05-16 10:42:09');
INSERT INTO `build_instance` VALUES (37, 13, 8, 27, 27, NULL, NULL, 3373761579740680192, 3373763563780689920, '', NULL, NULL, 3267307713708539904, '2024-05-16 10:52:59');
INSERT INTO `build_instance` VALUES (38, 13, 8, 45, 45, NULL, NULL, 3373750862236995584, 3394080772943880192, '17', NULL, NULL, 3267307713708539904, '2024-05-30 11:16:19');
INSERT INTO `build_instance` VALUES (39, 13, 8, 45, 45, NULL, NULL, 3373761579740680192, 3394084320217767936, '17', NULL, NULL, 3267307713708539904, '2024-05-30 11:19:51');
INSERT INTO `build_instance` VALUES (40, 12, 7, 48, 48, NULL, NULL, 3301578929360515072, 3394094313549701120, '18', NULL, NULL, 3267307713708539904, '2024-05-30 11:29:46');
INSERT INTO `build_instance` VALUES (41, 12, 7, 48, 48, NULL, NULL, 3319012819869749248, 3394099938061033472, '18', NULL, NULL, 3267307713708539904, '2024-05-30 11:35:21');
INSERT INTO `build_instance` VALUES (42, 13, 8, 73, 73, NULL, NULL, 3373761579740680192, 3404185915830226944, '20', NULL, NULL, 3267307713708539904, '2024-06-06 10:34:53');
INSERT INTO `build_instance` VALUES (43, 12, 7, 48, 48, NULL, NULL, 3369838149395927040, 3404454798214483968, '18', NULL, NULL, 3267303552673759232, '2024-06-06 15:01:59');
INSERT INTO `build_instance` VALUES (44, 12, 7, 48, 48, NULL, NULL, 3369838149395927040, 3404459934223618048, '18,15', NULL, NULL, 3267303552673759232, '2024-06-06 15:07:05');
INSERT INTO `build_instance` VALUES (45, 100, 15, 74, 74, NULL, NULL, 3397215227678138368, 3405534941368471552, '21', NULL, NULL, 3267303552673759232, '2024-06-07 08:55:01');
INSERT INTO `build_instance` VALUES (46, 100, 16, 74, 74, NULL, NULL, 3397219875604504576, 3405653603513454592, '21', NULL, NULL, 3267303552673759232, '2024-06-07 10:52:54');
INSERT INTO `build_instance` VALUES (47, 12, 7, 48, 48, NULL, NULL, 3369838149395927040, 3413096405071482880, '18,15', NULL, NULL, 1, '2024-06-12 14:06:39');
INSERT INTO `build_instance` VALUES (48, 12, 5, 48, 48, NULL, NULL, 3303063228047863808, 3413099023927791616, '', NULL, NULL, 1, '2024-06-12 14:09:15');
INSERT INTO `build_instance` VALUES (49, 12, 5, 48, 48, NULL, NULL, 3303063228047863808, 3413099493605953536, '18,15', NULL, NULL, 1, '2024-06-12 14:09:43');
INSERT INTO `build_instance` VALUES (50, 12, 5, 48, 48, NULL, NULL, 3369838149395927040, 3413157118360080384, '18,15', NULL, NULL, 3267303552673759232, '2024-06-12 15:06:58');
INSERT INTO `build_instance` VALUES (51, 12, 5, 48, 48, NULL, NULL, 3303063228047863808, 3413293106940006400, '18,15', NULL, NULL, 3267303552673759232, '2024-06-12 17:22:03');
INSERT INTO `build_instance` VALUES (52, 12, 5, 48, 48, NULL, NULL, 3303063228047863808, 3414248536189095936, '18,15', NULL, NULL, 3267303552673759232, '2024-06-13 09:11:11');
INSERT INTO `build_instance` VALUES (53, 12, 5, 48, 48, NULL, NULL, 3303063228047863808, 3414249094434181120, '18,15', NULL, NULL, 3267303552673759232, '2024-06-13 09:11:45');
INSERT INTO `build_instance` VALUES (54, 226, 17, NULL, NULL, NULL, NULL, 3492891454916755456, 3494279589370232832, '', NULL, NULL, 1, '2024-08-07 14:14:54');
INSERT INTO `build_instance` VALUES (55, 226, 17, NULL, NULL, NULL, NULL, 3492891454916755456, 3494482617356484608, '', NULL, NULL, 1, '2024-08-07 17:36:35');

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '特性管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of devops_feature
-- ----------------------------
INSERT INTO `devops_feature` VALUES (1, NULL, '流水线', '', 0, 'CONTROLLED', 0, NULL, 8, 1, NULL, '', 1, 1, NULL, 1, 'pipeline', NULL, 'FT000000001', 1, 1, '2024-03-05 18:05:04', 1, '2024-03-04 19:55:56', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (2, NULL, '流水线运行时颜色判断', '', 0, 'CONTROLLED', 0, NULL, 8, 1, NULL, '2024-03-07 ', 2, 1, NULL, 1, 'pipeline-color', NULL, 'FT000000002', 0, 1, '2024-03-05 18:08:09', 1, '2024-03-05 18:08:09', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (3, NULL, '资产证明-去除手机号', '', 0, 'CONTROLLED', 0, NULL, 8, 2, NULL, '', 3, 1, NULL, 1, 'cancel-phone-num', NULL, 'FT000000003', 0, 1, '2024-03-05 18:24:06', 1, '2024-03-05 18:24:06', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (4, NULL, '研发协同批量操作', '', 0, 'CONTROLLED', 0, NULL, 8, 1, NULL, '2024-03-06 ', 4, 1, NULL, 1, 'dev-plcz-2.0.0', NULL, 'FT000000004', 0, 2856704057914482688, '2024-03-06 11:13:11', 2856704057914482688, '2024-03-06 11:13:11', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (5, NULL, 'test', '千万千万', 1, 'GENERAL', 0, NULL, 9, 1, NULL, '', 1, 2, NULL, 1, 'test', NULL, 'FB000000005', 0, 1, '2024-03-21 15:13:59', 1, '2024-03-21 15:13:59', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (6, NULL, '0408-测试发版', '0408-测试发版', 0, 'GENERAL', 5, NULL, 12, 7, NULL, '2024-04-08 ', 1, 3, NULL, 3267307713708539904, '0408', NULL, 'FT000000006', 0, 3267307713708539904, '2024-04-08 16:04:21', 1, '2024-05-10 17:23:17', 2, '2024-05-10 17:23:17', 3267284931239067648);
INSERT INTO `devops_feature` VALUES (7, NULL, '0411-release', '0411上线', 0, 'GENERAL', 5, NULL, 12, 7, NULL, '2024-04-11 ', 2, 3, NULL, 3267307713708539904, '0411-release', NULL, 'FT000000007', 0, 1, '2024-04-11 09:26:49', 1, '2024-05-10 17:23:15', 2, '2024-05-10 17:23:15', 3267284931239067648);
INSERT INTO `devops_feature` VALUES (8, NULL, '0411-release', '0411-release', 0, 'GENERAL', 5, NULL, 13, 7, NULL, '2024-04-11 ', 1, 3, NULL, 3267307713708539904, '0411-release', NULL, 'FT000000008', 1, 3267307713708539904, '2024-05-13 14:40:24', 1, '2024-05-13 09:57:04', 2, '2024-05-13 09:57:04', 3267284931239067648);
INSERT INTO `devops_feature` VALUES (9, NULL, '0411-release', '0411-release', 0, 'GENERAL', 5, NULL, 10, 7, NULL, '2024-04-11 ', 1, 3, NULL, 3267307713708539904, '0411-release', NULL, 'FT000000009', 0, 1, '2024-04-11 14:08:50', 3267307713708539904, '2024-05-14 14:28:21', 2, '2024-05-14 14:28:21', 3267284931239067648);
INSERT INTO `devops_feature` VALUES (10, NULL, '2024.05.09', '2024.05.09功能分支', 0, 'GENERAL', 5, NULL, 15, 10, NULL, '2024-05-07 ', 1, 6, NULL, 3271122024350023680, '2024.05.09', NULL, 'FT000000010', 0, 1, '2024-04-19 16:15:53', 3271121021592600576, '2024-05-31 15:26:34', 2, '2024-05-31 15:26:34', 3267284931239067648);
INSERT INTO `devops_feature` VALUES (11, NULL, '2024.04.25', '2024.04.25上线', 0, 'GENERAL', 0, NULL, 18, 11, NULL, '2024-04-23 ', 1, 7, NULL, 3267307713708539904, '2024.04.25', NULL, 'FT000000011', 1, 3267307713708539904, '2024-07-01 09:03:59', 1, '2024-04-19 16:56:14', 0, NULL, 3267284931239067648);
INSERT INTO `devops_feature` VALUES (12, NULL, '12', '', 0, 'GENERAL', 0, NULL, 9, 1, NULL, '', 2, 2, NULL, 1, '12', NULL, 'FT000000012', 0, 1, '2024-04-22 11:09:47', 1, '2024-04-22 11:09:47', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (13, NULL, '123', '', 0, 'GENERAL', 0, NULL, 8, 1, NULL, '', 5, 1, NULL, 1, '123', NULL, 'FT000000013', 1, 1, '2024-05-13 10:29:23', 1, '2024-04-22 11:18:48', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (14, NULL, '430需求上线', '', 0, 'CONTROLLED', 0, NULL, 8, 1, NULL, '', 6, 1, NULL, 1, 'wwfdd-1.0.0', NULL, 'FT000000014', 0, 1, '2024-04-25 16:25:41', 1, '2024-04-25 16:25:41', 0, NULL, 2498172061581504512);
INSERT INTO `devops_feature` VALUES (15, NULL, '0516-官网后端上线', '0516-官网后端上线的功能分支-解决业务需求+bug', 0, 'GENERAL', 0, NULL, 12, 7, NULL, '2024-05-16 ', 3, 3, NULL, 3267307713708539904, '0516', NULL, 'FT000000015', 0, 3267307713708539904, '2024-05-13 17:27:37', 3267307713708539904, '2024-05-13 17:27:37', 0, NULL, 3267284931239067648);
INSERT INTO `devops_feature` VALUES (16, NULL, '0516-官网后管前端上线', '0516-官网后管前端上线分支-解决业务需求+bug', 0, 'GENERAL', 0, NULL, 10, 7, NULL, '2024-05-16 ', 2, 3, NULL, 3267307713708539904, '0516', NULL, 'FT000000016', 0, 3267307713708539904, '2024-05-14 14:32:54', 3267307713708539904, '2024-05-14 14:32:54', 0, NULL, 3267284931239067648);
INSERT INTO `devops_feature` VALUES (17, NULL, '2024.05.30-党建修复', '2024.05.30上线-党建修复', 1, 'GENERAL', 0, NULL, 13, 7, NULL, '2024-05-30 ', 2, 3, NULL, 3267307713708539904, '20240530', NULL, 'FB000000017', 0, 3267307713708539904, '2024-05-30 11:14:31', 3267307713708539904, '2024-05-30 11:14:31', 0, NULL, 3267284931239067648);
INSERT INTO `devops_feature` VALUES (18, NULL, '2024.05.30-后端-党建修复', '2024.05.30-后端-党建修复', 1, 'GENERAL', 5, NULL, 12, 7, NULL, '2024-05-30 ', 4, 3, NULL, 3267307713708539904, '20240530', NULL, 'FB000000018', 0, 3267307713708539904, '2024-05-30 11:24:35', 3267307713708539904, '2024-06-12 16:58:52', 2, '2024-06-12 16:58:52', 3267284931239067648);
INSERT INTO `devops_feature` VALUES (19, NULL, '优化效能度量大屏代码行数统计', '<p>优化效能度量大屏代码行数统计，使用commitCountTotal统计行数，commitCountTotalNew统计次数</p>', 0, 'CONTROLLED', 0, NULL, 98, 35, NULL, '2024-06-06 ', 1, 34, NULL, 3267307713708539904, 'commitCount', NULL, 'FT000000019', 0, 1, '2024-06-04 10:52:19', 1, '2024-06-04 11:02:21', 0, NULL, 3267284931239067648);
INSERT INTO `devops_feature` VALUES (20, NULL, '2024.06.06-上线', '2024.06.06-上线', 0, 'GENERAL', 0, NULL, 13, 7, NULL, '2024-06-06 ', 3, 3, NULL, 3267307713708539904, '2024.06.06', NULL, 'FT000000020', 0, 3267307713708539904, '2024-06-06 10:30:59', 3267307713708539904, '2024-06-06 10:30:59', 0, NULL, 3267284931239067648);
INSERT INTO `devops_feature` VALUES (21, NULL, '项目概览-延期需求判断逻辑修正', '项目概览-延期需求判断逻辑修正', 1, 'CONTROLLED', 0, NULL, 100, 35, NULL, '2024-06-07 ', 1, 34, NULL, 3267303552673759232, '20240606', NULL, 'FB000000021', 0, 3267303552673759232, '2024-06-06 10:46:09', 3267303552673759232, '2024-06-06 10:46:09', 0, NULL, 3267284931239067648);

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
) ENGINE = InnoDB AUTO_INCREMENT = 277 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '子系统阶段配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of devops_stage
-- ----------------------------
INSERT INTO `devops_stage` VALUES (1, 8, 101, 4, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (2, 8, 102, 4, 1, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (3, 8, 103, 4, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (4, 9, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (5, 9, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (6, 9, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (7, 10, 101, 7, 0, 0, '开发阶段常用于管理自测/联调环境', 21, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (8, 10, 102, 8, 1, 1, '测试阶段常用于管理集成测试环境', 19, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (9, 10, 103, 7, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', 21, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (10, 12, 101, 7, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (11, 12, 102, 8, 1, 1, '测试阶段常用于管理集成测试环境', 19, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (12, 12, 103, 8, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (13, 13, 101, 7, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (14, 13, 102, 8, 1, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (15, 13, 103, 7, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (16, 11, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (17, 11, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (18, 11, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (19, 18, 101, 9, 0, 0, '开发阶段常用于管理自测/联调环境', 23, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (20, 18, 102, 12, 1, 1, '测试阶段常用于管理集成测试环境', 24, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (21, 18, 103, 9, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (22, 15, 101, 10, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (23, 15, 102, 11, 1, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (24, 15, 103, 10, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (25, 16, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (26, 16, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (27, 16, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (28, 22, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (29, 22, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (30, 22, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (31, 27, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (32, 27, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (33, 27, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (34, 28, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (35, 28, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (36, 28, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (37, 32, 101, 19, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (38, 32, 102, 20, 1, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (39, 32, 103, 19, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (40, 25, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (41, 25, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (42, 25, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (43, 29, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (44, 29, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (45, 29, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (46, 35, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (47, 35, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (48, 35, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (49, 46, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (50, 46, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (51, 46, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (52, 34, 101, 17, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (53, 34, 102, 18, 1, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (54, 34, 103, 17, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (55, 33, 101, 17, 0, 0, '开发阶段常用于管理自测/联调环境', 30, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (56, 33, 102, 18, 1, 1, '测试阶段常用于管理集成测试环境', 31, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (57, 33, 103, 17, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', 30, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (58, 66, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (59, 66, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (60, 66, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (61, 14, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (62, 14, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (63, 14, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (64, 98, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (65, 98, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (66, 98, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (67, 94, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (68, 94, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (69, 94, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (70, 100, 101, 53, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, 67, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (72, 100, 103, 54, 1, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (73, 180, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (74, 180, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (75, 180, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (76, 192, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (77, 192, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (78, 192, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (79, 158, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (80, 158, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (81, 158, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (82, 182, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (83, 182, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (84, 182, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (85, 191, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (86, 191, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (87, 191, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (88, 176, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (89, 176, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (90, 176, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (91, 30, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (92, 30, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (93, 30, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (94, 195, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (95, 195, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (96, 195, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (97, 174, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (98, 174, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (99, 174, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (100, 155, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (101, 155, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (102, 155, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (103, 204, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (104, 204, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (105, 204, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (106, 209, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (107, 209, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (108, 209, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (109, 211, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (110, 211, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (111, 211, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (112, 205, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (113, 205, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (114, 205, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (115, 207, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (116, 207, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (117, 207, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (118, 208, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (119, 208, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (120, 208, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (121, 151, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (122, 151, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (123, 151, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (124, 153, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (125, 153, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (126, 153, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (127, 165, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (128, 165, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (129, 165, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (130, 152, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (131, 152, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (132, 152, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (133, 220, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (134, 220, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (135, 220, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (136, 219, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (137, 219, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (138, 219, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (139, 218, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (140, 218, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (141, 218, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (142, 210, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (143, 210, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (144, 210, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (145, 109, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (146, 109, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (147, 109, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (148, 212, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (149, 212, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (150, 212, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (151, 226, 101, 53, 0, 0, '开发阶段常用于管理自测/联调环境', NULL, 67, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (152, 226, 102, 81, 1, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (153, 226, 103, 54, 2, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (154, 215, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (155, 215, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (156, 215, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (157, 229, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (158, 229, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (159, 229, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (160, 222, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (161, 222, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (162, 222, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (163, 221, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (164, 221, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (165, 221, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (166, 235, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (167, 235, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (168, 235, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (169, 82, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (170, 82, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (171, 82, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (172, 242, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (173, 242, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (174, 242, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (175, 250, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (176, 250, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (177, 250, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (178, 125, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (179, 125, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (180, 125, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (181, 110, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (182, 110, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (183, 110, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (184, 83, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (185, 83, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (186, 83, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (187, 95, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (188, 95, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (189, 95, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (190, 36, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (191, 36, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (192, 36, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (193, 23, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (194, 23, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (195, 23, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (196, 102, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (197, 102, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (198, 102, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (199, 79, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (200, 79, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (201, 79, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (202, 296, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (203, 296, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (204, 296, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (205, 54, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (206, 54, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (207, 54, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (208, 305, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (209, 305, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (210, 305, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (211, 300, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (212, 300, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (213, 300, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (214, 124, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (215, 124, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (216, 124, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (217, 297, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (218, 297, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (219, 297, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (220, 311, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (221, 311, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (222, 311, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (223, 313, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (224, 313, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (225, 313, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (226, 74, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (227, 74, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (228, 74, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (229, 141, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (230, 141, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (231, 141, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (232, 315, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (233, 315, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (234, 315, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (235, 322, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (236, 322, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (237, 322, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (238, 130, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (239, 130, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (240, 130, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (241, 319, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (242, 319, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (243, 319, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (244, 318, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (245, 318, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (246, 318, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (247, 333, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (248, 333, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (249, 333, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (250, 323, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (251, 323, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (252, 323, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (253, 334, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (254, 334, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (255, 334, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (256, 304, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (257, 304, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (258, 304, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (259, 265, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (260, 265, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (261, 265, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (262, 326, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (263, 326, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (264, 326, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (265, 206, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (266, 206, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (267, 206, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (268, 328, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (269, 328, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (270, 328, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (271, 97, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (272, 97, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (273, 97, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (274, 106, 101, NULL, 4, 0, '开发阶段常用于管理自测/联调环境', NULL, NULL, '开发阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (275, 106, 102, NULL, 4, 1, '测试阶段常用于管理集成测试环境', NULL, NULL, '测试阶段', '0,1,2,4,3');
INSERT INTO `devops_stage` VALUES (276, 106, 103, NULL, 4, 1, '预发阶段常用于管理回归验证环境及制品生成', NULL, NULL, '预发布阶段', '0,1,2,4,3');

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
-- Records of devops_stage_env
-- ----------------------------
INSERT INTO `devops_stage_env` VALUES (1, 8, 1, NULL, 'dev', 'dev01', 1, NULL, NULL, '3', NULL, 0, 1, '2024-03-05 17:39:42', 1, '2024-03-05 17:39:42');
INSERT INTO `devops_stage_env` VALUES (2, 8, 2, NULL, 'test', 'test', 4, 2, 'devops', NULL, NULL, 0, 1, '2024-03-05 17:42:03', 1, '2024-03-05 17:42:03');
INSERT INTO `devops_stage_env` VALUES (3, 8, 3, NULL, 'prod', 'pro01', 4, 2, 'devops', NULL, NULL, 0, 1, '2024-03-05 17:42:41', 1, '2024-03-05 17:42:41');
INSERT INTO `devops_stage_env` VALUES (4, 8, 1, NULL, 'dev02', 'dev02', 1, NULL, NULL, '3', NULL, 0, 2856704057914482688, '2024-03-06 11:18:59', 2856704057914482688, '2024-03-06 11:18:59');
INSERT INTO `devops_stage_env` VALUES (5, 12, 11, NULL, 'test', 'test', 1, NULL, NULL, '9', NULL, 0, 1, '2024-03-27 16:09:49', 3267303552673759232, '2024-06-12 17:21:49');
INSERT INTO `devops_stage_env` VALUES (6, 12, 12, NULL, 'portalsite-dev', 'dev-0408', 1, NULL, NULL, '6', NULL, 0, 3267307713708539904, '2024-04-08 16:08:56', 3267307713708539904, '2024-04-08 16:08:56');
INSERT INTO `devops_stage_env` VALUES (7, 12, 10, NULL, 'portalsite-dev', 'dev-040801', 1, NULL, NULL, '10', NULL, 0, 1, '2024-04-08 16:18:08', 1, '2024-04-08 16:18:08');
INSERT INTO `devops_stage_env` VALUES (8, 13, 13, NULL, 'portalsite-web-dev', 'dev-0411', 1, NULL, NULL, '11', NULL, 0, 1, '2024-04-10 16:51:18', 3267307713708539904, '2024-04-11 10:02:40');
INSERT INTO `devops_stage_env` VALUES (9, 13, 15, NULL, 'portalsite-web-dev', 'dev-0411-prod', 1, NULL, NULL, '11', NULL, 0, 3267307713708539904, '2024-04-11 10:04:10', 3267307713708539904, '2024-04-11 10:04:10');
INSERT INTO `devops_stage_env` VALUES (10, 10, 7, NULL, '0411-release', '0411-release', 1, NULL, NULL, '11', NULL, 0, 1, '2024-04-11 14:10:57', 1, '2024-04-11 14:10:57');
INSERT INTO `devops_stage_env` VALUES (11, 15, 22, NULL, '0509迭代', '0509-iteration', 1, NULL, NULL, '12', NULL, 0, 1, '2024-04-19 15:39:51', 1, '2024-04-19 15:39:51');
INSERT INTO `devops_stage_env` VALUES (12, 18, 19, NULL, '0425上线', '0425-iteration', 1, NULL, NULL, '15', NULL, 0, 1, '2024-04-19 17:04:13', 1, '2024-04-19 17:04:13');
INSERT INTO `devops_stage_env` VALUES (13, 8, 2, NULL, 'test01', 'test-1', 4, 2, 'devops', NULL, NULL, 0, 1, '2024-04-22 11:33:20', 1, '2024-04-22 11:33:20');
INSERT INTO `devops_stage_env` VALUES (14, 32, 37, NULL, '0511上线', '0511-release', 1, NULL, NULL, '23', NULL, 0, 1, '2024-05-11 15:39:21', 1, '2024-05-11 15:39:21');
INSERT INTO `devops_stage_env` VALUES (15, 100, 70, NULL, 'DevOps开发环境', 'devops_dev', 4, 45, 'devops', NULL, NULL, 0, 3267303552673759232, '2024-06-07 08:52:58', 3267303552673759232, '2024-06-07 08:52:58');
INSERT INTO `devops_stage_env` VALUES (16, 100, 72, NULL, 'DevOps生产环境', 'devops_pro', 4, 46, 'devops', NULL, NULL, 0, 3267303552673759232, '2024-06-07 10:51:35', 3267303552673759232, '2024-06-07 10:51:35');
INSERT INTO `devops_stage_env` VALUES (17, 226, 151, NULL, '开发环境', 'dev', 4, 104, 'devops', NULL, NULL, 0, 1, '2024-08-07 11:10:21', 1, '2024-08-07 11:10:21');

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
-- Records of devops_stage_env_feature
-- ----------------------------
INSERT INTO `devops_stage_env_feature` VALUES (1, 1, 2, 1);
INSERT INTO `devops_stage_env_feature` VALUES (2, 1, 4, 1);
INSERT INTO `devops_stage_env_feature` VALUES (3, 2, 4, 1);
INSERT INTO `devops_stage_env_feature` VALUES (5, 6, 6, 7);
INSERT INTO `devops_stage_env_feature` VALUES (6, 7, 6, NULL);
INSERT INTO `devops_stage_env_feature` VALUES (7, 7, 6, 7);
INSERT INTO `devops_stage_env_feature` VALUES (8, 1, 4, 6);
INSERT INTO `devops_stage_env_feature` VALUES (9, 1, 3, 6);
INSERT INTO `devops_stage_env_feature` VALUES (10, 2, 3, 1);
INSERT INTO `devops_stage_env_feature` VALUES (11, 2, 2, 1);
INSERT INTO `devops_stage_env_feature` VALUES (12, 1, 14, 6);
INSERT INTO `devops_stage_env_feature` VALUES (13, 7, 15, 25);
INSERT INTO `devops_stage_env_feature` VALUES (14, 10, 16, 30);
INSERT INTO `devops_stage_env_feature` VALUES (16, 7, 18, 48);
INSERT INTO `devops_stage_env_feature` VALUES (17, 8, 20, 45);
INSERT INTO `devops_stage_env_feature` VALUES (18, 8, 20, 73);
INSERT INTO `devops_stage_env_feature` VALUES (19, 7, 15, 48);
INSERT INTO `devops_stage_env_feature` VALUES (20, 15, 21, 74);
INSERT INTO `devops_stage_env_feature` VALUES (21, 16, 21, 74);
INSERT INTO `devops_stage_env_feature` VALUES (22, 5, 18, 48);
INSERT INTO `devops_stage_env_feature` VALUES (23, 5, 15, 48);

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
) ENGINE = InnoDB AUTO_INCREMENT = 338 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '子系统表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of devops_sub_system
-- ----------------------------
INSERT INTO `devops_sub_system` VALUES (1, NULL, 'Ruoyi系统后端服务', NULL, 'RuoYi', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Java', 1, 1, '2024-03-04 10:06:55', 1, '2024-03-04 09:59:25', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (2, NULL, 'RuoYi系统后端服务', NULL, 'RuoYi-test', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Java', 1, 1, '2024-03-04 16:13:57', 1, '2024-03-04 10:08:04', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (3, NULL, 'RuoYi-Demo子系统后端服务', NULL, 'ruoyi-demo', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Java', 1, 1, '2024-03-04 16:32:15', 1, '2024-03-04 16:14:59', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (4, NULL, 'message后端服务', NULL, 'message', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Java', 1, 1, '2024-03-04 17:59:55', 1, '2024-03-04 16:45:33', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (5, NULL, 'message22后端服务', NULL, 'message22', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Java', 1, 1, '2024-03-04 17:59:57', 1, '2024-03-04 16:52:39', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (6, NULL, 'message123后端服务', NULL, 'message123', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Java', 1, 1, '2024-03-04 18:00:01', 1, '2024-03-04 16:53:51', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (7, NULL, 'message1234后端服务', NULL, 'message1234', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Java', 1, 1, '2024-03-04 18:00:04', 1, '2024-03-04 17:20:42', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (8, NULL, 'Ruoyi-demo后端服务', NULL, 'RuoYi', NULL, '', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Java', 0, 1, '2024-03-04 18:26:25', 1, '2024-03-04 18:26:25', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (9, NULL, '这是一个子系统后端服务', NULL, 'test', NULL, '', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Java', 0, 1, '2024-03-20 16:34:17', 1, '2024-03-20 16:34:17', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (10, NULL, '后管前端服务', NULL, 'system-web', NULL, '门户官网后管前端服务', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271122024350023680, NULL, NULL, 'JavaScript', 0, 1, '2024-03-22 15:35:55', 1, '2024-03-22 15:36:30', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (11, NULL, '门户网站后端服务', NULL, 'portalsite', NULL, '', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2856704057914482688, NULL, NULL, 'Java', 0, 2856704057914482688, '2024-03-25 20:00:40', 2856704057914482688, '2024-03-25 20:00:40', 2498172061581504512);
INSERT INTO `devops_sub_system` VALUES (12, NULL, '后端代码后端服务', NULL, 'ahc-office', NULL, '', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267307713708539904, NULL, NULL, 'Java', 0, 3267307713708539904, '2024-03-26 11:11:46', 3267307713708539904, '2024-03-26 11:11:46', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (13, NULL, '前台前端代码前端服务', NULL, 'ahc-offic-web', NULL, '', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271125133872791552, NULL, NULL, 'JavaScript', 0, 3267307713708539904, '2024-03-26 11:16:23', 3267307713708539904, '2024-03-26 11:16:23', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (14, NULL, '统一身份认证系统后端代码后端服务', NULL, 'ahzx-tysf', NULL, '', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271120617295249408, NULL, NULL, 'Java', 0, 1, '2024-04-08 17:23:09', 1, '2024-04-08 17:23:09', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (15, NULL, '征信服务平台后端服务', NULL, 'zxfwpt', NULL, '', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271122024350023680, NULL, NULL, 'Java', 0, 1, '2024-04-09 15:54:01', 1, '2024-04-09 15:54:01', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (16, NULL, '征信服务平台前端服务-old', NULL, 'zxfwpt-web', NULL, '', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'JavaScript', 0, 1, '2024-04-09 15:55:32', 3271122670088290304, '2024-08-21 17:26:31', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (17, NULL, 'test后端服务', NULL, 'test', NULL, '', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Java', 1, 1, '2024-04-12 14:39:40', 1, '2024-04-12 14:39:24', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (18, NULL, '产品体验中心后端服务', NULL, 'ahc-experience', NULL, '', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267307713708539904, NULL, NULL, 'Java', 0, 1, '2024-04-18 12:59:12', 1, '2024-04-18 12:59:12', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (19, NULL, '产品体验中心前端服务', NULL, 'ahc-experience-web', NULL, '', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271125133872791552, NULL, NULL, 'JavaScript', 0, 1, '2024-04-18 12:59:41', 3271120617295249408, '2024-05-17 14:10:06', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (20, NULL, '徽商银行基金托管-前端服务', NULL, 'hs-fundCustody-web', NULL, '', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271125133872791552, NULL, NULL, 'JavaScript', 0, 3267307713708539904, '2024-04-22 19:25:53', 3267307713708539904, '2024-04-22 19:26:15', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (21, NULL, '统一开发框架前端-old', NULL, 'baseFramework-web', NULL, '统一开发框架前端', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271122670088290304, NULL, NULL, 'JavaScript', 0, 1, '2024-04-23 14:53:11', 3271122670088290304, '2024-08-22 09:42:31', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (22, NULL, '无为徽银徽押管理后端服务', NULL, 'wwfdd-service', NULL, '后端服务', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3342152887245934592, NULL, NULL, 'Java', 0, 3267292550326501376, '2024-04-25 11:44:38', 3267292550326501376, '2024-04-25 11:46:28', 3267281511404912640);
INSERT INTO `devops_sub_system` VALUES (23, NULL, '无为徽银徽押管理前端服务', NULL, 'wwfdd-html', NULL, '前端服务', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3342184780381229056, NULL, NULL, 'JavaScript', 0, 3267292550326501376, '2024-04-25 11:46:04', 3267292550326501376, '2024-04-25 11:46:04', 3267281511404912640);
INSERT INTO `devops_sub_system` VALUES (24, NULL, '产品体验中心H5前端服务', NULL, 'cptyzxh5', NULL, '', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'HTML', 1, 1, '2024-04-25 14:12:33', 1, '2024-04-25 14:08:42', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (25, NULL, '产品体验中心h5前端服务', NULL, 'h5', NULL, '', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'HTML', 0, 1, '2024-04-25 14:12:55', 1, '2024-04-25 14:12:55', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (26, NULL, '基线框架后端服务', NULL, 'Framework_Service', NULL, '', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Java', 0, 3271120617295249408, '2024-04-26 11:19:19', 3271120617295249408, '2024-04-26 11:19:19', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (27, NULL, '徽商银行基金托管后端服务', NULL, 'hsyhjjtg_service', NULL, '', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3270891015121600512, NULL, NULL, 'Java', 0, 1, '2024-04-26 14:20:31', 1, '2024-04-26 14:28:46', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (28, NULL, '基线框架前端前端服务', NULL, 'ahzx-web', NULL, '', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'HTML', 0, 1, '2024-04-28 15:38:18', 1, '2024-04-28 15:38:18', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (29, NULL, 'OA与DevOps联调部分后端', NULL, 'oaProject', NULL, '', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267303552673759232, NULL, NULL, 'Java', 0, 3267303552673759232, '2024-04-30 14:35:42', 3267307713708539904, '2024-06-05 16:44:57', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (30, NULL, '模型监控平台后端服务', NULL, 'ModelMonitor-backend', NULL, '', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'Java', 0, 3267296873982836736, '2024-05-09 14:39:51', 3267296873982836736, '2024-05-09 14:39:51', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (31, NULL, '模型监控平台前端服务', NULL, 'ModelMonitor-frontend', NULL, '', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'HTML', 0, 3267296873982836736, '2024-05-09 14:40:43', 3267296873982836736, '2024-05-09 14:40:43', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (32, NULL, '统一身份认证系统前端服务', NULL, 'identity-web', NULL, '', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3271121021592600576, NULL, NULL, 'HTML', 0, 3271121021592600576, '2024-05-09 14:59:45', 3271121021592600576, '2024-05-09 14:59:45', 3267284931239067648);
INSERT INTO `devops_sub_system` VALUES (33, NULL, 'psbcloan后端服务', NULL, 'psbcloan', NULL, '', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'Java', 0, 3267296873982836736, '2024-05-10 09:31:54', 3267296873982836736, '2024-05-10 09:31:54', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (34, NULL, 'psbcConsumerFinance前端服务', NULL, 'psbcConsumerFinance', NULL, '', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'HTML', 0, 3267296873982836736, '2024-05-10 09:32:53', 3267296873982836736, '2024-05-10 09:32:53', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (35, NULL, '聚合营销平台后端服务', NULL, 'aggregated-marketing-backend', NULL, '', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3369369332493033472, NULL, NULL, 'Java', 0, 3267292550326501376, '2024-05-13 10:16:45', 3267292550326501376, '2024-05-27 16:46:07', 3267281511404912640);
INSERT INTO `devops_sub_system` VALUES (36, NULL, '聚合营销平台前端服务', NULL, 'aggregated-marketing-frontend', NULL, '', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3342184780381229056, NULL, NULL, 'HTML', 0, 3267296873982836736, '2024-05-13 10:19:26', 3267296873982836736, '2024-05-13 10:19:26', 3267281511404912640);
INSERT INTO `devops_sub_system` VALUES (37, NULL, '采集平台前端服务', NULL, 'cj_server', NULL, '采集平台前端子系统', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'HTML', 0, 3267296873982836736, '2024-05-24 11:31:54', 3267296873982836736, '2024-05-24 11:31:54', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (38, NULL, '采集平台后端服务', NULL, 'cj_server_backend', NULL, '采集平台后端服务子系统', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'Java', 0, 3267296873982836736, '2024-05-24 11:34:33', 3267296873982836736, '2024-05-24 11:34:33', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (39, NULL, '管理平台前端服务', NULL, 'gl_server_frontend', NULL, '管理平台前端子系统', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'HTML', 0, 3267296873982836736, '2024-05-24 11:38:17', 3267296873982836736, '2024-05-24 11:38:17', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (40, NULL, '管理平台后端服务', NULL, 'gl-server-backend', NULL, '管理平台后端子系统', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'Java', 0, 3267296873982836736, '2024-05-24 11:39:14', 3267296873982836736, '2024-05-24 11:39:14', 3267282062251245568);
INSERT INTO `devops_sub_system` VALUES (41, NULL, '开发平台前端服务', NULL, 'kf-server-frontend', NULL, '开发平台前端服务', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3267296873982836736, NULL, NULL, 'HTML', 0, 3267296873982836736, '2024-05-24 11:40:41', 3267296873982836736, '2024-05-24 11:40:41', 3267282062251245568);

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
) ENGINE = InnoDB AUTO_INCREMENT = 124 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of devops_system
-- ----------------------------
INSERT INTO `devops_system` VALUES (1, NULL, NULL, 'ahzx-devops', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'devops系统', 'GENERAL', NULL, 1, NULL, NULL, 0, 1, '2024-03-04 09:54:05', 1, '2024-03-04 09:54:05', 2498172061581504512, 0);
INSERT INTO `devops_system` VALUES (2, NULL, NULL, 'test', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '这是一个系统', 'GENERAL', NULL, 1, NULL, NULL, 0, 1, '2024-03-20 16:31:00', 1, '2024-03-20 16:31:00', 2498172061581504512, 0);
INSERT INTO `devops_system` VALUES (3, NULL, NULL, 'ahc-official', NULL, '安徽征信公司官网', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'AHC公司门户官网', 'GENERAL', NULL, 3271125133872791552, NULL, NULL, 0, 1, '2024-03-22 15:30:38', 3267307713708539904, '2024-05-21 09:06:46', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (4, NULL, NULL, 'portalsite', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '公司门户网站', 'GENERAL', NULL, 2856704057914482688, NULL, NULL, 0, 2856704057914482688, '2024-03-25 19:59:54', 2856704057914482688, '2024-03-25 19:59:54', 2498172061581504512, 0);
INSERT INTO `devops_system` VALUES (5, NULL, NULL, 'tysfrzsystem', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '统一身份认证系统', 'GENERAL', NULL, 3271121021592600576, NULL, NULL, 0, 1, '2024-04-08 17:21:56', 1, '2024-04-09 15:49:41', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (6, NULL, NULL, 'zxfwpt', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '征信服务平台', 'GENERAL', NULL, 3271122024350023680, NULL, NULL, 0, 1, '2024-04-09 15:53:26', 1, '2024-04-09 15:53:26', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (7, NULL, NULL, 'ahc-experience', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '产品体验中心', 'GENERAL', NULL, 3267307713708539904, NULL, NULL, 0, 1, '2024-04-18 12:58:42', 1, '2024-04-18 12:58:42', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (8, NULL, NULL, 'hs-fundCustody', NULL, '徽商银行基金托管', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '徽商银行基金托管', 'GENERAL', NULL, 3270891015121600512, NULL, NULL, 0, 3267307713708539904, '2024-04-22 19:22:07', 3267307713708539904, '2024-05-21 09:07:07', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (9, NULL, NULL, 'ahc-baseFramework', NULL, '安徽征信统一开发框架', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽征信统一开发框架', 'GENERAL', NULL, 3271122670088290304, NULL, NULL, 0, 1, '2024-04-23 14:51:33', 3267307713708539904, '2024-05-21 09:07:30', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (10, NULL, NULL, 'wwfdd', NULL, '无为徽银徽押易贷管理平台', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '无为徽银徽押易贷管理平台', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-04-25 10:19:08', 3267292550326501376, '2024-04-25 10:19:08', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (11, NULL, NULL, 'tykfkj', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '统一开发框架', 'GENERAL', NULL, 3271120617295249408, NULL, NULL, 0, 3271120617295249408, '2024-04-26 11:18:36', 3271120617295249408, '2024-04-26 11:18:36', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (12, NULL, NULL, 'oaProject', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OA日常开发', 'GENERAL', NULL, 3267303552673759232, NULL, NULL, 0, 3267303552673759232, '2024-04-30 14:34:29', 3267303552673759232, '2024-04-30 14:34:29', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (13, NULL, NULL, 'ModleMonitor', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '监控模型平台', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-05-09 14:37:32', 3267296873982836736, '2024-05-09 14:37:32', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (14, NULL, NULL, 'ChinaPostConsumerFinance', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '中邮消金API引流项目', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-05-10 09:30:43', 3267296873982836736, '2024-05-10 10:39:26', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (15, NULL, NULL, 'aggreated-marketing', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '聚合营销平台', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-05-13 09:54:30', 3267292550326501376, '2024-05-13 09:54:30', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (16, NULL, NULL, 'nxzx', NULL, '宁夏地方征信服务平台系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '宁夏地方征信服务平台', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-05-24 11:30:44', 3267296873982836736, '2024-05-24 11:30:44', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (17, NULL, NULL, 'dacc', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽征信档案仓储系统', 'GENERAL', NULL, 3271119574725492736, NULL, NULL, 1, 3271119574725492736, '2024-05-24 12:18:29', 1, '2024-05-31 11:13:29', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (18, NULL, NULL, 'lljq', NULL, '流量鉴权系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '流量鉴权系统', 'GENERAL', NULL, 3371463310998532096, NULL, NULL, 0, 3371463310998532096, '2024-05-24 14:30:10', 3371463310998532096, '2024-05-24 14:30:10', 3267284481475461120, 0);
INSERT INTO `devops_system` VALUES (19, NULL, NULL, 'graph-platform', NULL, '图计算平台系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '图计算平台', 'GENERAL', NULL, 3363893784903917568, NULL, NULL, 0, 3363893784903917568, '2024-05-27 16:50:07', 3363893784903917568, '2024-05-27 16:50:07', 3267283983108259840, 0);
INSERT INTO `devops_system` VALUES (20, NULL, NULL, 'decision-engine', NULL, '轻量级决策引擎系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '轻量级决策引擎', 'GENERAL', NULL, 3363893784903917568, NULL, NULL, 0, 3363893784903917568, '2024-05-27 16:50:51', 3363893784903917568, '2024-05-27 16:50:51', 3267283983108259840, 0);
INSERT INTO `devops_system` VALUES (21, NULL, NULL, 'kcjrcpyf', NULL, '科创金融产品研发系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '科创金融产品研发', 'GENERAL', NULL, 3363893784903917568, NULL, NULL, 0, 3363893784903917568, '2024-05-27 16:51:29', 3363893784903917568, '2024-05-27 16:51:29', 3267283983108259840, 0);
INSERT INTO `devops_system` VALUES (22, NULL, NULL, 'djylxyc', NULL, '党建引领信用村平台', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '党建引领信用村平台', 'GENERAL', NULL, 1, NULL, NULL, 0, 1, '2024-05-28 18:50:17', 1, '2024-05-28 18:50:17', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (23, NULL, NULL, 'dtg', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '省级_农业生产大托管信息服务平台', 'GENERAL', NULL, 3271115816176123904, NULL, NULL, 0, 1, '2024-05-28 19:39:44', 1, '2024-05-28 20:20:25', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (24, NULL, NULL, 'dtgc-mc', NULL, '蒙城县_农业生产大托管信息服务平台', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '蒙城县_农业生产大托管信息服务平台', 'GENERAL', NULL, 3271115816176123904, NULL, NULL, 0, 1, '2024-05-28 20:00:34', 1, '2024-05-28 20:08:50', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (25, NULL, NULL, 'certificate-storage-platform', NULL, '存证平台系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '存证平台', 'GENERAL', NULL, 3371463052193198080, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:07:32', 3267292550326501376, '2024-05-29 15:08:09', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (26, NULL, NULL, 'Little-Bee-Porject', NULL, '无为徽银小微智能风控平台系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '无为徽银小微智能风控平台', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:12:02', 3267292550326501376, '2024-05-29 15:12:02', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (27, NULL, NULL, 'psbs', NULL, '邮储银行服务系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '邮储银行服务', 'GENERAL', NULL, 3267292308583596032, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:17:47', 3267292550326501376, '2024-05-29 15:17:47', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (28, NULL, NULL, 'Tobacco-report', NULL, '小微烟草报告服务系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '小微烟草报告服务', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:19:44', 3267292550326501376, '2024-05-29 15:19:44', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (29, NULL, NULL, 'Wuwei-Huiyin-Phase-II', NULL, '徽易贷风控管理平台系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '徽易贷风控管理平台', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:21:37', 3267292550326501376, '2024-05-29 15:21:37', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (30, NULL, NULL, 'Post-Warning-Model', NULL, '小微贷后预警服务系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '小微贷后预警服务', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:26:47', 3267292550326501376, '2024-05-29 15:26:47', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (31, NULL, NULL, 'information-verification', NULL, '工商信息核验服务系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '工商信息核验服务', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-05-29 15:28:34', 3267292550326501376, '2024-05-29 15:28:34', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (32, NULL, NULL, 'xinjiang-zx', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '新疆征信平台', 'GENERAL', NULL, 3271106742436954112, NULL, NULL, 0, 1, '2024-05-30 20:17:16', 1, '2024-05-30 20:17:16', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (33, NULL, NULL, 'dacc-system', NULL, '安徽征信档案仓储系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽征信档案仓储系统', 'GENERAL', NULL, 3271119574725492736, NULL, NULL, 0, 3271119574725492736, '2024-05-31 14:07:17', 3271119574725492736, '2024-05-31 14:07:17', 3267283131949760512, 0);
INSERT INTO `devops_system` VALUES (34, NULL, NULL, 'ahc-devops', NULL, 'DevOps平台', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DevOps平台', 'GENERAL', NULL, 3267307713708539904, NULL, NULL, 0, 3267307713708539904, '2024-05-31 14:28:02', 3267307713708539904, '2024-05-31 14:28:02', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (35, NULL, NULL, 'ahc-outsource-management', NULL, '外包管理平台', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '外包管理平台', 'GENERAL', NULL, 3267307713708539904, NULL, NULL, 0, 3267307713708539904, '2024-05-31 15:01:12', 3267307713708539904, '2024-05-31 15:01:12', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (36, NULL, NULL, 'axmp', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '精准营销平台', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-01 11:09:55', 3267296873982836736, '2024-06-01 11:09:55', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (37, NULL, NULL, 'bxy-platform', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '保信银平台', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-01 12:10:06', 3267296873982836736, '2024-06-01 12:10:06', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (38, NULL, NULL, 'icbc-digital-risk-control', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '工商银行数字化风控', 'GENERAL', NULL, 3371463166462816256, NULL, NULL, 1, 3267296873982836736, '2024-06-01 12:29:32', 3267296873982836736, '2024-06-01 14:44:41', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (39, NULL, NULL, 'icbc-customer-warn', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '工商银行客户预警系统', 'GENERAL', NULL, 3371463166462816256, NULL, NULL, 0, 3267296873982836736, '2024-06-01 14:36:10', 3267296873982836736, '2024-06-01 14:36:10', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (40, NULL, NULL, 'yxw', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '邮小薇', 'GENERAL', NULL, 3371463166462816256, NULL, NULL, 0, 3267296873982836736, '2024-06-01 15:08:23', 3267296873982836736, '2024-06-01 15:08:23', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (41, NULL, NULL, 'szh-syd', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '中国银行E普惠平台', 'GENERAL', NULL, 3371463166462816256, NULL, NULL, 0, 3267296873982836736, '2024-06-01 16:18:41', 3267296873982836736, '2024-06-01 16:18:41', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (42, NULL, NULL, 'AgriculturalGuaranty', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽农担预审系统建设', 'GENERAL', NULL, 3371463408994250752, NULL, NULL, 1, 3267296873982836736, '2024-06-01 17:48:55', 3271108092029763584, '2024-09-03 14:33:28', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (43, NULL, NULL, 'jeecg-boot', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '农行合肥分行征信服务项目', 'GENERAL', NULL, 3371463408994250752, NULL, NULL, 0, 3267296873982836736, '2024-06-01 18:12:19', 3267296873982836736, '2024-06-01 18:12:19', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (44, NULL, NULL, 'bccommon-boot', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '小额贷款贷后辅助', 'GENERAL', NULL, 3371463166462816256, NULL, NULL, 0, 3267296873982836736, '2024-06-01 18:25:14', 3267296873982836736, '2024-06-01 18:25:14', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (45, NULL, NULL, 'ahc-bzdb', NULL, '亳州担保系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '亳州担保系统', 'GENERAL', NULL, 3267307713708539904, NULL, NULL, 0, 3267307713708539904, '2024-06-05 10:45:38', 3267307713708539904, '2024-06-05 10:45:38', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (46, NULL, NULL, 'Comprehensive-financial-servic', NULL, '安庆市综合金融服务平台项目系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安庆市综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 1, 3271117585803313152, '2024-06-11 15:01:13', 3271117585803313152, '2024-06-11 15:55:07', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (47, NULL, NULL, 'unified-zhjrfw-backend', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '统一后端综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 15:31:16', 3271117585803313152, '2024-06-11 15:31:16', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (48, NULL, NULL, 'huangshan-financial-servic', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '黄山综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 15:55:36', 3271117585803313152, '2024-06-11 15:55:36', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (49, NULL, NULL, 'anqing-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安庆综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:29:43', 3271117585803313152, '2024-06-11 17:29:43', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (50, NULL, NULL, 'bengbu-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '蚌埠综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:30:50', 3271117585803313152, '2024-06-11 17:30:50', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (51, NULL, NULL, 'suzhou-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '宿州综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:31:16', 3271117585803313152, '2024-06-11 17:31:16', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (52, NULL, NULL, 'tongling-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '铜陵综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:31:39', 3271117585803313152, '2024-06-11 17:31:39', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (53, NULL, NULL, 'huainan-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '淮南综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:32:01', 3271117585803313152, '2024-06-11 17:32:01', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (54, NULL, NULL, 'xuancheng-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '宣城综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:32:20', 3271117585803313152, '2024-06-11 17:32:20', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (55, NULL, NULL, 'maanshan-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '马鞍山综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:32:57', 3271117585803313152, '2024-06-11 17:32:57', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (56, NULL, NULL, 'chizhou-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '池州市综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:33:25', 3271117585803313152, '2024-06-11 17:33:25', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (57, NULL, NULL, 'bozhou-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '亳州综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-11 17:33:47', 3271117585803313152, '2024-06-11 17:33:47', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (58, NULL, NULL, 'luan-financial-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '六安综合金融服务平台项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-06-13 10:11:44', 3271117585803313152, '2024-06-13 10:11:44', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (59, NULL, NULL, 'bcc', NULL, '邮储银行三农部数字化风控项目', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '邮储银行三农部数字化风控项目', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 1, 3267296873982836736, '2024-06-16 17:33:48', 3267296873982836736, '2024-06-17 15:16:16', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (60, NULL, NULL, 'shanxi', NULL, '陕西征信综合服务平台系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '陕西征信综合服务平台', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-16 17:37:17', 3267296873982836736, '2024-06-16 17:37:17', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (61, NULL, NULL, 'shanxi-open', NULL, '陕西征信能力开放平台', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '陕西征信能力开放平台', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-16 17:49:34', 3267296873982836736, '2024-06-16 17:49:34', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (62, NULL, NULL, 'AHJR-zhjrfw-backend', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '省综合金融服务平台', 'GENERAL', NULL, 3271113249245298688, NULL, NULL, 1, 3271113249245298688, '2024-06-20 08:51:29', 1, '2024-07-08 15:11:00', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (63, NULL, NULL, 'Ahjr-zhjrfw', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '省综合金融服务平台', 'GENERAL', NULL, 3271113249245298688, NULL, NULL, 1, 3271113249245298688, '2024-06-20 09:13:20', 3271113249245298688, '2024-07-08 14:57:57', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (64, NULL, NULL, 'data-center', NULL, '数据中台自研系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '数据中台自研', 'GENERAL', NULL, 3371463499473776640, NULL, NULL, 0, 3371463310998532096, '2024-06-26 10:02:30', 3371463310998532096, '2024-06-26 10:05:00', 3267284481475461120, 0);
INSERT INTO `devops_system` VALUES (65, NULL, NULL, 'modelmonitor', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '模型监控平台', 'GENERAL', NULL, 3371463505731678208, NULL, NULL, 1, 3267296873982836736, '2024-06-27 14:23:54', 3267296873982836736, '2024-06-27 14:24:50', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (66, NULL, NULL, 'DBC', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DBC', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-27 14:24:14', 3267296873982836736, '2024-06-27 14:24:14', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (67, NULL, NULL, 'phdb-model', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽省普惠担保模型工厂', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-27 14:30:58', 3267296873982836736, '2024-06-27 14:30:58', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (68, NULL, NULL, 'csj-report', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '长三角征信链报告', 'GENERAL', NULL, 3267297734268141568, NULL, NULL, 1, 3267296873982836736, '2024-06-27 14:36:36', 3271108092029763584, '2024-09-03 11:28:18', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (69, NULL, NULL, 'hnzx-model', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '海南征信模型工厂', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-27 14:37:06', 3267296873982836736, '2024-06-27 14:37:06', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (70, NULL, NULL, 'gxdb-model', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '高新担保模型工厂', 'GENERAL', NULL, 3267297323813552128, NULL, NULL, 1, 3267296873982836736, '2024-06-27 14:38:02', 3271108092029763584, '2024-09-03 14:19:20', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (71, NULL, NULL, 'cibServer', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '兴业银行数据服务', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-27 14:39:32', 3267296873982836736, '2024-06-27 14:39:32', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (72, NULL, NULL, 'AgriculturalGuarantyDMC', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽省农业担保量化风控模型', 'GENERAL', NULL, 3371463408994250752, NULL, NULL, 1, 3267296873982836736, '2024-06-27 14:40:35', 1, '2024-09-03 14:58:58', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (73, NULL, NULL, 'msyhData', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '民生银行数据服务', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 1, 3267296873982836736, '2024-06-27 14:43:52', 3271108092029763584, '2024-09-03 14:19:47', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (74, NULL, NULL, 'nyxj', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '宁银消金', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-06-27 14:45:01', 3267296873982836736, '2024-06-27 14:45:01', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (75, NULL, NULL, 'abc-model', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽省农业银行科创贷', 'GENERAL', NULL, 3371463079372288000, NULL, NULL, 0, 3267296873982836736, '2024-06-27 14:56:23', 3267296873982836736, '2024-06-27 14:56:23', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (76, NULL, NULL, 'nxyc', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '宁夏烟草', 'GENERAL', NULL, 3267298800024010752, NULL, NULL, 0, 3267296873982836736, '2024-07-01 09:15:59', 3267296873982836736, '2024-07-01 09:15:59', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (77, NULL, NULL, 'gldztb', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '广联达招投标项目', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-07-01 09:16:38', 3267296873982836736, '2024-07-01 09:16:38', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (78, NULL, NULL, 'ysbc-sn', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽省邮储三农部预警系统', 'GENERAL', NULL, 3371463166462816256, NULL, NULL, 0, 3267296873982836736, '2024-07-01 10:50:07', 3267296873982836736, '2024-07-01 10:50:07', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (79, NULL, NULL, 'platform_construction', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '金融大脑', 'GENERAL', NULL, 3371463070648135680, NULL, NULL, 0, 3271117585803313152, '2024-07-05 15:52:03', 3271117585803313152, '2024-07-05 15:52:03', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (80, NULL, NULL, 'process-engine', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '流程引擎', 'GENERAL', NULL, 3271122670088290304, NULL, NULL, 1, 3271122670088290304, '2024-08-22 14:22:15', 3271122670088290304, '2024-08-22 14:24:09', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (81, NULL, NULL, 'ahc-process-engine', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '流程引擎', 'GENERAL', NULL, 3271122670088290304, NULL, NULL, 1, 3271122670088290304, '2024-08-22 14:43:42', 3271122670088290304, '2024-08-22 14:44:24', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (82, NULL, NULL, 'kcbg', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '科创报告', 'GENERAL', NULL, 3271120617295249408, NULL, NULL, 0, 3271120617295249408, '2024-08-29 14:30:06', 3271120617295249408, '2024-08-29 14:30:06', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (83, NULL, NULL, 'dzbh', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '电子保函系统', 'GENERAL', NULL, 3371463360424210432, NULL, NULL, 0, 3371463360424210432, '2024-09-03 10:07:11', 3371463360424210432, '2024-09-03 10:07:11', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (84, NULL, NULL, 'csjreport', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '长三角征信链', 'GENERAL', NULL, 3271108092029763584, NULL, NULL, 0, 3271108092029763584, '2024-09-03 10:07:54', 3271108092029763584, '2024-09-03 10:07:54', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (85, NULL, NULL, 'ahguaranty', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '省担保集团', 'GENERAL', NULL, 3371463375808917504, NULL, NULL, 0, 3371463375808917504, '2024-09-03 10:17:04', 3371463375808917504, '2024-09-03 10:17:04', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (86, NULL, NULL, 'gxdb', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '高新担保', 'GENERAL', NULL, 3495792932958896128, NULL, NULL, 0, 3271108092029763584, '2024-09-03 10:20:07', 3271108092029763584, '2024-09-03 14:18:53', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (87, NULL, NULL, 'cgbbank', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '广发银行', 'GENERAL', NULL, 3371463375808917504, NULL, NULL, 0, 3371463375808917504, '2024-09-03 10:39:34', 3371463375808917504, '2024-09-03 10:39:34', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (88, NULL, NULL, 'hsb', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '徽行', 'GENERAL', NULL, 3271108092029763584, NULL, NULL, 0, 3271108092029763584, '2024-09-03 10:48:04', 3271108092029763584, '2024-09-03 10:48:04', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (89, NULL, NULL, 'msyhModel', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '民生银行', 'GENERAL', NULL, 3371463375808917504, NULL, NULL, 0, 3371463375808917504, '2024-09-03 10:48:21', 3371463375808917504, '2024-09-03 10:48:21', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (90, NULL, NULL, 'baoli', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '保理系统', 'GENERAL', NULL, 3371463360424210432, NULL, NULL, 0, 3371463360424210432, '2024-09-03 14:26:23', 3371463360424210432, '2024-09-03 14:26:23', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (91, NULL, NULL, 'aj-report', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '大屏设计器', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3267296873982836736, '2024-09-03 14:56:47', 3267296873982836736, '2024-09-03 14:56:47', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (92, NULL, NULL, 'AgriculturalGuaranty', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '安徽省农业担保量化风控模型', 'GENERAL', NULL, 3371463408994250752, NULL, NULL, 0, 3271108092029763584, '2024-09-03 15:04:33', 3271108092029763584, '2024-09-03 15:05:02', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (93, NULL, NULL, 'RcbcServer', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '科农行四要素核验', 'GENERAL', NULL, 3371463408994250752, NULL, NULL, 0, 3271108092029763584, '2024-09-03 15:26:34', 3271108092029763584, '2024-09-03 15:26:56', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (94, NULL, NULL, 'yyzlmp', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '永盈租赁', 'GENERAL', NULL, 3267296873982836736, NULL, NULL, 0, 3271108092029763584, '2024-09-03 15:32:59', 3271108092029763584, '2024-09-03 15:33:16', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (95, NULL, NULL, 'pjmodels', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '票据系统', 'GENERAL', NULL, 3371463360424210432, NULL, NULL, 0, 3371463360424210432, '2024-09-03 16:12:20', 3371463360424210432, '2024-09-03 16:12:20', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (96, NULL, NULL, 'gyl', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '供应链系统', 'GENERAL', NULL, 3371463360424210432, NULL, NULL, 0, 3371463360424210432, '2024-09-03 16:28:09', 3371463360424210432, '2024-09-03 16:28:09', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (97, NULL, NULL, 'rnd', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '活体肉牛贷系统', 'GENERAL', NULL, 3371463360424210432, NULL, NULL, 0, 3371463360424210432, '2024-09-03 16:47:28', 3371463360424210432, '2024-09-03 16:47:28', 3267282062251245568, 0);
INSERT INTO `devops_system` VALUES (98, NULL, NULL, 'jft_icbc', NULL, '工商银行（深圳分行）聚富通项目', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'jft_icbc', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-09-11 10:55:07', 3267292550326501376, '2024-09-11 10:55:07', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (99, NULL, NULL, 'devops-arrangement', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DevOps部署', 'GENERAL', NULL, 3267307713708539904, NULL, NULL, 0, 3267307713708539904, '2024-09-30 11:19:15', 3267307713708539904, '2024-09-30 11:19:15', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (100, NULL, NULL, 'nyx-biz-risk-platform', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'nyx-biz-risk-platform', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-10-16 11:19:31', 3267292550326501376, '2024-10-16 11:19:31', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (101, NULL, NULL, 'ahc-integinfsys', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '信息一体化系统', 'GENERAL', NULL, 3271122024350023680, NULL, NULL, 0, 3271122024350023680, '2024-10-16 14:13:44', 3271122024350023680, '2024-10-16 14:13:44', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (102, NULL, NULL, 'nyx-image-client', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'nyx-image-client', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-10-16 15:48:50', 3267292550326501376, '2024-10-16 15:48:50', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (103, NULL, NULL, 'dcp', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '网商联合贷', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-10-23 08:50:02', 3267292550326501376, '2024-10-23 08:50:02', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (110, NULL, NULL, 'api_ws', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '网商税务', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-10-23 14:18:53', 3267292550326501376, '2024-10-23 14:18:53', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (111, NULL, NULL, 'ph_email', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '普惠邮件', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-10-23 14:26:44', 3267292550326501376, '2024-10-23 14:26:44', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (113, NULL, NULL, 'szah_bdc', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '数字安徽不动产', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-11-11 10:12:50', 3267292550326501376, '2024-11-11 10:12:50', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (114, NULL, NULL, 'zxyh_risk_report', NULL, '各个联合贷的风控报表系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '风控系统', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-11-14 10:07:22', 3267292550326501376, '2024-11-14 10:07:22', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (115, NULL, NULL, 'immovable_server', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '小微资产评估服务', 'GENERAL', NULL, 3267292308583596032, NULL, NULL, 0, 3267292550326501376, '2024-11-15 10:12:45', 3267292550326501376, '2024-11-15 10:12:45', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (116, NULL, NULL, 'xizang-web', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '西藏平台前端项目', 'GENERAL', NULL, 3271117585803313152, NULL, NULL, 0, 3271117585803313152, '2024-11-19 09:48:28', 3271117585803313152, '2024-11-19 09:48:28', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (117, NULL, NULL, 'xizang-backend', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '西藏平台后端项目', 'GENERAL', NULL, 3271113249245298688, NULL, NULL, 1, 3271113249245298688, '2024-11-19 14:32:09', 3271113249245298688, '2024-11-19 14:32:51', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (118, NULL, NULL, 'xizang-service', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '西藏平台后端项目', 'GENERAL', NULL, 3271113249245298688, NULL, NULL, 0, 3271113249245298688, '2024-11-19 14:33:20', 3271113249245298688, '2024-11-19 14:33:20', 3267282568738619392, 0);
INSERT INTO `devops_system` VALUES (119, NULL, NULL, 'tax_server', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '票税服务', 'GENERAL', NULL, 3267292308583596032, NULL, NULL, 0, 3267292308583596032, '2024-11-22 11:40:54', 3267292308583596032, '2024-11-22 11:40:54', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (120, NULL, NULL, 'credit_report_cw', NULL, '顺丰企业基本信息、探迹企业联系方式、财务分析', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '企业探针服务', 'GENERAL', NULL, 3267292308583596032, NULL, NULL, 0, 3267292308583596032, '2024-11-28 09:29:07', 3267292308583596032, '2024-11-28 09:29:07', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (121, NULL, NULL, 'hsyh-performance', NULL, '徽商银行合肥分行绩效考核系统', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '徽商银行合肥分行绩效考核系统', 'GENERAL', NULL, 3267307713708539904, NULL, NULL, 0, 3267307713708539904, '2024-12-12 09:03:36', 3267307713708539904, '2024-12-12 09:03:36', 3267284931239067648, 0);
INSERT INTO `devops_system` VALUES (122, NULL, NULL, 'file_input', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '文件传输系统', 'GENERAL', NULL, 3267292550326501376, NULL, NULL, 0, 3267292550326501376, '2024-12-12 17:14:27', 3267292550326501376, '2024-12-12 17:14:27', 3267281511404912640, 0);
INSERT INTO `devops_system` VALUES (123, NULL, NULL, 'test_111', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'test_111', 'GENERAL', NULL, 1, NULL, NULL, 0, 1, '2024-12-23 10:22:41', 1, '2024-12-23 10:22:41', 2498172061581504512, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '特性关联分支表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feature_branch
-- ----------------------------
INSERT INTO `feature_branch` VALUES (1, 'CONTROLLED', 'feature-1-pipeline', 'feature-dev-1-pipeline', NULL, 1, 8, '2024-03-04 19:55:57', 1, 1, 'master', 'e650dc2b14f4a50c94ab18fa56fdda41b0bcc06d', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (2, 'CONTROLLED', 'feature-2-pipeline-color', 'feature-dev-2-pipeline-color', NULL, 2, 8, '2024-03-05 18:08:10', 1, 0, 'master', 'eb6863ad0ca9c61eb690fa31ccf6eff0d192f5d8', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (3, 'CONTROLLED', 'feature-3-cancel-phone-num', 'feature-dev-3-cancel-phone-num', NULL, 3, 8, '2024-03-05 18:24:07', 1, 0, 'dev_dev01-1', '4ea3ecc5dfa74b81e8475ed6a21066e90e0f97f6', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (4, 'CONTROLLED', 'feature-4-dev-plcz-2.0.0', 'feature-dev-4-dev-plcz-2.0.0', NULL, 4, 8, '2024-03-06 11:13:12', 2856704057914482688, 0, 'master', 'eb6863ad0ca9c61eb690fa31ccf6eff0d192f5d8', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (5, 'GENERAL', 'bugfix-1-test', 'bugfix-1-test', NULL, 5, 9, '2024-03-21 15:13:59', 1, 0, 'master', 'c5a7dead49f3132fc2e3c6eee641413086049147', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (6, 'GENERAL', 'feature-1-0408', 'feature-1-0408', NULL, 6, 12, '2024-04-08 16:04:22', 3267307713708539904, 1, 'develop', '8695b7d091fde62a027a74c3562391873d09ad5e', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (7, 'GENERAL', 'feature-2-0411-release', 'feature-2-0411-release', NULL, 7, 12, '2024-04-11 09:26:51', 1, 1, 'develop', '614c26e820c9a0b1a3be70e60d456e15791d4c57', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (8, 'GENERAL', 'feature-1-0411-release', 'feature-1-0411-release', NULL, 8, 13, '2024-04-11 09:36:14', 1, 1, 'feat/shimengyuan/official-web', '38e79e4c9be79972960a3d7c5cdec2075de4c430', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (9, 'GENERAL', 'feature-1-0411-release', 'feature-1-0411-release', NULL, 9, 10, '2024-04-11 14:08:51', 1, 1, 'feat/shimy-system-web', '4a512a3e269f17bb66644837f1be02cb830aeb50', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (10, 'GENERAL', 'feature-1-2024.05.09', 'feature-1-2024.05.09', NULL, 10, 15, '2024-04-19 16:15:53', 1, 1, 'master', '40bbd7deda00db4b26aba10cf7239c339c9ee75c', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (11, 'GENERAL', 'feature-1-2024.04.25', 'feature-1-2024.04.25', NULL, 11, 18, '2024-04-19 16:56:15', 1, 1, 'master', '10c62190827350b330de0856cc638513e42fd932', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (12, 'GENERAL', 'feature-2-12', 'feature-2-12', NULL, 12, 9, '2024-04-22 11:09:47', 1, 0, 'bugfix-1-test', 'b10f67259fe9e3217f2a56e3feb75cb4a2fc7031', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (13, 'GENERAL', 'feature-5-123', 'feature-5-123', NULL, 13, 8, '2024-04-22 11:18:48', 1, 1, 'dev_dev01-1', '4ea3ecc5dfa74b81e8475ed6a21066e90e0f97f6', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (14, 'CONTROLLED', 'feature-6-wwfdd-1.0.0', 'feature-dev-6-wwfdd-1.0.0', NULL, 14, 8, '2024-04-25 16:25:42', 1, 0, 'dev_dev01-1', '4ea3ecc5dfa74b81e8475ed6a21066e90e0f97f6', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (15, 'GENERAL', 'feature-3-0516', 'feature-3-0516', NULL, 15, 12, '2024-05-13 17:27:37', 3267307713708539904, 0, 'master', 'c4ab899ffbfbc8d8af6d8fc293fe8b5c43a3755c', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (16, 'GENERAL', 'feature-2-0516', 'feature-2-0516', NULL, 16, 10, '2024-05-14 14:32:55', 3267307713708539904, 0, 'release/202401R1', '3e45e5a0974f541305e7c0e1e80bea7c71d1d458', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (17, 'GENERAL', 'bugfix-2-20240530', 'bugfix-2-20240530', NULL, 17, 13, '2024-05-30 11:14:31', 3267307713708539904, 0, 'release/202401R1', 'be02c79ed8a5e343f3893d1766e02d8ae951b3f0', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (18, 'GENERAL', 'bugfix-4-20240530', 'bugfix-4-20240530', NULL, 18, 12, '2024-05-30 11:24:35', 3267307713708539904, 1, 'master', '128f531304ca1cddcbec930459abcb172fff3527', NULL, NULL, 1);
INSERT INTO `feature_branch` VALUES (19, 'CONTROLLED', 'feature-1-commitCount', 'feature-dev-1-commitCount', NULL, 19, 98, '2024-06-04 10:52:20', 1, 0, 'master', 'a20f6868c1297305c8ad266cf3c334dd75e9b043', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (20, 'GENERAL', 'feature-3-2024.06.06', 'feature-3-2024.06.06', NULL, 20, 13, '2024-06-06 10:31:03', 3267307713708539904, 0, 'release/202401R1', '908ce06c9ada7532907a2acaaa834fc4779720f1', NULL, NULL, 0);
INSERT INTO `feature_branch` VALUES (21, 'CONTROLLED', 'bugfix-1-20240606', 'bugfix-dev-1-20240606', NULL, 21, 100, '2024-06-06 10:46:10', 3267303552673759232, 0, 'master', '960820a32a826018aef64c2fa19d926e05c25558', NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '特性标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feature_label
-- ----------------------------
INSERT INTO `feature_label` VALUES (1, 58, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (2, 57, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (3, 56, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (4, 49, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (5, 48, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (6, 52, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (7, 55, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (8, 54, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (9, 53, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (10, 51, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (11, 50, 3446166082666496000, 'development-system');
INSERT INTO `feature_label` VALUES (12, 114, 3637536835147005952, 'development-system');
INSERT INTO `feature_label` VALUES (13, 114, 3637537027145465856, 'development-system');
INSERT INTO `feature_label` VALUES (15, 29, 3653815679415877632, 'development-system');
INSERT INTO `feature_label` VALUES (16, 26, 3653815679415877632, 'development-system');
INSERT INTO `feature_label` VALUES (17, 26, 3653816588539658240, 'development-system');
INSERT INTO `feature_label` VALUES (18, 29, 3649502398245109760, 'development-system');
INSERT INTO `feature_label` VALUES (19, 10, 3653815679415877632, 'development-system');
INSERT INTO `feature_label` VALUES (20, 10, 3653817564419981312, 'development-system');

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
-- Records of feature_star
-- ----------------------------

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
-- Records of feature_status
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自动化测试管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feature_task
-- ----------------------------
INSERT INTO `feature_task` VALUES (1, 8, 1, '18');
INSERT INTO `feature_task` VALUES (2, 8, 2, '18');
INSERT INTO `feature_task` VALUES (3, 8, 3, '30');
INSERT INTO `feature_task` VALUES (4, 8, 4, '17');
INSERT INTO `feature_task` VALUES (5, 8, 4, '16');
INSERT INTO `feature_task` VALUES (6, 9, 5, '47');
INSERT INTO `feature_task` VALUES (7, 12, 6, '185');
INSERT INTO `feature_task` VALUES (8, 12, 6, '184');
INSERT INTO `feature_task` VALUES (9, 12, 6, '186');
INSERT INTO `feature_task` VALUES (10, 10, 9, '206');
INSERT INTO `feature_task` VALUES (11, 10, 9, '205');
INSERT INTO `feature_task` VALUES (12, 10, 9, '204');
INSERT INTO `feature_task` VALUES (13, 10, 9, '203');
INSERT INTO `feature_task` VALUES (14, 10, 9, '201');
INSERT INTO `feature_task` VALUES (15, 10, 9, '200');
INSERT INTO `feature_task` VALUES (16, 10, 9, '199');
INSERT INTO `feature_task` VALUES (17, 10, 9, '198');
INSERT INTO `feature_task` VALUES (18, 10, 9, '196');
INSERT INTO `feature_task` VALUES (19, 10, 9, '185');
INSERT INTO `feature_task` VALUES (20, 10, 9, '184');
INSERT INTO `feature_task` VALUES (21, 13, 8, '206');
INSERT INTO `feature_task` VALUES (22, 13, 8, '205');
INSERT INTO `feature_task` VALUES (23, 13, 8, '204');
INSERT INTO `feature_task` VALUES (24, 13, 8, '203');
INSERT INTO `feature_task` VALUES (25, 13, 8, '201');
INSERT INTO `feature_task` VALUES (26, 13, 8, '200');
INSERT INTO `feature_task` VALUES (27, 13, 8, '199');
INSERT INTO `feature_task` VALUES (28, 13, 8, '198');
INSERT INTO `feature_task` VALUES (29, 13, 8, '196');
INSERT INTO `feature_task` VALUES (30, 13, 8, '185');
INSERT INTO `feature_task` VALUES (31, 15, 10, '216');
INSERT INTO `feature_task` VALUES (32, 15, 10, '215');
INSERT INTO `feature_task` VALUES (33, 9, 12, '14');
INSERT INTO `feature_task` VALUES (34, 9, 12, '13');
INSERT INTO `feature_task` VALUES (35, 8, 13, '18');
INSERT INTO `feature_task` VALUES (36, 8, 14, '17');
INSERT INTO `feature_task` VALUES (37, 8, 14, '16');
INSERT INTO `feature_task` VALUES (38, 8, 14, '15');
INSERT INTO `feature_task` VALUES (39, 12, 15, '250');
INSERT INTO `feature_task` VALUES (40, 12, 15, '248');
INSERT INTO `feature_task` VALUES (41, 10, 16, '252');
INSERT INTO `feature_task` VALUES (43, 10, 16, '265');
INSERT INTO `feature_task` VALUES (44, 10, 16, '256');
INSERT INTO `feature_task` VALUES (45, 13, 17, '546');
INSERT INTO `feature_task` VALUES (46, 12, 18, '546');
INSERT INTO `feature_task` VALUES (47, 98, 19, '569');
INSERT INTO `feature_task` VALUES (48, 13, 20, '554');
INSERT INTO `feature_task` VALUES (49, 13, 20, '555');
INSERT INTO `feature_task` VALUES (50, 100, 21, '2381');
INSERT INTO `feature_task` VALUES (51, 100, 21, '2382');
INSERT INTO `feature_task` VALUES (52, 12, 18, '555');

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
) ENGINE = InnoDB AUTO_INCREMENT = 258 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '大版本' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of major_version
-- ----------------------------
INSERT INTO `major_version` VALUES (1, 8, 1, '1.0.0', '01', 1, 1, '2024-03-04 19:50:34', 1, '2024-03-05 17:40:35', NULL, 0);
INSERT INTO `major_version` VALUES (2, 12, 3267307713708539904, '1.0.0', '01', 0, 1, '2024-03-27 15:46:21', 1, '2024-03-27 15:46:21', NULL, 1);
INSERT INTO `major_version` VALUES (3, 10, 3271122024350023680, '1.0.0', '01', 3, 1, '2024-03-29 09:46:10', 3271125133872791552, '2024-07-17 17:01:16', NULL, 0);
INSERT INTO `major_version` VALUES (4, 10, 1, '2.0.0', '01', 0, 1, '2024-03-29 18:32:42', 1, '2024-03-29 18:32:42', NULL, 1);
INSERT INTO `major_version` VALUES (5, 13, 1, '1.0.0', '01', 3, 1, '2024-03-29 19:20:20', 3267307713708539904, '2024-06-27 09:28:48', NULL, 0);
INSERT INTO `major_version` VALUES (6, 8, 1, '2024.4.4', '01', 0, 1, '2024-04-01 10:14:22', 1, '2024-04-01 10:14:22', '2024.4.4投产', 0);
INSERT INTO `major_version` VALUES (7, 12, 3267307713708539904, '2024.04.08', '01', 3, 3267307713708539904, '2024-04-08 15:53:56', 1, '2024-05-10 17:23:17', '测试制品发版', 0);
INSERT INTO `major_version` VALUES (8, 12, 3267307713708539904, '2024.04.11', '01', 3, 3267307713708539904, '2024-04-10 15:53:45', 1, '2024-05-10 17:23:15', '2024.04.11上线版本', 0);
INSERT INTO `major_version` VALUES (9, 13, 3267307713708539904, '2024.04.11', '01', 3, 1, '2024-04-11 09:37:14', 1, '2024-05-13 09:57:04', '2024.04.11-release', 0);
INSERT INTO `major_version` VALUES (10, 10, 3267307713708539904, '2024.04.11', '01', 3, 1, '2024-04-11 14:11:36', 3267307713708539904, '2024-05-14 14:28:21', '0411-release', 0);
INSERT INTO `major_version` VALUES (11, 15, 3271122024350023680, '2024.05.09', '01', 3, 1, '2024-04-19 16:08:14', 3271121021592600576, '2024-05-31 15:26:34', '2024.05.09上线', 0);
INSERT INTO `major_version` VALUES (12, 18, 3271122024350023680, '2024.04.25', '01', 3, 1, '2024-04-19 16:52:11', 3267307713708539904, '2024-05-29 14:10:44', '2024.04.25', 0);
INSERT INTO `major_version` VALUES (13, 19, 1, '2024.04.25', '01', 3, 1, '2024-04-25 09:25:43', 3267307713708539904, '2024-05-30 16:22:57', '2024.04.25上线', 0);
INSERT INTO `major_version` VALUES (14, 13, 3267307713708539904, '2024.04.25', '01', 3, 1, '2024-04-25 14:53:04', 1, '2024-05-13 09:57:07', '2024.04.25上线', 0);
INSERT INTO `major_version` VALUES (15, 12, 3267307713708539904, '2024.04.25', '01', 3, 1, '2024-04-25 14:59:09', 1, '2024-05-10 17:23:12', '2024.04.25上线', 0);
INSERT INTO `major_version` VALUES (16, 10, 3267307713708539904, '2024.04.25', '01', 3, 1, '2024-04-25 16:09:33', 3267307713708539904, '2024-05-14 14:28:18', '2024.04.25上线', 0);
INSERT INTO `major_version` VALUES (17, 25, 3267307713708539904, '2024.04.25', '01', 3, 1, '2024-04-25 16:13:31', 3271120617295249408, '2024-05-31 14:04:10', '2024.04.25', 0);
INSERT INTO `major_version` VALUES (18, 22, 1, '1.0.0', '01', 0, 1, '2024-04-25 16:48:17', 1, '2024-04-25 16:48:17', NULL, 1);
INSERT INTO `major_version` VALUES (19, 22, 1, '2024.4.25', '01', 1, 1, '2024-04-25 16:49:55', 1, '2024-04-25 16:49:59', NULL, 0);
INSERT INTO `major_version` VALUES (20, 22, 3342152887245934592, '20240428', '01', 2, 3342152887245934592, '2024-04-28 09:39:54', 3342152887245934592, '2024-04-28 09:48:58', '消费贷产品版本', 0);
INSERT INTO `major_version` VALUES (21, 31, 3267296873982836736, '1.0.0', '01', 0, 3267296873982836736, '2024-05-09 17:04:14', 3267296873982836736, '2024-05-09 17:04:14', NULL, 0);
INSERT INTO `major_version` VALUES (22, 30, 3267296873982836736, '1.0.0', '01', 0, 3267296873982836736, '2024-05-09 17:56:35', 3267296873982836736, '2024-05-09 17:56:35', NULL, 0);
INSERT INTO `major_version` VALUES (23, 34, 3267296873982836736, '1.0.0', '01', 0, 3267296873982836736, '2024-05-10 10:38:52', 3267296873982836736, '2024-05-10 10:38:52', NULL, 0);
INSERT INTO `major_version` VALUES (24, 33, 3267296873982836736, '1.0.0', '01', 0, 3267296873982836736, '2024-05-10 10:43:50', 3267296873982836736, '2024-05-10 10:43:50', NULL, 0);
INSERT INTO `major_version` VALUES (25, 12, 3267307713708539904, '2024.05.16', '01', 3, 1, '2024-05-10 17:03:40', 3267307713708539904, '2024-05-28 16:01:28', '2024.05.16', 0);
INSERT INTO `major_version` VALUES (26, 32, 3271121021592600576, '2024.05.11', '01', 1, 1, '2024-05-11 15:36:47', 1, '2024-05-11 15:38:11', '2024.05.11上线', 0);
INSERT INTO `major_version` VALUES (27, 13, 3271120617295249408, '2024.05.16', '01', 3, 1, '2024-05-13 09:56:56', 3267307713708539904, '2024-05-22 14:07:29', '2024.05.16release', 0);
INSERT INTO `major_version` VALUES (28, 35, 3267292550326501376, '1.0.0', '01', 0, 3267292550326501376, '2024-05-13 16:19:43', 3267292550326501376, '2024-05-13 16:19:43', NULL, 0);
INSERT INTO `major_version` VALUES (29, 36, 3267292550326501376, '1.0.0', '01', 1, 3267292550326501376, '2024-05-13 16:28:51', 3267292550326501376, '2024-09-19 14:46:51', NULL, 0);
INSERT INTO `major_version` VALUES (30, 10, 3267307713708539904, '2024.05.16', '01', 3, 3267307713708539904, '2024-05-14 14:28:56', 3271125133872791552, '2024-07-17 17:01:14', '2024.05.16上线', 0);
INSERT INTO `major_version` VALUES (31, 14, 3267307713708539904, '1.0.0', '01', 0, 3267307713708539904, '2024-05-17 09:59:11', 3267307713708539904, '2024-05-17 09:59:11', '初始化版本', 0);
INSERT INTO `major_version` VALUES (32, 32, 3267307713708539904, '1.0.0', '01', 0, 3267307713708539904, '2024-05-17 10:43:32', 3267307713708539904, '2024-05-17 10:43:32', '初始化版本', 0);
INSERT INTO `major_version` VALUES (33, 25, 3271125133872791552, '2024.05.17', '01', 3, 3271125133872791552, '2024-05-17 11:16:47', 3267307713708539904, '2024-06-26 17:11:57', NULL, 0);
INSERT INTO `major_version` VALUES (34, 13, 3267307713708539904, '2024.05.23', '01', 3, 3267307713708539904, '2024-05-22 14:07:51', 3267307713708539904, '2024-06-06 10:31:40', NULL, 0);
INSERT INTO `major_version` VALUES (35, 23, 3267292550326501376, '2024-05-24', '01', 3, 3267292550326501376, '2024-05-23 15:23:54', 3267292550326501376, '2024-09-19 14:57:06', NULL, 0);
INSERT INTO `major_version` VALUES (36, 47, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:11:31', 3267296873982836736, '2024-05-24 14:11:31', NULL, 0);
INSERT INTO `major_version` VALUES (37, 44, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:14:09', 3267296873982836736, '2024-05-24 14:14:09', NULL, 0);
INSERT INTO `major_version` VALUES (38, 42, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:15:05', 3267296873982836736, '2024-05-24 14:15:05', NULL, 0);
INSERT INTO `major_version` VALUES (39, 41, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:15:33', 3267296873982836736, '2024-05-24 14:15:33', NULL, 0);
INSERT INTO `major_version` VALUES (40, 39, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:16:57', 3267296873982836736, '2024-05-24 14:16:57', NULL, 0);
INSERT INTO `major_version` VALUES (41, 40, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:17:09', 3267296873982836736, '2024-05-24 14:17:09', NULL, 0);
INSERT INTO `major_version` VALUES (42, 38, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:17:41', 3267296873982836736, '2024-05-24 14:17:41', NULL, 0);
INSERT INTO `major_version` VALUES (43, 37, 3267296873982836736, '2024-05-26', '01', 0, 3267296873982836736, '2024-05-24 14:18:06', 3267296873982836736, '2024-05-24 14:18:06', NULL, 0);
INSERT INTO `major_version` VALUES (44, 48, 1, '2024-05-26', '01', 0, 1, '2024-05-24 14:52:53', 1, '2024-05-24 14:52:53', NULL, 0);
INSERT INTO `major_version` VALUES (45, 13, 3267307713708539904, '2024.05.30', '01', 3, 3267307713708539904, '2024-05-28 10:50:54', 3267307713708539904, '2024-06-06 10:31:44', '2024.05.30', 0);
INSERT INTO `major_version` VALUES (46, 51, 3363893784903917568, '2024-05-28', '01', 0, 3363893784903917568, '2024-05-28 10:55:32', 3363893784903917568, '2024-05-28 10:55:32', NULL, 0);
INSERT INTO `major_version` VALUES (47, 50, 3363893784903917568, '2024-05-28', '01', 0, 3363893784903917568, '2024-05-28 15:31:19', 3363893784903917568, '2024-05-28 15:31:19', NULL, 0);
INSERT INTO `major_version` VALUES (48, 12, 3267307713708539904, '2024.05.30', '01', 3, 3267307713708539904, '2024-05-28 16:01:23', 3267307713708539904, '2024-06-12 16:58:52', '2024.05.30', 0);
INSERT INTO `major_version` VALUES (49, 53, 3363893784903917568, '2024-05-28', '01', 0, 3363893784903917568, '2024-05-28 16:19:21', 3363893784903917568, '2024-05-28 16:19:21', NULL, 0);
INSERT INTO `major_version` VALUES (50, 55, 3363893784903917568, '2024-05-28', '01', 0, 3363893784903917568, '2024-05-28 16:30:48', 3363893784903917568, '2024-05-28 16:30:48', NULL, 0);
INSERT INTO `major_version` VALUES (51, 52, 3363893784903917568, '2024-05-28', '01', 0, 3363893784903917568, '2024-05-28 19:50:05', 3363893784903917568, '2024-05-28 19:50:05', NULL, 0);
INSERT INTO `major_version` VALUES (52, 54, 3363893784903917568, '2024-05-28', '01', 0, 3363893784903917568, '2024-05-28 20:45:41', 3363893784903917568, '2024-05-28 20:45:41', NULL, 0);
INSERT INTO `major_version` VALUES (53, 18, 3267307713708539904, '2024.05.30', '01', 3, 3267307713708539904, '2024-05-29 14:10:34', 3271120617295249408, '2024-05-31 14:03:24', '2024.05.30', 0);
INSERT INTO `major_version` VALUES (54, 34, 3267296873982836736, '2024.05.30', '01', 1, 1, '2024-05-30 08:42:24', 1, '2024-05-30 08:42:29', '2024.05.30上线', 0);
INSERT INTO `major_version` VALUES (55, 33, 3267296873982836736, '2024.05.30', '01', 1, 3267296873982836736, '2024-05-30 09:03:27', 3267296873982836736, '2024-05-30 09:03:34', '2024.05.30上线', 0);
INSERT INTO `major_version` VALUES (56, 19, 3267307713708539904, '2024.05.30', '01', 3, 3267307713708539904, '2024-05-30 16:22:51', 3267307713708539904, '2024-06-18 14:48:11', '2024.05.30', 0);
INSERT INTO `major_version` VALUES (57, 18, 3271120617295249408, '2024.06.06', '01', 3, 3271120617295249408, '2024-05-31 14:03:18', 3267307713708539904, '2024-06-18 14:46:48', '2024.06.06', 0);
INSERT INTO `major_version` VALUES (58, 25, 3271120617295249408, '2024.06.06', '01', 3, 3271120617295249408, '2024-05-31 14:03:59', 3267307713708539904, '2024-06-26 17:11:54', '2024.06.06', 0);
INSERT INTO `major_version` VALUES (59, 15, 3271121021592600576, '2024.06.06', '01', 1, 3271121021592600576, '2024-05-31 15:26:27', 3271121021592600576, '2024-05-31 15:26:45', '2024.06.06上线', 0);
INSERT INTO `major_version` VALUES (60, 77, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 15:39:29', 3267292550326501376, '2024-06-03 15:39:29', NULL, 0);
INSERT INTO `major_version` VALUES (61, 76, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 15:44:03', 3267292550326501376, '2024-06-03 15:44:03', NULL, 0);
INSERT INTO `major_version` VALUES (62, 72, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:02:22', 3267292550326501376, '2024-06-03 16:02:22', NULL, 0);
INSERT INTO `major_version` VALUES (63, 70, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:15:24', 3267292550326501376, '2024-06-03 16:15:24', NULL, 0);
INSERT INTO `major_version` VALUES (64, 73, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:22:03', 3267292550326501376, '2024-06-03 16:22:03', NULL, 0);
INSERT INTO `major_version` VALUES (65, 74, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:34:33', 3267292550326501376, '2024-06-03 16:34:33', NULL, 0);
INSERT INTO `major_version` VALUES (66, 79, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:40:02', 3267292550326501376, '2024-06-03 16:40:02', NULL, 0);
INSERT INTO `major_version` VALUES (67, 78, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:46:41', 3267292550326501376, '2024-06-03 16:46:41', NULL, 0);
INSERT INTO `major_version` VALUES (68, 75, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 16:52:16', 3267292550326501376, '2024-06-03 16:52:16', NULL, 0);
INSERT INTO `major_version` VALUES (69, 82, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 17:10:19', 3267292550326501376, '2024-06-03 17:10:19', NULL, 0);
INSERT INTO `major_version` VALUES (70, 81, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 17:14:48', 3267292550326501376, '2024-06-03 17:14:48', NULL, 0);
INSERT INTO `major_version` VALUES (71, 80, 3267292550326501376, '2024-06-03', '01', 0, 3267292550326501376, '2024-06-03 17:19:32', 3267292550326501376, '2024-06-03 17:19:32', NULL, 0);
INSERT INTO `major_version` VALUES (72, 98, 3267303552673759232, '2024.06.06', '01', 1, 1, '2024-06-04 10:53:32', 3267303552673759232, '2024-06-04 11:07:16', '效能度量大屏优化代码提交行数统计逻辑', 0);
INSERT INTO `major_version` VALUES (73, 13, 3267307713708539904, '2024.06.06', '01', 3, 3267307713708539904, '2024-06-04 11:09:40', 3271125133872791552, '2024-06-12 11:06:44', NULL, 0);
INSERT INTO `major_version` VALUES (74, 100, 3267307713708539904, '2024-06-06', '01', 3, 3267307713708539904, '2024-06-04 16:46:11', 3267303552673759232, '2024-06-11 15:00:43', NULL, 0);
INSERT INTO `major_version` VALUES (75, 150, 3271117585803313152, '2024-06-12', '01', 0, 3271117585803313152, '2024-06-12 09:43:50', 3271117585803313152, '2024-06-12 09:43:50', NULL, 0);
INSERT INTO `major_version` VALUES (76, 13, 3271125133872791552, '2024.06.13', '01', 3, 3271125133872791552, '2024-06-12 11:06:41', 3267307713708539904, '2024-06-27 09:28:52', NULL, 0);
INSERT INTO `major_version` VALUES (77, 10, 3267307713708539904, '2024.06.13', '01', 3, 3267307713708539904, '2024-06-12 11:13:39', 3271125133872791552, '2024-07-17 17:01:09', NULL, 0);
INSERT INTO `major_version` VALUES (78, 155, 3271117585803313152, '2024-06-12', '01', 0, 3271117585803313152, '2024-06-12 14:23:46', 3271117585803313152, '2024-06-12 14:23:46', NULL, 0);
INSERT INTO `major_version` VALUES (79, 12, 3267307713708539904, '2024.06.13', '01', 1, 3267307713708539904, '2024-06-12 16:58:48', 3267307713708539904, '2024-06-12 16:58:56', '2024.06.13', 0);
INSERT INTO `major_version` VALUES (80, 173, 3271117585803313152, '1.0.0', '01', 1, 1, '2024-06-14 09:19:49', 1, '2024-06-14 09:19:53', 'init', 0);
INSERT INTO `major_version` VALUES (81, 158, 3271117585803313152, '1.0.0', '01', 1, 1, '2024-06-14 09:27:50', 1, '2024-06-14 09:27:53', 'init', 0);
INSERT INTO `major_version` VALUES (82, 163, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 09:58:25', 3271117585803313152, '2024-06-14 09:58:25', '1.0.0', 0);
INSERT INTO `major_version` VALUES (83, 159, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 09:58:42', 3271117585803313152, '2024-06-14 09:58:42', '1.0.0', 0);
INSERT INTO `major_version` VALUES (84, 165, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 09:59:33', 3271117585803313152, '2024-06-14 09:59:33', '1.0.0', 0);
INSERT INTO `major_version` VALUES (85, 164, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 09:59:58', 3271117585803313152, '2024-06-14 09:59:58', '1.0.0', 0);
INSERT INTO `major_version` VALUES (86, 157, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:00:40', 3271117585803313152, '2024-06-14 10:00:40', '1.0.0', 0);
INSERT INTO `major_version` VALUES (87, 156, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:01:44', 3271117585803313152, '2024-06-14 10:01:44', '1.0.0', 0);
INSERT INTO `major_version` VALUES (88, 166, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:02:06', 3271117585803313152, '2024-06-14 10:02:06', '1.0.0', 0);
INSERT INTO `major_version` VALUES (89, 174, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:02:27', 3271117585803313152, '2024-06-14 10:02:27', '1.0.0', 0);
INSERT INTO `major_version` VALUES (90, 167, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:02:54', 3271117585803313152, '2024-06-14 10:02:54', '1.0.0', 0);
INSERT INTO `major_version` VALUES (91, 153, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:03:12', 3271117585803313152, '2024-06-14 10:03:12', '1.0.0', 0);
INSERT INTO `major_version` VALUES (92, 152, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:04:10', 3271117585803313152, '2024-06-14 10:04:10', '1.0.0', 0);
INSERT INTO `major_version` VALUES (93, 151, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:04:58', 3271117585803313152, '2024-06-14 10:04:58', '1.0.0', 0);
INSERT INTO `major_version` VALUES (94, 149, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-06-14 10:05:56', 3271117585803313152, '2024-06-14 10:05:56', '1.0.0', 0);
INSERT INTO `major_version` VALUES (95, 18, 3267307713708539904, '2024.06.20', '01', 3, 3267307713708539904, '2024-06-18 14:46:44', 3271120617295249408, '2024-07-01 14:47:27', '2024.06.20', 0);
INSERT INTO `major_version` VALUES (96, 19, 3267307713708539904, '2024.06.20', '01', 3, 3267307713708539904, '2024-06-18 14:48:07', 3271125133872791552, '2024-07-03 09:06:47', '2024.06.20', 0);
INSERT INTO `major_version` VALUES (97, 68, 3267292550326501376, '06-21', '01', 0, 3267292550326501376, '2024-06-21 17:07:31', 3267292550326501376, '2024-06-21 17:07:31', NULL, 0);
INSERT INTO `major_version` VALUES (98, 183, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 15:07:00', 3267296873982836736, '2024-06-22 15:07:00', NULL, 0);
INSERT INTO `major_version` VALUES (99, 182, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 15:13:31', 3267296873982836736, '2024-06-22 15:13:31', NULL, 0);
INSERT INTO `major_version` VALUES (100, 141, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:02:26', 3267296873982836736, '2024-06-22 16:02:26', NULL, 0);
INSERT INTO `major_version` VALUES (101, 133, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:04:55', 3267296873982836736, '2024-06-22 16:04:55', NULL, 0);
INSERT INTO `major_version` VALUES (102, 131, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:09:23', 3267296873982836736, '2024-06-22 16:09:23', NULL, 0);
INSERT INTO `major_version` VALUES (103, 132, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:15:37', 3267296873982836736, '2024-06-22 16:15:37', NULL, 0);
INSERT INTO `major_version` VALUES (104, 177, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:21:11', 3267296873982836736, '2024-06-22 16:21:11', NULL, 0);
INSERT INTO `major_version` VALUES (105, 176, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:25:12', 3267296873982836736, '2024-06-22 16:25:12', NULL, 0);
INSERT INTO `major_version` VALUES (106, 185, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:33:28', 3267296873982836736, '2024-06-22 16:33:28', NULL, 0);
INSERT INTO `major_version` VALUES (107, 184, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:39:47', 3267296873982836736, '2024-06-22 16:39:47', NULL, 0);
INSERT INTO `major_version` VALUES (108, 181, 3267296873982836736, '2024-06-22', '01', 0, 3267296873982836736, '2024-06-22 16:51:52', 3267296873982836736, '2024-06-22 16:51:52', NULL, 0);
INSERT INTO `major_version` VALUES (109, 67, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 15:54:29', 3271115816176123904, '2024-06-24 15:54:29', NULL, 0);
INSERT INTO `major_version` VALUES (110, 66, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:04:49', 3271115816176123904, '2024-06-24 16:04:49', NULL, 0);
INSERT INTO `major_version` VALUES (111, 65, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:14:33', 3271115816176123904, '2024-06-24 16:14:33', NULL, 0);
INSERT INTO `major_version` VALUES (112, 64, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:21:32', 3271115816176123904, '2024-06-24 16:21:32', NULL, 0);
INSERT INTO `major_version` VALUES (113, 63, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:27:14', 3271115816176123904, '2024-06-24 16:27:14', NULL, 0);
INSERT INTO `major_version` VALUES (114, 62, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:45:40', 3271115816176123904, '2024-06-24 16:45:40', NULL, 0);
INSERT INTO `major_version` VALUES (115, 61, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:48:49', 3271115816176123904, '2024-06-24 16:48:49', NULL, 0);
INSERT INTO `major_version` VALUES (116, 57, 3271115816176123904, '2024-06-22', '01', 0, 3271115816176123904, '2024-06-24 16:57:15', 3271115816176123904, '2024-06-24 16:57:15', NULL, 0);
INSERT INTO `major_version` VALUES (117, 59, 3271115816176123904, '2024-06-24', '01', 0, 3271115816176123904, '2024-06-24 16:59:07', 3271115816176123904, '2024-06-24 16:59:07', NULL, 0);
INSERT INTO `major_version` VALUES (118, 60, 3271115816176123904, '2024-06-25', '01', 0, 3271115816176123904, '2024-06-25 09:58:58', 3271115816176123904, '2024-06-25 09:58:58', NULL, 0);
INSERT INTO `major_version` VALUES (119, 58, 3271115816176123904, '2024-06-25', '01', 0, 3271115816176123904, '2024-06-25 10:26:29', 3271115816176123904, '2024-06-25 10:26:29', NULL, 0);
INSERT INTO `major_version` VALUES (120, 56, 3271115816176123904, '2024-06-25', '01', 0, 3271115816176123904, '2024-06-25 10:43:53', 3271115816176123904, '2024-06-25 10:43:53', NULL, 0);
INSERT INTO `major_version` VALUES (121, 194, 3371463310998532096, '2024-06-26', '01', 0, 3371463310998532096, '2024-06-26 10:24:01', 3371463310998532096, '2024-06-26 10:24:01', NULL, 0);
INSERT INTO `major_version` VALUES (122, 180, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 15:18:08', 3267296873982836736, '2024-06-26 15:18:08', NULL, 0);
INSERT INTO `major_version` VALUES (123, 189, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 15:43:43', 3267296873982836736, '2024-06-26 15:43:43', NULL, 0);
INSERT INTO `major_version` VALUES (124, 139, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 15:47:09', 3267296873982836736, '2024-06-26 15:47:09', NULL, 0);
INSERT INTO `major_version` VALUES (125, 138, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 15:48:44', 3267296873982836736, '2024-06-26 15:48:44', NULL, 0);
INSERT INTO `major_version` VALUES (126, 137, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 15:51:51', 3267296873982836736, '2024-06-26 15:51:51', NULL, 0);
INSERT INTO `major_version` VALUES (127, 136, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 15:53:28', 3267296873982836736, '2024-06-26 15:53:28', NULL, 0);
INSERT INTO `major_version` VALUES (128, 175, 3267296873982836736, '2024-06-26', '01', 0, 3267296873982836736, '2024-06-26 16:09:06', 3267296873982836736, '2024-06-26 16:09:06', NULL, 0);
INSERT INTO `major_version` VALUES (129, 25, 3267307713708539904, '2024.06.27', '01', 3, 3267307713708539904, '2024-06-26 17:11:50', 3267307713708539904, '2024-06-28 11:06:11', '2024.06.27', 0);
INSERT INTO `major_version` VALUES (130, 13, 3267307713708539904, '2024.06.27', '01', 1, 3267307713708539904, '2024-06-27 09:28:44', 3267307713708539904, '2024-06-27 09:28:55', '2024.06.27', 0);
INSERT INTO `major_version` VALUES (131, 25, 3267307713708539904, '2024.06.28', '01', 3, 3267307713708539904, '2024-06-28 11:06:23', 3271120617295249408, '2024-07-04 14:38:17', '2024.06.28', 0);
INSERT INTO `major_version` VALUES (132, 30, 3267296873982836736, '2024-07-01', '01', 0, 3267296873982836736, '2024-06-28 11:19:21', 3267296873982836736, '2024-06-28 11:19:21', NULL, 0);
INSERT INTO `major_version` VALUES (133, 18, 3271120617295249408, '2024.07.04', '01', 3, 3271120617295249408, '2024-07-01 14:47:21', 3271120617295249408, '2024-07-10 10:21:53', '2024.07.04', 0);
INSERT INTO `major_version` VALUES (134, 30, 3371463622182334464, '2024-07-02', '01', 0, 3371463622182334464, '2024-07-02 14:53:03', 3371463622182334464, '2024-07-02 14:53:03', NULL, 0);
INSERT INTO `major_version` VALUES (135, 19, 3271125133872791552, '2024.07.04', '01', 3, 3271125133872791552, '2024-07-03 09:07:08', 3271125133872791552, '2024-07-10 09:52:22', '2024.07.04', 0);
INSERT INTO `major_version` VALUES (136, 158, 3271117585803313152, '1.0.1', '01', 1, 3271117585803313152, '2024-07-03 11:24:06', 3271117585803313152, '2024-07-03 11:24:11', NULL, 0);
INSERT INTO `major_version` VALUES (137, 25, 3271120617295249408, '2024.07.04', '01', 3, 3271120617295249408, '2024-07-04 14:38:12', 3271125133872791552, '2024-07-16 10:32:05', '2024.07.04', 0);
INSERT INTO `major_version` VALUES (138, 191, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 14:58:25', 3267296873982836736, '2024-07-05 14:58:25', NULL, 0);
INSERT INTO `major_version` VALUES (139, 190, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 16:09:10', 3267296873982836736, '2024-07-05 16:09:10', NULL, 0);
INSERT INTO `major_version` VALUES (140, 142, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 16:32:03', 3267296873982836736, '2024-07-05 16:32:03', NULL, 0);
INSERT INTO `major_version` VALUES (141, 135, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 16:50:33', 3267296873982836736, '2024-07-05 16:50:33', NULL, 0);
INSERT INTO `major_version` VALUES (142, 134, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 17:00:36', 3267296873982836736, '2024-07-05 17:00:36', NULL, 0);
INSERT INTO `major_version` VALUES (143, 130, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 17:03:43', 3267296873982836736, '2024-07-05 17:03:43', NULL, 0);
INSERT INTO `major_version` VALUES (144, 129, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 17:14:49', 3267296873982836736, '2024-07-05 17:14:49', NULL, 0);
INSERT INTO `major_version` VALUES (145, 128, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 17:27:14', 3267296873982836736, '2024-07-05 17:27:14', NULL, 0);
INSERT INTO `major_version` VALUES (146, 126, 3267296873982836736, '2024-07-05', '01', 0, 3267296873982836736, '2024-07-05 17:35:58', 3267296873982836736, '2024-07-05 17:35:58', NULL, 0);
INSERT INTO `major_version` VALUES (147, 216, 3271113249245298688, '1.0.0', '01', 1, 3271113249245298688, '2024-07-08 15:30:46', 3271113249245298688, '2024-07-08 15:31:33', '初始化', 0);
INSERT INTO `major_version` VALUES (148, 206, 3271117585803313152, '1.0.0', '01', 1, 3271117585803313152, '2024-07-08 16:52:46', 3271117585803313152, '2024-07-08 16:52:49', '初始化', 0);
INSERT INTO `major_version` VALUES (149, 204, 3271117585803313152, '1.0.0', '01', 1, 3271117585803313152, '2024-07-08 17:30:37', 3271117585803313152, '2024-07-08 17:30:39', NULL, 0);
INSERT INTO `major_version` VALUES (150, 205, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-07-08 17:43:57', 3271117585803313152, '2024-07-08 17:43:57', NULL, 0);
INSERT INTO `major_version` VALUES (151, 207, 3271117585803313152, '1.0.0', '01', 0, 3271117585803313152, '2024-07-08 17:44:23', 3271117585803313152, '2024-07-08 17:44:23', NULL, 0);
INSERT INTO `major_version` VALUES (152, 125, 3267296873982836736, '2024-07-09', '01', 0, 3267296873982836736, '2024-07-09 09:39:56', 3267296873982836736, '2024-07-09 09:39:56', NULL, 0);
INSERT INTO `major_version` VALUES (153, 31, 3267296873982836736, '2024-07-10', '01', 0, 3267296873982836736, '2024-07-09 14:34:08', 3267296873982836736, '2024-07-09 14:34:08', NULL, 0);
INSERT INTO `major_version` VALUES (154, 204, 3271117585803313152, 'release-20240711', '01', 1, 3271117585803313152, '2024-07-09 16:54:54', 3271117585803313152, '2024-07-09 16:55:00', NULL, 0);
INSERT INTO `major_version` VALUES (155, 19, 3271125133872791552, '2024.07.10', '01', 3, 3271125133872791552, '2024-07-10 09:52:18', 3271125133872791552, '2024-07-16 10:23:40', '2024.07.10', 0);
INSERT INTO `major_version` VALUES (156, 18, 3271120617295249408, '2024.07.11', '01', 0, 3271120617295249408, '2024-07-10 10:22:06', 3271120617295249408, '2024-07-10 10:22:06', '2024.07.11', 0);
INSERT INTO `major_version` VALUES (157, 209, 3271113249245298688, '1.0.0', '01', 0, 3271113249245298688, '2024-07-11 10:52:56', 3271113249245298688, '2024-07-11 10:52:56', '初始化版本', 0);
INSERT INTO `major_version` VALUES (158, 209, 3271113249245298688, '3.0-SNAPSHOT', '01', 0, 3271113249245298688, '2024-07-15 10:36:49', 3271113249245298688, '2024-07-15 10:36:49', NULL, 0);
INSERT INTO `major_version` VALUES (159, 208, 3271113249245298688, '1.0.0', '01', 0, 3271113249245298688, '2024-07-15 14:45:24', 3271113249245298688, '2024-07-15 14:45:24', NULL, 0);
INSERT INTO `major_version` VALUES (160, 19, 3271125133872791552, '2024.07.18', '01', 0, 3271125133872791552, '2024-07-16 10:24:01', 3271125133872791552, '2024-07-16 10:24:01', '2024.07.18', 0);
INSERT INTO `major_version` VALUES (161, 25, 3271125133872791552, '2024.07.18', '01', 0, 3271125133872791552, '2024-07-16 10:32:37', 3271125133872791552, '2024-07-16 10:32:37', '2024.07.18', 0);
INSERT INTO `major_version` VALUES (162, 10, 3271125133872791552, '2024.07.18', '01', 3, 3271125133872791552, '2024-07-17 17:01:06', 3271125133872791552, '2024-07-19 09:20:40', '2024.07.18', 0);
INSERT INTO `major_version` VALUES (163, 13, 3271122670088290304, '2023.07.25', '01', 1, 3271122670088290304, '2024-07-23 16:33:52', 3271122670088290304, '2024-07-23 16:33:56', '修改面包屑样式', 1);
INSERT INTO `major_version` VALUES (164, 13, 3271122670088290304, '2024.07.25', '01', 1, 3271122670088290304, '2024-07-23 16:34:44', 3271122670088290304, '2024-07-23 16:34:47', '2024.07.25上线', 0);
INSERT INTO `major_version` VALUES (165, 106, 3267307713708539904, '1.0.0', '01', 0, 3267307713708539904, '2024-07-24 16:25:08', 3267307713708539904, '2024-07-24 16:25:08', 'init', 0);
INSERT INTO `major_version` VALUES (166, 104, 1, '2024-07-28', '01', 0, 1, '2024-07-28 14:54:07', 1, '2024-07-28 14:54:07', NULL, 0);
INSERT INTO `major_version` VALUES (167, 103, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:12:57', 1, '2024-07-28 15:12:57', NULL, 0);
INSERT INTO `major_version` VALUES (168, 102, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:16:18', 1, '2024-07-28 15:16:18', NULL, 0);
INSERT INTO `major_version` VALUES (169, 101, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:21:08', 1, '2024-07-28 15:21:08', NULL, 0);
INSERT INTO `major_version` VALUES (170, 99, 1, '2024-07-28', '01', 3, 1, '2024-07-28 15:25:14', 3267307713708539904, '2024-09-13 10:37:11', NULL, 0);
INSERT INTO `major_version` VALUES (171, 97, 1, '2024-06-28', '01', 0, 1, '2024-07-28 15:30:07', 1, '2024-07-28 15:30:07', NULL, 0);
INSERT INTO `major_version` VALUES (172, 96, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:33:30', 1, '2024-07-28 15:33:30', NULL, 0);
INSERT INTO `major_version` VALUES (173, 95, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:37:42', 1, '2024-07-28 15:37:42', NULL, 0);
INSERT INTO `major_version` VALUES (174, 94, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:43:04', 1, '2024-07-28 15:43:04', NULL, 0);
INSERT INTO `major_version` VALUES (175, 113, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:46:58', 1, '2024-07-28 15:46:58', NULL, 0);
INSERT INTO `major_version` VALUES (176, 112, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:50:44', 1, '2024-07-28 15:50:44', NULL, 0);
INSERT INTO `major_version` VALUES (177, 111, 1, '2024-07-28', '01', 0, 1, '2024-07-28 15:56:04', 1, '2024-07-28 15:56:04', NULL, 0);
INSERT INTO `major_version` VALUES (178, 110, 1, '2024-07-28', '01', 0, 1, '2024-07-28 16:01:22', 1, '2024-07-28 16:01:22', NULL, 0);
INSERT INTO `major_version` VALUES (179, 109, 1, '2024-07-28', '01', 0, 1, '2024-07-28 16:06:38', 1, '2024-07-28 16:06:38', NULL, 0);
INSERT INTO `major_version` VALUES (180, 108, 1, '2024-07-28', '01', 2, 1, '2024-07-28 16:24:59', 3267307713708539904, '2024-09-14 08:54:24', NULL, 0);
INSERT INTO `major_version` VALUES (181, 107, 1, '2024-07-28', '01', 0, 1, '2024-07-28 16:33:25', 1, '2024-07-28 16:33:25', NULL, 0);
INSERT INTO `major_version` VALUES (182, 105, 1, '2024-07-28', '01', 0, 1, '2024-07-28 16:47:07', 1, '2024-07-28 16:47:07', NULL, 0);
INSERT INTO `major_version` VALUES (183, 114, 1, '2024-07-28', '01', 0, 1, '2024-07-28 16:54:21', 1, '2024-07-28 16:54:21', NULL, 0);
INSERT INTO `major_version` VALUES (184, 226, 1, '3.0.0', '01', 0, 1, '2024-08-07 11:11:06', 1, '2024-08-07 11:11:06', NULL, 0);
INSERT INTO `major_version` VALUES (185, 106, 1, '2024-07-28', '01', 0, 1, '2024-08-07 18:48:38', 1, '2024-08-07 18:48:38', NULL, 0);
INSERT INTO `major_version` VALUES (186, 226, 1, '2024-07-28', '01', 0, 1, '2024-08-07 18:57:47', 1, '2024-08-07 18:57:47', NULL, 0);
INSERT INTO `major_version` VALUES (187, 115, 3267307713708539904, '1.0.0', '01', 1, 3267307713708539904, '2024-08-15 14:49:35', 3267307713708539904, '2024-08-15 14:49:38', '初版本', 0);
INSERT INTO `major_version` VALUES (188, 96, 3267307713708539904, '2024.08.21', '01', 1, 3267307713708539904, '2024-08-21 17:26:34', 3267307713708539904, '2024-08-21 17:26:37', '2024.08.21依赖补充后的版本', 0);
INSERT INTO `major_version` VALUES (189, 228, 3267307713708539904, '1.0.0', '01', 1, 3267307713708539904, '2024-08-22 10:01:35', 3267307713708539904, '2024-08-22 10:01:40', '初版本', 0);
INSERT INTO `major_version` VALUES (190, 116, 3267307713708539904, '1.0.0', '01', 0, 3267307713708539904, '2024-09-06 16:33:21', 3267307713708539904, '2024-09-06 16:33:21', NULL, 0);
INSERT INTO `major_version` VALUES (191, 108, 3267307713708539904, '2024.09.13', '01', 0, 3267307713708539904, '2024-09-13 10:36:12', 3267307713708539904, '2024-09-13 10:36:12', '批量下载', 0);
INSERT INTO `major_version` VALUES (192, 99, 3267307713708539904, '2024.09.13', '01', 0, 3267307713708539904, '2024-09-13 10:37:06', 3267307713708539904, '2024-09-13 10:37:06', '批量下载', 0);
INSERT INTO `major_version` VALUES (193, 226, 3267307713708539904, '2024-09-14', '01', 0, 3267307713708539904, '2024-09-14 10:14:20', 3267307713708539904, '2024-09-14 10:14:20', '2024-09-14更新批量下载功能', 0);
INSERT INTO `major_version` VALUES (194, 113, 3267307713708539904, '2024-09-14', '01', 0, 3267307713708539904, '2024-09-14 10:57:17', 3267307713708539904, '2024-09-14 10:57:17', NULL, 0);
INSERT INTO `major_version` VALUES (195, 106, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 09:15:31', 3267307713708539904, '2024-09-19 09:15:31', '主应用框架打包', 0);
INSERT INTO `major_version` VALUES (196, 107, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 09:36:23', 3267307713708539904, '2024-09-19 09:36:23', '20240919大前端打包调试', 0);
INSERT INTO `major_version` VALUES (197, 108, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 09:56:22', 3267307713708539904, '2024-09-19 09:56:22', '20240919大前端打包调试', 0);
INSERT INTO `major_version` VALUES (198, 109, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 10:21:29', 3267307713708539904, '2024-09-19 10:21:29', '20240919大前端打包调试', 0);
INSERT INTO `major_version` VALUES (199, 111, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 10:39:23', 3267307713708539904, '2024-09-19 10:39:23', '20240919大前端打包调试', 0);
INSERT INTO `major_version` VALUES (200, 112, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 10:51:48', 3267307713708539904, '2024-09-19 10:51:48', '20240919大前端打包调试:dockerfile', 0);
INSERT INTO `major_version` VALUES (201, 110, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 11:12:43', 3267307713708539904, '2024-09-19 11:12:43', '20240919大前端打包调试:dockerfile', 0);
INSERT INTO `major_version` VALUES (202, 226, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 11:38:07', 3267307713708539904, '2024-09-19 11:38:07', '20240919大前端打包调试', 0);
INSERT INTO `major_version` VALUES (203, 113, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-09-19 14:29:24', 3267307713708539904, '2024-09-19 14:29:24', '20240919大前端打包调试:dockerfile', 0);
INSERT INTO `major_version` VALUES (204, 23, 3426345833549135872, '20240919', '01', 2, 3426345833549135872, '2024-09-19 14:39:23', 3426345833549135872, '2024-09-19 14:39:26', '消费贷产品版本', 0);
INSERT INTO `major_version` VALUES (205, 144, 3267307713708539904, '1.0.0', '01', 0, 3267307713708539904, '2024-09-19 15:03:32', 3267307713708539904, '2024-09-19 15:03:32', 'init', 0);
INSERT INTO `major_version` VALUES (206, 286, 3267292550326501376, '1.0.0', '01', 0, 1, '2024-09-23 14:36:27', 1, '2024-09-23 14:36:27', 'init', 0);
INSERT INTO `major_version` VALUES (207, 205, 3271117585803313152, '20240926', '01', 0, 3271117585803313152, '2024-09-23 15:51:47', 3271117585803313152, '2024-09-23 15:51:47', NULL, 0);
INSERT INTO `major_version` VALUES (208, 97, 3267307713708539904, '1.0.0', '01', 0, 1, '2024-09-24 11:04:25', 1, '2024-09-24 11:04:25', NULL, 0);
INSERT INTO `major_version` VALUES (209, 195, 3267296873982836736, '1.0.0', '01', 0, 3267296873982836736, '2024-09-27 15:20:50', 3267296873982836736, '2024-09-27 15:20:50', NULL, 0);
INSERT INTO `major_version` VALUES (210, 100, 3267307713708539904, '2024-10-31', '01', 3, 3267307713708539904, '2024-10-17 15:23:26', 3267307713708539904, '2024-11-11 16:51:22', '解决日期问题', 0);
INSERT INTO `major_version` VALUES (211, 300, 3371463290094120960, '06-21', '01', 0, 3371463290094120960, '2024-10-23 10:04:11', 3371463290094120960, '2024-10-23 10:04:11', NULL, 1);
INSERT INTO `major_version` VALUES (212, 300, 3371463290094120960, '10-23-test', '01', 0, 3371463290094120960, '2024-10-23 10:11:50', 3371463290094120960, '2024-10-23 10:11:50', '测试版本', 0);
INSERT INTO `major_version` VALUES (213, 303, 3267292550326501376, '10-24-test', '01', 0, 3267292550326501376, '2024-10-24 08:48:36', 3267292550326501376, '2024-10-24 08:48:36', NULL, 0);
INSERT INTO `major_version` VALUES (214, 305, 3369369332493033472, 'mqWsbPlatform-1.0', '01', 1, 3267292550326501376, '2024-10-28 09:42:22', 3267292550326501376, '2024-10-28 09:44:00', '网商mq上传版本号', 0);
INSERT INTO `major_version` VALUES (215, 226, 3267307713708539904, '2024-10-30', '01', 0, 3267307713708539904, '2024-10-30 11:31:52', 3267307713708539904, '2024-10-30 11:31:52', '大前端打包优化', 0);
INSERT INTO `major_version` VALUES (216, 308, 3371463290094120960, '24-11-11', '01', 2, 3371463290094120960, '2024-11-11 11:01:38', 3371463290094120960, '2024-11-11 11:01:46', NULL, 0);
INSERT INTO `major_version` VALUES (217, 100, 3267307713708539904, '2024-11-15', '01', 1, 3267307713708539904, '2024-11-11 16:51:47', 3267307713708539904, '2024-11-11 16:51:50', 'longsql的oa信息接口', 0);
INSERT INTO `major_version` VALUES (218, 309, 3369369332493033472, 'loan-report-1.0', '01', 1, 3369369332493033472, '2024-11-13 17:43:10', 3369369332493033472, '2024-11-13 17:43:14', '联合贷报表后端', 0);
INSERT INTO `major_version` VALUES (219, 310, 3267307713708539904, '2024-09-19', '01', 1, 3267307713708539904, '2024-11-14 09:07:10', 3267307713708539904, '2024-11-14 09:07:14', NULL, 0);
INSERT INTO `major_version` VALUES (220, 311, 3369369332493033472, 'risk-report-1.0', '01', 2, 3369369332493033472, '2024-11-14 10:26:55', 3369369332493033472, '2024-11-14 11:07:30', '主版本', 0);
INSERT INTO `major_version` VALUES (221, 314, 3271117585803313152, '1.0', '01', 3, 3271117585803313152, '2024-11-20 15:55:16', 3271117585803313152, '2024-11-29 17:14:28', NULL, 0);
INSERT INTO `major_version` VALUES (222, 315, 3271117585803313152, '1.0', '01', 3, 3271117585803313152, '2024-11-27 20:23:29', 3271117585803313152, '2024-12-16 14:28:58', NULL, 0);
INSERT INTO `major_version` VALUES (223, 316, 3271117585803313152, '1.0', '01', 3, 3271117585803313152, '2024-11-27 21:04:54', 3271117585803313152, '2024-12-16 14:29:19', NULL, 0);
INSERT INTO `major_version` VALUES (224, 323, 3267307713708539904, '1.0.1', '01', 0, 3267307713708539904, '2024-11-28 09:48:48', 3267307713708539904, '2024-11-28 09:48:48', NULL, 0);
INSERT INTO `major_version` VALUES (225, 323, 3267307713708539904, '2024-09-19', '01', 0, 3267307713708539904, '2024-11-28 10:15:39', 3267307713708539904, '2024-11-28 10:15:39', NULL, 0);
INSERT INTO `major_version` VALUES (226, 314, 3271117585803313152, '2.0', '01', 1, 3271117585803313152, '2024-11-29 17:14:24', 3271117585803313152, '2024-11-29 17:14:31', NULL, 0);
INSERT INTO `major_version` VALUES (227, 332, 3369369332493033472, 'file-1.0', '01', 0, 3369369332493033472, '2024-12-13 09:21:58', 3369369332493033472, '2024-12-13 09:21:58', '文件版本', 0);
INSERT INTO `major_version` VALUES (228, 315, 3271117585803313152, '2.0', '01', 2, 3271117585803313152, '2024-12-16 14:28:40', 3271117585803313152, '2024-12-16 14:28:53', NULL, 0);
INSERT INTO `major_version` VALUES (229, 316, 3271117585803313152, '2.0', '01', 2, 3271117585803313152, '2024-12-16 14:29:16', 3271117585803313152, '2024-12-16 14:29:22', NULL, 0);
INSERT INTO `major_version` VALUES (230, 94, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2024-12-25 09:38:08', 3267307713708539904, '2024-12-25 09:38:08', NULL, 0);
INSERT INTO `major_version` VALUES (231, 94, 3267307713708539904, '3.0.0', '01', 0, 3267307713708539904, '2024-12-25 11:29:35', 3267307713708539904, '2024-12-25 11:29:35', NULL, 0);
INSERT INTO `major_version` VALUES (232, 317, 3271117585803313152, '1.0', '01', 2, 3271117585803313152, '2024-12-27 10:01:50', 3271117585803313152, '2024-12-27 10:01:56', NULL, 0);
INSERT INTO `major_version` VALUES (233, 95, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-03 09:02:01', 3267307713708539904, '2025-01-03 09:02:01', NULL, 0);
INSERT INTO `major_version` VALUES (234, 100, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-03 09:05:09', 3267307713708539904, '2025-01-03 09:05:09', NULL, 0);
INSERT INTO `major_version` VALUES (235, 10, 3271125133872791552, '2025.01.06', '01', 0, 3271125133872791552, '2025-01-06 14:37:29', 3271125133872791552, '2025-01-06 14:37:29', NULL, 0);
INSERT INTO `major_version` VALUES (236, 96, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-06 15:36:20', 3267307713708539904, '2025-01-06 15:36:20', NULL, 0);
INSERT INTO `major_version` VALUES (237, 97, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-06 16:52:35', 3267307713708539904, '2025-01-06 16:52:35', NULL, 0);
INSERT INTO `major_version` VALUES (238, 98, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 10:21:30', 3267307713708539904, '2025-01-07 10:21:30', NULL, 0);
INSERT INTO `major_version` VALUES (239, 99, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 15:39:48', 3267307713708539904, '2025-01-07 15:39:48', NULL, 0);
INSERT INTO `major_version` VALUES (240, 101, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 15:45:02', 3267307713708539904, '2025-01-07 15:45:02', NULL, 0);
INSERT INTO `major_version` VALUES (241, 102, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 16:01:20', 3267307713708539904, '2025-01-07 16:01:20', NULL, 0);
INSERT INTO `major_version` VALUES (242, 103, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 16:12:54', 3267307713708539904, '2025-01-07 16:12:54', NULL, 0);
INSERT INTO `major_version` VALUES (243, 104, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 16:16:56', 3267307713708539904, '2025-01-07 16:16:56', NULL, 0);
INSERT INTO `major_version` VALUES (244, 105, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-07 16:20:35', 3267307713708539904, '2025-01-07 16:20:35', NULL, 0);
INSERT INTO `major_version` VALUES (245, 336, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:11:36', 3267307713708539904, '2025-01-09 15:11:36', NULL, 0);
INSERT INTO `major_version` VALUES (246, 335, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:12:31', 3267307713708539904, '2025-01-09 15:12:31', NULL, 0);
INSERT INTO `major_version` VALUES (247, 310, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:15:28', 3267307713708539904, '2025-01-09 15:15:28', NULL, 0);
INSERT INTO `major_version` VALUES (248, 226, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:16:11', 3267307713708539904, '2025-01-09 15:16:11', NULL, 0);
INSERT INTO `major_version` VALUES (249, 114, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:16:26', 3267307713708539904, '2025-01-09 15:16:26', NULL, 0);
INSERT INTO `major_version` VALUES (250, 113, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:17:02', 3267307713708539904, '2025-01-09 15:17:02', NULL, 0);
INSERT INTO `major_version` VALUES (251, 112, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:19:26', 3267307713708539904, '2025-01-09 15:19:26', NULL, 0);
INSERT INTO `major_version` VALUES (252, 111, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:23:58', 3267307713708539904, '2025-01-09 15:23:58', NULL, 0);
INSERT INTO `major_version` VALUES (253, 110, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-09 15:29:54', 3267307713708539904, '2025-01-09 15:29:54', NULL, 0);
INSERT INTO `major_version` VALUES (254, 109, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-10 14:00:09', 3267307713708539904, '2025-01-10 14:00:09', NULL, 0);
INSERT INTO `major_version` VALUES (255, 108, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-10 14:03:09', 3267307713708539904, '2025-01-10 14:03:09', NULL, 0);
INSERT INTO `major_version` VALUES (256, 107, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-10 14:04:37', 3267307713708539904, '2025-01-10 14:04:37', NULL, 0);
INSERT INTO `major_version` VALUES (257, 106, 3267307713708539904, '4.0.2', '01', 0, 3267307713708539904, '2025-01-10 14:08:50', 3267307713708539904, '2025-01-10 14:08:50', NULL, 0);

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
-- Records of online_order
-- ----------------------------

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
-- Records of online_order_feature
-- ----------------------------

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
-- Records of online_order_subsystem
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制品晋级策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_promotion_strategy
-- ----------------------------

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
-- Records of project_management
-- ----------------------------

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
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (7, 'system_sync', '1', '系统同步');
INSERT INTO `role_permission` VALUES (7, 'system_modify', '1', '系统信息编辑');
INSERT INTO `role_permission` VALUES (7, 'system_delete_member', '1', '移除成员');
INSERT INTO `role_permission` VALUES (7, 'subsys_create', '1', '创建子系统');
INSERT INTO `role_permission` VALUES (7, 'subsys_delete', '1', '删除子系统');
INSERT INTO `role_permission` VALUES (7, 'sys_repository_view', '1', '查看仓库账号权限');
INSERT INTO `role_permission` VALUES (7, 'system_add_member', '1', '添加成员');
INSERT INTO `role_permission` VALUES (8, 'system_sync', '0', '系统同步');
INSERT INTO `role_permission` VALUES (8, 'system_modify', '0', '系统信息编辑');
INSERT INTO `role_permission` VALUES (8, 'system_delete_member', '0', '移除成员');
INSERT INTO `role_permission` VALUES (8, 'subsys_create', '0', '创建子系统');
INSERT INTO `role_permission` VALUES (8, 'subsys_delete', '0', '删除子系统');
INSERT INTO `role_permission` VALUES (8, 'sys_repository_view', '0', '查看仓库账号权限');
INSERT INTO `role_permission` VALUES (8, 'system_add_member', '0', '添加成员');
INSERT INTO `role_permission` VALUES (9, 'subsys_sync', '1', '同步子系统');
INSERT INTO `role_permission` VALUES (9, 'subsys_modify', '1', '子系统信息编辑');
INSERT INTO `role_permission` VALUES (9, 'subsys_add_member', '1', '添加子系统成员');
INSERT INTO `role_permission` VALUES (9, 'subsys_delete_member', '1', '移除子系统成员');
INSERT INTO `role_permission` VALUES (9, 'subsys_add_feature', '1', '创建特性');
INSERT INTO `role_permission` VALUES (9, 'subsys_delete_feature', '1', '删除特性');
INSERT INTO `role_permission` VALUES (9, 'subsys_modify_feature', '1', '编辑特性');
INSERT INTO `role_permission` VALUES (9, 'subsys_add_version', '1', '创建版本');
INSERT INTO `role_permission` VALUES (9, 'subsys_modify_version', '1', '编辑版本');
INSERT INTO `role_permission` VALUES (9, 'subsys_delete_version', '1', '删除版本');
INSERT INTO `role_permission` VALUES (9, 'subsys_merge', '1', '发起合并');
INSERT INTO `role_permission` VALUES (9, 'subsys_env_buildJob', '1', '测试环境管理执行流水线');
INSERT INTO `role_permission` VALUES (9, 'subsys_add_job', '1', '创建流水线');
INSERT INTO `role_permission` VALUES (9, 'subsys_build_job', '1', '执行流水线');
INSERT INTO `role_permission` VALUES (9, 'subsys_modify_job', '1', '编辑流水线');
INSERT INTO `role_permission` VALUES (9, 'subsys_delete_job', '1', '删除流水线');
INSERT INTO `role_permission` VALUES (9, 'subsys_add_code', '1', '新增关联代码库');
INSERT INTO `role_permission` VALUES (9, 'subsys_modify_scm', '1', '编辑代码库');
INSERT INTO `role_permission` VALUES (9, 'subsys_var_addEnv', '1', '子系统环境变量-添加环境');
INSERT INTO `role_permission` VALUES (9, 'subsys_var_add', '1', '子系统环境变量-添加变量');
INSERT INTO `role_permission` VALUES (9, 'subsys_var_modify', '1', '子系统环境变量-编辑变量');
INSERT INTO `role_permission` VALUES (9, 'subsys_env_test', '1', '发起环境测试');
INSERT INTO `role_permission` VALUES (9, 'subsys_project_create', '1', '创建项目');
INSERT INTO `role_permission` VALUES (9, 'subsys_project_sync', '1', '同步项目');
INSERT INTO `role_permission` VALUES (9, 'subsys_project_del', '1', '删除项目');
INSERT INTO `role_permission` VALUES (9, 'subsys_project_modify', '1', '更新项目');
INSERT INTO `role_permission` VALUES (16, 'subsys_sync', '0', '同步子系统');
INSERT INTO `role_permission` VALUES (16, 'subsys_modify', '0', '子系统信息编辑');
INSERT INTO `role_permission` VALUES (16, 'subsys_add_member', '0', '添加子系统成员');
INSERT INTO `role_permission` VALUES (16, 'subsys_delete_member', '0', '移除子系统成员');
INSERT INTO `role_permission` VALUES (16, 'subsys_add_feature', '1', '创建特性');
INSERT INTO `role_permission` VALUES (16, 'subsys_delete_feature', '1', '删除特性');
INSERT INTO `role_permission` VALUES (16, 'subsys_modify_feature', '1', '编辑特性');
INSERT INTO `role_permission` VALUES (16, 'subsys_add_version', '1', '创建版本');
INSERT INTO `role_permission` VALUES (16, 'subsys_modify_version', '1', '编辑版本');
INSERT INTO `role_permission` VALUES (16, 'subsys_delete_version', '1', '删除版本');
INSERT INTO `role_permission` VALUES (16, 'subsys_merge', '1', '发起合并');
INSERT INTO `role_permission` VALUES (16, 'subsys_env_buildJob', '1', '测试环境管理执行流水线');
INSERT INTO `role_permission` VALUES (16, 'subsys_add_job', '1', '创建流水线');
INSERT INTO `role_permission` VALUES (16, 'subsys_build_job', '1', '执行流水线');
INSERT INTO `role_permission` VALUES (16, 'subsys_modify_job', '1', '编辑流水线');
INSERT INTO `role_permission` VALUES (16, 'subsys_delete_job', '1', '删除流水线');
INSERT INTO `role_permission` VALUES (16, 'subsys_add_code', '1', '新增关联代码库');
INSERT INTO `role_permission` VALUES (16, 'subsys_modify_scm', '1', '编辑代码库');
INSERT INTO `role_permission` VALUES (16, 'subsys_var_addEnv', '1', '子系统环境变量-添加环境');
INSERT INTO `role_permission` VALUES (16, 'subsys_var_add', '1', '子系统环境变量-添加变量');
INSERT INTO `role_permission` VALUES (16, 'subsys_var_modify', '1', '子系统环境变量-编辑变量');
INSERT INTO `role_permission` VALUES (16, 'subsys_env_test', '1', '发起环境测试');
INSERT INTO `role_permission` VALUES (16, 'subsys_project_create', '1', '创建项目');
INSERT INTO `role_permission` VALUES (16, 'subsys_project_sync', '1', '同步项目');
INSERT INTO `role_permission` VALUES (16, 'subsys_project_del', '1', '删除项目');
INSERT INTO `role_permission` VALUES (16, 'subsys_project_modify', '1', '更新项目');
INSERT INTO `role_permission` VALUES (14, 'subsys_sync', '0', '同步子系统');
INSERT INTO `role_permission` VALUES (14, 'subsys_modify', '0', '子系统信息编辑');
INSERT INTO `role_permission` VALUES (14, 'subsys_add_member', '0', '添加子系统成员');
INSERT INTO `role_permission` VALUES (14, 'subsys_delete_member', '0', '移除子系统成员');
INSERT INTO `role_permission` VALUES (14, 'subsys_add_feature', '1', '创建特性');
INSERT INTO `role_permission` VALUES (14, 'subsys_delete_feature', '1', '删除特性');
INSERT INTO `role_permission` VALUES (14, 'subsys_modify_feature', '1', '编辑特性');
INSERT INTO `role_permission` VALUES (14, 'subsys_add_version', '0', '创建版本');
INSERT INTO `role_permission` VALUES (14, 'subsys_modify_version', '0', '编辑版本');
INSERT INTO `role_permission` VALUES (14, 'subsys_delete_version', '0', '删除版本');
INSERT INTO `role_permission` VALUES (14, 'subsys_merge', '1', '发起合并');
INSERT INTO `role_permission` VALUES (14, 'subsys_env_buildJob', '1', '测试环境管理执行流水线');
INSERT INTO `role_permission` VALUES (14, 'subsys_add_job', '1', '创建流水线');
INSERT INTO `role_permission` VALUES (14, 'subsys_build_job', '1', '执行流水线');
INSERT INTO `role_permission` VALUES (14, 'subsys_modify_job', '1', '编辑流水线');
INSERT INTO `role_permission` VALUES (14, 'subsys_delete_job', '1', '删除流水线');
INSERT INTO `role_permission` VALUES (14, 'subsys_add_code', '0', '新增关联代码库');
INSERT INTO `role_permission` VALUES (14, 'subsys_modify_scm', '0', '编辑代码库');
INSERT INTO `role_permission` VALUES (14, 'subsys_var_addEnv', '1', '子系统环境变量-添加环境');
INSERT INTO `role_permission` VALUES (14, 'subsys_var_add', '1', '子系统环境变量-添加变量');
INSERT INTO `role_permission` VALUES (14, 'subsys_var_modify', '1', '子系统环境变量-编辑变量');
INSERT INTO `role_permission` VALUES (14, 'subsys_env_test', '1', '发起环境测试');
INSERT INTO `role_permission` VALUES (14, 'subsys_project_create', '1', '创建项目');
INSERT INTO `role_permission` VALUES (14, 'subsys_project_sync', '1', '同步项目');
INSERT INTO `role_permission` VALUES (14, 'subsys_project_del', '1', '删除项目');
INSERT INTO `role_permission` VALUES (14, 'subsys_project_modify', '1', '更新项目');
INSERT INTO `role_permission` VALUES (15, 'subsys_sync', '0', '同步子系统');
INSERT INTO `role_permission` VALUES (15, 'subsys_modify', '0', '子系统信息编辑');
INSERT INTO `role_permission` VALUES (15, 'subsys_add_member', '0', '添加子系统成员');
INSERT INTO `role_permission` VALUES (15, 'subsys_delete_member', '0', '移除子系统成员');
INSERT INTO `role_permission` VALUES (15, 'subsys_add_feature', '1', '创建特性');
INSERT INTO `role_permission` VALUES (15, 'subsys_delete_feature', '1', '删除特性');
INSERT INTO `role_permission` VALUES (15, 'subsys_modify_feature', '1', '编辑特性');
INSERT INTO `role_permission` VALUES (15, 'subsys_add_version', '0', '创建版本');
INSERT INTO `role_permission` VALUES (15, 'subsys_modify_version', '0', '编辑版本');
INSERT INTO `role_permission` VALUES (15, 'subsys_delete_version', '0', '删除版本');
INSERT INTO `role_permission` VALUES (15, 'subsys_merge', '1', '发起合并');
INSERT INTO `role_permission` VALUES (15, 'subsys_env_buildJob', '1', '测试环境管理执行流水线');
INSERT INTO `role_permission` VALUES (15, 'subsys_add_job', '1', '创建流水线');
INSERT INTO `role_permission` VALUES (15, 'subsys_build_job', '1', '执行流水线');
INSERT INTO `role_permission` VALUES (15, 'subsys_modify_job', '1', '编辑流水线');
INSERT INTO `role_permission` VALUES (15, 'subsys_delete_job', '1', '删除流水线');
INSERT INTO `role_permission` VALUES (15, 'subsys_add_code', '0', '新增关联代码库');
INSERT INTO `role_permission` VALUES (15, 'subsys_modify_scm', '0', '编辑代码库');
INSERT INTO `role_permission` VALUES (15, 'subsys_var_addEnv', '0', '子系统环境变量-添加环境');
INSERT INTO `role_permission` VALUES (15, 'subsys_var_add', '0', '子系统环境变量-添加变量');
INSERT INTO `role_permission` VALUES (15, 'subsys_var_modify', '0', '子系统环境变量-编辑变量');
INSERT INTO `role_permission` VALUES (15, 'subsys_env_test', '1', '发起环境测试');
INSERT INTO `role_permission` VALUES (15, 'subsys_project_create', '1', '创建项目');
INSERT INTO `role_permission` VALUES (15, 'subsys_project_sync', '1', '同步项目');
INSERT INTO `role_permission` VALUES (15, 'subsys_project_del', '1', '删除项目');
INSERT INTO `role_permission` VALUES (15, 'subsys_project_modify', '1', '更新项目');
INSERT INTO `role_permission` VALUES (17, 'repository_create_branch', '1', '新建分支');
INSERT INTO `role_permission` VALUES (17, 'repository_create_mergerequest', '1', '新建合并请求');
INSERT INTO `role_permission` VALUES (17, 'repository_create_tag', '1', '新建版本');
INSERT INTO `role_permission` VALUES (17, 'repository_update_file', '1', '编辑文件');
INSERT INTO `role_permission` VALUES (17, 'repository_delete_file', '1', '删除文件');
INSERT INTO `role_permission` VALUES (17, 'repository_delete_branch', '1', '删除分支');
INSERT INTO `role_permission` VALUES (17, 'repository_delete_tag', '1', '删除版本');
INSERT INTO `role_permission` VALUES (17, 'repository_create_file', '1', '创建文件');
INSERT INTO `role_permission` VALUES (17, 'repository_upload_file', '1', '上传文件');
INSERT INTO `role_permission` VALUES (10, 'repository_create_branch', '1', '新建分支');
INSERT INTO `role_permission` VALUES (10, 'repository_create_mergerequest', '1', '新建合并请求');
INSERT INTO `role_permission` VALUES (10, 'repository_create_tag', '1', '新建版本');
INSERT INTO `role_permission` VALUES (10, 'repository_setting', '1', '仓库设置');
INSERT INTO `role_permission` VALUES (10, 'repository_update_file', '1', '编辑文件');
INSERT INTO `role_permission` VALUES (10, 'repository_delete_file', '1', '删除文件');
INSERT INTO `role_permission` VALUES (10, 'repository_delete_branch', '1', '删除分支');
INSERT INTO `role_permission` VALUES (10, 'repository_delete_tag', '1', '删除版本');
INSERT INTO `role_permission` VALUES (10, 'repository_create_file', '1', '创建文件');
INSERT INTO `role_permission` VALUES (10, 'repository_upload_file', '1', '上传文件');
INSERT INTO `role_permission` VALUES (11, 'repository_create_branch', '1', '新建分支');
INSERT INTO `role_permission` VALUES (11, 'repository_create_mergerequest', '1', '新建合并请求');
INSERT INTO `role_permission` VALUES (11, 'repository_create_tag', '1', '新建版本');
INSERT INTO `role_permission` VALUES (17, 'repository_setting', '1', '仓库设置');
INSERT INTO `role_permission` VALUES (11, 'repository_update_file', '1', '编辑文件');
INSERT INTO `role_permission` VALUES (11, 'repository_delete_file', '1', '删除文件');
INSERT INTO `role_permission` VALUES (11, 'repository_delete_branch', '1', '删除分支');
INSERT INTO `role_permission` VALUES (11, 'repository_delete_tag', '1', '删除版本');
INSERT INTO `role_permission` VALUES (11, 'repository_create_file', '1', '创建文件');
INSERT INTO `role_permission` VALUES (11, 'repository_upload_file', '1', '上传文件');

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
-- Records of scm_merge_resource
-- ----------------------------

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
-- Records of scm_merge_task
-- ----------------------------
INSERT INTO `scm_merge_task` VALUES (8, 'dev_1', 1, 3269838518102036480, '2024-05-13 10:30:08');

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
) ENGINE = InnoDB AUTO_INCREMENT = 322 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '子系统组件信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_system_component
-- ----------------------------
INSERT INTO `sub_system_component` VALUES (8, 8, 'GITLAB', '10', 'id', 1, '2024-03-04 18:26:26', 1, 0, NULL);
INSERT INTO `sub_system_component` VALUES (9, 9, 'GITLAB', '14', 'id', 1, '2024-03-20 16:34:18', 2, 0, NULL);
INSERT INTO `sub_system_component` VALUES (10, 10, 'GITLAB', '15', 'id', 1, '2024-03-22 15:35:56', 3, 0, NULL);
INSERT INTO `sub_system_component` VALUES (11, 11, 'GITLAB', '19', 'id', 2856704057914482688, '2024-03-25 20:00:41', 4, 0, NULL);
INSERT INTO `sub_system_component` VALUES (12, 12, 'GITLAB', '17', 'id', 3267307713708539904, '2024-03-26 11:11:46', 3, 0, NULL);
INSERT INTO `sub_system_component` VALUES (13, 13, 'GITLAB', '18', 'id', 3267307713708539904, '2024-03-26 11:16:23', 3, 0, NULL);
INSERT INTO `sub_system_component` VALUES (14, 14, 'GITLAB', '20', 'id', 1, '2024-04-08 17:23:10', 5, 0, NULL);
INSERT INTO `sub_system_component` VALUES (15, 15, 'GITLAB', '21', 'id', 1, '2024-04-09 15:54:03', 6, 0, NULL);
INSERT INTO `sub_system_component` VALUES (16, 16, 'GITLAB', '22', 'id', 1, '2024-04-09 15:55:33', 6, 0, NULL);
INSERT INTO `sub_system_component` VALUES (18, 18, 'GITLAB', '24', 'id', 1, '2024-04-18 12:59:14', 7, 0, NULL);
INSERT INTO `sub_system_component` VALUES (19, 19, 'GITLAB', '25', 'id', 1, '2024-04-18 12:59:42', 7, 0, NULL);
INSERT INTO `sub_system_component` VALUES (20, 20, 'GITLAB', '26', 'id', 3267307713708539904, '2024-04-22 19:25:54', 8, 0, NULL);
INSERT INTO `sub_system_component` VALUES (21, 21, 'GITLAB', '27', 'id', 1, '2024-04-23 14:53:12', 9, 0, NULL);
INSERT INTO `sub_system_component` VALUES (22, 22, 'GITLAB', '29', 'id', 3267292550326501376, '2024-04-25 11:44:38', 10, 0, NULL);
INSERT INTO `sub_system_component` VALUES (23, 23, 'GITLAB', '28', 'id', 3267292550326501376, '2024-04-25 11:46:04', 10, 0, NULL);
INSERT INTO `sub_system_component` VALUES (25, 25, 'GITLAB', '31', 'id', 1, '2024-04-25 14:12:56', 7, 0, NULL);
INSERT INTO `sub_system_component` VALUES (26, 26, 'GITLAB', '32', 'id', 3271120617295249408, '2024-04-26 11:19:20', 11, 0, NULL);
INSERT INTO `sub_system_component` VALUES (27, 27, 'GITLAB', '33', 'id', 1, '2024-04-26 14:20:33', 8, 0, NULL);
INSERT INTO `sub_system_component` VALUES (28, 28, 'GITLAB', '34', 'id', 1, '2024-04-28 15:38:19', 11, 0, NULL);
INSERT INTO `sub_system_component` VALUES (29, 29, 'GITLAB', '35', 'id', 3267303552673759232, '2024-05-06 09:13:26', 12, 0, NULL);
INSERT INTO `sub_system_component` VALUES (30, 30, 'GITLAB', '36', 'id', 3267296873982836736, '2024-05-09 14:39:53', 13, 0, NULL);
INSERT INTO `sub_system_component` VALUES (31, 31, 'GITLAB', '37', 'id', 3267296873982836736, '2024-05-09 14:40:44', 13, 0, NULL);
INSERT INTO `sub_system_component` VALUES (32, 32, 'GITLAB', '38', 'id', 3271121021592600576, '2024-05-09 14:59:46', 5, 0, NULL);
INSERT INTO `sub_system_component` VALUES (33, 33, 'GITLAB', '39', 'id', 3267296873982836736, '2024-05-10 09:31:55', 14, 0, NULL);
INSERT INTO `sub_system_component` VALUES (34, 34, 'GITLAB', '40', 'id', 3267296873982836736, '2024-05-10 09:32:54', 14, 0, NULL);
INSERT INTO `sub_system_component` VALUES (35, 35, 'GITLAB', '41', 'id', 3267292550326501376, '2024-05-13 10:16:46', 15, 0, NULL);
INSERT INTO `sub_system_component` VALUES (36, 36, 'GITLAB', '42', 'id', 3267296873982836736, '2024-05-13 10:19:28', 15, 0, NULL);
INSERT INTO `sub_system_component` VALUES (37, 37, 'GITLAB', '43', 'id', 3267296873982836736, '2024-05-24 11:31:56', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (38, 38, 'GITLAB', '44', 'id', 3267296873982836736, '2024-05-24 11:34:35', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (39, 39, 'GITLAB', '45', 'id', 3267296873982836736, '2024-05-24 11:38:18', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (40, 40, 'GITLAB', '46', 'id', 3267296873982836736, '2024-05-24 11:39:15', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (41, 41, 'GITLAB', '47', 'id', 3267296873982836736, '2024-05-24 11:40:42', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (42, 42, 'GITLAB', '48', 'id', 3267296873982836736, '2024-05-24 11:41:34', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (43, 43, 'GITLAB', '49', 'id', 3267296873982836736, '2024-05-24 11:42:22', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (44, 44, 'GITLAB', '50', 'id', 3267296873982836736, '2024-05-24 11:43:05', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (47, 47, 'GITLAB', '53', 'id', 3267296873982836736, '2024-05-24 14:10:44', 16, 0, NULL);
INSERT INTO `sub_system_component` VALUES (48, 48, 'GITLAB', '54', 'id', 1, '2024-05-24 14:52:11', 18, 0, NULL);
INSERT INTO `sub_system_component` VALUES (50, 50, 'GITLAB', '56', 'id', 3363893784903917568, '2024-05-27 17:05:08', 19, 0, NULL);
INSERT INTO `sub_system_component` VALUES (51, 51, 'GITLAB', '57', 'id', 3363893784903917568, '2024-05-27 17:06:19', 19, 0, NULL);
INSERT INTO `sub_system_component` VALUES (52, 52, 'GITLAB', '58', 'id', 3363893784903917568, '2024-05-27 17:08:56', 20, 0, NULL);
INSERT INTO `sub_system_component` VALUES (53, 53, 'GITLAB', '59', 'id', 3363893784903917568, '2024-05-27 17:10:12', 20, 0, NULL);
INSERT INTO `sub_system_component` VALUES (54, 54, 'GITLAB', '60', 'id', 3363893784903917568, '2024-05-27 17:14:57', 21, 0, NULL);
INSERT INTO `sub_system_component` VALUES (55, 55, 'GITLAB', '61', 'id', 3363893784903917568, '2024-05-27 17:16:04', 21, 0, NULL);
INSERT INTO `sub_system_component` VALUES (56, 56, 'GITLAB', '67', 'id', 1, '2024-05-28 19:07:55', 22, 0, NULL);
INSERT INTO `sub_system_component` VALUES (57, 57, 'GITLAB', '62', 'id', 1, '2024-05-28 19:09:31', 22, 0, NULL);
INSERT INTO `sub_system_component` VALUES (58, 58, 'GITLAB', '63', 'id', 1, '2024-05-28 19:11:14', 22, 0, NULL);
INSERT INTO `sub_system_component` VALUES (59, 59, 'GITLAB', '64', 'id', 1, '2024-05-28 19:12:02', 22, 0, NULL);
INSERT INTO `sub_system_component` VALUES (60, 60, 'GITLAB', '65', 'id', 1, '2024-05-28 19:13:18', 22, 0, NULL);
INSERT INTO `sub_system_component` VALUES (61, 61, 'GITLAB', '66', 'id', 1, '2024-05-28 19:14:26', 22, 0, NULL);
INSERT INTO `sub_system_component` VALUES (62, 62, 'GITLAB', '69', 'id', 1, '2024-05-28 19:42:17', 23, 0, NULL);
INSERT INTO `sub_system_component` VALUES (63, 63, 'GITLAB', '70', 'id', 1, '2024-05-28 19:43:45', 23, 0, NULL);
INSERT INTO `sub_system_component` VALUES (64, 64, 'GITLAB', '71', 'id', 1, '2024-05-28 19:46:46', 23, 0, NULL);
INSERT INTO `sub_system_component` VALUES (65, 65, 'GITLAB', '74', 'id', 1, '2024-05-28 20:02:51', 24, 0, NULL);
INSERT INTO `sub_system_component` VALUES (66, 66, 'GITLAB', '73', 'id', 1, '2024-05-28 20:04:13', 24, 0, NULL);
INSERT INTO `sub_system_component` VALUES (67, 67, 'GITLAB', '72', 'id', 1, '2024-05-28 20:05:24', 24, 0, NULL);
INSERT INTO `sub_system_component` VALUES (68, 68, 'GITLAB', '75', 'id', 3267292550326501376, '2024-05-29 15:36:51', 25, 0, NULL);
INSERT INTO `sub_system_component` VALUES (69, 69, 'GITLAB', '76', 'id', 3267292550326501376, '2024-05-29 15:39:13', 25, 0, NULL);
INSERT INTO `sub_system_component` VALUES (70, 70, 'GITLAB', '77', 'id', 3267292550326501376, '2024-05-29 15:41:55', 26, 0, NULL);
INSERT INTO `sub_system_component` VALUES (72, 72, 'GITLAB', '79', 'id', 3267292550326501376, '2024-05-29 15:52:17', 26, 0, NULL);
INSERT INTO `sub_system_component` VALUES (73, 73, 'GITLAB', '80', 'id', 3267292550326501376, '2024-05-29 15:53:42', 27, 0, NULL);
INSERT INTO `sub_system_component` VALUES (74, 74, 'GITLAB', '81', 'id', 3267292550326501376, '2024-05-29 15:56:46', 28, 0, NULL);
INSERT INTO `sub_system_component` VALUES (75, 75, 'GITLAB', '82', 'id', 3267292550326501376, '2024-05-29 16:00:37', 29, 0, NULL);
INSERT INTO `sub_system_component` VALUES (76, 76, 'GITLAB', '83', 'id', 3267292550326501376, '2024-05-30 10:38:30', 26, 0, NULL);
INSERT INTO `sub_system_component` VALUES (77, 77, 'GITLAB', '84', 'id', 3267292550326501376, '2024-05-30 10:40:12', 26, 0, NULL);
INSERT INTO `sub_system_component` VALUES (78, 78, 'GITLAB', '85', 'id', 3267292550326501376, '2024-05-30 10:45:38', 29, 0, NULL);
INSERT INTO `sub_system_component` VALUES (79, 79, 'GITLAB', '86', 'id', 3267292550326501376, '2024-05-30 10:47:43', 29, 0, NULL);
INSERT INTO `sub_system_component` VALUES (80, 80, 'GITLAB', '87', 'id', 3267292550326501376, '2024-05-30 10:49:08', 30, 0, NULL);
INSERT INTO `sub_system_component` VALUES (81, 81, 'GITLAB', '88', 'id', 3267292550326501376, '2024-05-30 10:50:08', 30, 0, NULL);
INSERT INTO `sub_system_component` VALUES (82, 82, 'GITLAB', '89', 'id', 3267292550326501376, '2024-05-30 10:51:20', 31, 0, NULL);
INSERT INTO `sub_system_component` VALUES (83, 83, 'GITLAB', '97', 'id', 1, '2024-05-30 20:24:22', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (84, 84, 'GITLAB', '92', 'id', 1, '2024-05-30 20:25:00', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (85, 85, 'GITLAB', '90', 'id', 1, '2024-05-30 20:25:37', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (86, 86, 'GITLAB', '96', 'id', 1, '2024-05-30 20:26:12', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (87, 87, 'GITLAB', '95', 'id', 1, '2024-05-30 20:26:48', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (88, 88, 'GITLAB', '98', 'id', 1, '2024-05-30 20:27:53', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (89, 89, 'GITLAB', '93', 'id', 1, '2024-05-30 20:28:36', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (90, 90, 'GITLAB', '91', 'id', 1, '2024-05-30 20:29:34', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (91, 91, 'GITLAB', '94', 'id', 1, '2024-05-30 20:30:36', 32, 0, NULL);
INSERT INTO `sub_system_component` VALUES (92, 92, 'GITLAB', '99', 'id', 3271119574725492736, '2024-05-31 14:08:31', 33, 0, NULL);
INSERT INTO `sub_system_component` VALUES (93, 93, 'GITLAB', '100', 'id', 3271119574725492736, '2024-05-31 14:09:48', 33, 0, NULL);
INSERT INTO `sub_system_component` VALUES (94, 94, 'GITLAB', '101', 'id', 3267307713708539904, '2024-05-31 14:28:53', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (95, 95, 'GITLAB', '102', 'id', 3267307713708539904, '2024-05-31 14:29:49', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (96, 96, 'GITLAB', '103', 'id', 3267307713708539904, '2024-05-31 14:30:27', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (97, 97, 'GITLAB', '104', 'id', 3267307713708539904, '2024-05-31 14:31:09', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (98, 98, 'GITLAB', '105', 'id', 3267307713708539904, '2024-05-31 14:32:19', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (99, 99, 'GITLAB', '106', 'id', 3267307713708539904, '2024-05-31 14:34:24', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (100, 100, 'GITLAB', '107', 'id', 3267307713708539904, '2024-05-31 14:35:29', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (101, 101, 'GITLAB', '108', 'id', 3267307713708539904, '2024-05-31 14:36:34', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (102, 102, 'GITLAB', '109', 'id', 3267307713708539904, '2024-05-31 14:37:33', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (103, 103, 'GITLAB', '110', 'id', 3267307713708539904, '2024-05-31 14:38:28', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (104, 104, 'GITLAB', '111', 'id', 3267307713708539904, '2024-05-31 14:39:35', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (105, 105, 'GITLAB', '112', 'id', 3267307713708539904, '2024-05-31 14:40:25', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (106, 106, 'GITLAB', '113', 'id', 3267307713708539904, '2024-05-31 14:41:30', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (107, 107, 'GITLAB', '114', 'id', 3267307713708539904, '2024-05-31 14:42:35', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (108, 108, 'GITLAB', '115', 'id', 3267307713708539904, '2024-05-31 14:44:11', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (109, 109, 'GITLAB', '116', 'id', 3267307713708539904, '2024-05-31 14:45:10', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (110, 110, 'GITLAB', '117', 'id', 3267307713708539904, '2024-05-31 14:45:50', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (111, 111, 'GITLAB', '118', 'id', 3267307713708539904, '2024-05-31 14:48:32', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (112, 112, 'GITLAB', '119', 'id', 3267307713708539904, '2024-05-31 14:49:38', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (113, 113, 'GITLAB', '120', 'id', 3267307713708539904, '2024-05-31 14:50:52', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (114, 114, 'GITLAB', '121', 'id', 3267307713708539904, '2024-05-31 14:51:59', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (115, 115, 'GITLAB', '122', 'id', 3267307713708539904, '2024-05-31 15:07:24', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (116, 116, 'GITLAB', '123', 'id', 3267307713708539904, '2024-05-31 15:09:45', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (117, 117, 'GITLAB', '124', 'id', 3267307713708539904, '2024-05-31 15:11:00', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (118, 118, 'GITLAB', '125', 'id', 3267307713708539904, '2024-05-31 15:12:03', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (119, 119, 'GITLAB', '126', 'id', 3267307713708539904, '2024-05-31 15:13:28', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (120, 120, 'GITLAB', '127', 'id', 3267307713708539904, '2024-05-31 15:25:53', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (121, 121, 'GITLAB', '128', 'id', 3267307713708539904, '2024-05-31 15:27:32', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (122, 122, 'GITLAB', '129', 'id', 3267307713708539904, '2024-05-31 15:29:37', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (123, 123, 'GITLAB', '130', 'id', 3267307713708539904, '2024-05-31 15:46:06', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (124, 124, 'GITLAB', '131', 'id', 3267307713708539904, '2024-05-31 15:49:14', 35, 0, NULL);
INSERT INTO `sub_system_component` VALUES (125, 125, 'GITLAB', '132', 'id', 3267296873982836736, '2024-06-01 11:32:59', 36, 0, NULL);
INSERT INTO `sub_system_component` VALUES (126, 126, 'GITLAB', '133', 'id', 3267296873982836736, '2024-06-01 12:16:03', 37, 0, NULL);
INSERT INTO `sub_system_component` VALUES (128, 128, 'GITLAB', '135', 'id', 3267296873982836736, '2024-06-01 15:01:50', 39, 0, NULL);
INSERT INTO `sub_system_component` VALUES (129, 129, 'GITLAB', '136', 'id', 3267296873982836736, '2024-06-01 15:21:25', 40, 0, NULL);
INSERT INTO `sub_system_component` VALUES (130, 130, 'GITLAB', '137', 'id', 3267296873982836736, '2024-06-01 15:31:14', 40, 0, NULL);
INSERT INTO `sub_system_component` VALUES (131, 131, 'GITLAB', '138', 'id', 3267296873982836736, '2024-06-01 15:44:40', 40, 0, NULL);
INSERT INTO `sub_system_component` VALUES (132, 132, 'GITLAB', '139', 'id', 3267296873982836736, '2024-06-01 16:05:07', 40, 0, NULL);
INSERT INTO `sub_system_component` VALUES (133, 133, 'GITLAB', '140', 'id', 3267296873982836736, '2024-06-01 16:11:58', 40, 0, NULL);
INSERT INTO `sub_system_component` VALUES (134, 134, 'GITLAB', '141', 'id', 3267296873982836736, '2024-06-01 16:49:53', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (135, 135, 'GITLAB', '142', 'id', 3267296873982836736, '2024-06-01 16:57:09', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (136, 136, 'GITLAB', '143', 'id', 3267296873982836736, '2024-06-01 17:05:26', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (137, 137, 'GITLAB', '144', 'id', 3267296873982836736, '2024-06-01 17:10:18', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (138, 138, 'GITLAB', '145', 'id', 3267296873982836736, '2024-06-01 17:25:30', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (139, 139, 'GITLAB', '146', 'id', 3267296873982836736, '2024-06-01 17:30:32', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (140, 140, 'GITLAB', '147', 'id', 3267296873982836736, '2024-06-01 17:34:48', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (141, 141, 'GITLAB', '148', 'id', 3267296873982836736, '2024-06-01 17:38:50', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (143, 143, 'GITLAB', '150', 'id', 3267296873982836736, '2024-06-01 18:27:14', 44, 0, NULL);
INSERT INTO `sub_system_component` VALUES (144, 144, 'GITLAB', '152', 'id', 3267307713708539904, '2024-06-05 10:46:33', 45, 0, NULL);
INSERT INTO `sub_system_component` VALUES (145, 145, 'GITLAB', '153', 'id', 3267307713708539904, '2024-06-05 15:35:10', 45, 0, NULL);
INSERT INTO `sub_system_component` VALUES (146, 146, 'GITLAB', '154', 'id', 3267307713708539904, '2024-06-05 17:07:23', 12, 0, NULL);
INSERT INTO `sub_system_component` VALUES (148, 148, 'GITLAB', '156', 'id', 3267307713708539904, '2024-06-06 10:05:36', 9, 0, NULL);
INSERT INTO `sub_system_component` VALUES (149, 149, 'GITLAB', '157', 'id', 3271117585803313152, '2024-06-11 15:38:45', 47, 0, NULL);
INSERT INTO `sub_system_component` VALUES (151, 151, 'GITLAB', '159', 'id', 3271117585803313152, '2024-06-11 15:58:16', 48, 0, NULL);
INSERT INTO `sub_system_component` VALUES (152, 152, 'GITLAB', '160', 'id', 3271117585803313152, '2024-06-11 15:58:48', 48, 0, NULL);
INSERT INTO `sub_system_component` VALUES (153, 153, 'GITLAB', '161', 'id', 3271117585803313152, '2024-06-11 15:59:32', 48, 0, NULL);
INSERT INTO `sub_system_component` VALUES (155, 155, 'GITLAB', '163', 'id', 3271117585803313152, '2024-06-12 10:52:55', 47, 0, NULL);
INSERT INTO `sub_system_component` VALUES (156, 156, 'GITLAB', '164', 'id', 3271117585803313152, '2024-06-13 08:46:16', 52, 0, NULL);
INSERT INTO `sub_system_component` VALUES (157, 157, 'GITLAB', '165', 'id', 3271117585803313152, '2024-06-13 09:11:28', 53, 0, NULL);
INSERT INTO `sub_system_component` VALUES (158, 158, 'GITLAB', '166', 'id', 3271117585803313152, '2024-06-13 10:12:16', 58, 0, NULL);
INSERT INTO `sub_system_component` VALUES (159, 159, 'GITLAB', '167', 'id', 3271117585803313152, '2024-06-13 10:42:01', 56, 0, NULL);
INSERT INTO `sub_system_component` VALUES (160, 163, 'GITLAB', '168', 'id', 3271117585803313152, '2024-06-13 11:00:36', 57, 0, NULL);
INSERT INTO `sub_system_component` VALUES (161, 164, 'GITLAB', '169', 'id', 3271117585803313152, '2024-06-13 11:23:39', 54, 0, NULL);
INSERT INTO `sub_system_component` VALUES (162, 165, 'GITLAB', '170', 'id', 3271117585803313152, '2024-06-13 11:23:53', 55, 0, NULL);
INSERT INTO `sub_system_component` VALUES (163, 166, 'GITLAB', '171', 'id', 3271117585803313152, '2024-06-13 14:09:31', 51, 0, NULL);
INSERT INTO `sub_system_component` VALUES (164, 167, 'GITLAB', '172', 'id', 3271117585803313152, '2024-06-13 14:44:06', 49, 0, NULL);
INSERT INTO `sub_system_component` VALUES (167, 174, 'GITLAB', '175', 'id', 3271117585803313152, '2024-06-14 09:31:14', 50, 0, NULL);
INSERT INTO `sub_system_component` VALUES (168, 175, 'GITLAB', '176', 'id', 3267296873982836736, '2024-06-16 17:12:33', 36, 0, NULL);
INSERT INTO `sub_system_component` VALUES (169, 176, 'GITLAB', '177', 'id', 3267296873982836736, '2024-06-16 17:21:51', 37, 0, NULL);
INSERT INTO `sub_system_component` VALUES (170, 177, 'GITLAB', '178', 'id', 3267296873982836736, '2024-06-16 17:25:57', 39, 0, NULL);
INSERT INTO `sub_system_component` VALUES (173, 180, 'GITLAB', '181', 'id', 3267296873982836736, '2024-06-16 17:38:46', 60, 0, NULL);
INSERT INTO `sub_system_component` VALUES (174, 181, 'GITLAB', '182', 'id', 3267296873982836736, '2024-06-16 17:39:45', 60, 0, NULL);
INSERT INTO `sub_system_component` VALUES (175, 182, 'GITLAB', '183', 'id', 3267296873982836736, '2024-06-16 17:50:46', 61, 0, NULL);
INSERT INTO `sub_system_component` VALUES (176, 183, 'GITLAB', '184', 'id', 3267296873982836736, '2024-06-16 17:51:38', 61, 0, NULL);
INSERT INTO `sub_system_component` VALUES (177, 184, 'GITLAB', '185', 'id', 3267296873982836736, '2024-06-16 17:52:44', 61, 0, NULL);
INSERT INTO `sub_system_component` VALUES (178, 185, 'GITLAB', '186', 'id', 3267296873982836736, '2024-06-16 17:53:51', 61, 0, NULL);
INSERT INTO `sub_system_component` VALUES (180, 187, 'GITLAB', '188', 'id', 3267296873982836736, '2024-06-17 15:08:53', 44, 0, NULL);
INSERT INTO `sub_system_component` VALUES (183, 190, 'GITLAB', '191', 'id', 3267296873982836736, '2024-06-17 15:48:59', 43, 0, NULL);
INSERT INTO `sub_system_component` VALUES (184, 191, 'GITLAB', '192', 'id', 3267296873982836736, '2024-06-18 16:37:31', 60, 0, NULL);
INSERT INTO `sub_system_component` VALUES (186, 193, 'GITLAB', '194', 'id', 3267296873982836736, '2024-06-20 16:31:44', 39, 0, NULL);
INSERT INTO `sub_system_component` VALUES (187, 194, 'GITLAB', '196', 'id', 3371463310998532096, '2024-06-26 10:05:39', 64, 0, NULL);
INSERT INTO `sub_system_component` VALUES (188, 195, 'GITLAB', '197', 'id', 3267296873982836736, '2024-07-01 10:47:14', 77, 0, NULL);
INSERT INTO `sub_system_component` VALUES (190, 197, 'GITLAB', '199', 'id', 3267296873982836736, '2024-07-01 10:51:06', 78, 0, NULL);
INSERT INTO `sub_system_component` VALUES (191, 203, 'GITLAB', '200', 'id', 3267296873982836736, '2024-07-01 14:51:44', 76, 0, NULL);
INSERT INTO `sub_system_component` VALUES (192, 204, 'GITLAB', '201', 'id', 3271117585803313152, '2024-07-05 15:55:06', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (193, 205, 'GITLAB', '202', 'id', 3271117585803313152, '2024-07-05 15:57:09', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (194, 206, 'GITLAB', '203', 'id', 3271117585803313152, '2024-07-05 15:58:08', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (195, 207, 'GITLAB', '204', 'id', 3271117585803313152, '2024-07-05 15:58:28', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (196, 208, 'GITLAB', '205', 'id', 3271113249245298688, '2024-07-08 09:51:45', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (197, 209, 'GITLAB', '206', 'id', 3271113249245298688, '2024-07-08 09:52:58', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (198, 210, 'GITLAB', '207', 'id', 3271113249245298688, '2024-07-08 09:55:34', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (199, 211, 'GITLAB', '208', 'id', 3271113249245298688, '2024-07-08 09:56:27', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (200, 212, 'GITLAB', '209', 'id', 3271113249245298688, '2024-07-08 09:57:35', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (201, 213, 'GITLAB', '210', 'id', 3271113249245298688, '2024-07-08 09:58:21', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (202, 214, 'GITLAB', '211', 'id', 3271113249245298688, '2024-07-08 09:58:49', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (203, 215, 'GITLAB', '212', 'id', 3271113249245298688, '2024-07-08 09:59:41', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (204, 216, 'GITLAB', '213', 'id', 3271113249245298688, '2024-07-08 10:00:30', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (205, 217, 'GITLAB', '214', 'id', 3271113249245298688, '2024-07-09 10:54:32', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (206, 218, 'GITLAB', '215', 'id', 3271113249245298688, '2024-07-09 10:56:23', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (207, 219, 'GITLAB', '216', 'id', 3271113249245298688, '2024-07-09 11:04:29', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (208, 220, 'GITLAB', '217', 'id', 3271113249245298688, '2024-07-09 11:05:06', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (209, 221, 'GITLAB', '218', 'id', 3271113249245298688, '2024-07-09 11:07:57', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (210, 222, 'GITLAB', '219', 'id', 3371463065732411392, '2024-07-16 16:18:54', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (211, 223, 'GITLAB', '220', 'id', 3271120617295249408, '2024-07-19 10:14:00', 6, 0, NULL);
INSERT INTO `sub_system_component` VALUES (212, 224, 'GITLAB', '221', 'id', 3271120617295249408, '2024-07-19 10:20:20', 7, 0, NULL);
INSERT INTO `sub_system_component` VALUES (213, 225, 'GITLAB', '222', 'id', 3271120617295249408, '2024-07-19 10:29:08', 3, 0, NULL);
INSERT INTO `sub_system_component` VALUES (214, 226, 'GITLAB', '223', 'id', 1, '2024-08-06 14:32:50', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (215, 227, 'GITLAB', '224', 'id', 3371463065732411392, '2024-08-08 10:13:31', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (217, 229, 'GITLAB', '226', 'id', 3271121021592600576, '2024-08-20 15:45:00', 5, 0, NULL);
INSERT INTO `sub_system_component` VALUES (218, 230, 'GITLAB', '227', 'id', 3271122670088290304, '2024-08-21 17:30:15', 6, 0, NULL);
INSERT INTO `sub_system_component` VALUES (219, 231, 'GITLAB', '228', 'id', 3271122670088290304, '2024-08-22 09:43:16', 9, 0, NULL);
INSERT INTO `sub_system_component` VALUES (221, 235, 'GITLAB', '230', 'id', 3271123647897993216, '2024-08-22 14:17:30', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (224, 238, 'GITLAB', '233', 'id', 3271121021592600576, '2024-08-22 14:52:35', 5, 0, NULL);
INSERT INTO `sub_system_component` VALUES (225, 239, 'GITLAB', '234', 'id', 3271120617295249408, '2024-08-29 14:30:45', 82, 0, NULL);
INSERT INTO `sub_system_component` VALUES (226, 240, 'GITLAB', '235', 'id', 3271108092029763584, '2024-09-03 10:08:38', 84, 0, NULL);
INSERT INTO `sub_system_component` VALUES (228, 242, 'GITLAB', '236', 'id', 3371463360424210432, '2024-09-03 10:11:54', 83, 0, NULL);
INSERT INTO `sub_system_component` VALUES (229, 243, 'GITLAB', '237', 'id', 3371463375808917504, '2024-09-03 10:18:39', 85, 0, NULL);
INSERT INTO `sub_system_component` VALUES (230, 244, 'GITLAB', '238', 'id', 3271108092029763584, '2024-09-03 10:20:55', 86, 0, NULL);
INSERT INTO `sub_system_component` VALUES (231, 245, 'GITLAB', '239', 'id', 3271108092029763584, '2024-09-03 10:29:02', 86, 0, NULL);
INSERT INTO `sub_system_component` VALUES (232, 246, 'GITLAB', '240', 'id', 3271108092029763584, '2024-09-03 10:29:43', 86, 0, NULL);
INSERT INTO `sub_system_component` VALUES (233, 247, 'GITLAB', '241', 'id', 3271108092029763584, '2024-09-03 10:30:17', 86, 0, NULL);
INSERT INTO `sub_system_component` VALUES (234, 248, 'GITLAB', '242', 'id', 3371463375808917504, '2024-09-03 10:32:25', 85, 0, NULL);
INSERT INTO `sub_system_component` VALUES (235, 249, 'GITLAB', '243', 'id', 3371463375808917504, '2024-09-03 10:40:41', 87, 0, NULL);
INSERT INTO `sub_system_component` VALUES (236, 250, 'GITLAB', '244', 'id', 3371463360424210432, '2024-09-03 10:46:16', 83, 0, NULL);
INSERT INTO `sub_system_component` VALUES (237, 251, 'GITLAB', '245', 'id', 3371463375808917504, '2024-09-03 10:49:00', 89, 0, NULL);
INSERT INTO `sub_system_component` VALUES (238, 252, 'GITLAB', '246', 'id', 3371463360424210432, '2024-09-03 10:56:10', 83, 0, NULL);
INSERT INTO `sub_system_component` VALUES (239, 253, 'GITLAB', '247', 'id', 3371463360424210432, '2024-09-03 11:10:55', 74, 0, NULL);
INSERT INTO `sub_system_component` VALUES (240, 254, 'GITLAB', '248', 'id', 3271108092029763584, '2024-09-03 11:15:52', 89, 0, NULL);
INSERT INTO `sub_system_component` VALUES (241, 255, 'GITLAB', '249', 'id', 3267296873982836736, '2024-09-03 11:16:31', 78, 0, NULL);
INSERT INTO `sub_system_component` VALUES (243, 257, 'GITLAB', '251', 'id', 3271108092029763584, '2024-09-03 11:20:07', 88, 0, NULL);
INSERT INTO `sub_system_component` VALUES (245, 259, 'GITLAB', '253', 'id', 3371463360424210432, '2024-09-03 11:20:25', 74, 0, NULL);
INSERT INTO `sub_system_component` VALUES (246, 260, 'GITLAB', '254', 'id', 3371463360424210432, '2024-09-03 11:32:10', 75, 0, NULL);
INSERT INTO `sub_system_component` VALUES (248, 263, 'GITLAB', '256', 'id', 3371463360424210432, '2024-09-03 14:27:54', 90, 0, NULL);
INSERT INTO `sub_system_component` VALUES (249, 264, 'GITLAB', '257', 'id', 3371463360424210432, '2024-09-03 14:41:53', 90, 0, NULL);
INSERT INTO `sub_system_component` VALUES (250, 265, 'GITLAB', '258', 'id', 3271108092029763584, '2024-09-03 14:57:00', 66, 0, NULL);
INSERT INTO `sub_system_component` VALUES (251, 266, 'GITLAB', '259', 'id', 3267296873982836736, '2024-09-03 14:58:52', 91, 0, NULL);
INSERT INTO `sub_system_component` VALUES (252, 267, 'GITLAB', '260', 'id', 3267296873982836736, '2024-09-03 14:59:21', 91, 0, NULL);
INSERT INTO `sub_system_component` VALUES (253, 268, 'GITLAB', '261', 'id', 3271108092029763584, '2024-09-03 15:10:21', 71, 0, NULL);
INSERT INTO `sub_system_component` VALUES (254, 269, 'GITLAB', '262', 'id', 3271108092029763584, '2024-09-03 15:20:16', 67, 0, NULL);
INSERT INTO `sub_system_component` VALUES (255, 270, 'GITLAB', '263', 'id', 3271108092029763584, '2024-09-03 15:27:40', 93, 0, NULL);
INSERT INTO `sub_system_component` VALUES (256, 271, 'GITLAB', '264', 'id', 3271108092029763584, '2024-09-03 15:34:36', 94, 0, NULL);
INSERT INTO `sub_system_component` VALUES (257, 272, 'GITLAB', '265', 'id', 3371463360424210432, '2024-09-03 15:36:46', 90, 0, NULL);
INSERT INTO `sub_system_component` VALUES (258, 273, 'GITLAB', '266', 'id', 3271108092029763584, '2024-09-03 15:41:36', 92, 0, NULL);
INSERT INTO `sub_system_component` VALUES (259, 274, 'GITLAB', '267', 'id', 3371463360424210432, '2024-09-03 15:43:46', 90, 0, NULL);
INSERT INTO `sub_system_component` VALUES (260, 275, 'GITLAB', '268', 'id', 3371463360424210432, '2024-09-03 16:13:45', 95, 0, NULL);
INSERT INTO `sub_system_component` VALUES (261, 276, 'GITLAB', '269', 'id', 3371463360424210432, '2024-09-03 16:17:29', 95, 0, NULL);
INSERT INTO `sub_system_component` VALUES (262, 277, 'GITLAB', '270', 'id', 3371463360424210432, '2024-09-03 16:29:20', 96, 0, NULL);
INSERT INTO `sub_system_component` VALUES (263, 278, 'GITLAB', '271', 'id', 3371463360424210432, '2024-09-03 16:29:46', 96, 0, NULL);
INSERT INTO `sub_system_component` VALUES (264, 279, 'GITLAB', '272', 'id', 3267296873982836736, '2024-09-03 16:44:48', 67, 0, NULL);
INSERT INTO `sub_system_component` VALUES (265, 280, 'GITLAB', '273', 'id', 3271108092029763584, '2024-09-03 16:46:07', 92, 0, NULL);
INSERT INTO `sub_system_component` VALUES (266, 281, 'GITLAB', '274', 'id', 3271108092029763584, '2024-09-03 16:47:20', 92, 0, NULL);
INSERT INTO `sub_system_component` VALUES (267, 282, 'GITLAB', '275', 'id', 3371463360424210432, '2024-09-03 16:48:09', 97, 0, NULL);
INSERT INTO `sub_system_component` VALUES (268, 283, 'GITLAB', '276', 'id', 3371463360424210432, '2024-09-03 16:48:52', 97, 0, NULL);
INSERT INTO `sub_system_component` VALUES (269, 284, 'GITLAB', '277', 'id', 3371463360424210432, '2024-09-03 17:13:35', 90, 0, NULL);
INSERT INTO `sub_system_component` VALUES (270, 285, 'GITLAB', '278', 'id', 3371463360424210432, '2024-09-03 17:20:50', 90, 0, NULL);
INSERT INTO `sub_system_component` VALUES (271, 286, 'GITLAB', '311', 'id', 3267292550326501376, '2024-09-11 10:56:57', 98, 0, NULL);
INSERT INTO `sub_system_component` VALUES (275, 290, 'GITLAB', '316', 'id', 3267307713708539904, '2024-09-30 11:22:31', 99, 0, NULL);
INSERT INTO `sub_system_component` VALUES (276, 291, 'GITLAB', '317', 'id', 3267307713708539904, '2024-09-30 11:23:26', 99, 0, NULL);
INSERT INTO `sub_system_component` VALUES (277, 292, 'GITLAB', '318', 'id', 3267307713708539904, '2024-09-30 11:29:17', 99, 0, NULL);
INSERT INTO `sub_system_component` VALUES (278, 293, 'GITLAB', '319', 'id', 3271121021592600576, '2024-10-14 10:00:36', 6, 0, NULL);
INSERT INTO `sub_system_component` VALUES (281, 296, 'GITLAB', '321', 'id', 3271122024350023680, '2024-10-16 14:17:24', 101, 0, NULL);
INSERT INTO `sub_system_component` VALUES (282, 297, 'GITLAB', '322', 'id', 3271122024350023680, '2024-10-16 14:19:00', 101, 0, NULL);
INSERT INTO `sub_system_component` VALUES (283, 298, 'GITLAB', '320', 'id', 3267292550326501376, '2024-10-16 14:34:15', 100, 0, NULL);
INSERT INTO `sub_system_component` VALUES (284, 299, 'GITLAB', '323', 'id', 3267292550326501376, '2024-10-16 15:49:20', 102, 0, NULL);
INSERT INTO `sub_system_component` VALUES (285, 300, 'GITLAB', '324', 'id', 3267292550326501376, '2024-10-23 08:50:49', 103, 0, NULL);
INSERT INTO `sub_system_component` VALUES (287, 302, 'GITLAB', '326', 'id', 3267292550326501376, '2024-10-23 14:27:17', 111, 0, NULL);
INSERT INTO `sub_system_component` VALUES (288, 303, 'GITLAB', '327', 'id', 3267292550326501376, '2024-10-23 15:02:34', 110, 0, NULL);
INSERT INTO `sub_system_component` VALUES (289, 304, 'GITLAB', '328', 'id', 3267307713708539904, '2024-10-24 15:29:49', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (290, 305, 'GITLAB', '329', 'id', 3267292550326501376, '2024-10-28 09:38:33', 103, 0, NULL);
INSERT INTO `sub_system_component` VALUES (291, 306, 'GITLAB', '330', 'id', 3267292550326501376, '2024-10-28 11:37:52', 103, 0, NULL);
INSERT INTO `sub_system_component` VALUES (292, 307, 'GITLAB', '331', 'id', 3267307713708539904, '2024-11-07 11:11:26', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (293, 308, 'GITLAB', '332', 'id', 3267292550326501376, '2024-11-11 10:14:18', 113, 0, NULL);
INSERT INTO `sub_system_component` VALUES (294, 309, 'GITLAB', '333', 'id', 3369369332493033472, '2024-11-12 17:35:48', 103, 0, NULL);
INSERT INTO `sub_system_component` VALUES (295, 310, 'GITLAB', '334', 'id', 3267307713708539904, '2024-11-14 09:00:25', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (296, 311, 'GITLAB', '335', 'id', 3267292550326501376, '2024-11-14 10:09:52', 114, 0, NULL);
INSERT INTO `sub_system_component` VALUES (298, 313, 'GITLAB', '337', 'id', 3267292550326501376, '2024-11-15 10:16:14', 115, 0, NULL);
INSERT INTO `sub_system_component` VALUES (299, 314, 'GITLAB', '338', 'id', 3271117585803313152, '2024-11-19 09:50:26', 116, 0, NULL);
INSERT INTO `sub_system_component` VALUES (300, 315, 'GITLAB', '339', 'id', 3271117585803313152, '2024-11-19 10:08:39', 116, 0, NULL);
INSERT INTO `sub_system_component` VALUES (301, 316, 'GITLAB', '340', 'id', 3271117585803313152, '2024-11-19 10:14:11', 116, 0, NULL);
INSERT INTO `sub_system_component` VALUES (302, 317, 'GITLAB', '341', 'id', 3271117585803313152, '2024-11-19 10:28:11', 116, 0, NULL);
INSERT INTO `sub_system_component` VALUES (303, 318, 'GITLAB', '342', 'id', 3271113249245298688, '2024-11-19 14:35:44', 118, 0, NULL);
INSERT INTO `sub_system_component` VALUES (304, 319, 'GITLAB', '343', 'id', 3271113249245298688, '2024-11-19 14:36:20', 118, 0, NULL);
INSERT INTO `sub_system_component` VALUES (305, 320, 'GITLAB', '344', 'id', 3271113249245298688, '2024-11-20 10:04:05', 118, 0, NULL);
INSERT INTO `sub_system_component` VALUES (306, 321, 'GITLAB', '345', 'id', 3371463396260343808, '2024-11-22 09:56:32', 41, 0, NULL);
INSERT INTO `sub_system_component` VALUES (307, 322, 'GITLAB', '346', 'id', 3371463234746085376, '2024-11-22 14:55:34', 119, 0, NULL);
INSERT INTO `sub_system_component` VALUES (308, 323, 'GITLAB', '347', 'id', 3267307713708539904, '2024-11-28 09:31:06', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (309, 324, 'GITLAB', '348', 'id', 3267292308583596032, '2024-11-28 09:34:24', 120, 0, NULL);
INSERT INTO `sub_system_component` VALUES (310, 325, 'GITLAB', '349', 'id', 3271113249245298688, '2024-11-29 09:01:24', 118, 0, NULL);
INSERT INTO `sub_system_component` VALUES (311, 326, 'GITLAB', '350', 'id', 3271113249245298688, '2024-11-29 09:02:20', 118, 0, NULL);
INSERT INTO `sub_system_component` VALUES (312, 327, 'GITLAB', '351', 'id', 3371463081586880512, '2024-11-29 17:00:12', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (313, 328, 'GITLAB', '352', 'id', 3371463234746085376, '2024-12-06 15:03:21', 115, 0, NULL);
INSERT INTO `sub_system_component` VALUES (314, 329, 'GITLAB', '353', 'id', 3267307713708539904, '2024-12-12 09:04:45', 121, 0, NULL);
INSERT INTO `sub_system_component` VALUES (315, 330, 'GITLAB', '354', 'id', 3267307713708539904, '2024-12-12 09:05:27', 121, 0, NULL);
INSERT INTO `sub_system_component` VALUES (316, 332, 'GITLAB', '388', 'id', 3267292550326501376, '2024-12-12 17:17:19', 122, 0, NULL);
INSERT INTO `sub_system_component` VALUES (317, 333, 'GITLAB', '421', 'id', 3371463081586880512, '2024-12-17 11:18:58', 79, 0, NULL);
INSERT INTO `sub_system_component` VALUES (318, 334, 'GITLAB', '422', 'id', 3371463065732411392, '2024-12-19 09:00:07', 118, 0, NULL);
INSERT INTO `sub_system_component` VALUES (319, 335, 'GITLAB', '423', 'id', 3267307713708539904, '2025-01-02 17:22:26', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (320, 336, 'GITLAB', '424', 'id', 3267307713708539904, '2025-01-02 17:24:49', 34, 0, NULL);
INSERT INTO `sub_system_component` VALUES (321, 337, 'GITLAB', '426', 'id', 3371463310998532096, '2025-01-07 16:36:02', 18, 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '应用配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sub_system_config
-- ----------------------------

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
-- Records of sub_system_env
-- ----------------------------

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
-- Records of sub_system_pipeline
-- ----------------------------
INSERT INTO `sub_system_pipeline` VALUES (8, 3268423816287690752, 1, '2024-03-04 18:47:21', 1);
INSERT INTO `sub_system_pipeline` VALUES (8, 3269643232346185728, 1, '2024-03-05 14:58:44', 1);
INSERT INTO `sub_system_pipeline` VALUES (10, 3294361419540246528, 0, '2024-03-22 16:14:02', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3301578929360515072, 1, '2024-03-27 15:44:00', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3303057750421057536, 0, '2024-03-28 16:13:04', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3303063228047863808, 1, '2024-03-28 16:21:18', 1);
INSERT INTO `sub_system_pipeline` VALUES (10, 3304119807836860416, 0, '2024-03-29 09:48:08', 1);
INSERT INTO `sub_system_pipeline` VALUES (10, 3304324898327744512, 0, '2024-03-29 13:12:58', 1);
INSERT INTO `sub_system_pipeline` VALUES (13, 3304541119128129536, 0, '2024-03-29 16:47:51', 1);
INSERT INTO `sub_system_pipeline` VALUES (13, 3304697435251396608, 0, '2024-03-29 19:24:38', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3319012819869749248, 0, '2024-04-08 16:23:00', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3323439981662162944, 0, '2024-04-11 17:46:22', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3323458639788625920, 0, '2024-04-11 17:59:32', 1);
INSERT INTO `sub_system_pipeline` VALUES (15, 3333158783396204544, 0, '2024-04-18 10:35:46', 1);
INSERT INTO `sub_system_pipeline` VALUES (15, 3333162850730233856, 0, '2024-04-18 10:39:48', 1);
INSERT INTO `sub_system_pipeline` VALUES (16, 3334608405507461120, 0, '2024-04-19 10:35:50', 3271121021592600576);
INSERT INTO `sub_system_pipeline` VALUES (16, 3334613946887688192, 0, '2024-04-19 10:41:20', 3271121021592600576);
INSERT INTO `sub_system_pipeline` VALUES (16, 3334618446285361152, 0, '2024-04-19 10:45:48', 3271121021592600576);
INSERT INTO `sub_system_pipeline` VALUES (15, 3334629213265055744, 0, '2024-04-19 10:56:30', 3271121021592600576);
INSERT INTO `sub_system_pipeline` VALUES (15, 3334633259006808064, 0, '2024-04-19 11:00:31', 3271121021592600576);
INSERT INTO `sub_system_pipeline` VALUES (18, 3335006453865762816, 0, '2024-04-19 17:27:47', 1);
INSERT INTO `sub_system_pipeline` VALUES (9, 3338991520631869440, 0, '2024-04-22 11:10:04', 1);
INSERT INTO `sub_system_pipeline` VALUES (9, 3338992595699093504, 0, '2024-04-22 11:11:08', 1);
INSERT INTO `sub_system_pipeline` VALUES (19, 3343230074555846656, 0, '2024-04-25 09:22:19', 1);
INSERT INTO `sub_system_pipeline` VALUES (19, 3343229693058732032, 0, '2024-04-25 09:22:19', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3343378703358742528, 0, '2024-04-25 11:48:20', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (23, 3343515656158826496, 0, '2024-04-25 14:04:23', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (25, 3343676311826452480, 0, '2024-04-25 16:43:59', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3343704961036701696, 0, '2024-04-25 17:12:27', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3343712537661001728, 0, '2024-04-25 17:19:58', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3347589569893486592, 0, '2024-04-28 09:31:27', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (22, 3347598339361067008, 0, '2024-04-28 09:40:10', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (22, 3347602515528896512, 0, '2024-04-28 09:44:19', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (31, 3364001105717350400, 0, '2024-05-09 17:15:58', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (31, 3363914142259728384, 0, '2024-05-09 17:15:58', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (30, 3364042825486159872, 0, '2024-05-09 17:56:45', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (30, 3363986679358410752, 0, '2024-05-09 17:56:45', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (33, 3365051232619974656, 0, '2024-05-10 10:42:54', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (33, 3365039604583223296, 0, '2024-05-10 10:42:54', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (34, 3365089918246047744, 0, '2024-05-10 11:18:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (34, 3365294870327316480, 0, '2024-05-10 14:40:24', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (15, 3365471333571743744, 0, '2024-05-10 17:35:25', 1);
INSERT INTO `sub_system_pipeline` VALUES (15, 3365471379339988992, 0, '2024-05-10 17:35:28', 1);
INSERT INTO `sub_system_pipeline` VALUES (31, 3365490298066948096, 0, '2024-05-10 17:54:14', 1);
INSERT INTO `sub_system_pipeline` VALUES (30, 3365531232930484224, 0, '2024-05-10 18:34:54', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (30, 3366742742474280960, 0, '2024-05-11 15:04:06', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (31, 3366767351412150272, 0, '2024-05-11 15:04:31', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (33, 3366785647771504640, 0, '2024-05-11 15:27:11', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (14, 3366795528847085568, 0, '2024-05-11 15:30:52', 1);
INSERT INTO `sub_system_pipeline` VALUES (32, 3366796210320822272, 1, '2024-05-11 15:31:32', 1);
INSERT INTO `sub_system_pipeline` VALUES (33, 3366807797421166592, 0, '2024-05-11 15:43:21', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (36, 3369631142642569216, 0, '2024-05-13 14:27:47', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (36, 3369722926060130304, 0, '2024-05-13 16:16:13', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (35, 3369651424618991616, 0, '2024-05-13 16:16:36', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (36, 3369746673789947904, 0, '2024-05-13 16:22:34', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (36, 3369804713696284672, 0, '2024-05-13 17:20:13', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (36, 3369811348749668352, 0, '2024-05-13 17:26:48', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (36, 3369811991786803200, 0, '2024-05-13 17:27:27', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (12, 3369825833124220928, 0, '2024-05-13 17:41:12', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3369835332400697344, 0, '2024-05-13 17:50:38', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3369838149395927040, 0, '2024-05-13 17:53:26', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3369841230951075840, 0, '2024-05-13 17:56:30', 1);
INSERT INTO `sub_system_pipeline` VALUES (35, 3369942492036059136, 0, '2024-05-13 19:37:05', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (35, 3369954339183251456, 0, '2024-05-13 19:48:51', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (35, 3369959650514292736, 0, '2024-05-13 19:54:08', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (12, 3371310723678195712, 0, '2024-05-14 18:16:19', 1);
INSERT INTO `sub_system_pipeline` VALUES (12, 3371349511091638272, 0, '2024-05-14 18:54:51', 1);
INSERT INTO `sub_system_pipeline` VALUES (13, 3373750862236995584, 0, '2024-05-16 10:40:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (13, 3373761579740680192, 0, '2024-05-16 10:51:01', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (14, 3375089539437416448, 0, '2024-05-17 08:50:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (33, 3375200218479710208, 0, '2024-05-17 10:40:11', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (32, 3375196394314649600, 0, '2024-05-17 10:42:24', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (34, 3375222873995988992, 0, '2024-05-17 11:02:41', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (34, 3375224777656356864, 0, '2024-05-17 11:04:34', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (34, 3375225556337283072, 0, '2024-05-17 11:05:21', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (31, 3375264751252525056, 0, '2024-05-17 11:44:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (35, 3375349969208594432, 0, '2024-05-17 13:08:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (36, 3375355339142451200, 0, '2024-05-17 13:14:16', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (30, 3375374953637335040, 0, '2024-05-17 13:33:46', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (33, 3375470997494681600, 0, '2024-05-17 15:09:10', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (33, 3375475076388212736, 0, '2024-05-17 15:13:13', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (22, 3381345687048146944, 0, '2024-05-21 16:25:09', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3381370925936922624, 0, '2024-05-21 16:50:13', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3381371182477332480, 0, '2024-05-21 16:50:28', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3382342145213845504, 0, '2024-05-22 08:55:02', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (23, 3384180480169320448, 0, '2024-05-23 15:21:16', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (23, 3384183890440462336, 0, '2024-05-23 15:24:39', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (23, 3384185629298237440, 0, '2024-05-23 15:26:22', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (23, 3384189566457847808, 0, '2024-05-23 15:30:17', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (32, 3385310955139080192, 0, '2024-05-24 10:04:17', 1);
INSERT INTO `sub_system_pipeline` VALUES (32, 3385311205153153024, 0, '2024-05-24 10:04:32', 1);
INSERT INTO `sub_system_pipeline` VALUES (14, 3385368899465617408, 0, '2024-05-24 11:01:51', 1);
INSERT INTO `sub_system_pipeline` VALUES (22, 3385379058506113024, 0, '2024-05-24 11:11:56', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (51, 3390094592892051456, 0, '2024-05-27 17:16:24', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (50, 3391142399371485184, 0, '2024-05-28 10:37:18', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (50, 3391150142325104640, 0, '2024-05-28 10:45:00', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (50, 3391151734768115712, 0, '2024-05-28 10:46:35', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (50, 3391153438393737216, 0, '2024-05-28 10:48:16', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (50, 3391155392754851840, 0, '2024-05-28 10:50:13', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (51, 3391157230984077312, 0, '2024-05-28 10:52:02', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (51, 3391169672799690752, 0, '2024-05-28 11:04:24', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (51, 3391171110422552576, 0, '2024-05-28 11:05:50', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (51, 3391172148009476096, 0, '2024-05-28 11:06:51', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (51, 3391175486037925888, 0, '2024-05-28 11:10:10', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (51, 3391177842481799168, 0, '2024-05-28 11:12:31', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (52, 3391180902511779840, 0, '2024-05-28 11:15:33', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (52, 3391182837763645440, 0, '2024-05-28 11:17:29', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (52, 3391184598029148160, 0, '2024-05-28 11:19:13', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (52, 3391187182139842560, 0, '2024-05-28 11:21:47', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (52, 3391189281556766720, 0, '2024-05-28 11:23:53', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (53, 3391191018199949312, 0, '2024-05-28 11:25:36', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (53, 3391194411542880256, 0, '2024-05-28 11:29:40', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (53, 3391193957551415296, 0, '2024-05-28 11:29:40', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (53, 3391193287385522176, 0, '2024-05-28 11:29:40', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (53, 3391192665957441536, 0, '2024-05-28 11:29:40', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (53, 3391191994315153408, 0, '2024-05-28 11:29:40', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (55, 3391372024378925056, 0, '2024-05-28 14:25:58', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (55, 3391371057340194816, 0, '2024-05-28 14:25:58', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (55, 3391370501074821120, 0, '2024-05-28 14:25:58', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (55, 3391364539895095296, 0, '2024-05-28 14:25:58', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (55, 3391203150710808576, 0, '2024-05-28 14:25:58', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (54, 3391375942664167424, 0, '2024-05-28 14:29:41', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (54, 3391375517261078528, 0, '2024-05-28 14:29:41', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (54, 3391375057129152512, 0, '2024-05-28 14:29:41', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (54, 3391374376410390528, 0, '2024-05-28 14:29:41', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (54, 3391373478862888960, 0, '2024-05-28 14:29:41', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392562037292638208, 0, '2024-05-29 10:07:35', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392587176138874880, 0, '2024-05-29 10:32:34', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392594887350001664, 0, '2024-05-29 10:40:13', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392600754359214080, 0, '2024-05-29 10:46:03', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392605147758436352, 0, '2024-05-29 10:50:25', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392606394154590208, 0, '2024-05-29 10:51:39', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (48, 3392609060725301248, 0, '2024-05-29 10:54:18', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (18, 3392805640254365696, 0, '2024-05-29 14:09:35', 1);
INSERT INTO `sub_system_pipeline` VALUES (68, 3394277204430790656, 0, '2024-05-30 14:31:27', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (68, 3394283464614060032, 0, '2024-05-30 14:37:40', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (68, 3394291685332459520, 0, '2024-05-30 14:45:50', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (68, 3394292954059087872, 0, '2024-05-30 14:47:06', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (68, 3394298708728061952, 0, '2024-05-30 14:52:49', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (69, 3394300924830523392, 0, '2024-05-30 14:55:01', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (69, 3394302445030842368, 0, '2024-05-30 14:56:32', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (69, 3394304969431425024, 0, '2024-05-30 14:59:02', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (69, 3394306759661035520, 0, '2024-05-30 15:00:49', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (69, 3394307799848427520, 0, '2024-05-30 15:01:51', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394320273490419712, 0, '2024-05-30 15:14:14', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394322971115757568, 0, '2024-05-30 15:16:55', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394326257520713728, 0, '2024-05-30 15:20:11', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394329503979118592, 0, '2024-05-30 15:23:24', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394331208611373056, 0, '2024-05-30 15:25:06', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394333216961568768, 0, '2024-05-30 15:27:06', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394339489794859008, 0, '2024-05-30 15:33:20', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394340453260042240, 0, '2024-05-30 15:34:17', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (77, 3394341246470037504, 0, '2024-05-30 15:35:04', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (76, 3394344757706465280, 0, '2024-05-30 15:38:34', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (76, 3394345934879825920, 0, '2024-05-30 15:39:44', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (76, 3394347555726663680, 0, '2024-05-30 15:41:20', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (76, 3394348728001077248, 0, '2024-05-30 15:42:30', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (76, 3394350176680124416, 0, '2024-05-30 15:43:57', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (72, 3394358060109373440, 0, '2024-05-30 15:51:47', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (72, 3394360316007391232, 0, '2024-05-30 15:54:01', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (72, 3394361578039910400, 0, '2024-05-30 15:55:16', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (72, 3394362764222636032, 0, '2024-05-30 15:56:27', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (72, 3394364657548238848, 0, '2024-05-30 15:58:20', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (70, 3394367570676916224, 0, '2024-05-30 16:01:13', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (70, 3394369654994345984, 0, '2024-05-30 16:03:18', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (70, 3394371179187642368, 0, '2024-05-30 16:04:48', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (70, 3394372576176087040, 0, '2024-05-30 16:06:12', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (70, 3394374283425587200, 0, '2024-05-30 16:07:53', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (70, 3394375275042938880, 0, '2024-05-30 16:08:53', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (73, 3394389261436166144, 0, '2024-05-30 16:22:46', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (73, 3394390110396850176, 0, '2024-05-30 16:23:37', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (73, 3394391916464152576, 0, '2024-05-30 16:25:25', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (73, 3394392863823208448, 0, '2024-05-30 16:26:21', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (73, 3394393876764401664, 0, '2024-05-30 16:27:21', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (73, 3394394960874545152, 0, '2024-05-30 16:28:26', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (74, 3394397556276305920, 0, '2024-05-30 16:31:01', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (74, 3394399266310823936, 0, '2024-05-30 16:32:43', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (74, 3394400333358538752, 0, '2024-05-30 16:33:46', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (74, 3394401442886164480, 0, '2024-05-30 16:34:52', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (74, 3394402619455545344, 0, '2024-05-30 16:36:02', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (79, 3394410892787294208, 0, '2024-05-30 16:44:16', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (79, 3394415359016411136, 0, '2024-05-30 16:48:42', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (79, 3394416169188171776, 0, '2024-05-30 16:49:30', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (79, 3394417324265938944, 0, '2024-05-30 16:50:39', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (79, 3394418367221571584, 0, '2024-05-30 16:51:41', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (78, 3394420882596012032, 0, '2024-05-30 16:54:11', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (78, 3394422420781506560, 0, '2024-05-30 16:55:43', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (78, 3394423719103143936, 0, '2024-05-30 16:57:00', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (78, 3394424465471152128, 0, '2024-05-30 16:57:45', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (78, 3394425336946860032, 0, '2024-05-30 16:58:37', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (78, 3394426093767073792, 0, '2024-05-30 16:59:22', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (75, 3394432406647578624, 0, '2024-05-30 17:05:38', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (75, 3394435441360740352, 0, '2024-05-30 17:08:39', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (75, 3394436689417838592, 0, '2024-05-30 17:09:53', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (75, 3394438129993490432, 0, '2024-05-30 17:11:19', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (75, 3394439317132517376, 0, '2024-05-30 17:12:30', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (80, 3394443593409994752, 0, '2024-05-30 17:16:45', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (80, 3394448803305988096, 0, '2024-05-30 17:21:55', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (80, 3394449949256949760, 0, '2024-05-30 17:23:04', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (80, 3394450915691700224, 0, '2024-05-30 17:24:01', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (80, 3394451716183007232, 0, '2024-05-30 17:24:49', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394453612612395008, 0, '2024-05-30 17:26:42', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394455706576723968, 0, '2024-05-30 17:28:47', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394457025869881344, 0, '2024-05-30 17:30:05', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394459767401193472, 0, '2024-05-30 17:32:49', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394462914186158080, 0, '2024-05-30 17:35:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394464626015838208, 0, '2024-05-30 17:37:38', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394465344533667840, 0, '2024-05-30 17:38:21', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394465640181768192, 0, '2024-05-30 17:38:39', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394466580628611072, 0, '2024-05-30 17:39:35', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (81, 3394467131072290816, 0, '2024-05-30 17:40:08', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3394468187080597504, 0, '2024-05-30 17:41:11', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3394469321371394048, 0, '2024-05-30 17:42:18', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3394471322222174208, 0, '2024-05-30 17:44:17', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3394471898234331136, 0, '2024-05-30 17:44:52', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3394472582593748992, 0, '2024-05-30 17:45:33', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3394473356308619264, 0, '2024-05-30 17:46:19', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (61, 3394581811799367680, 0, '2024-05-30 19:34:03', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (61, 3394591657777012736, 0, '2024-05-30 19:43:50', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (61, 3394595959572635648, 0, '2024-05-30 19:48:06', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (61, 3394596909565714432, 0, '2024-05-30 19:49:03', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (61, 3394598200790589440, 0, '2024-05-30 19:50:20', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (60, 3394599983319457792, 0, '2024-05-30 19:52:06', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (59, 3394600417077600256, 0, '2024-05-30 19:52:32', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (59, 3394601511925161984, 0, '2024-05-30 19:53:37', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (59, 3394602480037634048, 0, '2024-05-30 19:54:35', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (59, 3394603493901574144, 0, '2024-05-30 19:55:36', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (59, 3394604443139678208, 0, '2024-05-30 19:56:32', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (58, 3394617607130554368, 0, '2024-05-30 20:09:37', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (58, 3394619913578323968, 0, '2024-05-30 20:11:54', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (58, 3394621054814887936, 0, '2024-05-30 20:13:02', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (58, 3394622465829085184, 0, '2024-05-30 20:14:26', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (58, 3394623766096879616, 0, '2024-05-30 20:15:44', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (58, 3394624607155494912, 0, '2024-05-30 20:16:34', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (57, 3394626738499461120, 0, '2024-05-30 20:18:41', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (57, 3394627996287344640, 0, '2024-05-30 20:19:56', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (57, 3394629068317892608, 0, '2024-05-30 20:21:00', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (57, 3394630047167782912, 0, '2024-05-30 20:21:58', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (57, 3394630878428504064, 0, '2024-05-30 20:22:48', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (56, 3394633357715152896, 0, '2024-05-30 20:25:16', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (56, 3394634358207651840, 0, '2024-05-30 20:26:15', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (56, 3394635555463340032, 0, '2024-05-30 20:27:27', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (56, 3394636469536399360, 0, '2024-05-30 20:28:21', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (56, 3394638026864697344, 0, '2024-05-30 20:29:54', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (64, 3394639970287067136, 0, '2024-05-30 20:31:50', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (64, 3394644813449895936, 0, '2024-05-30 20:36:38', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (64, 3394646045535084544, 0, '2024-05-30 20:37:52', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (64, 3394649525045796864, 0, '2024-05-30 20:41:19', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (64, 3394650354343583744, 0, '2024-05-30 20:42:09', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394652781822189568, 0, '2024-05-30 20:44:33', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394654250583564288, 0, '2024-05-30 20:46:01', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394655469179871232, 0, '2024-05-30 20:47:13', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394656728746139648, 0, '2024-05-30 20:48:29', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394657599970189312, 0, '2024-05-30 20:49:20', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394652317680508928, 0, '2024-05-30 20:50:40', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (63, 3394659339415166976, 0, '2024-05-30 20:51:04', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (62, 3394660248304066560, 0, '2024-05-30 20:51:58', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (62, 3394661243931172864, 0, '2024-05-30 20:52:58', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (62, 3394662842950852608, 0, '2024-05-30 20:54:33', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (62, 3394663688639979520, 0, '2024-05-30 20:55:23', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (62, 3394665003352956928, 0, '2024-05-30 20:56:42', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394667072570892288, 0, '2024-05-30 20:58:45', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394668330459439104, 0, '2024-05-30 21:00:00', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394669957866168320, 0, '2024-05-30 21:01:37', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394671011894763520, 0, '2024-05-30 21:02:40', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394672269279993856, 0, '2024-05-30 21:03:55', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394674064408551424, 0, '2024-05-30 21:05:42', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3394675109712994304, 0, '2024-05-30 21:06:44', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (66, 3394676535289815040, 0, '2024-05-30 21:08:09', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (66, 3394677992089034752, 0, '2024-05-30 21:09:36', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (66, 3394679843958136832, 0, '2024-05-30 21:11:26', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (66, 3394681170549383168, 0, '2024-05-30 21:12:45', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (66, 3394682088028217344, 0, '2024-05-30 21:13:40', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (66, 3394697974004948992, 0, '2024-05-30 21:29:27', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (65, 3394700114391834624, 0, '2024-05-30 21:31:35', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (65, 3394701312150839296, 0, '2024-05-30 21:32:46', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (65, 3394702083634339840, 0, '2024-05-30 21:33:32', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (65, 3394703399991484416, 0, '2024-05-30 21:34:50', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (65, 3394704230279127040, 0, '2024-05-30 21:35:40', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (114, 3396937573527822336, 0, '2024-06-01 10:34:18', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (114, 3396939189408604160, 0, '2024-06-01 10:35:54', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (114, 3396940660082581504, 0, '2024-06-01 10:37:21', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (114, 3396952959979724800, 0, '2024-06-01 10:49:35', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (114, 3396953908244750336, 0, '2024-06-01 10:50:31', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (113, 3396957732426588160, 0, '2024-06-01 10:54:19', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (113, 3396959541614452736, 0, '2024-06-01 10:56:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (113, 3396961076259954688, 0, '2024-06-01 10:57:38', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (113, 3396963330127929344, 0, '2024-06-01 10:59:53', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (113, 3396964604256821248, 0, '2024-06-01 11:01:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (112, 3396966741523144704, 0, '2024-06-01 11:03:16', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (112, 3396968751198740480, 0, '2024-06-01 11:05:16', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (112, 3396970750371799040, 0, '2024-06-01 11:07:15', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (112, 3396972121137455104, 0, '2024-06-01 11:08:37', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (112, 3396975332481146880, 0, '2024-06-01 11:11:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (112, 3396977092327219200, 0, '2024-06-01 11:13:33', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (111, 3396979356613844992, 0, '2024-06-01 11:15:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (111, 3396981943996096512, 0, '2024-06-01 11:18:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (111, 3396983019432419328, 0, '2024-06-01 11:19:26', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (111, 3396984083040804864, 0, '2024-06-01 11:20:30', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (111, 3396984660244144128, 0, '2024-06-01 11:21:04', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3396988235468873728, 0, '2024-06-01 11:24:37', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3396989740620029952, 0, '2024-06-01 11:26:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3396990951633035264, 0, '2024-06-01 11:27:19', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3396992142932811776, 0, '2024-06-01 11:28:30', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3396993769953665024, 0, '2024-06-01 11:30:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3396995074633867264, 0, '2024-06-01 11:31:25', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (109, 3396998534213246976, 0, '2024-06-01 11:34:51', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (109, 3397000853042601984, 0, '2024-06-01 11:37:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (109, 3397002116819951616, 0, '2024-06-01 11:38:25', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (109, 3397003888812728320, 0, '2024-06-01 11:40:10', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (125, 3397009498560110592, 0, '2024-06-01 11:45:45', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (109, 3397010568208293888, 0, '2024-06-01 11:46:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (109, 3397012455695425536, 0, '2024-06-01 11:48:41', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (125, 3397013077828149248, 0, '2024-06-01 11:49:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (109, 3397013280731799552, 0, '2024-06-01 11:49:30', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (125, 3397015772249038848, 0, '2024-06-01 11:51:58', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (108, 3397016257714561024, 0, '2024-06-01 11:52:27', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (125, 3397017948891488256, 0, '2024-06-01 11:54:08', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (108, 3397018560790110208, 0, '2024-06-01 11:54:45', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (108, 3397022498402705408, 0, '2024-06-01 11:58:39', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (108, 3397023435846426624, 0, '2024-06-01 11:59:35', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (108, 3397027261890535424, 0, '2024-06-01 12:03:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (126, 3397041594062184448, 0, '2024-06-01 12:17:38', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (126, 3397043121292156928, 0, '2024-06-01 12:19:09', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (126, 3397044261203320832, 0, '2024-06-01 12:20:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (126, 3397045276392660992, 0, '2024-06-01 12:21:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (108, 3397151804550389760, 0, '2024-06-01 14:07:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (107, 3397152981673418752, 0, '2024-06-01 14:08:17', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (107, 3397154671474614272, 0, '2024-06-01 14:09:58', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (107, 3397155798869975040, 0, '2024-06-01 14:11:05', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (107, 3397156646169714688, 0, '2024-06-01 14:11:55', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (107, 3397157426679357440, 0, '2024-06-01 14:12:42', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (106, 3397160504040202240, 0, '2024-06-01 14:15:45', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (106, 3397162102153912320, 0, '2024-06-01 14:17:20', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (106, 3397162199377879040, 0, '2024-06-01 14:17:26', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (106, 3397165974771572736, 0, '2024-06-01 14:21:11', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (106, 3397167665411629056, 0, '2024-06-01 14:22:52', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (106, 3397169090099257344, 0, '2024-06-01 14:24:17', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (105, 3397172745921732608, 0, '2024-06-01 14:27:55', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (105, 3397174805274664960, 0, '2024-06-01 14:29:58', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (105, 3397176209812856832, 0, '2024-06-01 14:31:21', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (105, 3397177255570284544, 0, '2024-06-01 14:32:24', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (105, 3397177594386161664, 0, '2024-06-01 14:32:44', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (105, 3397178482538422272, 0, '2024-06-01 14:33:37', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (104, 3397181569596497920, 0, '2024-06-01 14:36:41', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (104, 3397183161938845696, 0, '2024-06-01 14:38:16', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (104, 3397185327105679360, 0, '2024-06-01 14:40:25', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (104, 3397186396233768960, 0, '2024-06-01 14:41:28', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (104, 3397187131310710784, 0, '2024-06-01 14:42:12', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (103, 3397189230643748864, 0, '2024-06-01 14:44:17', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (103, 3397192223782969344, 0, '2024-06-01 14:47:16', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (103, 3397193380337131520, 0, '2024-06-01 14:48:27', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (103, 3397193419344158720, 0, '2024-06-01 14:48:27', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (103, 3397194111018442752, 0, '2024-06-01 14:49:08', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (103, 3397195987902373888, 0, '2024-06-01 14:51:00', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (102, 3397198342500753408, 0, '2024-06-01 14:53:21', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (102, 3397200992965337088, 0, '2024-06-01 14:55:59', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (102, 3397201768760582144, 0, '2024-06-01 14:56:45', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (102, 3397203204705722368, 0, '2024-06-01 14:58:10', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (102, 3397203881314066432, 0, '2024-06-01 14:58:51', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (128, 3397207566916100096, 0, '2024-06-01 15:02:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (101, 3397208039060512768, 0, '2024-06-01 15:02:58', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (128, 3397209240074297344, 0, '2024-06-01 15:04:10', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (101, 3397209454738776064, 0, '2024-06-01 15:04:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (128, 3397209939650650112, 0, '2024-06-01 15:04:52', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (101, 3397210527088091136, 0, '2024-06-01 15:05:27', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (101, 3397210527071313920, 0, '2024-06-01 15:05:27', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (128, 3397211592709742592, 0, '2024-06-01 15:06:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (101, 3397212315891638272, 0, '2024-06-01 15:07:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (101, 3397213173341593600, 0, '2024-06-01 15:08:05', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (100, 3397215227678138368, 1, '2024-06-01 15:10:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (100, 3397219875604504576, 0, '2024-06-01 15:14:44', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (100, 3397221232277299200, 0, '2024-06-01 15:16:05', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (100, 3397222141048758272, 0, '2024-06-01 15:16:59', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (99, 3397225754827530240, 0, '2024-06-01 15:20:34', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (99, 3397226702337581056, 0, '2024-06-01 15:21:31', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (129, 3397227691874557952, 0, '2024-06-01 15:22:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (99, 3397227802637737984, 0, '2024-06-01 15:22:36', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (99, 3397228538318659584, 0, '2024-06-01 15:23:20', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (129, 3397228974291394560, 0, '2024-06-01 15:23:46', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (99, 3397229163790049280, 0, '2024-06-01 15:23:58', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (129, 3397229499904794624, 0, '2024-06-01 15:24:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (129, 3397230148813955072, 0, '2024-06-01 15:24:56', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (98, 3397231540786012160, 0, '2024-06-01 15:26:19', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (98, 3397231857808285696, 0, '2024-06-01 15:26:38', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (98, 3397232592667123712, 0, '2024-06-01 15:27:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (98, 3397234057670402048, 0, '2024-06-01 15:28:49', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (98, 3397234937568272384, 0, '2024-06-01 15:29:42', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (130, 3397236900066336768, 0, '2024-06-01 15:31:39', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (130, 3397237855545565184, 0, '2024-06-01 15:32:36', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (130, 3397238452361469952, 0, '2024-06-01 15:33:11', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (130, 3397239235337363456, 0, '2024-06-01 15:33:58', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (98, 3397240715775680512, 0, '2024-06-01 15:35:26', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (97, 3397241660551045120, 0, '2024-06-01 15:36:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (97, 3397243400247681024, 0, '2024-06-01 15:38:06', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (97, 3397244766584152064, 0, '2024-06-01 15:39:28', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (97, 3397245461513216000, 0, '2024-06-01 15:40:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (97, 3397246589596442624, 0, '2024-06-01 15:41:16', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (95, 3397247853742891008, 0, '2024-06-01 15:42:32', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (95, 3397248854839369728, 0, '2024-06-01 15:43:31', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (95, 3397249991965515776, 0, '2024-06-01 15:44:39', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (131, 3397250798949605376, 0, '2024-06-01 15:45:27', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (95, 3397250830406885376, 0, '2024-06-01 15:45:29', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (95, 3397251511729627136, 0, '2024-06-01 15:46:10', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (131, 3397252383104671744, 0, '2024-06-01 15:47:02', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (96, 3397252579515539456, 0, '2024-06-01 15:47:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (96, 3397253538366988288, 0, '2024-06-01 15:48:10', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (131, 3397253693791117312, 0, '2024-06-01 15:48:20', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (131, 3397254413718233088, 0, '2024-06-01 15:49:03', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (96, 3397254702168907776, 0, '2024-06-01 15:49:20', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (96, 3397255411845144576, 0, '2024-06-01 15:50:02', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (96, 3397256041192071168, 0, '2024-06-01 15:50:40', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (96, 3397256747361869824, 0, '2024-06-01 15:51:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (94, 3397257771795456000, 0, '2024-06-01 15:52:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (94, 3397259058373042176, 0, '2024-06-01 15:53:39', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (94, 3397259781840150528, 0, '2024-06-01 15:54:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (94, 3397260761579233280, 0, '2024-06-01 15:55:21', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (94, 3397261447918362624, 0, '2024-06-01 15:56:02', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (94, 3397262249768624128, 0, '2024-06-01 15:56:50', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (132, 3397270976756293632, 0, '2024-06-01 16:05:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (132, 3397271776744284160, 0, '2024-06-01 16:06:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (132, 3397273331304341504, 0, '2024-06-01 16:07:50', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (132, 3397274164007903232, 0, '2024-06-01 16:08:40', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (133, 3397277823689138176, 0, '2024-06-01 16:12:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (133, 3397278783882764288, 0, '2024-06-01 16:13:15', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (133, 3397279318471974912, 0, '2024-06-01 16:13:47', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (133, 3397280174915297280, 0, '2024-06-01 16:14:38', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (134, 3397316276011245568, 0, '2024-06-01 16:50:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (134, 3397317707493646336, 0, '2024-06-01 16:51:55', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (134, 3397318785647878144, 0, '2024-06-01 16:53:00', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (134, 3397320081285160960, 0, '2024-06-01 16:54:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (135, 3397323407301124096, 0, '2024-06-01 16:57:35', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (135, 3397324212053843968, 0, '2024-06-01 16:58:23', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (135, 3397324793350823936, 0, '2024-06-01 16:58:58', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (136, 3397331700362878976, 0, '2024-06-01 17:05:49', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (136, 3397332607590834176, 0, '2024-06-01 17:06:43', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (136, 3397333305455910912, 0, '2024-06-01 17:07:25', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397335255371063296, 0, '2024-06-01 17:09:21', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397336013365682176, 0, '2024-06-01 17:10:06', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (137, 3397336366442192896, 0, '2024-06-01 17:10:27', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (137, 3397337091117260800, 0, '2024-06-01 17:11:11', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397337767742382080, 0, '2024-06-01 17:11:51', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (137, 3397338156051046400, 0, '2024-06-01 17:12:14', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397339850314981376, 0, '2024-06-01 17:13:55', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397340845874978816, 0, '2024-06-01 17:14:54', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397341840981991424, 0, '2024-06-01 17:15:54', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397343991686864896, 0, '2024-06-01 17:18:02', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397345305560981504, 0, '2024-06-01 17:19:20', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397348373644025856, 0, '2024-06-01 17:22:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397349436396773376, 0, '2024-06-01 17:23:26', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397350230026199040, 0, '2024-06-01 17:24:14', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397351290497245184, 0, '2024-06-01 17:25:17', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (138, 3397351707411062784, 0, '2024-06-01 17:25:42', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397352237420093440, 0, '2024-06-01 17:26:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397352694498566144, 0, '2024-06-01 17:26:41', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (138, 3397352710420144128, 0, '2024-06-01 17:26:42', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397353520810008576, 0, '2024-06-01 17:27:30', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397353826994200576, 0, '2024-06-01 17:27:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (138, 3397354146398838784, 0, '2024-06-01 17:28:07', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397354827453145088, 0, '2024-06-01 17:28:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397355550064615424, 0, '2024-06-01 17:29:31', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (122, 3397356197128282112, 0, '2024-06-01 17:30:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (139, 3397356937053839360, 0, '2024-06-01 17:30:54', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397357035083112448, 0, '2024-06-01 17:30:59', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (139, 3397357403779211264, 0, '2024-06-01 17:31:21', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (139, 3397358169927557120, 0, '2024-06-01 17:32:07', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397358221433610240, 0, '2024-06-01 17:32:10', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397359363626475520, 0, '2024-06-01 17:33:18', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397360202571161600, 0, '2024-06-01 17:34:08', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (140, 3397361087250538496, 0, '2024-06-01 17:35:01', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (140, 3397361574930653184, 0, '2024-06-01 17:35:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (140, 3397362255347425280, 0, '2024-06-01 17:36:10', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (141, 3397365282460508160, 0, '2024-06-01 17:39:11', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (141, 3397365603458981888, 0, '2024-06-01 17:39:30', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397366192037273600, 0, '2024-06-01 17:40:05', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (141, 3397366430978383872, 0, '2024-06-01 17:40:19', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397366766807916544, 0, '2024-06-01 17:40:39', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397370996696391680, 0, '2024-06-01 17:44:52', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (121, 3397371964003557376, 0, '2024-06-01 17:45:49', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (120, 3397373087489826816, 0, '2024-06-01 17:46:56', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (124, 3397377492113006592, 0, '2024-06-01 17:51:19', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (120, 3397381345956962304, 0, '2024-06-01 17:55:08', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (120, 3397383333620850688, 0, '2024-06-01 17:57:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (120, 3397384356393492480, 0, '2024-06-01 17:58:08', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (120, 3397385036055289856, 0, '2024-06-01 17:58:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (119, 3397386817812406272, 0, '2024-06-01 18:00:35', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (119, 3397397341203701760, 0, '2024-06-01 18:11:02', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (119, 3397398418451963904, 0, '2024-06-01 18:12:06', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (119, 3397399733785698304, 0, '2024-06-01 18:13:24', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (119, 3397400475422531584, 0, '2024-06-01 18:14:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (119, 3397401282205294592, 0, '2024-06-01 18:14:57', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397402906323689472, 0, '2024-06-01 18:16:33', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397404572989104128, 0, '2024-06-01 18:18:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397405551872548864, 0, '2024-06-01 18:19:11', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397406444235890688, 0, '2024-06-01 18:20:04', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397408529375404032, 0, '2024-06-01 18:22:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397409380567457792, 0, '2024-06-01 18:22:59', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (118, 3397410420805181440, 0, '2024-06-01 18:24:01', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (117, 3397412945524531200, 0, '2024-06-01 18:26:32', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (117, 3397414060789964800, 0, '2024-06-01 18:27:38', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (143, 3397414793048334336, 0, '2024-06-01 18:28:22', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (117, 3397415061383127040, 0, '2024-06-01 18:28:38', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (143, 3397415227007803392, 0, '2024-06-01 18:28:48', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (117, 3397415648686350336, 0, '2024-06-01 18:29:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (143, 3397416745496846336, 0, '2024-06-01 18:30:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (117, 3397416849633026048, 0, '2024-06-01 18:30:25', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (116, 3397418475311702016, 0, '2024-06-01 18:32:01', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (116, 3397420900324057088, 0, '2024-06-01 18:34:26', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (116, 3397422216026890240, 0, '2024-06-01 18:35:44', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (116, 3397422854097969152, 0, '2024-06-01 18:36:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (116, 3397423703545192448, 0, '2024-06-01 18:37:13', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (115, 3397425005339713536, 0, '2024-06-01 18:38:31', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (115, 3397427318246711296, 0, '2024-06-01 18:40:49', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (115, 3397428011430944768, 0, '2024-06-01 18:41:30', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (115, 3397428907753709568, 0, '2024-06-01 18:42:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (115, 3397429560337080320, 0, '2024-06-01 18:43:02', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397432806006956032, 0, '2024-06-01 18:46:16', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397433696726130688, 0, '2024-06-01 18:47:09', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397434420210016256, 0, '2024-06-01 18:47:52', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397435900916768768, 0, '2024-06-01 18:49:20', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397436273438072832, 0, '2024-06-01 18:49:42', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397438620872581120, 0, '2024-06-01 18:52:02', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397440549749104640, 0, '2024-06-01 18:53:57', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (123, 3397441429294653440, 0, '2024-06-01 18:54:50', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (98, 3401533517216980992, 0, '2024-06-04 14:39:57', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (100, 3401765481974964224, 0, '2024-06-04 18:30:23', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (55, 3403128479696134144, 0, '2024-06-05 17:04:24', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (55, 3403128651377385472, 0, '2024-06-05 17:04:34', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (100, 3405672694156546048, 0, '2024-06-07 11:11:51', 3267303552673759232);
INSERT INTO `sub_system_pipeline` VALUES (100, 3405870452553469952, 0, '2024-06-07 14:28:19', 1);
INSERT INTO `sub_system_pipeline` VALUES (145, 3411679577233346560, 0, '2024-06-11 14:39:09', 1);
INSERT INTO `sub_system_pipeline` VALUES (149, 3412808020532580352, 0, '2024-06-12 09:20:10', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3412824712906199040, 0, '2024-06-12 10:55:39', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3412918034089824256, 0, '2024-06-12 11:09:27', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3412922848546836480, 0, '2024-06-12 11:14:14', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (14, 3412923844408823808, 0, '2024-06-12 11:15:13', 1);
INSERT INTO `sub_system_pipeline` VALUES (14, 3412928684333649920, 0, '2024-06-12 11:20:02', 1);
INSERT INTO `sub_system_pipeline` VALUES (32, 3412930593094291456, 0, '2024-06-12 11:21:56', 1);
INSERT INTO `sub_system_pipeline` VALUES (155, 3412941329874997248, 0, '2024-06-12 11:32:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413099144472088576, 0, '2024-06-12 14:09:22', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413140635450003456, 0, '2024-06-12 14:50:35', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413147073572425728, 0, '2024-06-12 14:56:59', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413149013136035840, 0, '2024-06-12 14:58:55', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413150366554050560, 0, '2024-06-12 15:00:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413151716918611968, 0, '2024-06-12 15:01:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413152768984272896, 0, '2024-06-12 15:02:38', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413154290208002048, 0, '2024-06-12 15:04:09', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413155531705208832, 0, '2024-06-12 15:05:23', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413156644051406848, 0, '2024-06-12 15:06:29', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413157798340644864, 0, '2024-06-12 15:07:38', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (155, 3413159592831668224, 0, '2024-06-12 15:09:25', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3415715929096638464, 0, '2024-06-14 09:28:55', 1);
INSERT INTO `sub_system_pipeline` VALUES (158, 3416009469609562112, 0, '2024-06-14 14:20:31', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3416064862540976128, 0, '2024-06-14 15:15:33', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3416066579118608384, 0, '2024-06-14 15:17:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3416070971024658432, 0, '2024-06-14 15:21:37', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3416071614565109760, 0, '2024-06-14 15:22:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3416096368911110144, 0, '2024-06-14 15:46:51', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3416101400045867008, 0, '2024-06-14 15:51:51', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3416104882777804800, 0, '2024-06-14 15:55:18', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3416125264561885184, 0, '2024-06-14 16:15:33', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3416128229012066304, 0, '2024-06-14 16:18:30', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3416133548664606720, 0, '2024-06-14 16:23:47', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3416137418883125248, 0, '2024-06-14 16:27:37', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3416139859951276032, 0, '2024-06-14 16:30:03', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3416153098936307712, 0, '2024-06-14 16:43:12', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3416155263750819840, 0, '2024-06-14 16:45:21', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3416159638141456384, 0, '2024-06-14 16:49:42', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3416163261080588288, 0, '2024-06-14 16:53:18', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3416173009314172928, 0, '2024-06-14 17:02:59', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3416176050318790656, 0, '2024-06-14 17:06:00', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3416184876912791552, 0, '2024-06-14 17:14:46', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3416187341250940928, 0, '2024-06-14 17:17:13', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3416193665288294400, 0, '2024-06-14 17:23:30', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3418921767277875200, 0, '2024-06-16 14:33:38', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3418922890797699072, 0, '2024-06-16 14:34:45', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3418924016783773696, 0, '2024-06-16 14:35:52', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3418924712937574400, 0, '2024-06-16 14:36:33', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3418925525273595904, 0, '2024-06-16 14:37:22', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3418927456415043584, 0, '2024-06-16 14:39:17', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3418928137586790400, 0, '2024-06-16 14:39:57', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3418928843957915648, 0, '2024-06-16 14:40:39', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3418929473288065024, 0, '2024-06-16 14:41:17', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3418930707403296768, 0, '2024-06-16 14:42:30', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3418932275720671232, 0, '2024-06-16 14:44:04', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418933272991944704, 0, '2024-06-16 14:45:03', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418933888430559232, 0, '2024-06-16 14:45:40', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418934491386925056, 0, '2024-06-16 14:46:16', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418935096792764416, 0, '2024-06-16 14:46:52', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418935314846240768, 0, '2024-06-16 14:47:05', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418936265258749952, 0, '2024-06-16 14:48:02', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3418936935625969664, 0, '2024-06-16 14:48:42', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418937808695513088, 0, '2024-06-16 14:49:34', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418938506577367040, 0, '2024-06-16 14:50:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418938989962514432, 0, '2024-06-16 14:50:44', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418939971127660544, 0, '2024-06-16 14:51:43', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418940690920558592, 0, '2024-06-16 14:52:25', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418941516527357952, 0, '2024-06-16 14:53:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3418941984863342592, 0, '2024-06-16 14:53:43', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3418942578810343424, 0, '2024-06-16 14:54:18', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3418944643330658304, 0, '2024-06-16 14:56:21', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3418946016596119552, 0, '2024-06-16 14:57:43', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3418948012799610880, 0, '2024-06-16 14:59:42', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3418948719992819712, 0, '2024-06-16 15:00:24', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3415695595328950272, 0, '2024-06-16 15:01:14', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3418949754140413952, 0, '2024-06-16 15:01:26', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3418950581542375424, 0, '2024-06-16 15:02:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3418951209815560192, 0, '2024-06-16 15:02:52', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3418953007192264704, 0, '2024-06-16 15:04:40', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3418953759197417472, 0, '2024-06-16 15:05:24', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3418954360811606016, 0, '2024-06-16 15:06:00', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3418955520050122752, 0, '2024-06-16 15:07:09', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3418957249042894848, 0, '2024-06-16 15:08:52', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3418958117750362112, 0, '2024-06-16 15:09:44', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3418958675928338432, 0, '2024-06-16 15:10:17', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418970672694743040, 0, '2024-06-16 15:22:13', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418977435238191104, 0, '2024-06-16 15:28:56', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418979262042132480, 0, '2024-06-16 15:30:45', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418980036847521792, 0, '2024-06-16 15:31:31', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418980891160137728, 0, '2024-06-16 15:32:22', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418982517577011200, 0, '2024-06-16 15:33:59', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418984129699696640, 0, '2024-06-16 15:35:35', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418986032437317632, 0, '2024-06-16 15:37:28', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418986642037460992, 0, '2024-06-16 15:38:04', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418987376476868608, 0, '2024-06-16 15:38:48', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418987938211614720, 0, '2024-06-16 15:39:22', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418990526650830848, 0, '2024-06-16 15:41:56', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418991037517058048, 0, '2024-06-16 15:42:26', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418991804806254592, 0, '2024-06-16 15:43:12', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418992800433360896, 0, '2024-06-16 15:44:11', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418994294410891264, 0, '2024-06-16 15:45:40', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418995223029796864, 0, '2024-06-16 15:46:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418996007297536000, 0, '2024-06-16 15:47:23', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418996811983147008, 0, '2024-06-16 15:48:11', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418997636281323520, 0, '2024-06-16 15:49:00', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418998787869429760, 0, '2024-06-16 15:50:08', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3418999810289750016, 0, '2024-06-16 15:51:09', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419000390932418560, 0, '2024-06-16 15:51:44', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419001102873579520, 0, '2024-06-16 15:52:26', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419001806510018560, 0, '2024-06-16 15:53:08', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419002467951759360, 0, '2024-06-16 15:53:48', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419003831838756864, 0, '2024-06-16 15:55:09', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419004532639846400, 0, '2024-06-16 15:55:51', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419004922391351296, 0, '2024-06-16 15:56:14', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419005398545518592, 0, '2024-06-16 15:56:42', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419006144460541952, 0, '2024-06-16 15:57:27', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419006753054052352, 0, '2024-06-16 15:58:03', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419007882127134720, 0, '2024-06-16 15:59:10', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419008610140868608, 0, '2024-06-16 15:59:54', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419009315236925440, 0, '2024-06-16 16:00:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419010795943677952, 0, '2024-06-16 16:02:04', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419011498489597952, 0, '2024-06-16 16:02:46', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419011992796712960, 0, '2024-06-16 16:03:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419017154407878656, 0, '2024-06-16 16:08:23', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419017784593666048, 0, '2024-06-16 16:09:01', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419018463919919104, 0, '2024-06-16 16:09:41', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419019524592291840, 0, '2024-06-16 16:10:44', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419020183987212288, 0, '2024-06-16 16:11:24', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419020717536235520, 0, '2024-06-16 16:11:55', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419021629243707392, 0, '2024-06-16 16:12:50', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419022192857501696, 0, '2024-06-16 16:13:23', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419023070406561792, 0, '2024-06-16 16:14:16', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419023971896709120, 0, '2024-06-16 16:15:09', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419025179101286400, 0, '2024-06-16 16:16:21', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419025869886377984, 0, '2024-06-16 16:17:03', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419026620012482560, 0, '2024-06-16 16:17:47', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419027437264228352, 0, '2024-06-16 16:18:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419028210073128960, 0, '2024-06-16 16:19:22', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419028698424332288, 0, '2024-06-16 16:19:51', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419029101178179584, 0, '2024-06-16 16:20:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419029590838005760, 0, '2024-06-16 16:20:44', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419030399097163776, 0, '2024-06-16 16:21:33', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419031002456182784, 0, '2024-06-16 16:22:08', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419031700019269632, 0, '2024-06-16 16:22:50', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (149, 3419032251167592448, 0, '2024-06-16 16:23:23', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (175, 3419081995613032448, 0, '2024-06-16 17:12:48', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (190, 3420501532552122368, 0, '2024-06-17 16:42:59', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (190, 3420503973687382016, 0, '2024-06-17 16:45:24', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (190, 3420505245853339648, 0, '2024-06-17 16:46:40', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (190, 3420506345566294016, 0, '2024-06-17 16:47:46', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (190, 3420507980824760320, 0, '2024-06-17 16:49:23', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (18, 3421840198948016128, 0, '2024-06-18 14:52:50', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (18, 3421841263143604224, 0, '2024-06-18 14:53:53', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (18, 3421847470696747008, 0, '2024-06-18 15:00:03', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (182, 3423066976815337472, 0, '2024-06-19 11:11:31', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (182, 3423069065931051008, 0, '2024-06-19 11:13:36', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (182, 3423069707475013632, 0, '2024-06-19 11:14:14', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (182, 3423070573816893440, 0, '2024-06-19 11:15:06', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (182, 3423071269618372608, 0, '2024-06-19 11:15:47', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (33, 3423072767370776576, 0, '2024-06-19 11:17:16', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (183, 3423073735432916992, 0, '2024-06-19 11:18:14', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (183, 3423075465734311936, 0, '2024-06-19 11:19:57', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (183, 3423076217840128000, 0, '2024-06-19 11:20:42', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (183, 3423077180533559296, 0, '2024-06-19 11:21:39', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424707966814834688, 0, '2024-06-20 14:21:42', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (185, 3424799474633068544, 0, '2024-06-20 15:52:36', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (185, 3424801225184563200, 0, '2024-06-20 15:54:21', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (185, 3424802149189734400, 0, '2024-06-20 15:55:16', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (185, 3424802960233910272, 0, '2024-06-20 15:56:04', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (185, 3424803809781796864, 0, '2024-06-20 15:56:55', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (185, 3424804588076847104, 0, '2024-06-20 15:57:41', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424805707737911296, 0, '2024-06-20 15:58:48', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424806099704008704, 0, '2024-06-20 15:59:11', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424806743999434752, 0, '2024-06-20 15:59:49', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424809203153424384, 0, '2024-06-20 16:02:16', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424810000373174272, 0, '2024-06-20 16:03:04', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (184, 3424811879924682752, 0, '2024-06-20 16:04:56', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (191, 3424813902837501952, 0, '2024-06-20 16:06:56', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (191, 3424814128524611584, 0, '2024-06-20 16:07:10', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (191, 3424814970019434496, 0, '2024-06-20 16:08:00', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (191, 3424815918519341056, 0, '2024-06-20 16:08:56', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (191, 3424816505805787136, 0, '2024-06-20 16:09:31', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (191, 3424817507556577280, 0, '2024-06-20 16:10:31', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (177, 3424823796227559424, 0, '2024-06-20 16:16:46', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (177, 3424828179040358400, 0, '2024-06-20 16:21:07', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (177, 3424829060498509824, 0, '2024-06-20 16:22:00', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (177, 3424830088975405056, 0, '2024-06-20 16:23:01', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (177, 3424830876095270912, 0, '2024-06-20 16:23:48', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (128, 3424832393560903680, 0, '2024-06-20 16:25:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (128, 3424833255742033920, 0, '2024-06-20 16:26:10', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (128, 3424834002110042112, 0, '2024-06-20 16:26:54', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (193, 3424854783544184832, 0, '2024-06-20 16:47:34', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (193, 3425963494589255680, 0, '2024-06-21 11:08:57', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (176, 3425965203734581248, 0, '2024-06-21 11:10:39', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (176, 3425966325257916416, 0, '2024-06-21 11:11:46', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (176, 3425967401432436736, 0, '2024-06-21 11:12:50', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (176, 3425968201571422208, 0, '2024-06-21 11:13:38', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (176, 3425968964750200832, 0, '2024-06-21 11:14:23', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (181, 3425972893923856384, 0, '2024-06-21 11:18:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (181, 3425973902234537984, 0, '2024-06-21 11:19:18', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (181, 3425974942606479360, 0, '2024-06-21 11:20:20', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (181, 3425975910165303296, 0, '2024-06-21 11:21:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (181, 3425976999040176128, 0, '2024-06-21 11:22:22', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (180, 3425978067698503680, 0, '2024-06-21 11:23:26', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (180, 3425979153368928256, 0, '2024-06-21 11:24:31', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (180, 3425979905374081024, 0, '2024-06-21 11:25:15', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (180, 3426158635455270912, 0, '2024-06-21 14:22:48', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (180, 3426158959037435904, 0, '2024-06-21 14:23:08', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (180, 3426159684702359552, 0, '2024-06-21 14:23:51', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (143, 3426161006948306944, 0, '2024-06-21 14:25:10', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (143, 3426161155980316672, 0, '2024-06-21 14:25:19', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (143, 3426161930131394560, 0, '2024-06-21 14:26:05', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (143, 3426163054406193152, 0, '2024-06-21 14:27:12', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (143, 3426163490580254720, 0, '2024-06-21 14:27:38', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (126, 3426167167156146176, 0, '2024-06-21 14:31:17', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (126, 3426167819101982720, 0, '2024-06-21 14:31:56', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (60, 3431681738197356544, 0, '2024-06-25 09:49:31', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (60, 3431684910634684416, 0, '2024-06-25 09:52:40', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (60, 3431686112940314624, 0, '2024-06-25 09:53:52', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (60, 3431687878742298624, 0, '2024-06-25 09:55:37', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (60, 3431688712939032576, 0, '2024-06-25 09:56:27', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (60, 3431689561413177344, 0, '2024-06-25 09:57:17', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (67, 3432017110567669760, 0, '2024-06-25 15:22:41', 3271115816176123904);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433148075465691136, 0, '2024-06-26 10:06:12', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433163875257864192, 0, '2024-06-26 10:21:53', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433174204553547776, 0, '2024-06-26 10:32:09', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433184946954620928, 0, '2024-06-26 10:42:49', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433206739316690944, 0, '2024-06-26 11:04:28', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433207737493934080, 0, '2024-06-26 11:05:28', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (194, 3433208396033216512, 0, '2024-06-26 11:06:07', 3371463310998532096);
INSERT INTO `sub_system_pipeline` VALUES (158, 3433220862964322304, 0, '2024-06-26 11:18:30', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (175, 3433510619342622720, 0, '2024-06-26 16:06:21', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (25, 3434512899017723904, 0, '2024-06-27 08:42:01', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (25, 3434545809775054848, 0, '2024-06-27 09:14:43', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (182, 3434884152517906432, 0, '2024-06-27 14:50:50', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (182, 3434885211227344896, 0, '2024-06-27 14:51:53', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (182, 3423072655215087616, 0, '2024-06-27 14:52:38', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (158, 3434940087084961792, 0, '2024-06-27 15:46:24', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3434961114573754368, 0, '2024-06-27 16:07:17', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (18, 3440337536549048320, 0, '2024-07-01 09:08:17', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (158, 3443374906919800832, 0, '2024-07-03 11:25:38', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3443376035607007232, 0, '2024-07-03 11:26:46', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (158, 3443552113378119680, 0, '2024-07-03 14:21:41', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3443647869422325760, 0, '2024-07-03 15:56:48', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3443651487781277696, 0, '2024-07-03 16:00:24', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (163, 3444726133075136512, 0, '2024-07-04 09:47:58', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3444753946394152960, 0, '2024-07-04 10:15:35', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (195, 3444785892998434816, 0, '2024-07-04 10:47:20', 3371463321836613632);
INSERT INTO `sub_system_pipeline` VALUES (153, 3444789532412792832, 0, '2024-07-04 10:50:56', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3444792920940662784, 0, '2024-07-04 10:54:18', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (153, 3444795372075143168, 0, '2024-07-04 10:56:45', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3445170950859051008, 0, '2024-07-04 17:09:51', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3445208664547446784, 0, '2024-07-04 17:47:19', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (159, 3445212298744090624, 0, '2024-07-04 17:50:55', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3445218965053427712, 0, '2024-07-04 17:57:33', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3445235396356788224, 0, '2024-07-04 18:13:52', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3446156606427025408, 0, '2024-07-05 09:29:00', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3446157207353348096, 0, '2024-07-05 09:29:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (167, 3446162230300823552, 0, '2024-07-05 09:34:36', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3446226725308125184, 0, '2024-07-05 10:38:40', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3446236935754010624, 0, '2024-07-05 10:48:49', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (156, 3446239131421822976, 0, '2024-07-05 10:51:00', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3446467418614059008, 0, '2024-07-05 14:37:46', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3446471171878604800, 0, '2024-07-05 14:41:30', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (165, 3446473652054446080, 0, '2024-07-05 14:43:58', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3446486405490069504, 0, '2024-07-05 14:56:38', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3446526308051505152, 0, '2024-07-05 15:36:17', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (164, 3446527719015370752, 0, '2024-07-05 15:37:41', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3446543525333880832, 0, '2024-07-05 15:53:23', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3446547580856750080, 0, '2024-07-05 15:57:25', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (157, 3446557476109078528, 0, '2024-07-05 16:07:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3446566202106892288, 0, '2024-07-05 16:15:54', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3446568195793801216, 0, '2024-07-05 16:17:53', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (166, 3446569433700683776, 0, '2024-07-05 16:19:07', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3446585449465958400, 0, '2024-07-05 16:35:02', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3446587215771258880, 0, '2024-07-05 16:36:47', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3450482683328778240, 0, '2024-07-08 09:06:35', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (174, 3450487814086643712, 0, '2024-07-08 09:11:41', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (51, 3450882254320095232, 0, '2024-07-08 15:43:31', 3363893784903917568);
INSERT INTO `sub_system_pipeline` VALUES (206, 3450910082151403520, 0, '2024-07-08 16:12:10', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (204, 3450994927032520704, 0, '2024-07-08 17:35:27', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (205, 3451005598767960064, 0, '2024-07-08 17:46:03', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (204, 3451924107018555392, 0, '2024-07-09 09:00:43', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (205, 3451926995686051840, 0, '2024-07-09 09:01:28', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (207, 3451927965274918912, 0, '2024-07-09 09:02:34', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (207, 3451927451841777664, 0, '2024-07-09 09:02:34', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (204, 3452004283924533248, 0, '2024-07-09 10:18:35', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (204, 3452383850786902016, 0, '2024-07-09 16:35:14', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (151, 3452407429402382336, 0, '2024-07-09 16:58:39', 3371463387435528192);
INSERT INTO `sub_system_pipeline` VALUES (35, 3452417401544691712, 0, '2024-07-09 17:08:33', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (216, 3452418759475777536, 0, '2024-07-09 17:09:54', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (209, 3453812086240411648, 0, '2024-07-10 16:17:19', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (209, 3453817576802451456, 0, '2024-07-10 16:20:38', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (208, 3453829866901700608, 0, '2024-07-10 16:34:31', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (208, 3453829271562190848, 0, '2024-07-10 16:34:31', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (210, 3453831975881637888, 0, '2024-07-10 16:34:50', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (210, 3453831409650597888, 0, '2024-07-10 16:34:50', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (151, 3455164373051342848, 0, '2024-07-11 14:37:37', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (151, 3455164006301401088, 0, '2024-07-11 14:37:37', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (152, 3455166966959931392, 0, '2024-07-11 14:42:11', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (152, 3455166656564658176, 0, '2024-07-11 14:42:11', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (206, 3450898774408482816, 0, '2024-07-11 17:59:44', 3371463333748436992);
INSERT INTO `sub_system_pipeline` VALUES (208, 3456685591646666752, 0, '2024-07-12 15:48:37', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (208, 3462584655525412864, 0, '2024-07-16 17:28:49', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (208, 3463558205862281216, 0, '2024-07-17 09:35:57', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (209, 3463871035006222336, 0, '2024-07-17 14:46:43', 3271113249245298688);
INSERT INTO `sub_system_pipeline` VALUES (12, 3463961385347547136, 0, '2024-07-17 16:16:28', 3271120617295249408);
INSERT INTO `sub_system_pipeline` VALUES (100, 3463983260958162944, 0, '2024-07-17 16:38:12', 1);
INSERT INTO `sub_system_pipeline` VALUES (226, 3492849071105736704, 0, '2024-08-06 14:33:48', 1);
INSERT INTO `sub_system_pipeline` VALUES (226, 3492884061382213632, 0, '2024-08-06 15:08:34', 1);
INSERT INTO `sub_system_pipeline` VALUES (226, 3492891454916755456, 0, '2024-08-06 15:15:54', 1);
INSERT INTO `sub_system_pipeline` VALUES (114, 3495827174417465344, 0, '2024-08-08 15:52:17', 1);
INSERT INTO `sub_system_pipeline` VALUES (115, 3505904967301955584, 0, '2024-08-15 14:44:22', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (144, 3556654143534759936, 0, '2024-09-19 14:58:27', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (226, 3556666349513048064, 0, '2024-09-19 15:10:35', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (286, 3562457170923687936, 0, '2024-09-23 15:03:14', 1);
INSERT INTO `sub_system_pipeline` VALUES (286, 3563554373838770176, 0, '2024-09-24 09:13:13', 1);
INSERT INTO `sub_system_pipeline` VALUES (97, 3563564085833568256, 0, '2024-09-24 09:22:52', 3267303552673759232);
INSERT INTO `sub_system_pipeline` VALUES (72, 3566485293075992576, 0, '2024-09-26 09:44:49', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (72, 3566493522333995008, 0, '2024-09-26 09:53:00', 3342152887245934592);
INSERT INTO `sub_system_pipeline` VALUES (82, 3566825875140972544, 0, '2024-09-26 15:23:09', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3566827158312783872, 0, '2024-09-26 15:24:26', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3566851638619738112, 0, '2024-09-26 15:48:45', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3566854030027329536, 0, '2024-09-26 15:51:08', 3371463290094120960);
INSERT INTO `sub_system_pipeline` VALUES (82, 3566859622695505920, 0, '2024-09-26 15:56:41', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (82, 3566871362854391808, 0, '2024-09-26 16:08:21', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (195, 3568270710561509376, 0, '2024-09-27 15:18:28', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (195, 3568284588255154176, 0, '2024-09-27 15:32:15', 3267296873982836736);
INSERT INTO `sub_system_pipeline` VALUES (100, 3597265151506714624, 0, '2024-10-17 15:21:52', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (300, 3605610616023355392, 0, '2024-10-23 09:32:20', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (300, 3605634689650593792, 0, '2024-10-23 09:56:15', 3371463290094120960);
INSERT INTO `sub_system_pipeline` VALUES (300, 3605635069318991872, 0, '2024-10-23 09:56:38', 3371463290094120960);
INSERT INTO `sub_system_pipeline` VALUES (303, 3607015063031058432, 0, '2024-10-24 08:47:32', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (303, 3607016496644165632, 0, '2024-10-24 08:48:57', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (303, 3607023813758488576, 0, '2024-10-24 08:56:13', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (300, 3607027488656658432, 0, '2024-10-24 08:59:52', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (305, 3612884906368241664, 0, '2024-10-28 09:58:42', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (305, 3612888872955088896, 0, '2024-10-28 10:02:38', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (306, 3612985447744212992, 0, '2024-10-28 11:38:34', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (306, 3612988107251716096, 0, '2024-10-28 11:41:13', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (305, 3613219804681539584, 0, '2024-10-28 15:31:23', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (305, 3613249779291852800, 0, '2024-10-28 16:01:10', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (300, 3613341925466378240, 0, '2024-10-28 17:32:42', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (300, 3613346398725148672, 0, '2024-10-28 17:37:09', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (300, 3613349438320480256, 0, '2024-10-28 17:40:10', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (300, 3613359102365995008, 0, '2024-10-28 17:49:46', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (303, 3617275078610456576, 0, '2024-10-31 10:39:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (303, 3617289004219830272, 0, '2024-10-31 10:53:46', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (308, 3633235933751611392, 0, '2024-11-11 10:55:37', 3371463290094120960);
INSERT INTO `sub_system_pipeline` VALUES (308, 3633247461729046528, 0, '2024-11-11 11:07:04', 3371463290094120960);
INSERT INTO `sub_system_pipeline` VALUES (308, 3633249630385541120, 0, '2024-11-11 11:09:14', 3371463290094120960);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636121692196245504, 0, '2024-11-13 10:42:22', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636157864847020032, 0, '2024-11-13 11:18:18', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636537049977393152, 0, '2024-11-13 17:34:59', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636545576863207424, 0, '2024-11-13 17:43:27', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636551066200510464, 0, '2024-11-13 17:48:55', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636551744067145728, 0, '2024-11-13 17:49:35', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636570365870936064, 0, '2024-11-13 18:08:05', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3636571058065313792, 0, '2024-11-13 18:08:46', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (310, 3637472235535667200, 0, '2024-11-14 09:04:01', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (310, 3637476230895439872, 0, '2024-11-14 09:07:59', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637570737204826112, 0, '2024-11-14 10:41:52', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (305, 3637589160668368896, 0, '2024-11-14 11:00:10', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (35, 3637599876158787584, 0, '2024-11-14 11:10:49', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (309, 3637608966457069568, 0, '2024-11-14 11:19:50', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637616808043941888, 0, '2024-11-14 11:27:38', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637618580707807232, 0, '2024-11-14 11:29:23', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637622236194738176, 0, '2024-11-14 11:33:01', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637578903011397632, 0, '2024-11-14 11:34:41', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637607285161922560, 0, '2024-11-14 11:34:41', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (311, 3637624417702580224, 0, '2024-11-14 11:35:11', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (314, 3646578685411266560, 0, '2024-11-20 15:50:27', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (314, 3646584524016652288, 0, '2024-11-20 15:56:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (315, 3656997453736120320, 0, '2024-11-27 20:20:34', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (315, 3657003832282648576, 0, '2024-11-27 20:26:54', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (316, 3657038135297249280, 0, '2024-11-27 21:00:59', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (316, 3657042576880635904, 0, '2024-11-27 21:05:24', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (323, 3657795231630430208, 0, '2024-11-28 09:33:06', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (323, 3657799277925830656, 0, '2024-11-28 09:37:07', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (332, 3678560907370369024, 0, '2024-12-12 17:21:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (332, 3678560907705913346, 0, '2024-12-12 17:21:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (332, 3678560907705913344, 0, '2024-12-12 17:21:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (332, 3678560907705913345, 0, '2024-12-12 17:21:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (332, 3678560907722690560, 0, '2024-12-12 17:21:56', 3267292550326501376);
INSERT INTO `sub_system_pipeline` VALUES (332, 3678570699979689984, 0, '2024-12-12 17:31:42', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (332, 3679522803883905024, 0, '2024-12-13 09:17:30', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (332, 3679543745288802304, 0, '2024-12-13 09:38:18', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (332, 3679547834634539009, 0, '2024-12-13 09:42:22', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (332, 3679547834634539008, 0, '2024-12-13 09:42:22', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (332, 3679555425787908096, 0, '2024-12-13 09:49:54', 3369369332493033472);
INSERT INTO `sub_system_pipeline` VALUES (94, 3696946103423057920, 0, '2024-12-25 09:46:00', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (317, 3699857017541480448, 0, '2024-12-27 09:57:43', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (317, 3699864114958159872, 0, '2024-12-27 10:04:46', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (317, 3699924998317395968, 0, '2024-12-27 11:05:15', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (317, 3699945967169818624, 0, '2024-12-27 11:26:05', 1);
INSERT INTO `sub_system_pipeline` VALUES (317, 3699947011752841216, 0, '2024-12-27 11:27:07', 1);
INSERT INTO `sub_system_pipeline` VALUES (317, 3700226875277955072, 0, '2024-12-27 16:05:09', 3271117585803313152);
INSERT INTO `sub_system_pipeline` VALUES (317, 3700302304936448000, 0, '2024-12-27 17:20:05', 1);
INSERT INTO `sub_system_pipeline` VALUES (100, 3709950592266522624, 0, '2025-01-03 09:04:48', 3267307713708539904);
INSERT INTO `sub_system_pipeline` VALUES (110, 3719083471005274112, 0, '2025-01-09 16:17:29', 3267307713708539904);

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
-- Records of sub_system_variable
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 117 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统组件表，存储系统和其他组件的关联关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_component
-- ----------------------------
INSERT INTO `system_component` VALUES (1, 1, 'GITLAB', '5', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (2, 2, 'GITLAB', '52', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (3, 3, 'GITLAB', '57', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (4, 4, 'GITLAB', '63', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (5, 5, 'GITLAB', '75', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (6, 6, 'GITLAB', '77', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (7, 7, 'GITLAB', '87', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (8, 8, 'GITLAB', '92', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (9, 9, 'GITLAB', '94', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (10, 10, 'GITLAB', '135', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (11, 11, 'GITLAB', '143', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (12, 12, 'GITLAB', '148', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (13, 13, 'GITLAB', '157', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (14, 14, 'GITLAB', '165', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (15, 15, 'GITLAB', '169', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (16, 16, 'GITLAB', '185', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (18, 18, 'GITLAB', '201', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (19, 19, 'GITLAB', '206', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (20, 20, 'GITLAB', '207', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (21, 21, 'GITLAB', '208', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (22, 22, 'GITLAB', '217', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (23, 23, 'GITLAB', '225', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (24, 24, 'GITLAB', '229', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (25, 25, 'GITLAB', '235', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (26, 26, 'GITLAB', '236', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (27, 27, 'GITLAB', '237', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (28, 28, 'GITLAB', '239', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (29, 29, 'GITLAB', '240', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (30, 30, 'GITLAB', '241', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (31, 31, 'GITLAB', '242', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (32, 32, 'GITLAB', '260', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (33, 33, 'GITLAB', '271', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (34, 34, 'GITLAB', '274', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (35, 35, 'GITLAB', '296', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (36, 36, 'GITLAB', '308', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (37, 37, 'GITLAB', '310', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (39, 39, 'GITLAB', '315', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (40, 40, 'GITLAB', '317', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (41, 41, 'GITLAB', '324', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (43, 43, 'GITLAB', '336', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (44, 44, 'GITLAB', '337', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (45, 45, 'GITLAB', '341', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (47, 47, 'GITLAB', '353', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (48, 48, 'GITLAB', '356', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (49, 49, 'GITLAB', '360', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (50, 50, 'GITLAB', '361', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (51, 51, 'GITLAB', '362', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (52, 52, 'GITLAB', '363', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (53, 53, 'GITLAB', '364', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (54, 54, 'GITLAB', '365', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (55, 55, 'GITLAB', '366', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (56, 56, 'GITLAB', '367', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (57, 57, 'GITLAB', '368', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (58, 58, 'GITLAB', '375', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (60, 60, 'GITLAB', '399', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (61, 61, 'GITLAB', '402', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (64, 64, 'GITLAB', '424', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (66, 66, 'GITLAB', '430', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (67, 67, 'GITLAB', '431', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (69, 69, 'GITLAB', '434', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (71, 71, 'GITLAB', '437', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (74, 74, 'GITLAB', '440', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (75, 75, 'GITLAB', '441', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (76, 76, 'GITLAB', '446', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (77, 77, 'GITLAB', '448', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (78, 78, 'GITLAB', '451', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (79, 79, 'GITLAB', '458', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (82, 82, 'GITLAB', '552', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (83, 83, 'GITLAB', '560', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (84, 84, 'GITLAB', '561', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (85, 85, 'GITLAB', '564', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (86, 86, 'GITLAB', '566', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (87, 87, 'GITLAB', '572', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (88, 88, 'GITLAB', '575', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (89, 89, 'GITLAB', '576', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (90, 90, 'GITLAB', '590', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (91, 91, 'GITLAB', '593', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (92, 92, 'GITLAB', '597', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (93, 93, 'GITLAB', '600', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (94, 94, 'GITLAB', '602', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (95, 95, 'GITLAB', '607', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (96, 96, 'GITLAB', '610', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (97, 97, 'GITLAB', '616', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (98, 98, 'GITLAB', '657', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (99, 99, 'GITLAB', '680', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (100, 100, 'GITLAB', '695', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (101, 101, 'GITLAB', '697', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (102, 102, 'GITLAB', '700', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (103, 103, 'GITLAB', '706', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (104, 110, 'GITLAB', '708', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (105, 111, 'GITLAB', '710', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (106, 113, 'GITLAB', '729', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (107, 114, 'GITLAB', '735', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (108, 115, 'GITLAB', '741', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (109, 116, 'GITLAB', '744', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (111, 118, 'GITLAB', '750', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (112, 119, 'GITLAB', '758', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (113, 120, 'GITLAB', '763', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (114, 121, 'GITLAB', '777', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (115, 122, 'GITLAB', '781', 'group_id', NULL, NULL, 0);
INSERT INTO `system_component` VALUES (116, 123, 'GITLAB', '887', 'group_id', NULL, NULL, 0);

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
-- Records of system_dict
-- ----------------------------
INSERT INTO `system_dict` VALUES (1, 'TEST_ENV', 'sit', 'sit', '1', NULL, 2, NULL, NULL);
INSERT INTO `system_dict` VALUES (2, 'TEST_ENV', 'uat', 'uat', '1', NULL, 3, NULL, NULL);
INSERT INTO `system_dict` VALUES (3, 'TEST_ENV', 'main', 'main', '2', NULL, 4, NULL, NULL);
INSERT INTO `system_dict` VALUES (4, 'BASE_BRANCH', 'main', 'main', '', NULL, 1, NULL, NULL);
INSERT INTO `system_dict` VALUES (8, 'DEFAULT_STRATEGY', 'strategy', '默认晋级策略', NULL, '3,4,5', 1, '{\"showFlag\": true}', NULL);
INSERT INTO `system_dict` VALUES (11, 'TEST_ENV', 'dev', 'dev', '3', NULL, 1, NULL, NULL);
INSERT INTO `system_dict` VALUES (101, 'DEVOPS_STAGE', 'dev', '开发阶段', '1', NULL, 1, NULL, NULL);
INSERT INTO `system_dict` VALUES (102, 'DEVOPS_STAGE', 'test', '测试阶段', '2', NULL, 2, NULL, NULL);
INSERT INTO `system_dict` VALUES (103, 'DEVOPS_STAGE', 'beta', '预发布阶段', '3', NULL, 3, NULL, NULL);
INSERT INTO `system_dict` VALUES (201, 'FILTER_START_PARAM', 'tag', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `system_dict` VALUES (301, 'FEATURE_STATUS', '0', '开发中', NULL, '0', 1, '{\"bg\": \"#E9EAED\", \"dotColor\": \"#D8D8D8\", \"contentBg\": \"#F2F3F7\", \"background\": \"#72D996\"}', NULL);
INSERT INTO `system_dict` VALUES (302, 'FEATURE_STATUS', '1', '开发完成', NULL, '1', 2, '{\"bg\": \"#D8ECE8\", \"dotColor\": \"#52c41a\", \"contentBg\": \"#F2F7F6\", \"background\": \"#72D996\"}', NULL);
INSERT INTO `system_dict` VALUES (303, 'FEATURE_STATUS', '2', '测试中', NULL, '2', 3, '{\"bg\": \"#F5EEE1\", \"dotColor\": \"#faad14\", \"contentBg\": \"#FAF8F5\", \"background\": \"#72D996\"}', NULL);
INSERT INTO `system_dict` VALUES (304, 'FEATURE_STATUS', '3', '已发布', NULL, '3', 5, '{\"bg\": \"#E7F1F7\", \"dotColor\": \"#1890ff\", \"contentBg\": \"#F6FBFE\", \"background\": \"#95A5B4\"}', NULL);
INSERT INTO `system_dict` VALUES (305, 'FEATURE_STATUS', '4', '测试完成', NULL, '4', 4, '{\"bg\": \"#D8ECE8\", \"dotColor\": \"#52c41a\", \"contentBg\": \"#F2F7F6\", \"background\": \"#72D996\"}', NULL);
INSERT INTO `system_dict` VALUES (306, 'FEATURE_STATUS', '5', '已清理', NULL, '5', 6, '{\"bg\": \"#E9EAED\", \"filter\": true, \"dotColor\": \"#D8D8D8\", \"contentBg\": \"#F2F3F7\", \"background\": \"#D3D3D3\"}', NULL);
INSERT INTO `system_dict` VALUES (401, 'DEFAULT_DEVOPS_STAGE', NULL, '开发阶段', NULL, NULL, 4, '{\"stageDictId\": 101, \"canRemoveFlag\": false, \"featureStatus\": [0]}', '开发阶段常用于管理自测/联调环境');
INSERT INTO `system_dict` VALUES (402, 'DEFAULT_DEVOPS_STAGE', NULL, '测试阶段', NULL, NULL, 4, '{\"stageDictId\": 102, \"canRemoveFlag\": true, \"featureStatus\": [1, 2]}', '测试阶段常用于管理集成测试环境');
INSERT INTO `system_dict` VALUES (403, 'DEFAULT_DEVOPS_STAGE', NULL, '预发布阶段', NULL, NULL, 4, '{\"stageDictId\": 103, \"canRemoveFlag\": true, \"featureStatus\": [3, 4]}', '预发阶段常用于管理回归验证环境及制品生成');
INSERT INTO `system_dict` VALUES (501, 'MAX_DEVOPS_STAGE', NULL, '最大阶段数量', NULL, '5', 0, NULL, NULL);

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
-- Records of system_file
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统项目关联关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_project
-- ----------------------------
INSERT INTO `system_project` VALUES (1, 123, 72, 1, '2024-12-23 10:22:41');

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
-- Records of test_management
-- ----------------------------

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
-- Records of test_management_env_status
-- ----------------------------

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
-- Records of version_component
-- ----------------------------
INSERT INTO `version_component` VALUES (1, 8, 1, 'FEATURE', '1', 1, '2024-03-05 17:40:59', NULL);
INSERT INTO `version_component` VALUES (2, 8, 6, 'FEATURE', '4', 3267307713708539904, '2024-04-01 14:37:55', NULL);
INSERT INTO `version_component` VALUES (3, 12, 7, 'FEATURE', '6', 3267307713708539904, '2024-04-08 16:08:14', NULL);
INSERT INTO `version_component` VALUES (4, 12, 8, 'FEATURE', '7', 1, '2024-04-11 09:33:45', NULL);
INSERT INTO `version_component` VALUES (5, 13, 9, 'FEATURE', '8', 1, '2024-04-11 09:37:30', NULL);
INSERT INTO `version_component` VALUES (6, 10, 10, 'FEATURE', '9', 1, '2024-04-11 14:11:49', NULL);
INSERT INTO `version_component` VALUES (7, 15, 11, 'FEATURE', '10', 1, '2024-04-19 16:16:10', NULL);
INSERT INTO `version_component` VALUES (8, 12, 48, 'FEATURE', '18', 1, '2024-06-12 14:16:11', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本实例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of version_instance
-- ----------------------------
INSERT INTO `version_instance` VALUES (1, '1.0.0/01', 1, 1, 8, 3269643232346185728, 3269805723743232000, 1, '2024-03-05 17:40:09');
INSERT INTO `version_instance` VALUES (2, '1.0.0/02', 2, 1, 8, 3268423816287690752, 3269807866931912704, 1, '2024-03-05 17:42:17');
INSERT INTO `version_instance` VALUES (3, '1.0.0/03', 3, 1, 8, 3269643232346185728, 3269838520834924544, 1, '2024-03-05 18:12:44');
INSERT INTO `version_instance` VALUES (4, '1.0.0/04', 4, 1, 8, 3269643232346185728, 3270875907203604480, 1, '2024-03-06 11:23:17');
INSERT INTO `version_instance` VALUES (5, '2024.4.4/01', 1, 6, 8, 3268423816287690752, 3308495874414202880, 1, '2024-04-01 10:15:22');
INSERT INTO `version_instance` VALUES (6, '2024.04.08/01', 1, 7, 12, 3301578929360515072, 3319009416896696320, 1, '2024-04-08 16:19:38');
INSERT INTO `version_instance` VALUES (7, '2024.04.11/01', 1, 8, 12, 3301578929360515072, 3322945890520256512, 1, '2024-04-11 09:30:10');
INSERT INTO `version_instance` VALUES (8, '2024.04.11/01', 1, 9, 13, 3304541119128129536, 3322954835242635264, 1, '2024-04-11 09:39:03');
INSERT INTO `version_instance` VALUES (9, '2024.04.11/02', 2, 9, 13, 3304541119128129536, 3322963364745695232, 1, '2024-04-11 09:47:31');
INSERT INTO `version_instance` VALUES (10, '2024.04.11/01', 1, 10, 10, 3294361419540246528, 3323237130608431104, 1, '2024-04-11 14:19:29');
INSERT INTO `version_instance` VALUES (11, '2024.04.11/02', 2, 10, 10, 3294361419540246528, 3323241790966714368, 1, '2024-04-11 14:24:07');
INSERT INTO `version_instance` VALUES (12, '2024.05.09/01', 1, 11, 15, 3334633259006808064, 3334958127715831808, 1, '2024-04-19 16:23:15');
INSERT INTO `version_instance` VALUES (13, '2024.04.25/01', 1, 12, 18, 3335006453865762816, 3335023426150453248, 1, '2024-04-19 17:28:07');
INSERT INTO `version_instance` VALUES (14, '2024.04.25/01', 1, 14, 13, 3304541119128129536, 3343565267040849920, 1, '2024-04-25 14:53:40');
INSERT INTO `version_instance` VALUES (15, '2024.04.25/01', 1, 15, 12, 3301578929360515072, 3343572420812197888, 1, '2024-04-25 15:00:47');
INSERT INTO `version_instance` VALUES (16, '2024.4.4/02', 2, 6, 8, 3268423816287690752, 3343658637012619264, 1, '2024-04-25 16:26:26');
INSERT INTO `version_instance` VALUES (17, '2024.05.11/01', 1, 26, 32, 3366796210320822272, 3366804399078625280, 1, '2024-05-11 15:39:41');
INSERT INTO `version_instance` VALUES (18, '2024.05.11/02', 2, 26, 32, 3366796210320822272, 3366810322962599936, 1, '2024-05-11 15:45:34');
INSERT INTO `version_instance` VALUES (19, '2024.4.4/03', 3, 6, 8, 3268423816287690752, 3369391560776863744, 1, '2024-05-13 10:29:47');
INSERT INTO `version_instance` VALUES (20, '2024.05.16/01', 1, 30, 10, 3294361419540246528, 3372305423423885312, 3267307713708539904, '2024-05-15 10:44:27');
INSERT INTO `version_instance` VALUES (21, '2024.05.16/02', 2, 30, 10, 3294361419540246528, 3372310784868470784, 3267307713708539904, '2024-05-15 10:49:47');
INSERT INTO `version_instance` VALUES (22, '2024.05.16/03', 3, 30, 10, 3294361419540246528, 3372326540469456896, 1, '2024-05-15 11:05:26');
INSERT INTO `version_instance` VALUES (23, '2024.05.16/01', 1, 25, 12, 3319012819869749248, 3372637609951875072, 3267307713708539904, '2024-05-15 16:14:27');
INSERT INTO `version_instance` VALUES (24, '2024.05.16/02', 2, 25, 12, 3319012819869749248, 3373629505050365952, 3267307713708539904, '2024-05-16 08:39:49');
INSERT INTO `version_instance` VALUES (25, '2024.05.16/03', 3, 25, 12, 3319012819869749248, 3373631011879243776, 3267307713708539904, '2024-05-16 08:41:18');
INSERT INTO `version_instance` VALUES (26, '2024.05.16/04', 4, 25, 12, 3301578929360515072, 3373633108712476672, 3267307713708539904, '2024-05-16 08:43:23');
INSERT INTO `version_instance` VALUES (27, '2024.05.16/05', 5, 25, 12, 3301578929360515072, 3373633596459700224, 3267307713708539904, '2024-05-16 08:43:52');
INSERT INTO `version_instance` VALUES (28, '2024.05.16/06', 6, 25, 12, 3301578929360515072, 3373729689105190912, 3267307713708539904, '2024-05-16 10:19:20');
INSERT INTO `version_instance` VALUES (29, '2024.05.16/07', 7, 25, 12, 3301578929360515072, 3373733771001843712, 3267307713708539904, '2024-05-16 10:23:23');
INSERT INTO `version_instance` VALUES (30, '2024.05.16/08', 8, 25, 12, 3371310723678195712, 3373739146656731136, 3267307713708539904, '2024-05-16 10:28:44');
INSERT INTO `version_instance` VALUES (31, '2024.05.16/09', 9, 25, 12, 3319012819869749248, 3373740738931970048, 3267307713708539904, '2024-05-16 10:30:19');
INSERT INTO `version_instance` VALUES (32, '2024.05.16/10', 10, 25, 12, 3319012819869749248, 3373744608714280960, 3267307713708539904, '2024-05-16 10:34:09');
INSERT INTO `version_instance` VALUES (33, '2024.05.16/01', 1, 27, 13, 3373750862236995584, 3373752658019864576, 3267307713708539904, '2024-05-16 10:42:09');
INSERT INTO `version_instance` VALUES (34, '2024.05.16/02', 2, 27, 13, 3373761579740680192, 3373763563780689920, 3267307713708539904, '2024-05-16 10:52:59');
INSERT INTO `version_instance` VALUES (35, '2024.05.30/01', 1, 45, 13, 3373750862236995584, 3394080772943880192, 3267307713708539904, '2024-05-30 11:16:19');
INSERT INTO `version_instance` VALUES (36, '2024.05.30/02', 2, 45, 13, 3373761579740680192, 3394084320217767936, 3267307713708539904, '2024-05-30 11:19:51');
INSERT INTO `version_instance` VALUES (37, '2024.05.30/01', 1, 48, 12, 3301578929360515072, 3394094313549701120, 3267307713708539904, '2024-05-30 11:29:46');
INSERT INTO `version_instance` VALUES (38, '2024.05.30/02', 2, 48, 12, 3319012819869749248, 3394099938061033472, 3267307713708539904, '2024-05-30 11:35:21');
INSERT INTO `version_instance` VALUES (39, '2024.06.06/01', 1, 73, 13, 3373761579740680192, 3404185915830226944, 3267307713708539904, '2024-06-06 10:34:53');
INSERT INTO `version_instance` VALUES (40, '2024.05.30/03', 3, 48, 12, 3369838149395927040, 3404454798214483968, 3267303552673759232, '2024-06-06 15:01:59');
INSERT INTO `version_instance` VALUES (41, '2024.05.30/04', 4, 48, 12, 3369838149395927040, 3404459934223618048, 3267303552673759232, '2024-06-06 15:07:05');
INSERT INTO `version_instance` VALUES (42, '2024-06-06/01', 1, 74, 100, 3397215227678138368, 3405534941368471552, 3267303552673759232, '2024-06-07 08:55:01');
INSERT INTO `version_instance` VALUES (43, '2024-06-06/02', 2, 74, 100, 3397219875604504576, 3405653603513454592, 3267303552673759232, '2024-06-07 10:52:54');
INSERT INTO `version_instance` VALUES (44, '2024.05.30/05', 5, 48, 12, 3369838149395927040, 3413096405071482880, 1, '2024-06-12 14:06:39');
INSERT INTO `version_instance` VALUES (45, '2024.05.30/06', 6, 48, 12, 3303063228047863808, 3413099023927791616, 1, '2024-06-12 14:09:15');
INSERT INTO `version_instance` VALUES (46, '2024.05.30/07', 7, 48, 12, 3303063228047863808, 3413099493605953536, 1, '2024-06-12 14:09:43');
INSERT INTO `version_instance` VALUES (47, '2024.05.30/08', 8, 48, 12, 3369838149395927040, 3413157118360080384, 3267303552673759232, '2024-06-12 15:06:58');
INSERT INTO `version_instance` VALUES (48, '2024.05.30/09', 9, 48, 12, 3303063228047863808, 3413293106940006400, 3267303552673759232, '2024-06-12 17:22:03');
INSERT INTO `version_instance` VALUES (49, '2024.05.30/10', 10, 48, 12, 3303063228047863808, 3414248536189095936, 3267303552673759232, '2024-06-13 09:11:11');
INSERT INTO `version_instance` VALUES (50, '2024.05.30/11', 11, 48, 12, 3303063228047863808, 3414249094434181120, 3267303552673759232, '2024-06-13 09:11:45');

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
) ENGINE = InnoDB AUTO_INCREMENT = 258 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本信息主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of version_management
-- ----------------------------
INSERT INTO `version_management` VALUES (1, 8, NULL, 1, 1, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-03-04 19:50:34', 1, '2024-03-05 17:40:35', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (2, 12, NULL, 3267307713708539904, 2, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-03-27 15:46:21', 1, '2024-03-27 15:46:21', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (3, 10, NULL, 3271122024350023680, 3, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-03-29 09:46:10', 3271125133872791552, '2024-07-17 17:01:16', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-07-17 17:01:16');
INSERT INTO `version_management` VALUES (4, 10, NULL, 1, 4, '2.0.0', '01', '2.0.0-01', 2, NULL, 1, '2024-03-29 18:32:42', 1, '2024-03-29 18:32:42', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (5, 13, NULL, 1, 5, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-03-29 19:20:20', 3267307713708539904, '2024-06-27 09:28:48', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-06-27 09:28:48');
INSERT INTO `version_management` VALUES (6, 8, NULL, 1, 6, '2024.4.4', '01', '2024.4.4-01', 2, NULL, 1, '2024-04-01 10:14:22', 1, '2024-04-01 10:14:22', 0, 0, NULL, NULL, 0, NULL, NULL, '2024.4.4投产', NULL);
INSERT INTO `version_management` VALUES (7, 12, NULL, 3267307713708539904, 7, '2024.04.08', '01', '2024.04.08-01', 2, NULL, 3267307713708539904, '2024-04-08 15:53:56', 1, '2024-05-10 17:23:17', 3, 0, NULL, NULL, 0, NULL, NULL, '测试制品发版', '2024-05-10 17:23:17');
INSERT INTO `version_management` VALUES (8, 12, NULL, 3267307713708539904, 8, '2024.04.11', '01', '2024.04.11-01', 2, NULL, 3267307713708539904, '2024-04-10 15:53:45', 1, '2024-05-10 17:23:15', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.11上线版本', '2024-05-10 17:23:15');
INSERT INTO `version_management` VALUES (9, 13, NULL, 3267307713708539904, 9, '2024.04.11', '01', '2024.04.11-01', 2, NULL, 1, '2024-04-11 09:37:14', 1, '2024-05-13 09:57:04', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.11-release', '2024-05-13 09:57:04');
INSERT INTO `version_management` VALUES (10, 10, NULL, 3267307713708539904, 10, '2024.04.11', '01', '2024.04.11-01', 2, NULL, 1, '2024-04-11 14:11:36', 3267307713708539904, '2024-05-14 14:28:21', 3, 0, NULL, NULL, 0, NULL, NULL, '0411-release', '2024-05-14 14:28:21');
INSERT INTO `version_management` VALUES (11, 15, NULL, 3271122024350023680, 11, '2024.05.09', '01', '2024.05.09-01', 2, NULL, 1, '2024-04-19 16:08:14', 3271121021592600576, '2024-05-31 15:26:34', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.09上线', '2024-05-31 15:26:34');
INSERT INTO `version_management` VALUES (12, 18, NULL, 3271122024350023680, 12, '2024.04.25', '01', '2024.04.25-01', 2, NULL, 1, '2024-04-19 16:52:11', 3267307713708539904, '2024-05-29 14:10:44', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.25', '2024-05-29 14:10:44');
INSERT INTO `version_management` VALUES (13, 19, NULL, 1, 13, '2024.04.25', '01', '2024.04.25-01', 2, NULL, 1, '2024-04-25 09:25:43', 3267307713708539904, '2024-05-30 16:22:57', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.25上线', '2024-05-30 16:22:57');
INSERT INTO `version_management` VALUES (14, 13, NULL, 3267307713708539904, 14, '2024.04.25', '01', '2024.04.25-01', 2, NULL, 1, '2024-04-25 14:53:04', 1, '2024-05-13 09:57:07', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.25上线', '2024-05-13 09:57:07');
INSERT INTO `version_management` VALUES (15, 12, NULL, 3267307713708539904, 15, '2024.04.25', '01', '2024.04.25-01', 2, NULL, 1, '2024-04-25 14:59:09', 1, '2024-05-10 17:23:12', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.25上线', '2024-05-10 17:23:12');
INSERT INTO `version_management` VALUES (16, 10, NULL, 3267307713708539904, 16, '2024.04.25', '01', '2024.04.25-01', 2, NULL, 1, '2024-04-25 16:09:33', 3267307713708539904, '2024-05-14 14:28:18', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.25上线', '2024-05-14 14:28:18');
INSERT INTO `version_management` VALUES (17, 25, NULL, 3267307713708539904, 17, '2024.04.25', '01', '2024.04.25-01', 2, NULL, 1, '2024-04-25 16:13:31', 3271120617295249408, '2024-05-31 14:04:10', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.04.25', '2024-05-31 14:04:10');
INSERT INTO `version_management` VALUES (18, 22, NULL, 1, 18, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-04-25 16:48:17', 1, '2024-04-25 16:48:17', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (19, 22, NULL, 1, 19, '2024.4.25', '01', '2024.4.25-01', 2, NULL, 1, '2024-04-25 16:49:55', 1, '2024-04-25 16:49:59', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (20, 22, NULL, 3342152887245934592, 20, '20240428', '01', '20240428-01', 2, NULL, 3342152887245934592, '2024-04-28 09:39:54', 3342152887245934592, '2024-04-28 09:48:58', 2, 0, NULL, NULL, 0, NULL, NULL, '消费贷产品版本', NULL);
INSERT INTO `version_management` VALUES (21, 31, NULL, 3267296873982836736, 21, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267296873982836736, '2024-05-09 17:04:14', 3267296873982836736, '2024-05-09 17:04:14', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (22, 30, NULL, 3267296873982836736, 22, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267296873982836736, '2024-05-09 17:56:35', 3267296873982836736, '2024-05-09 17:56:35', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (23, 34, NULL, 3267296873982836736, 23, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267296873982836736, '2024-05-10 10:38:52', 3267296873982836736, '2024-05-10 10:38:52', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (24, 33, NULL, 3267296873982836736, 24, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267296873982836736, '2024-05-10 10:43:50', 3267296873982836736, '2024-05-10 10:43:50', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (25, 12, NULL, 3267307713708539904, 25, '2024.05.16', '01', '2024.05.16-01', 2, NULL, 1, '2024-05-10 17:03:40', 3267307713708539904, '2024-05-28 16:01:28', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.16', '2024-05-28 16:01:28');
INSERT INTO `version_management` VALUES (26, 32, NULL, 3271121021592600576, 26, '2024.05.11', '01', '2024.05.11-01', 2, NULL, 1, '2024-05-11 15:36:47', 1, '2024-05-11 15:38:11', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.05.11上线', NULL);
INSERT INTO `version_management` VALUES (27, 13, NULL, 3271120617295249408, 27, '2024.05.16', '01', '2024.05.16-01', 2, NULL, 1, '2024-05-13 09:56:56', 3267307713708539904, '2024-05-22 14:07:29', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.16release', '2024-05-22 14:07:29');
INSERT INTO `version_management` VALUES (28, 35, NULL, 3267292550326501376, 28, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267292550326501376, '2024-05-13 16:19:43', 3267292550326501376, '2024-05-13 16:19:43', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (29, 36, NULL, 3267292550326501376, 29, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267292550326501376, '2024-05-13 16:28:51', 3267292550326501376, '2024-09-19 14:46:51', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (30, 10, NULL, 3267307713708539904, 30, '2024.05.16', '01', '2024.05.16-01', 2, NULL, 3267307713708539904, '2024-05-14 14:28:56', 3271125133872791552, '2024-07-17 17:01:14', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.16上线', '2024-07-17 17:01:14');
INSERT INTO `version_management` VALUES (31, 14, NULL, 3267307713708539904, 31, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-05-17 09:59:11', 3267307713708539904, '2024-05-17 09:59:11', 0, 0, NULL, NULL, 0, NULL, NULL, '初始化版本', NULL);
INSERT INTO `version_management` VALUES (32, 32, NULL, 3267307713708539904, 32, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-05-17 10:43:32', 3267307713708539904, '2024-05-17 10:43:32', 0, 0, NULL, NULL, 0, NULL, NULL, '初始化版本', NULL);
INSERT INTO `version_management` VALUES (33, 25, NULL, 3271125133872791552, 33, '2024.05.17', '01', '2024.05.17-01', 2, NULL, 3271125133872791552, '2024-05-17 11:16:47', 3267307713708539904, '2024-06-26 17:11:57', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-06-26 17:11:57');
INSERT INTO `version_management` VALUES (34, 13, NULL, 3267307713708539904, 34, '2024.05.23', '01', '2024.05.23-01', 2, NULL, 3267307713708539904, '2024-05-22 14:07:51', 3267307713708539904, '2024-06-06 10:31:40', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-06-06 10:31:40');
INSERT INTO `version_management` VALUES (35, 23, NULL, 3267292550326501376, 35, '2024-05-24', '01', '2024-05-24-01', 2, NULL, 3267292550326501376, '2024-05-23 15:23:54', 3267292550326501376, '2024-09-19 14:57:06', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-09-19 14:57:06');
INSERT INTO `version_management` VALUES (36, 47, NULL, 3267296873982836736, 36, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:11:31', 3267296873982836736, '2024-05-24 14:11:31', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (37, 44, NULL, 3267296873982836736, 37, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:14:09', 3267296873982836736, '2024-05-24 14:14:09', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (38, 42, NULL, 3267296873982836736, 38, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:15:05', 3267296873982836736, '2024-05-24 14:15:05', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (39, 41, NULL, 3267296873982836736, 39, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:15:33', 3267296873982836736, '2024-05-24 14:15:33', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (40, 39, NULL, 3267296873982836736, 40, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:16:57', 3267296873982836736, '2024-05-24 14:16:57', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (41, 40, NULL, 3267296873982836736, 41, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:17:09', 3267296873982836736, '2024-05-24 14:17:09', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (42, 38, NULL, 3267296873982836736, 42, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:17:41', 3267296873982836736, '2024-05-24 14:17:41', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (43, 37, NULL, 3267296873982836736, 43, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 3267296873982836736, '2024-05-24 14:18:06', 3267296873982836736, '2024-05-24 14:18:06', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (44, 48, NULL, 1, 44, '2024-05-26', '01', '2024-05-26-01', 2, NULL, 1, '2024-05-24 14:52:53', 1, '2024-05-24 14:52:53', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (45, 13, NULL, 3267307713708539904, 45, '2024.05.30', '01', '2024.05.30-01', 2, NULL, 3267307713708539904, '2024-05-28 10:50:54', 3267307713708539904, '2024-06-06 10:31:44', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.30', '2024-06-06 10:31:44');
INSERT INTO `version_management` VALUES (46, 51, NULL, 3363893784903917568, 46, '2024-05-28', '01', '2024-05-28-01', 2, NULL, 3363893784903917568, '2024-05-28 10:55:32', 3363893784903917568, '2024-05-28 10:55:32', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (47, 50, NULL, 3363893784903917568, 47, '2024-05-28', '01', '2024-05-28-01', 2, NULL, 3363893784903917568, '2024-05-28 15:31:19', 3363893784903917568, '2024-05-28 15:31:19', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (48, 12, NULL, 3267307713708539904, 48, '2024.05.30', '01', '2024.05.30-01', 2, NULL, 3267307713708539904, '2024-05-28 16:01:23', 3267307713708539904, '2024-06-12 16:58:52', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.30', '2024-06-12 16:58:52');
INSERT INTO `version_management` VALUES (49, 53, NULL, 3363893784903917568, 49, '2024-05-28', '01', '2024-05-28-01', 2, NULL, 3363893784903917568, '2024-05-28 16:19:21', 3363893784903917568, '2024-05-28 16:19:21', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (50, 55, NULL, 3363893784903917568, 50, '2024-05-28', '01', '2024-05-28-01', 2, NULL, 3363893784903917568, '2024-05-28 16:30:48', 3363893784903917568, '2024-05-28 16:30:48', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (51, 52, NULL, 3363893784903917568, 51, '2024-05-28', '01', '2024-05-28-01', 2, NULL, 3363893784903917568, '2024-05-28 19:50:05', 3363893784903917568, '2024-05-28 19:50:05', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (52, 54, NULL, 3363893784903917568, 52, '2024-05-28', '01', '2024-05-28-01', 2, NULL, 3363893784903917568, '2024-05-28 20:45:41', 3363893784903917568, '2024-05-28 20:45:41', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (53, 18, NULL, 3267307713708539904, 53, '2024.05.30', '01', '2024.05.30-01', 2, NULL, 3267307713708539904, '2024-05-29 14:10:34', 3271120617295249408, '2024-05-31 14:03:24', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.30', '2024-05-31 14:03:24');
INSERT INTO `version_management` VALUES (54, 34, NULL, 3267296873982836736, 54, '2024.05.30', '01', '2024.05.30-01', 2, NULL, 1, '2024-05-30 08:42:24', 1, '2024-05-30 08:42:29', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.05.30上线', NULL);
INSERT INTO `version_management` VALUES (55, 33, NULL, 3267296873982836736, 55, '2024.05.30', '01', '2024.05.30-01', 2, NULL, 3267296873982836736, '2024-05-30 09:03:27', 3267296873982836736, '2024-05-30 09:03:34', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.05.30上线', NULL);
INSERT INTO `version_management` VALUES (56, 19, NULL, 3267307713708539904, 56, '2024.05.30', '01', '2024.05.30-01', 2, NULL, 3267307713708539904, '2024-05-30 16:22:51', 3267307713708539904, '2024-06-18 14:48:11', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.05.30', '2024-06-18 14:48:11');
INSERT INTO `version_management` VALUES (57, 18, NULL, 3271120617295249408, 57, '2024.06.06', '01', '2024.06.06-01', 2, NULL, 3271120617295249408, '2024-05-31 14:03:18', 3267307713708539904, '2024-06-18 14:46:48', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.06.06', '2024-06-18 14:46:48');
INSERT INTO `version_management` VALUES (58, 25, NULL, 3271120617295249408, 58, '2024.06.06', '01', '2024.06.06-01', 2, NULL, 3271120617295249408, '2024-05-31 14:03:59', 3267307713708539904, '2024-06-26 17:11:54', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.06.06', '2024-06-26 17:11:54');
INSERT INTO `version_management` VALUES (59, 15, NULL, 3271121021592600576, 59, '2024.06.06', '01', '2024.06.06-01', 2, NULL, 3271121021592600576, '2024-05-31 15:26:27', 3271121021592600576, '2024-05-31 15:26:45', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.06.06上线', '2024-05-31 15:26:45');
INSERT INTO `version_management` VALUES (60, 77, NULL, 3267292550326501376, 60, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 15:39:29', 3267292550326501376, '2024-06-03 15:39:29', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (61, 76, NULL, 3267292550326501376, 61, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 15:44:03', 3267292550326501376, '2024-06-03 15:44:03', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (62, 72, NULL, 3267292550326501376, 62, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:02:22', 3267292550326501376, '2024-06-03 16:02:22', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (63, 70, NULL, 3267292550326501376, 63, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:15:24', 3267292550326501376, '2024-06-03 16:15:24', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (64, 73, NULL, 3267292550326501376, 64, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:22:03', 3267292550326501376, '2024-06-03 16:22:03', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (65, 74, NULL, 3267292550326501376, 65, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:34:33', 3267292550326501376, '2024-06-03 16:34:33', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (66, 79, NULL, 3267292550326501376, 66, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:40:02', 3267292550326501376, '2024-06-03 16:40:02', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (67, 78, NULL, 3267292550326501376, 67, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:46:41', 3267292550326501376, '2024-06-03 16:46:41', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (68, 75, NULL, 3267292550326501376, 68, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 16:52:16', 3267292550326501376, '2024-06-03 16:52:16', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (69, 82, NULL, 3267292550326501376, 69, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 17:10:19', 3267292550326501376, '2024-06-03 17:10:19', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (70, 81, NULL, 3267292550326501376, 70, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 17:14:48', 3267292550326501376, '2024-06-03 17:14:48', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (71, 80, NULL, 3267292550326501376, 71, '2024-06-03', '01', '2024-06-03-01', 2, NULL, 3267292550326501376, '2024-06-03 17:19:32', 3267292550326501376, '2024-06-03 17:19:32', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (72, 98, NULL, 3267303552673759232, 72, '2024.06.06', '01', '2024.06.06-01', 2, NULL, 1, '2024-06-04 10:53:32', 3267303552673759232, '2024-06-04 11:07:16', 1, 0, NULL, NULL, 0, NULL, NULL, '效能度量大屏优化代码提交行数统计逻辑', NULL);
INSERT INTO `version_management` VALUES (73, 13, NULL, 3267307713708539904, 73, '2024.06.06', '01', '2024.06.06-01', 2, NULL, 3267307713708539904, '2024-06-04 11:09:40', 3271125133872791552, '2024-06-12 11:06:44', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-06-12 11:06:44');
INSERT INTO `version_management` VALUES (74, 100, NULL, 3267307713708539904, 74, '2024-06-06', '01', '2024-06-06-01', 2, NULL, 3267307713708539904, '2024-06-04 16:46:11', 3267303552673759232, '2024-06-11 15:00:43', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-06-11 15:00:43');
INSERT INTO `version_management` VALUES (75, 150, NULL, 3271117585803313152, 75, '2024-06-12', '01', '2024-06-12-01', 2, NULL, 3271117585803313152, '2024-06-12 09:43:50', 3271117585803313152, '2024-06-12 09:43:50', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (76, 13, NULL, 3271125133872791552, 76, '2024.06.13', '01', '2024.06.13-01', 2, NULL, 3271125133872791552, '2024-06-12 11:06:41', 3267307713708539904, '2024-06-27 09:28:52', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-06-27 09:28:52');
INSERT INTO `version_management` VALUES (77, 10, NULL, 3267307713708539904, 77, '2024.06.13', '01', '2024.06.13-01', 2, NULL, 3267307713708539904, '2024-06-12 11:13:39', 3271125133872791552, '2024-07-17 17:01:09', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-07-17 17:01:09');
INSERT INTO `version_management` VALUES (78, 155, NULL, 3271117585803313152, 78, '2024-06-12', '01', '2024-06-12-01', 2, NULL, 3271117585803313152, '2024-06-12 14:23:46', 3271117585803313152, '2024-06-12 14:23:46', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (79, 12, NULL, 3267307713708539904, 79, '2024.06.13', '01', '2024.06.13-01', 2, NULL, 3267307713708539904, '2024-06-12 16:58:48', 3267307713708539904, '2024-06-12 16:58:56', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.06.13', NULL);
INSERT INTO `version_management` VALUES (80, 173, NULL, 3271117585803313152, 80, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-06-14 09:19:49', 1, '2024-06-14 09:19:53', 1, 0, NULL, NULL, 0, NULL, NULL, 'init', NULL);
INSERT INTO `version_management` VALUES (81, 158, NULL, 3271117585803313152, 81, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-06-14 09:27:50', 1, '2024-06-14 09:27:53', 1, 0, NULL, NULL, 0, NULL, NULL, 'init', NULL);
INSERT INTO `version_management` VALUES (82, 163, NULL, 3271117585803313152, 82, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 09:58:25', 3271117585803313152, '2024-06-14 09:58:25', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (83, 159, NULL, 3271117585803313152, 83, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 09:58:42', 3271117585803313152, '2024-06-14 09:58:42', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (84, 165, NULL, 3271117585803313152, 84, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 09:59:33', 3271117585803313152, '2024-06-14 09:59:33', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (85, 164, NULL, 3271117585803313152, 85, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 09:59:58', 3271117585803313152, '2024-06-14 09:59:58', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (86, 157, NULL, 3271117585803313152, 86, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:00:40', 3271117585803313152, '2024-06-14 10:00:40', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (87, 156, NULL, 3271117585803313152, 87, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:01:44', 3271117585803313152, '2024-06-14 10:01:44', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (88, 166, NULL, 3271117585803313152, 88, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:02:06', 3271117585803313152, '2024-06-14 10:02:06', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (89, 174, NULL, 3271117585803313152, 89, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:02:27', 3271117585803313152, '2024-06-14 10:02:27', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (90, 167, NULL, 3271117585803313152, 90, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:02:54', 3271117585803313152, '2024-06-14 10:02:54', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (91, 153, NULL, 3271117585803313152, 91, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:03:12', 3271117585803313152, '2024-06-14 10:03:12', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (92, 152, NULL, 3271117585803313152, 92, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:04:10', 3271117585803313152, '2024-06-14 10:04:10', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (93, 151, NULL, 3271117585803313152, 93, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:04:58', 3271117585803313152, '2024-06-14 10:04:58', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (94, 149, NULL, 3271117585803313152, 94, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-06-14 10:05:56', 3271117585803313152, '2024-06-14 10:05:56', 0, 0, NULL, NULL, 0, NULL, NULL, '1.0.0', NULL);
INSERT INTO `version_management` VALUES (95, 18, NULL, 3267307713708539904, 95, '2024.06.20', '01', '2024.06.20-01', 2, NULL, 3267307713708539904, '2024-06-18 14:46:44', 3271120617295249408, '2024-07-01 14:47:27', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.06.20', '2024-07-01 14:47:27');
INSERT INTO `version_management` VALUES (96, 19, NULL, 3267307713708539904, 96, '2024.06.20', '01', '2024.06.20-01', 2, NULL, 3267307713708539904, '2024-06-18 14:48:07', 3271125133872791552, '2024-07-03 09:06:47', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.06.20', '2024-07-03 09:06:47');
INSERT INTO `version_management` VALUES (97, 68, NULL, 3267292550326501376, 97, '06-21', '01', '06-21-01', 2, NULL, 3267292550326501376, '2024-06-21 17:07:31', 3267292550326501376, '2024-06-21 17:07:31', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (98, 183, NULL, 3267296873982836736, 98, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 15:07:00', 3267296873982836736, '2024-06-22 15:07:00', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (99, 182, NULL, 3267296873982836736, 99, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 15:13:31', 3267296873982836736, '2024-06-22 15:13:31', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (100, 141, NULL, 3267296873982836736, 100, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:02:26', 3267296873982836736, '2024-06-22 16:02:26', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (101, 133, NULL, 3267296873982836736, 101, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:04:55', 3267296873982836736, '2024-06-22 16:04:55', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (102, 131, NULL, 3267296873982836736, 102, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:09:23', 3267296873982836736, '2024-06-22 16:09:23', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (103, 132, NULL, 3267296873982836736, 103, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:15:37', 3267296873982836736, '2024-06-22 16:15:37', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (104, 177, NULL, 3267296873982836736, 104, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:21:11', 3267296873982836736, '2024-06-22 16:21:11', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (105, 176, NULL, 3267296873982836736, 105, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:25:12', 3267296873982836736, '2024-06-22 16:25:12', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (106, 185, NULL, 3267296873982836736, 106, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:33:28', 3267296873982836736, '2024-06-22 16:33:28', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (107, 184, NULL, 3267296873982836736, 107, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:39:47', 3267296873982836736, '2024-06-22 16:39:47', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (108, 181, NULL, 3267296873982836736, 108, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3267296873982836736, '2024-06-22 16:51:52', 3267296873982836736, '2024-06-22 16:51:52', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (109, 67, NULL, 3271115816176123904, 109, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 15:54:29', 3271115816176123904, '2024-06-24 15:54:29', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (110, 66, NULL, 3271115816176123904, 110, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:04:49', 3271115816176123904, '2024-06-24 16:04:49', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (111, 65, NULL, 3271115816176123904, 111, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:14:33', 3271115816176123904, '2024-06-24 16:14:33', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (112, 64, NULL, 3271115816176123904, 112, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:21:32', 3271115816176123904, '2024-06-24 16:21:32', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (113, 63, NULL, 3271115816176123904, 113, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:27:14', 3271115816176123904, '2024-06-24 16:27:14', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (114, 62, NULL, 3271115816176123904, 114, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:45:40', 3271115816176123904, '2024-06-24 16:45:40', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (115, 61, NULL, 3271115816176123904, 115, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:48:49', 3271115816176123904, '2024-06-24 16:48:49', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (116, 57, NULL, 3271115816176123904, 116, '2024-06-22', '01', '2024-06-22-01', 2, NULL, 3271115816176123904, '2024-06-24 16:57:15', 3271115816176123904, '2024-06-24 16:57:15', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (117, 59, NULL, 3271115816176123904, 117, '2024-06-24', '01', '2024-06-24-01', 2, NULL, 3271115816176123904, '2024-06-24 16:59:07', 3271115816176123904, '2024-06-24 16:59:07', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (118, 60, NULL, 3271115816176123904, 118, '2024-06-25', '01', '2024-06-25-01', 2, NULL, 3271115816176123904, '2024-06-25 09:58:58', 3271115816176123904, '2024-06-25 09:58:58', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (119, 58, NULL, 3271115816176123904, 119, '2024-06-25', '01', '2024-06-25-01', 2, NULL, 3271115816176123904, '2024-06-25 10:26:29', 3271115816176123904, '2024-06-25 10:26:29', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (120, 56, NULL, 3271115816176123904, 120, '2024-06-25', '01', '2024-06-25-01', 2, NULL, 3271115816176123904, '2024-06-25 10:43:53', 3271115816176123904, '2024-06-25 10:43:53', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (121, 194, NULL, 3371463310998532096, 121, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3371463310998532096, '2024-06-26 10:24:01', 3371463310998532096, '2024-06-26 10:24:01', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (122, 180, NULL, 3267296873982836736, 122, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 15:18:08', 3267296873982836736, '2024-06-26 15:18:08', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (123, 189, NULL, 3267296873982836736, 123, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 15:43:43', 3267296873982836736, '2024-06-26 15:43:43', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (124, 139, NULL, 3267296873982836736, 124, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 15:47:09', 3267296873982836736, '2024-06-26 15:47:09', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (125, 138, NULL, 3267296873982836736, 125, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 15:48:44', 3267296873982836736, '2024-06-26 15:48:44', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (126, 137, NULL, 3267296873982836736, 126, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 15:51:51', 3267296873982836736, '2024-06-26 15:51:51', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (127, 136, NULL, 3267296873982836736, 127, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 15:53:28', 3267296873982836736, '2024-06-26 15:53:28', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (128, 175, NULL, 3267296873982836736, 128, '2024-06-26', '01', '2024-06-26-01', 2, NULL, 3267296873982836736, '2024-06-26 16:09:06', 3267296873982836736, '2024-06-26 16:09:06', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (129, 25, NULL, 3267307713708539904, 129, '2024.06.27', '01', '2024.06.27-01', 2, NULL, 3267307713708539904, '2024-06-26 17:11:50', 3267307713708539904, '2024-06-28 11:06:11', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.06.27', '2024-06-28 11:06:11');
INSERT INTO `version_management` VALUES (130, 13, NULL, 3267307713708539904, 130, '2024.06.27', '01', '2024.06.27-01', 2, NULL, 3267307713708539904, '2024-06-27 09:28:44', 3267307713708539904, '2024-06-27 09:28:55', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.06.27', NULL);
INSERT INTO `version_management` VALUES (131, 25, NULL, 3267307713708539904, 131, '2024.06.28', '01', '2024.06.28-01', 2, NULL, 3267307713708539904, '2024-06-28 11:06:23', 3271120617295249408, '2024-07-04 14:38:17', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.06.28', '2024-07-04 14:38:17');
INSERT INTO `version_management` VALUES (132, 30, NULL, 3267296873982836736, 132, '2024-07-01', '01', '2024-07-01-01', 2, NULL, 3267296873982836736, '2024-06-28 11:19:21', 3267296873982836736, '2024-06-28 11:19:21', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (133, 18, NULL, 3271120617295249408, 133, '2024.07.04', '01', '2024.07.04-01', 2, NULL, 3271120617295249408, '2024-07-01 14:47:21', 3271120617295249408, '2024-07-10 10:21:53', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.07.04', '2024-07-10 10:21:53');
INSERT INTO `version_management` VALUES (134, 30, NULL, 3371463622182334464, 134, '2024-07-02', '01', '2024-07-02-01', 2, NULL, 3371463622182334464, '2024-07-02 14:53:03', 3371463622182334464, '2024-07-02 14:53:03', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (135, 19, NULL, 3271125133872791552, 135, '2024.07.04', '01', '2024.07.04-01', 2, NULL, 3271125133872791552, '2024-07-03 09:07:08', 3271125133872791552, '2024-07-10 09:52:22', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.07.04', '2024-07-10 09:52:22');
INSERT INTO `version_management` VALUES (136, 158, NULL, 3271117585803313152, 136, '1.0.1', '01', '1.0.1-01', 2, NULL, 3271117585803313152, '2024-07-03 11:24:06', 3271117585803313152, '2024-07-03 11:24:11', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (137, 25, NULL, 3271120617295249408, 137, '2024.07.04', '01', '2024.07.04-01', 2, NULL, 3271120617295249408, '2024-07-04 14:38:12', 3271125133872791552, '2024-07-16 10:32:05', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.07.04', '2024-07-16 10:32:05');
INSERT INTO `version_management` VALUES (138, 191, NULL, 3267296873982836736, 138, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 14:58:25', 3267296873982836736, '2024-07-05 14:58:25', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (139, 190, NULL, 3267296873982836736, 139, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 16:09:10', 3267296873982836736, '2024-07-05 16:09:10', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (140, 142, NULL, 3267296873982836736, 140, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 16:32:03', 3267296873982836736, '2024-07-05 16:32:03', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (141, 135, NULL, 3267296873982836736, 141, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 16:50:33', 3267296873982836736, '2024-07-05 16:50:33', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (142, 134, NULL, 3267296873982836736, 142, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 17:00:36', 3267296873982836736, '2024-07-05 17:00:36', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (143, 130, NULL, 3267296873982836736, 143, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 17:03:43', 3267296873982836736, '2024-07-05 17:03:43', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (144, 129, NULL, 3267296873982836736, 144, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 17:14:49', 3267296873982836736, '2024-07-05 17:14:49', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (145, 128, NULL, 3267296873982836736, 145, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 17:27:14', 3267296873982836736, '2024-07-05 17:27:14', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (146, 126, NULL, 3267296873982836736, 146, '2024-07-05', '01', '2024-07-05-01', 2, NULL, 3267296873982836736, '2024-07-05 17:35:58', 3267296873982836736, '2024-07-05 17:35:58', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (147, 216, NULL, 3271113249245298688, 147, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271113249245298688, '2024-07-08 15:30:46', 3271113249245298688, '2024-07-08 15:31:33', 1, 0, NULL, NULL, 0, NULL, NULL, '初始化', NULL);
INSERT INTO `version_management` VALUES (148, 206, NULL, 3271117585803313152, 148, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-07-08 16:52:46', 3271117585803313152, '2024-07-08 16:52:49', 1, 0, NULL, NULL, 0, NULL, NULL, '初始化', NULL);
INSERT INTO `version_management` VALUES (149, 204, NULL, 3271117585803313152, 149, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-07-08 17:30:37', 3271117585803313152, '2024-07-08 17:30:39', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (150, 205, NULL, 3271117585803313152, 150, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-07-08 17:43:57', 3271117585803313152, '2024-07-08 17:43:57', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (151, 207, NULL, 3271117585803313152, 151, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271117585803313152, '2024-07-08 17:44:23', 3271117585803313152, '2024-07-08 17:44:23', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (152, 125, NULL, 3267296873982836736, 152, '2024-07-09', '01', '2024-07-09-01', 2, NULL, 3267296873982836736, '2024-07-09 09:39:56', 3267296873982836736, '2024-07-09 09:39:56', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (153, 31, NULL, 3267296873982836736, 153, '2024-07-10', '01', '2024-07-10-01', 2, NULL, 3267296873982836736, '2024-07-09 14:34:08', 3267296873982836736, '2024-07-09 14:34:08', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (154, 204, NULL, 3271117585803313152, 154, 'release-20240711', '01', 'release-20240711-01', 2, NULL, 3271117585803313152, '2024-07-09 16:54:54', 3271117585803313152, '2024-07-09 16:55:00', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (155, 19, NULL, 3271125133872791552, 155, '2024.07.10', '01', '2024.07.10-01', 2, NULL, 3271125133872791552, '2024-07-10 09:52:18', 3271125133872791552, '2024-07-16 10:23:40', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.07.10', '2024-07-16 10:23:40');
INSERT INTO `version_management` VALUES (156, 18, NULL, 3271120617295249408, 156, '2024.07.11', '01', '2024.07.11-01', 2, NULL, 3271120617295249408, '2024-07-10 10:22:06', 3271120617295249408, '2024-07-10 10:22:06', 0, 0, NULL, NULL, 0, NULL, NULL, '2024.07.11', NULL);
INSERT INTO `version_management` VALUES (157, 209, NULL, 3271113249245298688, 157, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271113249245298688, '2024-07-11 10:52:56', 3271113249245298688, '2024-07-11 10:52:56', 0, 0, NULL, NULL, 0, NULL, NULL, '初始化版本', NULL);
INSERT INTO `version_management` VALUES (158, 209, NULL, 3271113249245298688, 158, '3.0-SNAPSHOT', '01', '3.0-SNAPSHOT-01', 2, NULL, 3271113249245298688, '2024-07-15 10:36:49', 3271113249245298688, '2024-07-15 10:36:49', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (159, 208, NULL, 3271113249245298688, 159, '1.0.0', '01', '1.0.0-01', 2, NULL, 3271113249245298688, '2024-07-15 14:45:24', 3271113249245298688, '2024-07-15 14:45:24', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (160, 19, NULL, 3271125133872791552, 160, '2024.07.18', '01', '2024.07.18-01', 2, NULL, 3271125133872791552, '2024-07-16 10:24:01', 3271125133872791552, '2024-07-16 10:24:01', 0, 0, NULL, NULL, 0, NULL, NULL, '2024.07.18', NULL);
INSERT INTO `version_management` VALUES (161, 25, NULL, 3271125133872791552, 161, '2024.07.18', '01', '2024.07.18-01', 2, NULL, 3271125133872791552, '2024-07-16 10:32:37', 3271125133872791552, '2024-07-16 10:32:37', 0, 0, NULL, NULL, 0, NULL, NULL, '2024.07.18', NULL);
INSERT INTO `version_management` VALUES (162, 10, NULL, 3271125133872791552, 162, '2024.07.18', '01', '2024.07.18-01', 2, NULL, 3271125133872791552, '2024-07-17 17:01:06', 3271125133872791552, '2024-07-19 09:20:40', 3, 0, NULL, NULL, 0, NULL, NULL, '2024.07.18', '2024-07-19 09:20:40');
INSERT INTO `version_management` VALUES (163, 13, NULL, 3271122670088290304, 163, '2023.07.25', '01', '2023.07.25-01', 2, NULL, 3271122670088290304, '2024-07-23 16:33:52', 3271122670088290304, '2024-07-23 16:33:56', 1, 0, NULL, NULL, 1, NULL, NULL, '修改面包屑样式', NULL);
INSERT INTO `version_management` VALUES (164, 13, NULL, 3271122670088290304, 164, '2024.07.25', '01', '2024.07.25-01', 2, NULL, 3271122670088290304, '2024-07-23 16:34:44', 3271122670088290304, '2024-07-23 16:34:47', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.07.25上线', NULL);
INSERT INTO `version_management` VALUES (165, 106, NULL, 3267307713708539904, 165, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-07-24 16:25:08', 3267307713708539904, '2024-07-24 16:25:08', 0, 0, NULL, NULL, 0, NULL, NULL, 'init', NULL);
INSERT INTO `version_management` VALUES (166, 104, NULL, 1, 166, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 14:54:07', 1, '2024-07-28 14:54:07', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (167, 103, NULL, 1, 167, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:12:57', 1, '2024-07-28 15:12:57', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (168, 102, NULL, 1, 168, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:16:18', 1, '2024-07-28 15:16:18', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (169, 101, NULL, 1, 169, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:21:08', 1, '2024-07-28 15:21:08', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (170, 99, NULL, 1, 170, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:25:14', 3267307713708539904, '2024-09-13 10:37:11', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-09-13 10:37:11');
INSERT INTO `version_management` VALUES (171, 97, NULL, 1, 171, '2024-06-28', '01', '2024-06-28-01', 2, NULL, 1, '2024-07-28 15:30:07', 1, '2024-07-28 15:30:07', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (172, 96, NULL, 1, 172, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:33:30', 1, '2024-07-28 15:33:30', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (173, 95, NULL, 1, 173, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:37:42', 1, '2024-07-28 15:37:42', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (174, 94, NULL, 1, 174, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:43:04', 1, '2024-07-28 15:43:04', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (175, 113, NULL, 1, 175, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:46:58', 1, '2024-07-28 15:46:58', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (176, 112, NULL, 1, 176, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:50:44', 1, '2024-07-28 15:50:44', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (177, 111, NULL, 1, 177, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 15:56:04', 1, '2024-07-28 15:56:04', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (178, 110, NULL, 1, 178, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 16:01:22', 1, '2024-07-28 16:01:22', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (179, 109, NULL, 1, 179, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 16:06:38', 1, '2024-07-28 16:06:38', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (180, 108, NULL, 1, 180, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 16:24:59', 3267307713708539904, '2024-09-14 08:54:24', 2, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-09-13 10:36:16');
INSERT INTO `version_management` VALUES (181, 107, NULL, 1, 181, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 16:33:25', 1, '2024-07-28 16:33:25', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (182, 105, NULL, 1, 182, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 16:47:07', 1, '2024-07-28 16:47:07', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (183, 114, NULL, 1, 183, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-07-28 16:54:21', 1, '2024-07-28 16:54:21', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (184, 226, NULL, 1, 184, '3.0.0', '01', '3.0.0-01', 2, NULL, 1, '2024-08-07 11:11:06', 1, '2024-08-07 11:11:06', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (185, 106, NULL, 1, 185, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-08-07 18:48:38', 1, '2024-08-07 18:48:38', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (186, 226, NULL, 1, 186, '2024-07-28', '01', '2024-07-28-01', 2, NULL, 1, '2024-08-07 18:57:47', 1, '2024-08-07 18:57:47', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (187, 115, NULL, 3267307713708539904, 187, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-08-15 14:49:35', 3267307713708539904, '2024-08-15 14:49:38', 1, 0, NULL, NULL, 0, NULL, NULL, '初版本', NULL);
INSERT INTO `version_management` VALUES (188, 96, NULL, 3267307713708539904, 188, '2024.08.21', '01', '2024.08.21-01', 2, NULL, 3267307713708539904, '2024-08-21 17:26:34', 3267307713708539904, '2024-08-21 17:26:37', 1, 0, NULL, NULL, 0, NULL, NULL, '2024.08.21依赖补充后的版本', NULL);
INSERT INTO `version_management` VALUES (189, 228, NULL, 3267307713708539904, 189, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-08-22 10:01:35', 3267307713708539904, '2024-08-22 10:01:40', 1, 0, NULL, NULL, 0, NULL, NULL, '初版本', NULL);
INSERT INTO `version_management` VALUES (190, 116, NULL, 3267307713708539904, 190, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-09-06 16:33:21', 3267307713708539904, '2024-09-06 16:33:21', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (191, 108, NULL, 3267307713708539904, 191, '2024.09.13', '01', '2024.09.13-01', 2, NULL, 3267307713708539904, '2024-09-13 10:36:12', 3267307713708539904, '2024-09-13 10:36:12', 0, 0, NULL, NULL, 0, NULL, NULL, '批量下载', NULL);
INSERT INTO `version_management` VALUES (192, 99, NULL, 3267307713708539904, 192, '2024.09.13', '01', '2024.09.13-01', 2, NULL, 3267307713708539904, '2024-09-13 10:37:06', 3267307713708539904, '2024-09-13 10:37:06', 0, 0, NULL, NULL, 0, NULL, NULL, '批量下载', NULL);
INSERT INTO `version_management` VALUES (193, 226, NULL, 3267307713708539904, 193, '2024-09-14', '01', '2024-09-14-01', 2, NULL, 3267307713708539904, '2024-09-14 10:14:20', 3267307713708539904, '2024-09-14 10:14:20', 0, 0, NULL, NULL, 0, NULL, NULL, '2024-09-14更新批量下载功能', NULL);
INSERT INTO `version_management` VALUES (194, 113, NULL, 3267307713708539904, 194, '2024-09-14', '01', '2024-09-14-01', 2, NULL, 3267307713708539904, '2024-09-14 10:57:17', 3267307713708539904, '2024-09-14 10:57:17', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (195, 106, NULL, 3267307713708539904, 195, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 09:15:31', 3267307713708539904, '2024-09-19 09:15:31', 0, 0, NULL, NULL, 0, NULL, NULL, '主应用框架打包', NULL);
INSERT INTO `version_management` VALUES (196, 107, NULL, 3267307713708539904, 196, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 09:36:23', 3267307713708539904, '2024-09-19 09:36:23', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试', NULL);
INSERT INTO `version_management` VALUES (197, 108, NULL, 3267307713708539904, 197, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 09:56:22', 3267307713708539904, '2024-09-19 09:56:22', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试', NULL);
INSERT INTO `version_management` VALUES (198, 109, NULL, 3267307713708539904, 198, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 10:21:29', 3267307713708539904, '2024-09-19 10:21:29', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试', NULL);
INSERT INTO `version_management` VALUES (199, 111, NULL, 3267307713708539904, 199, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 10:39:23', 3267307713708539904, '2024-09-19 10:39:23', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试', NULL);
INSERT INTO `version_management` VALUES (200, 112, NULL, 3267307713708539904, 200, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 10:51:48', 3267307713708539904, '2024-09-19 10:51:48', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试:dockerfile', NULL);
INSERT INTO `version_management` VALUES (201, 110, NULL, 3267307713708539904, 201, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 11:12:43', 3267307713708539904, '2024-09-19 11:12:43', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试:dockerfile', NULL);
INSERT INTO `version_management` VALUES (202, 226, NULL, 3267307713708539904, 202, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 11:38:07', 3267307713708539904, '2024-09-19 11:38:07', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试', NULL);
INSERT INTO `version_management` VALUES (203, 113, NULL, 3267307713708539904, 203, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-09-19 14:29:24', 3267307713708539904, '2024-09-19 14:29:24', 0, 0, NULL, NULL, 0, NULL, NULL, '20240919大前端打包调试:dockerfile', NULL);
INSERT INTO `version_management` VALUES (204, 23, NULL, 3426345833549135872, 204, '20240919', '01', '20240919-01', 2, NULL, 3426345833549135872, '2024-09-19 14:39:23', 3426345833549135872, '2024-09-19 14:39:26', 2, 0, NULL, NULL, 0, NULL, NULL, '消费贷产品版本', NULL);
INSERT INTO `version_management` VALUES (205, 144, NULL, 3267307713708539904, 205, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267307713708539904, '2024-09-19 15:03:32', 3267307713708539904, '2024-09-19 15:03:32', 0, 0, NULL, NULL, 0, NULL, NULL, 'init', NULL);
INSERT INTO `version_management` VALUES (206, 286, NULL, 3267292550326501376, 206, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-09-23 14:36:27', 1, '2024-09-23 14:36:27', 0, 0, NULL, NULL, 0, NULL, NULL, 'init', NULL);
INSERT INTO `version_management` VALUES (207, 205, NULL, 3271117585803313152, 207, '20240926', '01', '20240926-01', 2, NULL, 3271117585803313152, '2024-09-23 15:51:47', 3271117585803313152, '2024-09-23 15:51:47', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (208, 97, NULL, 3267307713708539904, 208, '1.0.0', '01', '1.0.0-01', 2, NULL, 1, '2024-09-24 11:04:25', 1, '2024-09-24 11:04:25', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (209, 195, NULL, 3267296873982836736, 209, '1.0.0', '01', '1.0.0-01', 2, NULL, 3267296873982836736, '2024-09-27 15:20:50', 3267296873982836736, '2024-09-27 15:20:50', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (210, 100, NULL, 3267307713708539904, 210, '2024-10-31', '01', '2024-10-31-01', 2, NULL, 3267307713708539904, '2024-10-17 15:23:26', 3267307713708539904, '2024-11-11 16:51:22', 3, 0, NULL, NULL, 0, NULL, NULL, '解决日期问题', '2024-11-11 16:51:22');
INSERT INTO `version_management` VALUES (211, 300, NULL, 3371463290094120960, 211, '06-21', '01', '06-21-01', 2, NULL, 3371463290094120960, '2024-10-23 10:04:11', 3371463290094120960, '2024-10-23 10:04:11', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (212, 300, NULL, 3371463290094120960, 212, '10-23-test', '01', '10-23-test-01', 2, NULL, 3371463290094120960, '2024-10-23 10:11:50', 3371463290094120960, '2024-10-23 10:11:50', 0, 0, NULL, NULL, 0, NULL, NULL, '测试版本', NULL);
INSERT INTO `version_management` VALUES (213, 303, NULL, 3267292550326501376, 213, '10-24-test', '01', '10-24-test-01', 2, NULL, 3267292550326501376, '2024-10-24 08:48:36', 3267292550326501376, '2024-10-24 08:48:36', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (214, 305, NULL, 3369369332493033472, 214, 'mqWsbPlatform-1.0', '01', 'mqWsbPlatform-1.0-01', 2, NULL, 3267292550326501376, '2024-10-28 09:42:22', 3267292550326501376, '2024-10-28 09:44:00', 1, 0, NULL, NULL, 0, NULL, NULL, '网商mq上传版本号', NULL);
INSERT INTO `version_management` VALUES (215, 226, NULL, 3267307713708539904, 215, '2024-10-30', '01', '2024-10-30-01', 2, NULL, 3267307713708539904, '2024-10-30 11:31:52', 3267307713708539904, '2024-10-30 11:31:52', 0, 0, NULL, NULL, 0, NULL, NULL, '大前端打包优化', NULL);
INSERT INTO `version_management` VALUES (216, 308, NULL, 3371463290094120960, 216, '24-11-11', '01', '24-11-11-01', 2, NULL, 3371463290094120960, '2024-11-11 11:01:38', 3371463290094120960, '2024-11-11 11:01:46', 2, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (217, 100, NULL, 3267307713708539904, 217, '2024-11-15', '01', '2024-11-15-01', 2, NULL, 3267307713708539904, '2024-11-11 16:51:47', 3267307713708539904, '2024-11-11 16:51:50', 1, 0, NULL, NULL, 0, NULL, NULL, 'longsql的oa信息接口', NULL);
INSERT INTO `version_management` VALUES (218, 309, NULL, 3369369332493033472, 218, 'loan-report-1.0', '01', 'loan-report-1.0-01', 2, NULL, 3369369332493033472, '2024-11-13 17:43:10', 3369369332493033472, '2024-11-13 17:43:14', 1, 0, NULL, NULL, 0, NULL, NULL, '联合贷报表后端', NULL);
INSERT INTO `version_management` VALUES (219, 310, NULL, 3267307713708539904, 219, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-11-14 09:07:10', 3267307713708539904, '2024-11-14 09:07:14', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (220, 311, NULL, 3369369332493033472, 220, 'risk-report-1.0', '01', 'risk-report-1.0-01', 2, NULL, 3369369332493033472, '2024-11-14 10:26:55', 3369369332493033472, '2024-11-14 11:07:30', 2, 0, NULL, NULL, 0, NULL, NULL, '主版本', NULL);
INSERT INTO `version_management` VALUES (221, 314, NULL, 3271117585803313152, 221, '1.0', '01', '1.0-01', 2, NULL, 3271117585803313152, '2024-11-20 15:55:16', 3271117585803313152, '2024-11-29 17:14:28', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-11-29 17:14:28');
INSERT INTO `version_management` VALUES (222, 315, NULL, 3271117585803313152, 222, '1.0', '01', '1.0-01', 2, NULL, 3271117585803313152, '2024-11-27 20:23:29', 3271117585803313152, '2024-12-16 14:28:58', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-12-16 14:28:58');
INSERT INTO `version_management` VALUES (223, 316, NULL, 3271117585803313152, 223, '1.0', '01', '1.0-01', 2, NULL, 3271117585803313152, '2024-11-27 21:04:54', 3271117585803313152, '2024-12-16 14:29:19', 3, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-12-16 14:29:19');
INSERT INTO `version_management` VALUES (224, 323, NULL, 3267307713708539904, 224, '1.0.1', '01', '1.0.1-01', 2, NULL, 3267307713708539904, '2024-11-28 09:48:48', 3267307713708539904, '2024-11-28 09:48:48', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (225, 323, NULL, 3267307713708539904, 225, '2024-09-19', '01', '2024-09-19-01', 2, NULL, 3267307713708539904, '2024-11-28 10:15:39', 3267307713708539904, '2024-11-28 10:15:39', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (226, 314, NULL, 3271117585803313152, 226, '2.0', '01', '2.0-01', 2, NULL, 3271117585803313152, '2024-11-29 17:14:24', 3271117585803313152, '2024-11-29 17:14:31', 1, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (227, 332, NULL, 3369369332493033472, 227, 'file-1.0', '01', 'file-1.0-01', 2, NULL, 3369369332493033472, '2024-12-13 09:21:58', 3369369332493033472, '2024-12-13 09:21:58', 0, 0, NULL, NULL, 0, NULL, NULL, '文件版本', NULL);
INSERT INTO `version_management` VALUES (228, 315, NULL, 3271117585803313152, 228, '2.0', '01', '2.0-01', 2, NULL, 3271117585803313152, '2024-12-16 14:28:40', 3271117585803313152, '2024-12-16 14:28:53', 2, 0, NULL, NULL, 0, NULL, NULL, NULL, '2024-12-16 14:28:43');
INSERT INTO `version_management` VALUES (229, 316, NULL, 3271117585803313152, 229, '2.0', '01', '2.0-01', 2, NULL, 3271117585803313152, '2024-12-16 14:29:16', 3271117585803313152, '2024-12-16 14:29:22', 2, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (230, 94, NULL, 3267307713708539904, 230, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2024-12-25 09:38:08', 3267307713708539904, '2024-12-25 09:38:08', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (231, 94, NULL, 3267307713708539904, 231, '3.0.0', '01', '3.0.0-01', 2, NULL, 3267307713708539904, '2024-12-25 11:29:35', 3267307713708539904, '2024-12-25 11:29:35', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (232, 317, NULL, 3271117585803313152, 232, '1.0', '01', '1.0-01', 2, NULL, 3271117585803313152, '2024-12-27 10:01:50', 3271117585803313152, '2024-12-27 10:01:56', 2, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (233, 95, NULL, 3267307713708539904, 233, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-03 09:02:01', 3267307713708539904, '2025-01-03 09:02:01', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (234, 100, NULL, 3267307713708539904, 234, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-03 09:05:09', 3267307713708539904, '2025-01-03 09:05:09', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (235, 10, NULL, 3271125133872791552, 235, '2025.01.06', '01', '2025.01.06-01', 2, NULL, 3271125133872791552, '2025-01-06 14:37:29', 3271125133872791552, '2025-01-06 14:37:29', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (236, 96, NULL, 3267307713708539904, 236, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-06 15:36:20', 3267307713708539904, '2025-01-06 15:36:20', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (237, 97, NULL, 3267307713708539904, 237, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-06 16:52:35', 3267307713708539904, '2025-01-06 16:52:35', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (238, 98, NULL, 3267307713708539904, 238, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 10:21:30', 3267307713708539904, '2025-01-07 10:21:30', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (239, 99, NULL, 3267307713708539904, 239, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 15:39:48', 3267307713708539904, '2025-01-07 15:39:48', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (240, 101, NULL, 3267307713708539904, 240, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 15:45:02', 3267307713708539904, '2025-01-07 15:45:02', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (241, 102, NULL, 3267307713708539904, 241, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 16:01:20', 3267307713708539904, '2025-01-07 16:01:20', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (242, 103, NULL, 3267307713708539904, 242, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 16:12:54', 3267307713708539904, '2025-01-07 16:12:54', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (243, 104, NULL, 3267307713708539904, 243, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 16:16:56', 3267307713708539904, '2025-01-07 16:16:56', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (244, 105, NULL, 3267307713708539904, 244, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-07 16:20:35', 3267307713708539904, '2025-01-07 16:20:35', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (245, 336, NULL, 3267307713708539904, 245, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:11:36', 3267307713708539904, '2025-01-09 15:11:36', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (246, 335, NULL, 3267307713708539904, 246, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:12:31', 3267307713708539904, '2025-01-09 15:12:31', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (247, 310, NULL, 3267307713708539904, 247, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:15:28', 3267307713708539904, '2025-01-09 15:15:28', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (248, 226, NULL, 3267307713708539904, 248, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:16:11', 3267307713708539904, '2025-01-09 15:16:11', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (249, 114, NULL, 3267307713708539904, 249, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:16:26', 3267307713708539904, '2025-01-09 15:16:26', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (250, 113, NULL, 3267307713708539904, 250, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:17:02', 3267307713708539904, '2025-01-09 15:17:02', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (251, 112, NULL, 3267307713708539904, 251, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:19:26', 3267307713708539904, '2025-01-09 15:19:26', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (252, 111, NULL, 3267307713708539904, 252, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:23:58', 3267307713708539904, '2025-01-09 15:23:58', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (253, 110, NULL, 3267307713708539904, 253, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-09 15:29:54', 3267307713708539904, '2025-01-09 15:29:54', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (254, 109, NULL, 3267307713708539904, 254, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-10 14:00:09', 3267307713708539904, '2025-01-10 14:00:09', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (255, 108, NULL, 3267307713708539904, 255, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-10 14:03:09', 3267307713708539904, '2025-01-10 14:03:09', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (256, 107, NULL, 3267307713708539904, 256, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-10 14:04:37', 3267307713708539904, '2025-01-10 14:04:37', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `version_management` VALUES (257, 106, NULL, 3267307713708539904, 257, '4.0.2', '01', '4.0.2-01', 2, NULL, 3267307713708539904, '2025-01-10 14:08:50', 3267307713708539904, '2025-01-10 14:08:50', 0, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for version_promotion
-- ----------------------------
DROP TABLE IF EXISTS `version_promotion`;
CREATE TABLE `version_promotion`  (
  `version_instance_id` bigint(0) NULL DEFAULT NULL COMMENT '版本实例id，外键（version_instance.id）',
  `promotion_strategy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '晋级策略'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本实例晋级策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of version_promotion
-- ----------------------------
INSERT INTO `version_promotion` VALUES (1, '3,4,5');
INSERT INTO `version_promotion` VALUES (2, '3,4,5');
INSERT INTO `version_promotion` VALUES (3, '3,4,5');
INSERT INTO `version_promotion` VALUES (4, '3,4,5');
INSERT INTO `version_promotion` VALUES (5, '3,4,5');
INSERT INTO `version_promotion` VALUES (6, '3,4,5');
INSERT INTO `version_promotion` VALUES (7, '3,4,5');
INSERT INTO `version_promotion` VALUES (8, '3,4,5');
INSERT INTO `version_promotion` VALUES (9, '3,4,5');
INSERT INTO `version_promotion` VALUES (10, '3,4,5');
INSERT INTO `version_promotion` VALUES (11, '3,4,5');
INSERT INTO `version_promotion` VALUES (12, '3,4,5');
INSERT INTO `version_promotion` VALUES (13, '3,4,5');
INSERT INTO `version_promotion` VALUES (14, '3,4,5');
INSERT INTO `version_promotion` VALUES (15, '3,4,5');
INSERT INTO `version_promotion` VALUES (16, '3,4,5');
INSERT INTO `version_promotion` VALUES (17, '3,4,5');
INSERT INTO `version_promotion` VALUES (18, '3,4,5');
INSERT INTO `version_promotion` VALUES (19, '3,4,5');
INSERT INTO `version_promotion` VALUES (20, '3,4,5');
INSERT INTO `version_promotion` VALUES (21, '3,4,5');
INSERT INTO `version_promotion` VALUES (22, '3,4,5');
INSERT INTO `version_promotion` VALUES (23, '3,4,5');
INSERT INTO `version_promotion` VALUES (24, '3,4,5');
INSERT INTO `version_promotion` VALUES (25, '3,4,5');
INSERT INTO `version_promotion` VALUES (26, '3,4,5');
INSERT INTO `version_promotion` VALUES (27, '3,4,5');
INSERT INTO `version_promotion` VALUES (28, '3,4,5');
INSERT INTO `version_promotion` VALUES (29, '3,4,5');
INSERT INTO `version_promotion` VALUES (30, '3,4,5');
INSERT INTO `version_promotion` VALUES (31, '3,4,5');
INSERT INTO `version_promotion` VALUES (32, '3,4,5');
INSERT INTO `version_promotion` VALUES (33, '3,4,5');
INSERT INTO `version_promotion` VALUES (34, '3,4,5');
INSERT INTO `version_promotion` VALUES (35, '3,4,5');
INSERT INTO `version_promotion` VALUES (36, '3,4,5');
INSERT INTO `version_promotion` VALUES (37, '3,4,5');
INSERT INTO `version_promotion` VALUES (38, '3,4,5');
INSERT INTO `version_promotion` VALUES (39, '3,4,5');
INSERT INTO `version_promotion` VALUES (40, '3,4,5');
INSERT INTO `version_promotion` VALUES (41, '3,4,5');
INSERT INTO `version_promotion` VALUES (42, '3,4,5');
INSERT INTO `version_promotion` VALUES (43, '3,4,5');
INSERT INTO `version_promotion` VALUES (44, '3,4,5');
INSERT INTO `version_promotion` VALUES (45, '3,4,5');
INSERT INTO `version_promotion` VALUES (46, '3,4,5');
INSERT INTO `version_promotion` VALUES (47, '3,4,5');
INSERT INTO `version_promotion` VALUES (48, '3,4,5');
INSERT INTO `version_promotion` VALUES (49, '3,4,5');
INSERT INTO `version_promotion` VALUES (50, '3,4,5');

SET FOREIGN_KEY_CHECKS = 1;
