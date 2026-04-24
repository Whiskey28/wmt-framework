# TongWeb 信创验证（JDK17）

本次验证基线针对 `wmt-dependencies-jdk17` 和 `wmt-framework-jdk17` 两个组件库。

## 调整原则

- 框架层不再绑定默认内嵌 Tomcat，避免对具体 Web 容器的强耦合。
- Web 容器选择下沉到业务应用，由业务工程按部署环境（TongWeb / Tomcat / Jetty）显式引入。
- 维持 `security` 等组件对 `web` 的依赖关系不变，仅调整容器传递依赖策略。

## 本轮改造点

- `wmt-dependencies-jdk17`：统一管理 `spring-boot-starter-web`、`spring-boot-starter-websocket`，并排除 `spring-boot-starter-tomcat`。
- `wmt-framework-jdk17/wmt-spring-boot-starter-web`：排除 `spring-boot-starter-tomcat`。
- `wmt-framework-jdk17/wmt-spring-boot-starter-websocket`：排除 `spring-boot-starter-tomcat`。
- `wmt-framework-jdk17/wmt-spring-boot-starter-mybatis`：在已有 `undertow` 排除基础上，新增 `tomcat` 排除。

## 业务工程验证建议

1. 业务工程引入 TongWeb 官方 Spring Boot Starter（或 TongWeb 提供的 Servlet 容器依赖）。
2. 启动后验证：
   - 登录鉴权链路（`security`）
   - 全局异常、参数处理、过滤器链（`web`）
   - WebSocket 握手与消息收发（`websocket`）
3. 对比 Tomcat 基线回归核心接口，确认无行为回归。
