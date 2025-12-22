/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_knowledge

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 14/01/2025 17:11:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for knowledge_comment
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_comment`;
CREATE TABLE `knowledge_comment`  (
  `ID` bigint(0) NOT NULL COMMENT ' 主键ID ',
  `document_id` bigint(0) NOT NULL COMMENT ' 文件ID ',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT ' 评论内容 ',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT ' 评论父级id ',
  `create_time` datetime(0) NOT NULL COMMENT ' 创建时间 ',
  `update_time` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 创建人 ',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 更新人 ',
  `user_id` bigint(0) NOT NULL DEFAULT 0 COMMENT ' 创建人ID',
  `del_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ' 删除标记：1已删除，0正常 ',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_comment
-- ----------------------------

-- ----------------------------
-- Table structure for knowledge_directory
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_directory`;
CREATE TABLE `knowledge_directory`  (
  `id` bigint(0) NOT NULL COMMENT ' 主键ID ',
  `space_id` bigint(0) NOT NULL COMMENT ' 空间id ',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 名称 ',
  `unique_key` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 唯一键 ',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT ' 父类id ',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT ' 排序号 ',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT ' 备注 ',
  `status` tinyint(0) NOT NULL DEFAULT 1 COMMENT ' 状态 1-正常 2-回收站 ',
  `create_time` datetime(0) NOT NULL COMMENT ' 创建时间 ',
  `update_time` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 创建人 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 更新人 ',
  `user_id` bigint(0) NOT NULL DEFAULT 0 COMMENT ' 创建人ID',
  `del_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ' 逻辑删除 0正常 1删除 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文档目录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_directory
-- ----------------------------
INSERT INTO `knowledge_directory` VALUES (3627765220867952640, 3395721324604301312, 'DevOps二次开发', '/DevOps二次开发', 0, 1, '', 1, '2024-11-07 16:20:57', '2024-12-21 15:44:49', '王洺藤', '系统用户', 3267307713708539904, 0);
INSERT INTO `knowledge_directory` VALUES (3634893682342744064, 3395721324604301312, '研发需求', '研发需求', 0, 1, NULL, 1, '2024-11-12 14:22:27', '2024-12-21 15:44:49', '王洺藤', '系统用户', 3267307713708539904, 0);

-- ----------------------------
-- Table structure for knowledge_document
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document`;
CREATE TABLE `knowledge_document`  (
  `id` bigint(0) NOT NULL COMMENT ' 主键ID ',
  `space_id` bigint(0) NOT NULL COMMENT ' 空间id ',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 名称 ',
  `directory_id` bigint(0) NOT NULL DEFAULT 0 COMMENT ' 文件夹id ',
  `size` bigint(0) NULL DEFAULT 0 COMMENT '文件大小 单位字节',
  `unique_key` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 唯一键 ',
  `file_type` tinyint(0) NOT NULL COMMENT ' 文件类型 1-文件 2-文档模版 ',
  `sort_id` smallint(0) NOT NULL DEFAULT 1 COMMENT ' 排序号 ',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT ' 备注 ',
  `status` tinyint(0) NOT NULL DEFAULT 1 COMMENT ' 状态 1-正常 2-回收站 ',
  `create_time` datetime(0) NOT NULL COMMENT ' 创建时间 ',
  `update_time` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 创建人 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 更新人 ',
  `user_id` bigint(0) NOT NULL DEFAULT 0 COMMENT ' 创建人ID',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT ' 乐观锁 ',
  `del_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ' 逻辑删除 0正常 1删除 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文档表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_document
