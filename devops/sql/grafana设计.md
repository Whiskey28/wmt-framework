### 一、统一度量维度（所有报表共用）

- **时间维度**
    - 可选：日 / 周 / 月 / 季度 / 自定义区间
    - 支持：同比（去年同周期）、环比（上一个周期）
    - 主要来源：各业务表中的 `create_time` / `update_time` / 执行时间字段

- **组织 / 租户维度**
    - 组织树：`sys_organization`（公司 → 部门 → 子部门）
    - 用户组织关系：`sys_user_organization`
    - 租户 ID = `sys_organization.id`
    - 对中层、团队级报表：所有指标都按组织ID进行过滤与聚合（高层可以看“全公司/全部组织”）

- **项目 / 系统维度**
    - **项目（Project）**：需求、任务、文档、知识空间等围绕“项目”的度量
        - 典型表：`yanlian_devops_development.sql` 中的 `devops_feature`、`version_instance` 等（需求/特性/版本）
        - `yanlian_devops_knowledge.sql` 中的 `knowledge_space.project_id`
    - **系统 / 子系统**：GitLab 代码库、流水线、部署等围绕“系统”的度量
        - 典型表：`devops_system`、`devops_sub_system`，SCM 中的仓库、Pipeline 中的 job、构建、部署等

- **用户维度**
    - 用户 ID 来自各库的 `create_by` / `user_id` / `director` 等字段
    - 通过 `sys_user_organization` 反查其所属组织

---

### 二、面向高级领导层的指标体系（公司级、战略视角）

**定位**：看“全公司 DevOps 推进程度 + 效能 + 质量 + 安全”的大盘，不深究细节。

- **1. DevOps 覆盖与使用程度**
    - DevOps 平台活跃项目数（按时间区间内有提交或流水线的项目数）
    - 活跃系统/子系统数（有构建/部署/特性变更的系统数）
    - 活跃用户数（当期有提交、构建、部署、需求操作的用户数）
    - 部门覆盖率（有使用 DevOps 的部门数 / 总部门数）

- **2. 交付效率与稳定性（DORA 类）**
    - 部署频率（全公司单位时间内部署次数
        - 来源：`yanlian_dop_pipeline.sql` → `devops_build_deploy_rel`（按 `deploy_env` + `status`='SUCCESS' 计数）
    - 变更失败率（失败部署次数 / 总部署次数）
    - 变更交付周期（从需求/特性创建到上线部署的平均时长）
        - 来源：`devops_feature.create_time` → 关联到最后一次成功部署时间（build/deploy 表）
    - 故障恢复时间（从失败部署/回滚触发到恢复成功部署的平均时间）
        - 需要约定“失败+后续成功”为一次恢复链条，在 Pipeline 部署历史中分析

- **3. 研发效能与需求交付**
    - 单位时间完成的特性/需求数（`devops_feature.feature_status` 进入“已发布/已完成”的数量）
    - 需求按时交付率（按项目配置的计划完成时间 vs 实际上线时间，需看是否有计划时间字段，若无可暂不做）
    - 需求/特性在各阶段停留时间（开发中 / 测试中 / 已发布 等状态的平均时长）

- **4. 质量与代码健康（汇总）**
    - 静态扫描执行覆盖率（有扫描历史的仓库数 / 总仓库数）
        - 来源：`yanlian_devops_code_inspect.sql` → `code_repository` + `scan_history`
    - 每次扫描平均问题数 / 严重问题占比
        - 来源：`scan_history` + `scan_issue` / `scan_history_detail`
    - 代码问题闭环率（已关闭问题数 / 发现问题数，如有“状态字段”）

- **5. 安全与依赖可信（汇总）**
    - 参与可信扫描的应用数（`devops_app` / `devops_app_scan_history`）
    - 应用平均漏洞数 / 高危漏洞占比
        - 来源：`yanlian_devops_trustworthy.sql` 中 `devops_leak`、`devops_leak_dp_relation`、`devops_app_scan_history`
    - 许可（License）违规应用数（`devops_license` + gate 判定）

- **6. 知识与协同**
    - 知识空间数、文档数（`knowledge_space`、`knowledge_document`）
    - 文档创建/更新次数（知识活跃度）
    - 文档评论、收藏次数（协同活跃度）
        - 来源：`knowledge_comment`、`knowledge_user_collect`

---

### 三、面向中层部门领导的指标体系（部门视角、租户隔离）

**定位**：每个部门 / 组织看自身的 DevOps 使用成效和短板，全部指标都按 `tenant_id` / 部门过滤。

- **1. 部门使用情况**
    - 本部门 DevOps 活跃项目数、活跃系统数（按组织关联的项目/系统）
    - 本部门活跃开发/测试/运维人数（按用户所属组织 + 行为出现）
    - 部门内 DevOps 使用渗透率（参与 DevOps 的人员 / 部门总用户数）

