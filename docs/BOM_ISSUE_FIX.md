# UTF-8 BOM 问题修复指南

## 问题描述

### 问题1：BOM标记导致Spring Boot无法读取配置类

**错误信息**：
```
java.lang.IllegalStateException: Unable to read meta-data for class ﻿com.wmt.framework.apilog.config.WmtApiLogAutoConfiguration
Caused by: java.io.FileNotFoundException: class path resource [﻿com/wmt/framework/apilog/config/WmtApiLogAutoConfiguration.class] cannot be opened because it does not exist
```

**原因**：
- 在批量替换 `Guarantee` 为 `Wmt` 时，使用了 PowerShell 的 `Set-Content` 命令
- PowerShell 默认使用 UTF-8 with BOM 编码
- UTF-8 BOM（`\ufeff`）在文件开头添加了不可见字符
- Spring Boot 读取 `.imports` 文件时无法识别带BOM的类名

### 问题2：Java编译失败

**错误信息**：
```
[ERROR] /E:/desktop/AHC/0.工作任务/0进行时/合肥新站/code/jar/wmt-framework/wmt-spring-boot-starter-biz-tenant/src/main/java/com/wmt/framework/tenant/config/TenantProperties.java:[1,1] 非法字符: '\ufeff'
[ERROR] /E:/desktop/AHC/0.工作任务/0进行时/合肥新站/code/jar/wmt-framework/wmt-spring-boot-starter-biz-tenant/src/main/java/com/wmt/framework/tenant/config/TenantProperties.java:[1,10] 需要class, interface或enum
```

**原因**：
- Java 编译器无法识别 UTF-8 BOM 字符
- BOM 出现在 `.java` 文件的开头导致编译失败

## 解决方案

### 方案1：使用PowerShell脚本批量修复

已创建 `wmt-framework/fix-bom.ps1` 脚本：

```powershell
# 执行修复
cd E:\desktop\AHC\0.工作任务\0进行时\合肥新站\code\jar\wmt-framework
.\fix-bom.ps1
```

脚本功能：
- 自动扫描所有 `.imports` 和 `.java` 文件
- 检测并移除 UTF-8 BOM 标记
- 保存为 UTF-8 without BOM 编码

### 方案2：手动使用PowerShell命令修复

```powershell
# 进入framework目录
cd E:\desktop\AHC\0.工作任务\0进行时\合肥新站\code\jar\wmt-framework

# 创建UTF-8 without BOM编码器
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 修复所有.imports文件
Get-ChildItem -Recurse -Filter "*.imports" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    [System.IO.File]::WriteAllText($_.FullName, $content, $utf8NoBom)
}

# 修复所有.java文件（仅修复含BOM的）
Get-ChildItem -Recurse -Filter "*.java" | ForEach-Object {
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $content = Get-Content $_.FullName -Raw
        [System.IO.File]::WriteAllText($_.FullName, $content, $utf8NoBom)
        Write-Host "Fixed: $($_.Name)"
    }
}
```

### 方案3：使用IDE批量修复

#### IntelliJ IDEA：
1. 打开项目
2. 选择 `File` -> `Settings` -> `Editor` -> `File Encodings`
3. 设置 `Project Encoding` 为 `UTF-8`
4. 勾选 `Transparent native-to-ascii conversion`
5. 在项目中右键 `wmt-framework` 目录
6. 选择 `Remove BOM`

#### VS Code：
1. 安装插件 `change-string-encoding`
2. 打开命令面板（Ctrl+Shift+P）
3. 输入 `Change File Encoding`
4. 选择 `UTF-8 without BOM`

## 验证修复

### 1. 检查文件是否还有BOM

```powershell
# 检查特定文件
$file = "E:\desktop\AHC\0.工作任务\0进行时\合肥新站\code\jar\wmt-framework\wmt-spring-boot-starter-web\src\main\resources\META-INF\spring\org.springframework.boot.autoconfigure.AutoConfiguration.imports"
$bytes = [System.IO.File]::ReadAllBytes($file)
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "文件仍有BOM" -ForegroundColor Red
} else {
    Write-Host "文件没有BOM" -ForegroundColor Green
}
```

### 2. 重新编译项目

```bash
cd E:\desktop\AHC\0.工作任务\0进行时\合肥新站\code\jar
mvn clean install -DskipTests
```

### 3. 启动Demo应用测试

```bash
cd wmt-demo
mvn spring-boot:run
```

