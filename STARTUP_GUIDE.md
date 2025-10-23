# WMT项目启动完整指南

## ✅ 问题已解决清单

### 1. BOM问题 ✓
- **问题**：UTF-8 BOM导致Spring Boot无法读取配置类
- **解决**：已运行 `fix-bom.ps1` 脚本修复所有文件

### 2. 配置缺失问题 ✓
- **问题**：缺少 `wmt.info.base-package` 配置
- **解决**：已在 `wmt-demo/src/main/resources/application.yml` 中添加：
  ```yaml
  Wmt:
    info:
      base-package: com.wmt.demo
  ```

### 3. Excel依赖问题 ✓
- **问题**：缺少 EasyExcel 依赖
- **解决**：已在 `wmt-demo/pom.xml` 中添加依赖

## 🚀 快速启动步骤

### 步骤1：编译项目（如果还没编译）

```bash
# 进入根目录
cd E:\desktop\AHC\0.工作任务\0进行时\合肥新站\code\jar

# 编译整个项目（javadoc警告可以忽略）
mvn clean install -DskipTests
```

### 步骤2：配置数据库和Redis

编辑 `wmt-demo/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://172.20.10.2:33060/wmt_demo
    username: root
    password: 123456
  
  redis:
    host: 172.20.10.2
    port: 6379
    password: Ab123456
```

### 步骤3：初始化数据库（可选）

```bash
# 如果要使用数据库功能，先执行SQL脚本
mysql -h 172.20.10.2 -P 33060 -u root -p123456 < wmt-demo/src/main/resources/sql/schema.sql
```

### 步骤4：启动应用

```bash
# 方式1：使用Maven
cd wmt-demo
mvn spring-boot:run

# 方式2：直接运行jar包
cd wmt-demo
mvn package -DskipTests
java -jar target/wmt-demo-2025.10-jdk8-SNAPSHOT.jar

# 方式3：使用启动脚本（Windows）
cd wmt-demo
start.bat
```

### 步骤5：验证启动

访问以下地址确认启动成功：

- **Swagger API文档**: http://localhost:8080/demo/swagger-ui/index.html
- **Druid监控面板**: http://localhost:8080/demo/druid/index.html (admin/admin)

看到以下日志说明启动成功：
```
Started DemoApplication in X.XXX seconds (JVM running for X.XXX)
```

## ⚠️ 常见启动问题

### 问题1：`Could not resolve placeholder 'wmt.info.base-package'`

**原因**：配置文件中缺少基础包配置

**解决**：确认 `application.yml` 中有：
```yaml
Wmt:
  info:
    base-package: com.wmt.demo
```

### 问题2：数据库连接失败

**原因**：MySQL未启动或配置错误

**解决**：
1. 确认MySQL已启动
2. 检查连接配置是否正确
3. 如果不需要数据库功能，可以禁用：
   ```yaml
   wmt:
     mybatis:
       enabled: false
   ```

### 问题3：Redis连接失败

**原因**：Redis未启动或配置错误

**解决**：
1. 确认Redis已启动
2. 检查连接配置是否正确
3. 如果不需要Redis功能，可以禁用：
   ```yaml
   wmt:
     redis:
       enabled: false
   ```

### 问题4：端口被占用

**原因**：8080端口已被其他程序占用

**解决**：修改端口
```yaml
server:
  port: 8081  # 改为其他可用端口
```

### 问题5：javadoc生成失败

**原因**：项目路径包含中文字符

**解决**：这是警告不是错误，jar包已正常生成，可以忽略

##  📋 完整配置检查清单

在启动前，请确认以下配置：

- [ ] `wmt.info.base-package` 已配置
- [ ] 数据库连接信息正确（如果使用）
- [ ] Redis连接信息正确（如果使用）
- [ ] 端口未被占用
- [ ] 所有依赖已正确安装（`mvn install` 成功）

## 🎯 最小配置启动（不需要数据库和Redis）

如果只想快速启动看效果，可以禁用数据库和Redis：

```yaml
server:
  port: 8080

spring:
  application:
    name: wmt-demo
  autoconfigure:
    exclude:
      - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
      - org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration

Wmt:
  info:
    base-package: com.wmt.demo

wmt:
  mybatis:
    enabled: false
  redis:
    enabled: false
  web:
    doc:
      enabled: true
```

## 🔧 调试模式启动

如果需要调试，使用以下命令：

```bash
# Maven调试模式
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"

# 或直接运行jar包
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar target/wmt-demo-2025.10-jdk8-SNAPSHOT.jar
```

然后在IDE中配置远程调试，连接到端口5005。

## 📚 更多文档

- **CONFIGURATION_GUIDE.md** - 详细配置说明
- **TESTING.md** - 功能测试指南
- **CONFIG_EXAMPLES.md** - 配置示例大全
- **BOM_ISSUE_FIX.md** - BOM问题修复说明

## ✨ 成功启动的标志

看到以下日志输出即表示启动成功：

```
  ____                      ____                 _             _ 
 / ___|_ __  _ __(_)_ __   __ )  ___   ___ | |_ 
 \___ \ '_ \| '_ | | '_  / _\/|/ _ \ / _ \| __  
  ___) | |_) | '_)| | | | |_| | |_| | (_) | |_  
 |____/| .__/|_|  |_|_| |_\____|_|\___/ \___/ \__|
       |_|                                         

2025-10-23 HH:mm:ss.SSS  INFO --- [           main] com.wmt.demo.DemoApplication
: Started DemoApplication in X.XXX seconds (JVM running for X.XXX)
```

祝启动顺利！🎉

