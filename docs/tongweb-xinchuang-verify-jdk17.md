# TongWeb 信创验证（JDK17）

本次验证基线针对 `wmt-dependencies-jdk17` 和 `wmt-framework-jdk17` 两个组件库。

## 调整原则

- 信创组件库默认绑定 TongWeb，实现业务系统开箱即用。
- 框架层移除默认内嵌 Tomcat，避免与 TongWeb 容器冲突。
- 维持 `security` 等组件对 `web` 的依赖关系不变，仅调整容器传递依赖策略。

## 本轮改造点

- `wmt-dependencies-jdk17`：
  - 新增 TongWeb 版本属性 `tongweb-spring-boot.version`。
  - 新增 `com.tongweb.springboot:tongweb-spring-boot-starter-3.x` 统一依赖管理。
  - 管理 `spring-boot-starter-web`、`spring-boot-starter-websocket` 并排除 `spring-boot-starter-tomcat`。
- `wmt-framework-jdk17/wmt-spring-boot-starter-web`：
  - 排除 `spring-boot-starter-tomcat`。
  - 默认引入 `tongweb-spring-boot-starter-3.x`。
- `wmt-framework-jdk17/wmt-spring-boot-starter-websocket`：
  - 排除 `spring-boot-starter-tomcat`。
  - 默认引入 `tongweb-spring-boot-starter-3.x`。
- `wmt-framework-jdk17/wmt-spring-boot-starter-mybatis`：在已有 `undertow` 排除基础上，新增 `tomcat` 排除。

## 业务工程验证建议

1. 业务工程仅依赖本信创组件库（无需额外引入 TongWeb Starter）。
2. 启动后验证：
   - 登录鉴权链路（`security`）
   - 全局异常、参数处理、过滤器链（`web`）
   - WebSocket 握手与消息收发（`websocket`）
3. 通过 `mvn dependency:tree` 验证运行时容器依赖为 TongWeb，且无 `spring-boot-starter-tomcat`。
4. 对比 Tomcat 基线回归核心接口，确认无行为回归。