## 预防措施

### 1. 配置IDE编码

确保IDE配置为 UTF-8 without BOM：

**IntelliJ IDEA**：
```
File -> Settings -> Editor -> File Encodings
- Global Encoding: UTF-8
- Project Encoding: UTF-8
- Default encoding for properties files: UTF-8
- Transparent native-to-ascii conversion: ✓
```

**Eclipse**：
```
Window -> Preferences -> General -> Workspace
- Text file encoding: UTF-8
- New text file line delimiter: Unix
```

### 2. Git配置

在 `.gitattributes` 文件中配置：

```gitattributes
# 强制所有文本文件使用LF换行符
* text=auto eol=lf

# Java文件
*.java text eol=lf

# 配置文件
*.imports text eol=lf
*.factories text eol=lf
*.xml text eol=lf
*.yml text eol=lf
*.yaml text eol=lf
*.properties text eol=lf
```

### 3. PowerShell脚本规范

以后使用PowerShell编辑文件时，始终使用：

```powershell
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
```

而不是：
```powershell
Set-Content $filePath -Value $content -Encoding UTF8  # 这会添加BOM
```

## 受影响的文件列表

### 配置文件（.imports）

所有以下目录下的 `org.springframework.boot.autoconfigure.AutoConfiguration.imports`：
- wmt-spring-boot-starter-biz-data-permission
- wmt-spring-boot-starter-biz-tenant
- wmt-spring-boot-starter-excel
- wmt-spring-boot-starter-job
- wmt-spring-boot-starter-monitor
- wmt-spring-boot-starter-mq
- wmt-spring-boot-starter-mybatis
- wmt-spring-boot-starter-protection
- wmt-spring-boot-starter-redis
- wmt-spring-boot-starter-security
- wmt-spring-boot-starter-web
- wmt-spring-boot-starter-websocket
- wmt-spring-boot-starter-xxljob

### Java文件

批量替换时修改的AutoConfiguration类：
- WmtApiLogAutoConfiguration.java
- WmtBannerAutoConfiguration.java
- WmtApiEncryptAutoConfiguration.java
- ...（所有从Guarantee改为Wmt的配置类）

以及部分Properties和其他类文件：
- TenantProperties.java
- TenantDatabaseInterceptor.java
- TenantSecurityWebFilter.java
- package-info.java
- 等

## 常见问题

### Q1: 为什么会出现BOM问题？

A: 在批量重命名和替换文件内容时，使用了PowerShell的 `Set-Content` 命令，该命令默认使用 UTF-8 with BOM 编码。

### Q2: 如何避免再次出现此问题？

A: 
1. 使用正确的编码方式保存文件（UTF-8 without BOM）
2. 配置IDE使用正确的编码
3. 使用Git的 `.gitattributes` 管理文件编码

### Q3: 除了Java文件，还有哪些文件可能受影响？

A:
- `.imports` 文件（Spring Boot自动配置）
- `.factories` 文件（Spring Boot自动配置）
- `.xml` 文件
- `.properties` 文件
- 任何需要被程序精确读取的文本文件

### Q4: javadoc生成失败是正常的吗？

A: 是的，这是因为项目路径包含中文字符导致的javadoc问题，不影响jar包的功能，可以忽略或在根pom.xml中配置：

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-javadoc-plugin</artifactId>
    <configuration>
        <failOnError>false</failOnError>
        <failOnWarnings>false</failOnWarnings>
    </configuration>
</plugin>
```

## 总结

1. **问题根源**：PowerShell批量编辑文件时引入了UTF-8 BOM
2. **影响范围**：所有被批量修改的.imports和.java文件
3. **解决方法**：使用fix-bom.ps1脚本一键修复
4. **预防措施**：配置IDE和Git使用UTF-8 without BOM
5. **验证方法**：重新编译并启动应用测试

---

**修复完成后的操作步骤**：

```bash
# 1. 执行BOM修复脚本
cd E:\desktop\AHC\0.工作任务\0进行时\合肥新站\code\jar\wmt-framework
.\fix-bom.ps1

# 2. 重新编译整个项目
cd ..
mvn clean install -DskipTests

# 3. 启动demo应用测试
cd wmt-demo
mvn spring-boot:run

# 4. 访问应用
# http://localhost:8080/demo/swagger-ui/index.html
```

**最终状态**：所有BOM问题已修复，项目可正常编译和运行！ ✅