-- ----------------------------
INSERT INTO `knowledge_document` VALUES (3291053510067277824, 3290041438068068352, '这是一个文件.docx', 0, 0, '这是一个文件3291053510067277824.docx', 1, 1, NULL, 1, '2024-03-20 09:27:55', '2024-12-21 15:44:49', '超级管理员', '系统用户', 1, 0, 0);
INSERT INTO `knowledge_document` VALUES (3362400165433233408, 3290018604713299968, 'Clc导入 (4).xlsx', 0, 9438, 'Clc导入 (4)3362400165433233408.xlsx', 1, 1, NULL, 1, '2024-05-08 14:44:27', '2024-12-21 15:44:49', '超级管理员', '系统用户', 1, 0, 0);
INSERT INTO `knowledge_document` VALUES (3627765828119285760, 3395721324604301312, 'devops-ai大模型-二次开发-后端.docx', 3627765220867952640, 0, 'DevOps二次开发/devops-ai大模型-二次开发-后端3627765828119285760.docx', 1, 1, NULL, 1, '2024-11-07 16:21:34', '2024-12-21 15:44:49', '王洺藤', '系统用户', 3267307713708539904, 0, 0);
INSERT INTO `knowledge_document` VALUES (3634893682544070656, 3395721324604301312, 'devops-oa接口文档.md', 3634893682342744064, 6396, '研发需求/devops-oa接口文档.md', 1, 1, NULL, 2, '2024-11-12 14:22:27', '2024-12-21 15:44:49', '王洺藤', '系统用户', 3267307713708539904, 0, 0);
INSERT INTO `knowledge_document` VALUES (3634898131610095616, 3395721324604301312, 'devops-pa接口文档.docx', 3634893682342744064, 13570, '研发需求/devops-pa接口文档.docx', 1, 1, NULL, 2, '2024-11-12 14:26:52', '2024-12-21 15:44:49', '王洺藤', '系统用户', 3267307713708539904, 0, 0);
INSERT INTO `knowledge_document` VALUES (3634908040888176640, 3395721324604301312, 'Devops前端项目启动注意事项.docx', 3627765220867952640, 12536, 'DevOps二次开发/Devops前端项目启动注意事项3634908040888176640.docx', 1, 1, NULL, 2, '2024-11-12 14:36:43', '2024-12-21 15:44:49', '徐逸凡', '系统用户', 3271122670088290304, 0, 0);
INSERT INTO `knowledge_document` VALUES (3634916225653002240, 3395721324604301312, 'DevOps前端项目启动注意事项.docx', 3627765220867952640, 10620, 'DevOps二次开发/DevOps前端项目启动注意事项3634916225653002240.docx', 1, 1, NULL, 2, '2024-11-12 14:44:50', '2024-12-21 15:44:49', '徐逸凡', '系统用户', 3271122670088290304, 0, 0);
INSERT INTO `knowledge_document` VALUES (3636021741779275776, 3395721324604301312, 'devops-oa接口文档.docx', 3634893682342744064, 23378, '研发需求/devops-oa接口文档.docx', 1, 1, NULL, 1, '2024-11-13 09:03:04', '2024-12-21 15:44:49', '王洺藤', '系统用户', 3267307713708539904, 0, 0);
INSERT INTO `knowledge_document` VALUES (3637793225468137472, 3395721324604301312, 'DevOps前端项目启动注意事项.docx', 3627765220867952640, 10860, 'DevOps二次开发/DevOps前端项目启动注意事项3637793225468137472.docx', 1, 1, NULL, 1, '2024-11-14 14:22:53', '2024-12-21 15:44:49', '徐逸凡', '系统用户', 3271122670088290304, 0, 0);

-- ----------------------------
-- Table structure for knowledge_space
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_space`;
CREATE TABLE `knowledge_space`  (
  `id` bigint(0) NOT NULL COMMENT ' 自增ID ',
  `project_id` bigint(0) NULL DEFAULT NULL COMMENT ' 关联项目id ',
  `space_type` tinyint(1) NOT NULL COMMENT ' 权限类型，1-公开：2-私有 ',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT ' 文档空间 ',
  `bucket` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT ' 桶名称 ',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 空间描述 ',
  `create_time` datetime(0) NOT NULL COMMENT ' 创建时间 ',
  `update_time` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 创建人 ',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 更新人 ',
  `del_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ' 逻辑删除 0正常 1删除 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文档空间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_space
