# 中间件适配 SOP v1（TongWeb + TongRDS）

适用范围：
- `main` 为 Spring Boot 3 技术栈
- 信创改造分支：`feat/xinchuang-tongweb-verify`
- 组件库以 JAR/BOM 形式供业务项目（如 `ahzx-wmt-svc`）依赖

目标：
- Web 容器从 `Tomcat` 切换到 `TongWeb`
- 缓存/消息基础设施从 `Redis` 切换到 `TongRDS`（兼容 Redis 协议）

---

## 1. 前置条件

- JDK 17、Maven 3.8+
- 业务工程可访问组件库制品仓库
- 已获取 TongWeb 7.0.E.8_P2 安装包与 `license.dat`
- Windows IDEA 场景必须可执行 Maven 命令（用于清理缓存）

---

## 2. Tomcat -> TongWeb 替换步骤

### 2.1 组件库侧（本仓库）基线能力

已在信创分支完成：
- `web` / `websocket` 相关 starter 排除 `spring-boot-starter-tomcat`
- 默认引入：
  - `com.tongweb.springboot:tongweb-spring-boot-starter-3.x`
  - `com.tongweb.springboot:tongweb-spring-boot-websocket-3.x`
- 本地授权自动识别：
  - 当 classpath 存在 `license.dat` 且未显式配置时，自动注入  
    `server.tongweb.license.type=file`  
    `server.tongweb.license.path=classpath:license.dat`

### 2.2 业务工程侧接入动作

- 导入 `wmt-dependencies-jdk17` BOM
- 依赖 `wmt-spring-boot-starter-web`、`wmt-spring-boot-starter-websocket` 等 starter
- 不再显式引入 `spring-boot-starter-tomcat`
- 将 `license.dat` 放入业务工程 `src/main/resources/`

### 2.3 TongWeb 依赖安装（本地/构建机）

如果 TongWeb 依赖未在公共仓库可用，先安装本地 Maven 仓库：

```bash
cd "/Users/whiskey/Projects/Services/Tongweb 嵌入式/tongweb-7.0.E.8_P2/tongweb-embed-7.0.E.8_P2"
bash ./installMavenJar.sh
```

注意：必须在脚本所在目录执行，避免空格路径导致相对路径失效。

---

## 3. Redis -> TongRDS 替换步骤

TongRDS 按 Redis 协议兼容，应用层通常只需替换连接目标与认证信息。

### 3.1 Spring Data Redis 配置替换

```yaml
spring:
  data:
    redis:
      host: <tongrds-host>
      port: <tongrds-port>
      password: <tongrds-password>
      database: 0
      timeout: 5s
```

### 3.2 Redisson 配置替换（如使用）

- 单节点：将地址改为 TongRDS 实例地址
- 集群/哨兵：按 TongRDS 提供方式配置节点
- 若 TongRDS 要求 TLS，开启 `rediss://` 与 SSL 参数

### 3.3 功能验证范围

- 缓存读写（String/Hash/过期策略）
- 分布式锁（Lock4j/Redisson）
- Redis MQ/Stream（若项目启用 `wmt-spring-boot-starter-mq` 的 redis 通道）
- 幂等/防重（基于 Redis Key 的逻辑）

---

## 4. 标准检查清单（上线前）

- [ ] 依赖检查：`dependency:tree` 无 `spring-boot-starter-tomcat` 与 `org.apache.tomcat.embed:*`
- [ ] 构建检查：执行 `mvn -U clean package -DskipTests` 成功
- [ ] 启动检查：确认使用最新构建产物/最新 IDEA Run Configuration
- [ ] 日志检查：出现 TongWeb 初始化与 license 校验成功日志；无 `Tomcat started on port(s)`
- [ ] 端口检查：服务端口、管理端口与配置一致
- [ ] TongRDS 检查：应用已连接 TongRDS 地址，缓存/锁/MQ 核心链路通过

---

## 5. 常见问题与修复

### 问题 1：依赖树无 Tomcat，但启动仍像 Tomcat

原因：
- Windows IDEA 使用了旧缓存/旧运行配置

修复：
- 执行 `mvn -U clean package -DskipTests`
- 删除并重建 IDEA Run Configuration
- 使用 `java -jar` 启动最新产物做一次交叉验证

### 问题 2：TongWeb 启动失败，提示授权相关错误

原因：
- `license.dat` 未进 classpath 或路径配置错误

修复：
- 将 `license.dat` 放到 `src/main/resources/`
- 或显式配置：
  - `server.tongweb.license.type=file`
  - `server.tongweb.license.path=classpath:license.dat`

### 问题 3：构建机找不到 TongWeb starter

原因：
- 构建机未安装 TongWeb 私有依赖

修复：
- 在构建机执行 `installMavenJar.sh` 安装
- 或上传到企业私服后统一通过私服拉取

### 问题 4：TongRDS 接入后部分 Redis 功能异常

原因：
- 特性兼容差异、连接参数或 SSL 配置不一致

修复：
- 先验证基础 KV/过期，再验证锁与 Stream
- 对照 TongRDS 文档调整连接模式与参数
- 必要时对不兼容命令做降级或替代实现

---

## 6. 30 秒复核（发布口径）

- [ ] 当前发布分支是 `feat/xinchuang-tongweb-verify`
- [ ] 业务工程 `dependency:tree` 无 Tomcat 依赖
- [ ] 启动日志确认容器为 TongWeb（非仅关键字搜索）
- [ ] `license.dat` 已就位且授权校验成功
- [ ] Redis 实际连接目标已切换到 TongRDS
- [ ] 缓存、锁、消息（若使用）三条链路冒烟通过
