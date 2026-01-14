# ProGuard 混淆问题解决方案

## 当前状态

ProGuard 混淆已**默认禁用**。默认情况下，打包不会执行混淆。

## 如何禁用/启用混淆

### 禁用混淆（默认）
```bash
# 不指定 profile，默认跳过混淆
mvn clean package -DskipTests=true
```

### 启用混淆
```bash
# 使用 obfuscate profile 启用混淆
mvn clean package -Pobfuscate -DskipTests=true
```

## 问题分析：为什么混淆后的 common 模块导致其他模块无法打包？

### 问题原因

1. **类名被混淆**：混淆后的类名变成了 `a`, `b`, `c` 等无意义名称
2. **依赖模块无法找到类**：其他模块在编译时找不到被混淆的类名
3. **包结构可能被改变**：如果使用了 `-repackageclasses ''`，类可能被移动到根包

### 解决方案

#### 方案 1：只混淆最终发布的 jar（推荐）

**思路**：只对最终发布的 jar 文件进行混淆，不混淆中间依赖模块。

**实现方式**：
1. 在根 `pom.xml` 中，为每个子模块单独配置是否混淆
2. 只对最终发布的模块（如 `wmt-framework` 的聚合 jar）进行混淆
3. 依赖模块（如 `wmt-common`）不混淆，保持原始类名

**配置示例**：
```xml
<!-- 在需要混淆的模块的 pom.xml 中 -->
<build>
    <plugins>
        <plugin>
            <groupId>com.github.wvengen</groupId>
            <artifactId>proguard-maven-plugin</artifactId>
            <configuration>
                <skip>${skip.proguard}</skip>
            </configuration>
        </plugin>
    </plugins>
</build>

<!-- 在不需要混淆的模块的 pom.xml 中 -->
<build>
    <plugins>
        <plugin>
            <groupId>com.github.wvengen</groupId>
            <artifactId>proguard-maven-plugin</artifactId>
            <configuration>
                <skip>true</skip>  <!-- 强制跳过混淆 -->
            </configuration>
        </plugin>
    </plugins>
</build>
```

#### 方案 2：使用 Spring Boot 打包插件，只混淆最终 fat jar

**思路**：使用 Spring Boot Maven 插件的打包方式，只对最终的 fat jar 进行混淆。

**配置步骤**：
1. 确保所有子模块都不混淆
2. 在最终应用模块中，使用 Spring Boot Maven 插件打包
3. 对打包后的 fat jar 进行混淆

#### 方案 3：调整 ProGuard 配置，保留必要的类名

**思路**：修改 `proguard.conf`，确保被其他模块依赖的类不被混淆。

**配置示例**：
```conf
# 保留所有 public 类（避免依赖问题）
-keep public class com.wmt.framework.** { *; }

# 或者只保留被其他模块依赖的特定类
-keep class com.wmt.framework.common.pojo.** { *; }
-keep class com.wmt.framework.common.exception.** { *; }
-keep class com.wmt.framework.common.util.** { *; }
```

**注意**：这种方式会降低混淆效果，因为保留了太多类名。

#### 方案 4：使用 Maven 多模块构建策略

**思路**：将项目分为两个阶段构建：
1. 第一阶段：不混淆，构建所有模块
2. 第二阶段：只对最终发布的模块进行混淆

**实现方式**：
```bash
# 第一阶段：正常构建（不混淆）
mvn clean install -DskipTests=true

# 第二阶段：只混淆最终模块
cd wmt-framework
mvn clean package -Pobfuscate -DskipTests=true
```

## 推荐方案

**推荐使用方案 1**：只混淆最终发布的 jar，不混淆中间依赖模块。

### 实施步骤

1. **识别需要混淆的模块**：
   - 通常是最终发布的模块（如 `wmt-framework` 的聚合 jar）
   - 或者是独立发布的模块

2. **识别不需要混淆的模块**：
   - 被其他模块依赖的模块（如 `wmt-common`）
   - 中间依赖模块

3. **配置模块级别的混淆控制**：
   - 在需要混淆的模块中：使用 `${skip.proguard}`（可通过 profile 控制）
   - 在不需要混淆的模块中：强制设置 `<skip>true</skip>`

4. **测试验证**：
   - 确保混淆后的模块可以正常使用
   - 确保依赖关系正常

## 当前配置说明

- **默认行为**：`skip.proguard=true`，所有模块默认不混淆
- **启用混淆**：使用 `-Pobfuscate` profile 时，`skip.proguard=false`，会执行混淆
- **模块控制**：可以在各个子模块的 `pom.xml` 中单独配置是否混淆

## 注意事项

1. **混淆会改变类名**：混淆后的类名无法被其他模块识别
2. **保留必要的类**：如果必须混淆依赖模块，需要保留所有 public 类
3. **测试验证**：混淆后需要充分测试，确保功能正常
4. **版本管理**：混淆后的 jar 和未混淆的 jar 应该使用不同的版本号或分类

## 相关文件

- `pom.xml`：主配置文件，控制默认混淆行为
- `wmt-framework/pom.xml`：框架模块配置
- `proguard.conf`：ProGuard 混淆规则配置