-- ----------------------------
INSERT INTO `knowledge_space` VALUES (-1, 0, 1, '模版', 'application', NULL, '2024-04-16 16:10:00', '2024-04-16 16:10:00', NULL, NULL, 0);
INSERT INTO `knowledge_space` VALUES (3290018602398044160, 1, 2, 'devops项目', 'devopsxiangmu', NULL, '2024-03-19 16:19:50', '2024-03-19 16:19:50', '系统用户', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3290018604646191104, 2, 2, '某商银行项目', 'moushangyinxingxiangmu', NULL, '2024-03-19 16:19:50', '2024-03-19 16:19:50', '系统用户', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3290018604713299968, 3, 2, '项目1', 'xiangmu1', NULL, '2024-03-19 16:19:50', '2024-03-19 16:19:50', '系统用户', '系统用户', 1);
INSERT INTO `knowledge_space` VALUES (3290041438068068352, 4, 2, 'project-2', 'project-2', NULL, '2024-03-19 16:42:31', '2024-03-19 16:42:31', 'admin', 'admin', 1);
INSERT INTO `knowledge_space` VALUES (3292519083032760320, 5, 2, 'jj', 'jj-38352614', NULL, '2024-03-21 09:43:50', '2024-03-21 09:43:50', 'dm', 'dm', 1);
INSERT INTO `knowledge_space` VALUES (3292828173978095616, 6, 2, 'test', 'test', NULL, '2024-03-21 14:50:54', '2024-03-21 14:50:54', 'admin', 'admin', 1);
INSERT INTO `knowledge_space` VALUES (3304524510742237184, 7, 2, 'portalsite', 'portalsite', NULL, '2024-03-29 16:30:10', '2024-12-21 15:44:49', '王洺藤', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3319071251642503168, 8, 2, 'tysfrzsystem', 'tysfrzsystem', NULL, '2024-04-08 17:21:03', '2024-04-08 17:21:03', 'admin', 'admin', 1);
INSERT INTO `knowledge_space` VALUES (3320428251911606272, 9, 2, 'identityauthsystem', 'identityauthsystem', NULL, '2024-04-09 15:49:06', '2024-12-21 15:44:49', '超级管理员', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3320430216943030272, 10, 2, 'creditsystem', 'creditsystem', NULL, '2024-04-09 15:51:04', '2024-12-21 15:44:49', '超级管理员', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3334988627370102784, 11, 2, 'experience', 'experience', NULL, '2024-04-19 16:53:32', '2024-12-21 15:44:49', '超级管理员', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3342288502113751040, 12, 2, 'wwfdd', 'wwfdd', NULL, '2024-04-24 17:45:19', '2024-12-21 15:44:49', '夏露', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3350792244177981440, 13, 2, 'oaProject', 'oaproject', NULL, '2024-04-30 14:33:01', '2024-12-21 15:44:49', '王华', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3362036111254540288, 14, 2, 'ERIMS', 'erims', NULL, '2024-05-08 08:42:48', '2024-05-08 08:42:48', 'wangzhen', 'wangzhen', 1);
INSERT INTO `knowledge_space` VALUES (3367011847644172288, 16, 2, 'ModleMonitor', 'modlemonitor', NULL, '2024-05-11 19:05:45', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3367012307910316032, 17, 2, 'ChinaPostConsumerFinance', 'chinapostconsumerfinance', NULL, '2024-05-11 19:06:13', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3369325428029050880, 18, 2, 'aggreated-marketing', 'aggreated-marketing', NULL, '2024-05-13 09:24:05', '2024-12-21 15:44:49', '夏露', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3385390561400856576, 19, 2, 'nxzx', 'nxzx', NULL, '2024-05-24 11:23:22', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3385431117854285824, 20, 2, 'dacc', 'dacc', NULL, '2024-05-24 12:03:39', '2024-05-24 12:03:39', 'xiewenjun', 'xiewenjun', 1);
INSERT INTO `knowledge_space` VALUES (3385444549844410368, 21, 2, 'dacc', 'dacc', NULL, '2024-05-24 12:17:00', '2024-05-24 12:17:00', 'xiewenjun', 'xiewenjun', 1);
INSERT INTO `knowledge_space` VALUES (3385573802774765568, 22, 2, 'lljq', 'lljq', NULL, '2024-05-24 14:25:24', '2024-12-21 15:44:49', '张子恒', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3390055526942515200, 23, 2, 'graph-platform', 'graph-platform', NULL, '2024-05-27 16:37:35', '2024-12-21 15:44:49', '杨林', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3390063787037040640, 24, 2, 'decision-engine', 'decision-engine', NULL, '2024-05-27 16:45:48', '2024-12-21 15:44:49', '杨林', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3390065182666530816, 25, 2, 'kcjrcpyf', 'kcjrcpyf', NULL, '2024-05-27 16:47:11', '2024-12-21 15:44:49', '杨林', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392623073441226752, 26, 2, 'Data-center', 'data-center', NULL, '2024-05-29 11:08:13', '2024-12-21 15:44:49', '范群松', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392643810029871104, 27, 2, 'Certificate-storage-platform', 'certificate-storage-platform', NULL, '2024-05-29 11:28:49', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392651578216423424, 28, 2, 'Little-Bee-Porject', 'little-bee-porject', NULL, '2024-05-29 11:36:32', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392660802967314432, 29, 2, 'psbs', 'psbs', NULL, '2024-05-29 11:45:42', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392664291839713280, 30, 2, 'Tobacco-report', 'tobacco-report', NULL, '2024-05-29 11:49:10', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392667184886063104, 31, 2, 'Wuwei-Huiyin-Phase-II', 'wuwei-huiyin-phase-ii', NULL, '2024-05-29 11:52:02', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392668870593617920, 32, 2, 'Post-Warning-Model', 'post-warning-model', NULL, '2024-05-29 11:53:43', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3392670665587957760, 33, 2, 'gicisp', 'gicisp', NULL, '2024-05-29 11:55:30', '2024-12-21 15:44:49', '崔佩瑄', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3395515594026655744, 34, 2, 'dacc', 'dacc', NULL, '2024-05-31 11:01:41', '2024-12-21 15:44:49', '谢汶君', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3395721324604301312, 35, 2, 'ahc-devops', 'ahc-devops', NULL, '2024-05-31 14:26:03', '2024-12-21 15:44:49', '王洺藤', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3396970885394079744, 36, 2, 'precision-marketing', 'precision-marketing', NULL, '2024-06-01 11:07:23', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397031112025972736, 37, 2, 'bxy-platform', 'bxy-platform', NULL, '2024-06-01 12:07:13', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397051167711305728, 38, 2, 'icbc-digital-risk-control', 'icbc-digital-risk-control', NULL, '2024-06-01 12:27:08', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397177462365495296, 39, 2, 'psbc-digital-operation-3', 'psbc-digital-operation-3', NULL, '2024-06-01 14:32:36', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397282545283506176, 40, 2, 'boc-eph-2', 'boc-eph-2', NULL, '2024-06-01 16:16:59', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397373298831663104, 41, 2, 'ahnydb-guarantee-quantification-risk-control-model-2', 'ahnydb-guarantee-quantification-risk-control-model-2', NULL, '2024-06-01 17:47:09', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397396649495109632, 42, 2, 'abc-hf-credit-credit-service', 'abc-hf-credit-credit-service', NULL, '2024-06-01 18:10:20', '2024-06-01 18:10:20', 'chenmo', 'chenmo', 1);
INSERT INTO `knowledge_space` VALUES (3397397711392219136, 43, 2, 'abc-hf-credit-service', 'abc-hf-credit-service', NULL, '2024-06-01 18:11:24', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3397410143107948544, 44, 2, 'psbc-three-agricultures-digital-risk-control', 'psbc-three-agricultures-digital-risk-control', NULL, '2024-06-01 18:23:45', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401213836307603456, 45, 2, 'Comprehensive-financial-services', 'comprehensive-financial-services', NULL, '2024-06-04 09:22:23', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401222466960498688, 46, 2, 'Bb-Comprehensive-financial-service', 'bb-comprehensive-financial-service', NULL, '2024-06-04 09:30:57', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401232266314260480, 47, 2, 'Factoring-Business-Management-System', 'factoring-business-management-system', NULL, '2024-06-04 09:40:41', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401236786381463552, 48, 2, 'Mengcheng-Information-service', 'mengcheng-information-service', NULL, '2024-06-04 09:45:10', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401241804295774208, 49, 2, 'Hainan-Credit-Information-Database-System', 'hainan-credit-information-database-system', NULL, '2024-06-04 09:50:10', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401245401414770688, 50, 2, 'Huainan-Comprehensive-Financial-Service', 'huainan-comprehensive-financial-service', NULL, '2024-06-04 09:53:44', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401246991659966464, 51, 2, 'Anhui-Financial-Brain', 'anhui-financial-brain', NULL, '2024-06-04 09:55:19', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401249637460484096, 52, 2, 'Suzhou-Upgrade-Operation-Service', 'suzhou-upgrade-operation-service', NULL, '2024-06-04 09:57:56', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401252954685186048, 53, 2, 'Tongling-Upgrade-Operation-service', 'tongling-upgrade-operation-service', NULL, '2024-06-04 10:01:14', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401600971590213632, 55, 2, 'Liuan-Comprehensive-Financial-Service', 'liuan-comprehensive-financial-service', NULL, '2024-06-04 15:46:58', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401603185360642048, 56, 2, 'Huangshan-Comprehensive-Financial', 'huangshan-comprehensive-financial', NULL, '2024-06-04 15:49:10', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401605857836933120, 57, 2, 'Xuancheng-Comprehensive-Financial-Service', 'xuancheng-comprehensive-financial-service', NULL, '2024-06-04 15:51:49', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401609981844398080, 58, 2, 'Maanshan-Comprehensive-Financial-Service', 'maanshan-comprehensive-financial-service', NULL, '2024-06-04 15:55:55', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401611733167644672, 59, 2, 'Chizhou-Comprehensive-Financial-Service', 'chizhou-comprehensive-financial-service', NULL, '2024-06-04 15:57:39', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3401619265399431168, 60, 2, 'Bozhou-Comprehensive-Financial-Service', 'bozhou-comprehensive-financial-service', NULL, '2024-06-04 16:05:08', '2024-12-21 15:44:49', '杨彬', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3421861799108661248, 61, 2, 'xinlian-zhengxin-business', 'xinlian-zhengxin-business', NULL, '2024-06-18 15:14:17', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3421869094597152768, 62, 2, 'xinlian-zhengxin-openplatform', 'xinlian-zhengxin-openplatform', NULL, '2024-06-18 15:21:32', '2024-12-21 15:44:49', '陈默', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3431756924819460096, 63, 2, 'dtgc-mc', 'dtgc-mc', NULL, '2024-06-25 11:04:12', '2024-12-21 15:44:49', '何大伟', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3431757796899147776, 64, 2, 'dtg', 'dtg', NULL, '2024-06-25 11:05:04', '2024-12-21 15:44:49', '何大伟', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3431758143801643008, 65, 2, 'djylxyc', 'djylxyc', NULL, '2024-06-25 11:05:25', '2024-12-21 15:44:49', '何大伟', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3433127052823875584, 66, 2, 'gjj-jrjg', 'gjj-jrjg', NULL, '2024-06-26 09:45:18', '2024-12-21 15:44:49', '何大伟', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3544810429095727104, 67, 2, 'jft', 'jft', NULL, '2024-09-11 10:52:46', '2024-12-21 15:44:49', '夏露', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3548035715962621952, 68, 2, 'InformationInteSys', 'informationintesys', NULL, '2024-09-13 16:16:49', '2024-12-21 15:44:49', '超级管理员', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3594501722654494720, 69, 2, 'outsideWork-support', 'outsidework-support', NULL, '2024-10-15 17:36:38', '2024-12-21 15:44:49', '王洺藤', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3617180189862776832, 70, 2, 'bzdb', 'bzdb', NULL, '2024-10-31 09:05:40', '2024-12-21 15:44:49', '王洺藤', '系统用户', 0);
INSERT INTO `knowledge_space` VALUES (3694055459738324992, 71, 2, 'test', 'test', NULL, '2024-12-23 09:54:23', '2024-12-23 09:54:23', '超级管理员', '超级管理员', 0);
INSERT INTO `knowledge_space` VALUES (3694056019862458368, 72, 2, 'df', 'df-4afd658f', NULL, '2024-12-23 09:54:57', '2024-12-23 09:54:57', '超级管理员', '超级管理员', 0);
INSERT INTO `knowledge_space` VALUES (3726261266689003520, 73, 2, 'test0114', 'test0114', NULL, '2025-01-14 15:07:59', '2025-01-14 15:07:59', '超级管理员', '超级管理员', 0);

-- ----------------------------
-- Table structure for knowledge_template
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_template`;
CREATE TABLE `knowledge_template`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint(0) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` int(0) NOT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `del_flag` int(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_template
-- ----------------------------

-- ----------------------------
-- Table structure for knowledge_user_collect
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_user_collect`;
CREATE TABLE `knowledge_user_collect`  (
  `ID` bigint(0) NOT NULL COMMENT ' 主键ID ',
  `document_id` bigint(0) NOT NULL COMMENT ' 文件ID ',
  `user_id` bigint(0) NOT NULL COMMENT ' 作者ID ',
  `create_time` datetime(0) NOT NULL COMMENT ' 创建时间 ',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' 创建人 ',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_user_collect
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
