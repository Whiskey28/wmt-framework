# wmt-framework-jdk17 ProGuard 混淆发布说明

## 背景

Spring Boot Starter 类库不适合「全量 shrink + 重命名」，否则易出现：

- 自动配置类 / `@ConfigurationProperties` 无法加载
- MyBatis Mapper、Jackson 自定义序列化器失效
- Hibernate Validator 找不到 `ConstraintValidator` 实现类

JDK17 线采用 **分模块规则 + 库模块禁止 shrink** 的策略（见 `proguard-jdk17-library.conf` / `proguard-jdk17-starter.conf`）。

默认规则已启用 **元数据剥离**（`-renamesourcefileattribute`、不保留 `SourceFile`/`LineNumberTable`），降低 jadx 还原度，不影响对外 API 与 Spring 装配。

| Profile | 规则文件 | 说明 |
|---------|----------|------|
| `-Pobfuscate` | `proguard-jdk17-*.conf` | 默认发布混淆 |
| `-Pobfuscate-strong` | `proguard-jdk17-*-strong.conf` | 加强版（独立规则链，便于后续收紧 keep） |

## 试点模块

- 库模块：`wmt-common`（覆盖为 `proguard-jdk17-library.conf`）
- 其余 **16 个 jar 子模块** 由 `wmt-framework-jdk17/pom.xml` 的 `proguard-jar-modules` profile 自动挂载插件（存在 `src/main/java` 即生效），默认使用 `proguard-jdk17-starter.conf`

## 构建命令

```bash
# 使用 JDK 17 运行 Maven（java.home 即 ProGuard 引导库；也可显式 export PROGUARD_JDK_HOME）
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"

# 单模块
mvn -pl wmt-framework-jdk17/wmt-common -am clean package -Pobfuscate -DskipTests

# 全量 jdk17 组件库（推荐在仓库根目录执行，或 -f 子 POM 亦可）
mvn -f wmt-framework-jdk17/pom.xml clean install -Pobfuscate -DskipTests
# 等价：mvn -pl wmt-framework-jdk17 -amd clean package -Pobfuscate -DskipTests（需在仓库根目录）

# 加强混淆（规则链独立，当前与默认等价，预留后续收紧）
mvn -f wmt-framework-jdk17/pom.xml clean install -Pobfuscate-strong -DskipTests
```

### 常见失败：`Obfuscation failed (result=1)` on wmt-common

若 ProGuard 日志出现：

```text
No such file or directory: ${env.PROGUARD_JDK_HOME}/jmods/java.base.jmod
```

说明 **未设置 `PROGUARD_JDK_HOME` 且 Maven 未用 JDK 17 启动**（旧版 pom 会把未解析的环境变量字面量传给 ProGuard）。处理方式：

1. 用 JDK 17 跑 Maven：`export JAVA_HOME=$(/usr/libexec/java_home -v 17)` 后再构建；或
2. 显式指定：`export PROGUARD_JDK_HOME="$JAVA_HOME"`；或
3. 升级到已修复的 pom（`proguard.jdk.home` 默认 `${java.home}`）。

## 切换分支后构建

本地 `~/.m2` 可能残留另一分支的 `wmt-dependencies-jdk17` BOM；模块下的 `.flattened-pom.xml` 也可能过期。切换 `main` ↔ `xinchuang/tongweb` 后建议：

```bash
find wmt-framework-jdk17 wmt-dependencies-jdk17 -name '.flattened-pom.xml' -delete
mvn -f wmt-dependencies-jdk17/pom.xml clean install -DskipTests
```

产物：

- `wmt-common/target/wmt-common-*-SNAPSHOT.jar`（混淆后）
- `wmt-common/target/proguard_map.txt`（**仅内部留存，勿外发**）
- `wmt-common/target/wmt-common-*_proguard_base.jar`（混淆前备份，可删除）

## 推广到其他模块

1. **新增 jar 子模块**：放入 `wmt-framework-jdk17` 且包含 `src/main/java` 即可自动挂载；纯库模块在自身 `pom.xml` 覆盖 `proguard.config` 为 `proguard-jdk17-library.conf`。
2. 若引入新的反射/SPI 机制，在 `proguard-jdk17-starter.conf` 补充 `-keep` 后全量构建验证。
3. 每推广一个 Starter，建议补一条 `SpringBootTest` 启动冒烟（后续可加 CI）。

## 常见问题

| 现象 | 原因 | 处理 |
|------|------|------|
| `proguard.conf (No such file or directory)` | 旧配置使用 `${project.parent.basedir}`，在 jdk17 子模块下路径错误 | 使用 `${session.executionRootDirectory}/docs/proguard/...` |
| `Unsupported version number [69.0]` | 用 JDK 25 的 `jmods` 作引导库 | 设置 `PROGUARD_JDK_HOME` 为 JDK 17 |
| `NoSuchMethodError` in `ClassReader` | `proguard-base` 与 `proguard-core` 版本不一致 | 父 POM 已对齐 `7.4.2` + `proguard-core 9.1.1` |
| 业务方启动失败 | 对 Starter 使用了 library 规则或开启了 shrink | Starter 使用 `proguard-jdk17-starter.conf`，并确保 `-dontshrink` |
| `VerifyError: stackmap frame` | 配置含 `-dontpreverify` | JDK17 规则已移除；需保留 ProGuard 的 `Preverifying...` 步骤 |

## 冒烟验证

打包日志应出现 `Preverifying...`（无此步骤易出现运行期 `VerifyError`）。  
试点已在本地用混淆后 JAR 调用 `CommonResult.success(1)` 验证通过。

## 与旧版 `proguard.conf` 的关系

仓库根目录 `proguard.conf` 仍供 **wmt-framework（非 jdk17）** 旧线使用。  
**wmt-framework-jdk17 请以 `docs/proguard/proguard-jdk17-*.conf` 为准。**
