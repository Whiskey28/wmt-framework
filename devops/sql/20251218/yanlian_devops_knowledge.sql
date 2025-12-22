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

 Date: 18/12/2025 14:31:22
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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

SET FOREIGN_KEY_CHECKS = 1;
