/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.15.107-prod-mysql8
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 192.168.15.107:32283
 Source Schema         : yanlian_devops_trustworthy

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 18/12/2025 14:31:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for code_repo_history_rel
-- ----------------------------
DROP TABLE IF EXISTS `code_repo_history_rel`;
CREATE TABLE `code_repo_history_rel`  (
  `id` bigint(0) NOT NULL,
  `code_repo_id` bigint(0) NOT NULL COMMENT '代码仓库ID',
  `history_id` bigint(0) NOT NULL COMMENT '扫描历史ID',
  `branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分支',
  `commit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分支最新提交commit id',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `del_flag` tinyint(0) NULL DEFAULT 0,
  `version` int(0) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `create_by` bigint(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码库与扫描历史关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_app
-- ----------------------------
DROP TABLE IF EXISTS `devops_app`;
CREATE TABLE `devops_app`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `APP_NAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '应用名',
  `APP_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '应用类型，0->JAVA，1->JAVA_SCRIPT，2->GO，3->PYTHON',
  `APP_SOURCE` tinyint(0) NULL DEFAULT NULL COMMENT '应用来源，0->本系统页面，1->流水线，2->GO，3->代码仓库',
  `APP_VERSION` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '应用版本',
  `DEL_FLAG` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标记',
  `VERSION` int(0) NULL DEFAULT 0 COMMENT '版本',
  `TENANT_ID` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `CREATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `UPDATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `HASH` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件hash值',
  `CODE_REPO_ID` bigint(0) NULL DEFAULT NULL COMMENT '代码仓库id',
  `STATUS` tinyint(1) NULL DEFAULT NULL COMMENT '扫描状态，0：未扫描，1：扫描中，2：扫描结束，3：扫描失败',
  `RESULT` tinyint(1) NULL DEFAULT NULL COMMENT '扫描门禁结果，0：未通过，1：通过',
  `SUB_SYSTEM_ID` bigint(0) NULL DEFAULT NULL COMMENT '子系统ID',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `devops_app_DEL_FLAG_TENANT_ID_index`(`DEL_FLAG`, `TENANT_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4021932838047154177 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_app_dp_relation
-- ----------------------------
DROP TABLE IF EXISTS `devops_app_dp_relation`;
CREATE TABLE `devops_app_dp_relation`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `APP_HISTORY_ID` bigint(0) NULL DEFAULT NULL COMMENT '应用扫描历史ID',
  `DP_DETAIL_ID` bigint(0) NULL DEFAULT NULL COMMENT '依赖ID',
  `PARENT_ID` bigint(0) NULL DEFAULT NULL COMMENT '父依赖ID',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `devops_app_dp_relation_APP_HISTORY_ID_index`(`APP_HISTORY_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3899981444537231571 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用依赖关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_app_scan_history
-- ----------------------------
DROP TABLE IF EXISTS `devops_app_scan_history`;
CREATE TABLE `devops_app_scan_history`  (
  `ID` bigint(0) NOT NULL,
  `APP_ID` bigint(0) NOT NULL,
  `SCAN_NUM` int(0) NULL DEFAULT NULL COMMENT '扫描次数',
  `STATUS` tinyint(0) NULL DEFAULT 0 COMMENT '扫描状态，0-未扫描，1-扫描中，2-扫描完成，3-扫描失败',
  `RESULT` tinyint(0) NULL DEFAULT 0 COMMENT '门禁是否通过，0-未通过，1-通过',
  `GATE_COMPARE_MSG` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '门禁对比信息',
  `DEL_FLAG` tinyint(0) NULL DEFAULT 0,
  `VERSION` int(0) NULL DEFAULT 0,
  `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `UPDATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `CREATE_BY` bigint(0) NULL DEFAULT NULL,
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL,
  `PIPELINE_RECORD_ID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流水线构建id',
  `deep_analysis` tinyint(1) NULL DEFAULT 1 COMMENT '1:深层分析（间接依赖），0：浅层分析（直接依赖）',
  `cost_time` bigint(0) NULL DEFAULT NULL COMMENT '扫描耗时',
  `trigger_type` tinyint(0) NULL DEFAULT NULL COMMENT '触发类型(1,流水线)',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '依赖扫描历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `devops_blacklist`;
CREATE TABLE `devops_blacklist`  (
  `ID` bigint(0) NOT NULL,
  `DP_NAMESPACE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `DP_NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `EXACT_VERSION` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '精确匹配版本',
  `START_VERSION` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区间开始版本',
  `START_TYPE` tinyint(1) NULL DEFAULT NULL COMMENT '区间开始开闭类型0：闭，1：开',
  `END_VERSION` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区间结束版本',
  `END_TYPE` tinyint(1) NULL DEFAULT NULL COMMENT '区间结束开闭类型0：闭，1：开',
  `TENANT_ID` bigint(0) NULL DEFAULT NULL,
  `DEL_FLAG` tinyint(0) NULL DEFAULT 0,
  `VERSION` int(0) NULL DEFAULT 0 COMMENT '版本',
  `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `UPDATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `CREATE_BY` bigint(0) NULL DEFAULT NULL,
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL,
  `SOURCE` tinyint(1) NULL DEFAULT NULL COMMENT '添加来源,0-手动添加,1-依赖列表拉黑',
  `REASON` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '黑名单原因',
  `MD5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'md5(namespace+name+exactversion+startType+startVersion+endType+endVersion),用于去重',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_blacklist_unique_idx`(`MD5`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '依赖黑名单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_cpe_group
-- ----------------------------
DROP TABLE IF EXISTS `devops_cpe_group`;
CREATE TABLE `devops_cpe_group`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `LEAK_ID` bigint(0) NULL DEFAULT NULL COMMENT '漏洞ID',
  `RELATED_GPID` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT '关联组ID',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `devops_leak_id_idx`(`LEAK_ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '漏洞CPE组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_cwe
-- ----------------------------
DROP TABLE IF EXISTS `devops_cwe`;
CREATE TABLE `devops_cwe`  (
  `ID` bigint(0) NOT NULL,
  `PARENT_ID` bigint(0) NULL DEFAULT NULL,
  `CWE_ID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cwe_id',
  `CWE_TYPE` tinyint(1) NULL DEFAULT NULL COMMENT '枚举类型，1：按软件应用设计查看，2：按硬件设计查看，3：按研究概念查看',
  `LEVEL` tinyint(0) NULL DEFAULT NULL COMMENT '种类层级，1为顶级',
  `SUBJECT_CN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '枚举类别描述',
  `SUBJECT_EN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '枚举类别描述',
  `REPAIR_PLAN` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '修复建议',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'cwe通用弱点枚举分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_dependency
-- ----------------------------
DROP TABLE IF EXISTS `devops_dependency`;
CREATE TABLE `devops_dependency`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `DP_NAMESPACE` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '命名空间',
  `DP_NAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '依赖名',
  `DP_COMPANY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司',
  `DEL_FLAG` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标记',
  `VERSION` int(0) NULL DEFAULT 0 COMMENT '版本',
  `DP_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '依赖类型，0->JAVA，1->JAVA_SCRIPT，2->GO，3->PYTHON',
  `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `CREATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `UPDATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `TENANT_ID` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'productType+namespace+name',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_dependency_md5_uindex`(`md5`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3899981437557907487 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '依赖表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_dependency_detail
-- ----------------------------
DROP TABLE IF EXISTS `devops_dependency_detail`;
CREATE TABLE `devops_dependency_detail`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `DP_ID` bigint(0) NULL DEFAULT NULL COMMENT '依赖ID',
  `LICENSE_ID` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '许可证',
  `BLACKLIST_ID` bigint(0) NULL DEFAULT NULL COMMENT '黑名单id',
  `DP_VERSION` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '依赖版本',
  `LEAK_NUM` int(0) NULL DEFAULT 0 COMMENT '关联漏洞数量',
  `APP_NUM` int(0) NULL DEFAULT 0 COMMENT '关联应用数量',
  `DP_SOURCE` tinyint(0) NULL DEFAULT 0 COMMENT '依赖来源，0->扫描，1->手动',
  `DEL_FLAG` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标记',
  `VERSION` int(0) NULL DEFAULT 0 COMMENT '版本',
  `TENANT_ID` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `CREATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `UPDATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'productType+namespace+name+version',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_dependency_detail_md5_uindex`(`md5`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3899981441466999581 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '依赖详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_gate_app_relation
-- ----------------------------
DROP TABLE IF EXISTS `devops_gate_app_relation`;
CREATE TABLE `devops_gate_app_relation`  (
  `ID` bigint(0) NOT NULL,
  `GATE_ID` bigint(0) NOT NULL COMMENT '门禁id',
  `APP_ID` bigint(0) NOT NULL COMMENT '应用id',
  `VERSION` int(0) NULL DEFAULT 0,
  `TENANT_ID` bigint(0) NULL DEFAULT 0,
  `DEL_FLAG` tinyint(0) NULL DEFAULT 0,
  `CREATE_TIME` datetime(0) NULL DEFAULT NULL,
  `UPDATE_TIME` datetime(0) NULL DEFAULT NULL,
  `CREATE_BY` bigint(0) NULL DEFAULT NULL,
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '可信源门禁应用关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_leak
-- ----------------------------
DROP TABLE IF EXISTS `devops_leak`;
CREATE TABLE `devops_leak`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `LEAK_NAME` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '漏洞名称',
  `LEAK_CODE` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞代码',
  `LEAK_CODE_CN` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中国cnnvd编号',
  `CWE_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'cwe编号',
  `LEAK_TYPE` tinyint(0) NULL DEFAULT 0 COMMENT '漏洞类型，0->未知，1->应用程序，2->硬件，3->操作系统',
  `LEAK_SOURCE` tinyint(0) NULL DEFAULT 0 COMMENT '漏洞来源，0->NVD，1->手动',
  `LEAK_INFO` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '漏洞描述',
  `LEAK_SEVERITY_V2` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞等级v2',
  `LEAK_BASESCORE_V2` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞分数v2',
  `LEAK_SEVERITY_V3` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞等级v3',
  `LEAK_BASESCORE_V3` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞分数v3',
  `LEAK_RELEASE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '漏洞发布时间',
  `LAST_MODIFIED_TIME` datetime(0) NULL DEFAULT NULL COMMENT '漏洞更新时间',
  `IGNORE_FLAG` tinyint(0) NULL DEFAULT 0 COMMENT '忽略标记，0->否，1->是',
  `REPAIR_SCHEME` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT '修复方案',
  `DEL_FLAG` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标记',
  `VERSION` tinyint(0) NULL DEFAULT 0 COMMENT '版本',
  `TENANT_ID` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `CREATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `UPDATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `third_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '三方漏洞编号',
  `LEAK_REPLENISH_SOURCE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '漏洞补充信息来源',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_leak_code_idx`(`LEAK_CODE`) USING BTREE,
  INDEX `devops_leak_release_time_idx`(`LEAK_RELEASE_TIME`) USING BTREE,
  INDEX `devops_leak_type_idx`(`LEAK_TYPE`) USING BTREE,
  INDEX `devops_leak_LEAK_SEVERITY_V3_index`(`LEAK_SEVERITY_V3`) USING BTREE,
  INDEX `devops_leak_DEL_FLAG_LEAK_TYPE_index`(`DEL_FLAG`, `LEAK_TYPE`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '漏洞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_leak_dp_relation
-- ----------------------------
DROP TABLE IF EXISTS `devops_leak_dp_relation`;
CREATE TABLE `devops_leak_dp_relation`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `LEAK_ID` bigint(0) NOT NULL COMMENT '漏洞ID',
  `DP_DETAIL_ID` bigint(0) NOT NULL COMMENT '依赖ID',
  `ERROR_MATCH_ID` bigint(0) NULL DEFAULT NULL COMMENT '误报id',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_leak_dp_relation_DP_DETAIL_ID_LEAK_ID_uindex`(`DP_DETAIL_ID`, `LEAK_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3406017700908576769 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '漏洞依赖关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_leak_job
-- ----------------------------
DROP TABLE IF EXISTS `devops_leak_job`;
CREATE TABLE `devops_leak_job`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `LAST_UPDATE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '上次同步时间',
  `NOW_UPDATE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '这次同步时间',
  `JOB_END_TIME` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `JOB_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '任务类型：0：漏洞增量更新，1：漏洞扫描',
  `TRIGGER_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '触发方式0-定时执行1-手动执行',
  `RESULT_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '结果类型：0：成功，1：失败',
  `RESULT` longtext CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT '更新结果',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4215597643709513729 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '漏洞库任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_leak_job_github
-- ----------------------------
DROP TABLE IF EXISTS `devops_leak_job_github`;
CREATE TABLE `devops_leak_job_github`  (
  `ID` bigint(0) NOT NULL COMMENT '主键',
  `LAST_NEWEST_TIME` datetime(0) NULL DEFAULT NULL COMMENT '上次拉取漏洞中最新发布的时间',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '漏洞库任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_leak_link
-- ----------------------------
DROP TABLE IF EXISTS `devops_leak_link`;
CREATE TABLE `devops_leak_link`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `LEAK_ID` bigint(0) NULL DEFAULT NULL COMMENT '漏洞ID',
  `LEAK_LINK` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞链接',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_leak_link_unique_idx`(`LEAK_ID`, `LEAK_LINK`) USING BTREE,
  INDEX `LEAK_ID`(`LEAK_ID`) USING BTREE,
  INDEX `devops_leak_code_idx`(`LEAK_ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '漏洞链接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_leak_match
-- ----------------------------
DROP TABLE IF EXISTS `devops_leak_match`;
CREATE TABLE `devops_leak_match`  (
  `ID` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `LEAK_ID` bigint(0) NULL DEFAULT NULL COMMENT '漏洞ID',
  `CPE_STRING` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '漏洞CPE',
  `CPE_GROUP_ID` bigint(0) NULL DEFAULT NULL COMMENT 'CPE组ID',
  `START_VERSION` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '起始版本',
  `START_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '起始区间开闭，0->闭，1->开',
  `END_TYPE` tinyint(0) NULL DEFAULT NULL COMMENT '结束版本,0->闭，1->开',
  `END_VERSION` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '结束版本',
  `COMPANY` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '生产库',
  `PRODUCT` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '产品名',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `CPE_STRING`(`CPE_STRING`) USING BTREE,
  INDEX `LEAK_ID`(`LEAK_ID`) USING BTREE,
  INDEX `company_idx`(`COMPANY`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '漏洞CPE表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_license
-- ----------------------------
DROP TABLE IF EXISTS `devops_license`;
CREATE TABLE `devops_license`  (
  `ID` bigint(0) NOT NULL,
  `LICENSE_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `LEVEL` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '低' COMMENT '风险等级',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `spread` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '传染性',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `devops_license_LICENSE_NAME_uindex`(`LICENSE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '依赖许可证' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_security_gate
-- ----------------------------
DROP TABLE IF EXISTS `devops_security_gate`;
CREATE TABLE `devops_security_gate`  (
  `ID` bigint(0) NOT NULL,
  `GATE_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '门禁名称',
  `DEFAULT_GATE` tinyint(0) NULL DEFAULT 0 COMMENT '默认门禁,0:否，1：是',
  `VERSION` int(0) NULL DEFAULT 0,
  `TENANT_ID` bigint(0) NULL DEFAULT 0,
  `DEL_FLAG` tinyint(0) NULL DEFAULT 0,
  `CREATE_TIME` datetime(0) NULL DEFAULT NULL,
  `UPDATE_TIME` datetime(0) NULL DEFAULT NULL,
  `CREATE_BY` bigint(0) NULL DEFAULT NULL,
  `UPDATE_BY` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '可信源门禁' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for devops_security_gate_condition
-- ----------------------------
DROP TABLE IF EXISTS `devops_security_gate_condition`;
CREATE TABLE `devops_security_gate_condition`  (
  `ID` bigint(0) NOT NULL,
  `GATE_ID` bigint(0) NOT NULL COMMENT '门禁id',
  `CONDITION_TYPE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '条件类型',
  `THRESHOLD` int(0) NULL DEFAULT 0 COMMENT '条件阈值',
  `STATUS` tinyint(0) NULL DEFAULT 0 COMMENT '条件开关0:关闭,1;开启',
  `TOUCH_TIME` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '可信源门禁条件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for error_match_record
-- ----------------------------
DROP TABLE IF EXISTS `error_match_record`;
CREATE TABLE `error_match_record`  (
  `ID` bigint(0) NOT NULL,
  `VENDER` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '厂商名称',
  `PRODUCT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'CPE中的软件名',
  `DP_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '依赖名称',
  `IGNORE_FLAG` tinyint(0) NULL DEFAULT 0 COMMENT '忽略标记，0-不忽略，1-忽略',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `error_match_record_vender_product_dp_name_uindex`(`VENDER`, `PRODUCT`, `DP_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '误报记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for maven_artifact
-- ----------------------------
DROP TABLE IF EXISTS `maven_artifact`;
CREATE TABLE `maven_artifact`  (
  `id` bigint(0) NOT NULL,
  `group_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `artifact_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for maven_artifact_indices
-- ----------------------------
DROP TABLE IF EXISTS `maven_artifact_indices`;
CREATE TABLE `maven_artifact_indices`  (
  `artifact_id` bigint(0) NULL DEFAULT NULL,
  `artifact_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `artifact_sha1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `artifact_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  UNIQUE INDEX `maven_artifact_indices_un`(`artifact_sha1`) USING BTREE,
  INDEX `maven_artifact_indices_artifact_id_IDX`(`artifact_id`) USING BTREE,
  CONSTRAINT `maven_artifact_indices_FK` FOREIGN KEY (`artifact_id`) REFERENCES `maven_artifact` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
