/*
 Navicat Premium Data Transfer

 Source Server         : 虚拟机-mysql容器
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : 172.20.10.3:33060
 Source Schema         : health

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 15/12/2025 16:55:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for health_form_submissions
-- ----------------------------
DROP TABLE IF EXISTS `health_form_submissions`;
CREATE TABLE `health_form_submissions`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `submission_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提交ID，用于跟踪',
  `age` int(0) NOT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `height` int(0) NOT NULL,
  `weight` decimal(5, 2) NOT NULL,
  `goal_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `goal_value` decimal(5, 2) NOT NULL,
  `goal_time` int(0) NOT NULL,
  `daily_time` int(0) NOT NULL,
  `kitchen_condition` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `facility` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `experience` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户邮箱地址',
  `status` enum('pending','processing','completed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '处理状态',
  `created_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `processed_at` timestamp(0) NULL DEFAULT NULL COMMENT '处理完成时间',
  `result_html` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '最终HTML结果',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `submission_id`(`submission_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_submission_id`(`submission_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '健康表单提交数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_form_submissions
-- ----------------------------
INSERT INTO `health_form_submissions` VALUES (6, 'sub_1765250877304_imzblyiaz', 31, '女', 161, 58.00, '减肥', 50.00, 16, 60, '综合', '综合', '有经验', '1653048116@qq.com', 'completed', '2025-12-08 19:27:57', '2025-12-10 22:56:14', NULL, NULL, NULL);
INSERT INTO `health_form_submissions` VALUES (7, 'sub_1765430415117_pjggrl6w6', 44, '女', 164, 59.00, '减肥', 55.00, 8, 30, '综合', '居家', '没经验', 'luzt@VIP.qq.com', 'completed', '2025-12-10 21:20:15', '2025-12-10 22:56:11', NULL, NULL, NULL);
INSERT INTO `health_form_submissions` VALUES (8, 'sub_1765430907403_gc1kquc5b', 36, '男', 178, 70.00, '增肌', 72.00, 12, 60, '外卖为主', '健身房', '经验丰富', '595711564@qq.com', 'completed', '2025-12-10 21:28:27', '2025-12-10 22:55:56', NULL, NULL, NULL);
INSERT INTO `health_form_submissions` VALUES (9, 'sub_1765464098133_3gz1igbcd', 53, '女', 156, 65.00, '减肥', 58.00, 12, 60, '自己做饭', '户外', '没经验', '69567149@qq.com', 'completed', '2025-12-11 06:41:38', '2025-12-11 06:46:21', NULL, NULL, NULL);
INSERT INTO `health_form_submissions` VALUES (10, 'sub_1765586286702_txccrlzkl', 53, '女', 158, 47.50, '增肌', 52.50, 26, 60, '自己做饭', '综合', '有经验', '545999248@qq.com', 'completed', '2025-12-12 16:38:06', '2025-12-12 16:41:53', NULL, NULL, NULL);
INSERT INTO `health_form_submissions` VALUES (11, 'sub_1765609248748_g0jtc36fx', 52, '女', 152, 45.00, '增肌', 50.00, 12, 60, '自己做饭', '综合', '没经验', '1418558769@qq.com', 'completed', '2025-12-12 23:00:49', '2025-12-12 23:05:13', NULL, NULL, NULL);
INSERT INTO `health_form_submissions` VALUES (12, 'sub_1765609619575_4ttpn33p1', 53, '女', 165, 72.50, '减肥', 67.50, 16, 60, '自己做饭', '综合', '有经验', '752896603@qq.com', 'completed', '2025-12-12 23:06:59', '2025-12-12 23:11:29', NULL, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
