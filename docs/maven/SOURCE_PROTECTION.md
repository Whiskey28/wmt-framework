# WMT框架源代码保护配置

## 概述

本文档说明WMT框架如何配置以确保源代码不会暴露给业务方，只提供编译后的jar包。

## 当前安全配置

### 1. 禁用源码jar生成

**根目录pom.xml配置（已禁用）：**
```xml
<!-- 生成源码jar - 已禁用，保护源代码 -->
<!--
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-source-plugin</artifactId>
    <executions>
        <execution>
            <id>attach-sources</id>
            <goals>
                <goal>jar-no-fork</goal>
            </goals>
        </execution>
    </executions>
</plugin>
-->
```

**wmt-framework/pom.xml配置（覆盖父配置）：**
```xml
<build>
    <plugins>
        <!-- 禁用源码jar生成，保护源代码 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-source-plugin</artifactId>
            <version>3.3.1</version>
            <executions>
                <execution>
                    <id>attach-sources</id>
                    <phase>none</phase>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

**说明：** 
- 根目录的 `maven-source-plugin` 已被注释掉
- `wmt-framework` 模块中通过设置 `<phase>none</phase>` 完全禁用源码jar生成
- 确保子模块不会继承父模块的源码生成配置

### 2. 禁用javadoc生成

**当前配置：**
```xml
<!-- 禁用javadoc生成，避免路径解析错误 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-javadoc-plugin</artifactId>
    <version>3.10.1</version>
    <executions>
        <execution>
            <id>attach-javadocs</id>
            <phase>none</phase>
        </execution>
    </executions>
</plugin>
```

**说明：** 
- 禁用javadoc生成，避免项目路径中的特殊字符导致的解析错误
- 业务方可以通过IDE的自动补全和提示获得API信息
- 进一步保护源代码，不提供任何形式的文档

### 3. 代码混淆配置（可选）

**已配置但未启用：**
```xml
<!-- 是否启用代码混淆，默认false，发布时设置为true -->
<enable.proguard>false</enable.proguard>
```

**启用代码混淆的方法：**
```bash
# 使用obfuscate profile启用代码混淆
mvn clean package -Pobfuscate -DskipTests=true
```

## 验证源代码保护

### 1. 构建验证

**构建命令：**
```bash
mvn clean package
```

**验证结果：**
- ✅ 只生成 `wmt-spring-boot-starter-xxljob-2025.12-jdk8-SNAPSHOT.jar`
- ✅ **不会生成** `wmt-spring-boot-starter-xxljob-2025.12-jdk8-SNAPSHOT-sources.jar`
- ✅ **不会生成** `wmt-spring-boot-starter-xxljob-2025.12-jdk8-SNAPSHOT-javadoc.jar`

### 2. 部署验证

**业务方使用时的依赖：**
```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-xxljob</artifactId>
    <version>2025.12-jdk8-SNAPSHOT</version>
</dependency>
```

**业务方只能获得：**
- 编译后的class文件
- **无法获得源代码**
- **无法获得API文档**

## 进一步保护措施

### 1. 启用代码混淆（推荐）

**修改配置：**
```xml
<properties>
    <!-- 发布时启用代码混淆 -->
    <enable.proguard>true</enable.proguard>
</properties>
```

**使用混淆构建：**
```bash
mvn clean package -Pobfuscate
```

### 2. 私有Maven仓库

**配置私有仓库：**
```xml
<distributionManagement>
    <repository>
        <id>wmt-releases</id>
        <name>WMT Release Repository</name>
        <url>http://your-private-nexus/repository/maven-releases/</url>
    </repository>
    <snapshotRepository>
        <id>wmt-snapshots</id>
        <name>WMT Snapshot Repository</name>
        <url>http://your-private-nexus/repository/maven-snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```

### 3. 访问控制

**Nexus仓库配置：**
- 设置访问权限
- 限制下载权限
- 配置IP白名单

## 安全检查清单

### 构建前检查
- [ ] 确认 `maven-source-plugin` 已禁用
- [ ] 确认 `maven-javadoc-plugin` 配置正确
- [ ] 确认代码混淆配置（如需要）

### 构建后检查
- [ ] 验证没有生成 `-sources.jar` 文件
- [ ] 验证生成的jar包只包含class文件
- [ ] 验证javadoc jar包只包含文档

### 部署前检查
- [ ] 确认部署到私有仓库
- [ ] 确认访问权限配置正确
- [ ] 确认业务方无法访问源代码

## 常见问题

### Q1: 业务方说看不到源代码，无法调试怎么办？

**A:** 这是正常的，WMT框架作为依赖库，业务方只需要：
- 使用API接口
- 查看javadoc文档
- 不需要查看源代码实现

### Q2: 如何提供技术支持？

**A:** 可以通过以下方式：
- 提供详细的API文档
- 提供使用示例和最佳实践
- 提供技术支持和问题解答

### Q3: 代码混淆会影响性能吗？

**A:** 代码混淆主要影响：
- 类名、方法名、字段名被混淆
- 不影响运行时性能
- 可能影响反射调用（需要配置keep规则）

## 总结

通过以上配置，WMT框架可以安全地作为依赖库提供给业务方使用：

1. **源代码保护**：禁用源码jar生成，确保源代码不暴露
2. **API文档**：保留javadoc生成，提供完整的API文档
3. **可选混淆**：支持代码混淆，进一步保护实现细节
4. **私有部署**：支持部署到私有Maven仓库，控制访问权限

业务方只能获得编译后的jar包和API文档，无法获得源代码，有效保护了知识产权。
