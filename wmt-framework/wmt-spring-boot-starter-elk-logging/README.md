# wmt-spring-boot-starter-elk-logging

无侵入 ELK 日志接入：开发走 Logstash TCP，生产走 Filebeat + 本地文件；业务无需维护 logback.xml，也可完全自定义扩展。

## 使用方式

### 方式 A：零配置自动集成（推荐）

1) 引入依赖

```xml
<dependency>
  <groupId>com.wmt</groupId>
  <artifactId>wmt-spring-boot-starter-elk-logging</artifactId>
  <version>${revision}</version>
</dependency>
```

2) application.yml

开发（dev）：
```yaml
wmt.logging:
  enabled: true
  output: logstash
  logstash-host: 127.0.0.1
  logstash-port: 5000
```

生产（prod）：
```yaml
wmt.logging:
  enabled: true
  output: file
  file-path: /data/logs/${spring.application.name}/app.log
  auto-activate-profile: true
```

**无需配置 logback.xml**，组件会自动生效。

---

### 方式 B：自定义 logback-spring.xml 扩展

如果业务系统需要自定义日志配置，可以在 `src/main/resources` 中创建 `logback-spring.xml`，组件提供的 Appender 仍然可用。

#### 示例 1：同时输出控制台 + 文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <!-- 引入组件配置 -->
    <springProperty scope="context" name="output" source="wmt.logging.output" defaultValue="file"/>
    <springProperty scope="context" name="logstashHost" source="wmt.logging.logstash-host" defaultValue="127.0.0.1"/>
    <springProperty scope="context" name="logstashPort" source="wmt.logging.logstash-port" defaultValue="5000"/>
    <springProperty scope="context" name="filePath" source="wmt.logging.file-path" defaultValue="/data/logs/${spring.application.name}/app.log"/>
    
    <!-- 复用组件的 FILE Appender -->
    <appender name="WMT-FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${filePath}</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <fileNamePattern>${filePath}.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
            <maxHistory>14</maxHistory>
            <totalSizeCap>5GB</totalSizeCap>
            <maxFileSize>200MB</maxFileSize>
        </rollingPolicy>
        <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
            <providers>
                <timestamp/>
                <pattern><pattern>{"level":"%level","logger":"%logger","thread":"%thread"}</pattern></pattern>
                <logstashMarkers/>
                <message/>
                <mdc/>
                <stackTrace/>
            </providers>
        </encoder>
    </appender>
    
    <root level="INFO">
        <!-- 同时输出控制台 + 文件 -->
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="WMT-FILE"/>
    </root>
</configuration>
```

#### 示例 2：按环境切换（开发输出控制台，生产输出文件）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <springProfile name="dev">
        <root level="INFO">
            <appender-ref ref="STDOUT"/>
        </root>
    </springProfile>
    
    <springProfile name="prod">
        <!-- 引用组件的 FILE Appender，或自定义 -->
        <root level="INFO">
            <appender-ref ref="WMT-FILE"/>
        </root>
    </springProfile>
</configuration>
```

**提示**：业务自定义的 `logback-spring.xml` 优先级高于组件默认配置。

---

## 配置属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `wmt.logging.enabled` | boolean | true | 是否启用组件 |
| `wmt.logging.output` | string | file | 输出方式：logstash / file |
| `wmt.logging.logstash-host` | string | 127.0.0.1 | Logstash 主机 |
| `wmt.logging.logstash-port` | int | 5000 | Logstash 端口 |
| `wmt.logging.file-path` | string | /data/logs/${spring.application.name}/app.log | 文件输出路径 |
| `wmt.logging.auto-activate-profile` | boolean | false | 是否自动追加 logstash/file profile（默认不修改业务 active） |

---

## 字段与格式

- 统一 JSON 输出（logstash encoder），所有日志结构化输出。
- 自动输出 MDC 字段：
  - 链路追踪：`traceId`、`spanId`、`requestId`
  - 业务上下文：`tenantId`、`userId`、`roleIds`
  - 请求信息：`requestPath`、`httpMethod`、`clientIp`、`userAgent`、`appVersion`、`channel`
  - 环境信息：`env`（取自 spring.profiles.active）、`nodeId`（取自 HOSTNAME 或 spring.application.name，缺失则不输出）

**字段说明**：
- `traceId/spanId`：优先取请求头 `sw8`（SkyWalking）或 `X-Trace-Id`，否则自动生成
- `env`：取 Spring Environment 的 active profiles，确保与业务 active 一致
- `nodeId`：优先 `HOSTNAME`，其次 `spring.application.name`，缺失则为空（不强制默认值）

---

## 生产 Filebeat 场景的文件与滚动

- 文件保留策略：生产环境日志文件保留在本地，便于排障和审计；Filebeat 只负责采集并推送到 ELK。
- 滚动策略（Size + Time）：
  - 按天分片：`app.log.2024-01-15.0.gz`
  - 单片最大 200MB，超过自动滚动到下一个序号
  - 保留 14 天
  - 总容量不超过 5GB
- 清理策略：由运维定期清理或通过 `maxHistory/totalSizeCap` 自动控制。

---

## 工作原理

1. **自动装配**：`WmtLoggingAutoConfiguration` 自动加载
   - 读取 `wmt.logging.*` 配置
   - 设置 System Properties 供 logback 占位符使用
   - 可选的 profile 自动激活

2. **日志模板**：内置 `logback-spring.xml`
   - 默认 STDOUT（任何环境都能正常输出）
   - Profile `logstash`：TCP 输出到 Logstash
   - Profile `file`：文件滚动输出，供 Filebeat 采集

3. **MDC Filter**：`TraceMdcFilter` 自动注入链路追踪与请求信息
   - 条件装配（`@ConditionalOnMissingBean`），避免与 web 模块冲突
   - 优先从请求头获取，缺失则自动生成或留空

---

## 自定义扩展指南

组件提供了以下命名 Appender，业务可在 `logback-spring.xml` 中引用或覆盖：

- `STDOUT`：默认控制台输出（JSON 格式）
- `WMT-LOGSTASH`：TCP 输出到 Logstash
- `WMT-FILE`：文件输出（供 Filebeat 采集）

覆盖方式：在业务 `logback-spring.xml` 中定义同名 `<appender>`，组件定义会被忽略。

引入/合并方式：使用 `<include>` 或 `<springProfile>` 组合组件配置。