- **2. 部门交付效率**
    - 部门部署频率（按本部门系统/项目触发的部署）
    - 本部门版本/特性交付周期（devops_feature 关联组织后统计）
    - 需求按时交付率（若有计划完成时间则可按项目归属组织统计）

- **3. 部门质量与缺陷**
    - 部门代码扫描覆盖率（该部门系统对应的仓库是否有 `scan_history`）
    - 部门平均每次扫描问题数 & 严重问题占比
    - 部门质量红线触发次数（如在 `quality_gate` 或相关表有质量阈值配置）

- **4. 部门安全与合规**
    - 部门内参与可信扫描的应用数
    - 部门应用漏洞数量趋势、高危漏洞未修复数
    - 安全门禁 / 安全闸门未通过次数（`devops_security_gate`、`devops_security_gate_condition`、`devops_gate_app_relation`）

- **5. 部门知识与经验沉淀**
    - 部门项目对应的知识空间数（`knowledge_space.project_id` + 项目归属组织）
    - 部门创建/维护文档数量、活跃空间数
    - 部门文档访问/评论/收藏次数（如有访问日志，暂见到评论、收藏）

- **6. 部门资源与规范执行**
    - 部门是否开启 `gitlab_forced_control` / `jenkins_forced_control` / `ip_forced_control`（从 `sys_organization` 中的控制标志）
    - 部门下 GitLab 项目中规范执行率（基于 `devops_commit_check_rule`、`devops_merge_request_setting` 是否启用）
    - 部门 MR 审查通过率（`devops_merge_request` 状态）

---

### 四、面向团队 / 项目经理的指标体系（项目视角）

**定位**：看单个项目 / 系统的“进度 + 质量 + 交付效率”，便于日常管理。

- **1. 项目概览**
    - 项目当前特性/需求总数、按状态分布（开发中、测试中、已发布等）
        - 来源：`devops_feature`（按 `feature_status`）
    - 当前版本列表及状态（`version_instance` 等）
    - 项目成员数（参与该项目提交/流水线/需求操作的用户数）

- **2. 进度与交付**
    - 迭代/版本内已完成特性数 / 总特性数
    - 特性按时上线率（如果有计划上线时间）
    - 单个特性的 Lead Time（从创建到第一次上线成功部署）

- **3. 流水线与部署健康**
    - 项目流水线运行次数、成功率、平均构建时长
        - 来源：`devops_job_build_info` + `devops_jenkins_job`（在 `yanlian_dop_pipeline.sql` 中）
    - 部署次数、部署成功率
    - 构建/部署失败原因 TOP N（从 `status` 与日志字段中提取分类）

- **4. 代码质量与技术债**
    - 项目扫描执行次数、最近一次扫描时间
    - 未关闭问题数（按严重程度：阻塞 / 严重 / 一般）
    - 新增问题数 vs 已修复问题数（对比时间段）

- **5. 安全与依赖风险**
    - 当前版本使用的三方依赖数量（`devops_dependency`、`devops_dependency_detail`）
    - 存在漏洞的依赖数量 / 高危漏洞数
    - 安全门禁是否通过（`devops_security_gate` 相关记录）

- **6. 测试与质量保障**
    - 自动化测试计划数量、执行次数、通过率
        - 来源：`autotest_management` 等测试管理表
    - 测试环境部署成功率（按测试环境 `deploy_env` 过滤）
    - 回归测试周期（如有可用字段）

- **7. 项目知识与协同**
    - 项目知识空间下文档数、最近更新时间
    - 项目相关文档的评论/收藏数
    - 项目说明类文档覆盖情况（是否存在 README、设计文档、接口文档等模板，可用 `knowledge_template` 做约束）

---

### 五、下一步建议与需要你确认的点

1. **请你从上述三层指标中：**
    - 先选出：
        - 高层大屏：你最想放的 8–12 个核心指标
        - 部门看板：你最关心的 10–15 个指标
        - 项目看板：你最常用的 15–20 个指标
    - 或者告诉我：哪些模块（“交付效率 / 质量 / 安全 / 知识 / 规范执行”）优先级更高，我来帮你做一个精简版默认套件。

2. **如果你已经有现在线上运维的“高层大屏 / 部门大屏 / 项目大屏”的草图或想法（哪类图表、放在第几屏），也可以简单描述，我会按你的布局来匹配这些指标。**

你先定三大报表各自的“核心指标清单”（可以直接用编号或拷贝我上面的指标名字），我再按这些指标往下落：精确到 SQL 口径、字段来源、Grafana 面板类型和同比/环比的实现方式。
