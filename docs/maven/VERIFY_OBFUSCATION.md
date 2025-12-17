# 验证代码混淆效果

## 问题诊断

如果使用 `mvn clean package -Pobfuscate -DskipTests=true` 打包后，发现class文件没有明显变化，可能的原因：

1. **ProGuard插件未执行**：检查构建日志
2. **保留规则太宽泛**：大部分类被保留了
3. **混淆配置不正确**：需要调整proguard.conf

## 验证步骤

### 1. 检查构建日志

**查看ProGuard是否执行：**

```bash
# 重新打包并查看详细日志
mvn clean package -Pobfuscate -DskipTests=true -X | grep -i proguard
```

**应该看到类似输出：**
```
[INFO] --- proguard-maven-plugin:2.6.0:proguard (default) @ wmt-common ---
[INFO] ProGuard, version 7.4.2
[INFO] Reading program jar [wmt-common-2025.10-jdk8-SNAPSHOT.jar]
[INFO] Shrinking...
[INFO] Optimizing...
[INFO] Obfuscating...
[INFO] Writing output...
```

**如果没有看到ProGuard日志，说明插件未执行，可能原因：**
- 子模块没有显式引用ProGuard插件
- skip.proguard属性未正确传递

### 2. 检查jar包内容

**对比混淆前后的类名：**

```bash
# 不混淆打包
mvn clean package -DskipTests=true

# 查看未混淆的类名
jar tf wmt-framework/wmt-common/target/wmt-common-*.jar | grep "\.class$" | head -20

# 混淆打包
mvn clean package -Pobfuscate -DskipTests=true

# 查看混淆后的类名
jar tf wmt-framework/wmt-common/target/wmt-common-*.jar | grep "\.class$" | head -20
```

**预期结果：**
- 未混淆：`com/wmt/framework/common/util/json/JsonUtils.class`
- 混淆后：`com/wmt/framework/common/util/json/a.class` 或类似短名称

### 3. 使用反编译工具验证

#### 方法1：使用JD-GUI

1. **下载JD-GUI**：https://java-decompiler.github.io/
2. **打开jar包**：`wmt-framework/wmt-common/target/wmt-common-*.jar`
3. **查看类内容**：
   - 未混淆：可以看到清晰的类名、方法名、变量名
   - 混淆后：类名、方法名、变量名被混淆为 `a`, `b`, `c` 等

#### 方法2：使用IntelliJ IDEA

1. **打开jar包**：
   - File → Project Structure → Libraries
   - 添加jar包
2. **查看反编译代码**：
   - 在Project视图中打开jar包
   - 双击class文件查看反编译结果

#### 方法3：使用命令行工具

```bash
# 使用javap查看类信息
javap -c -private com.wmt.framework.common.util.json.JsonUtils

# 混淆后应该看到类名和方法名被混淆
```

### 4. 检查特定类的混淆效果

**选择一个工具类进行验证：**

```bash
# 1. 找到工具类
# 例如：com.wmt.framework.common.util.json.JsonUtils

# 2. 查看未混淆的jar包
unzip -l wmt-framework/wmt-common/target/wmt-common-*.jar | grep JsonUtils

# 3. 查看混淆后的jar包（类名应该被混淆）
unzip -l wmt-framework/wmt-common/target/wmt-common-*.jar | grep -E "(a\.class|b\.class|c\.class)"
```

### 5. 检查ProGuard输出文件

**ProGuard会生成映射文件：**

```bash
# 查看混淆映射文件（如果生成了）
ls -la wmt-framework/wmt-common/target/*.map
ls -la wmt-framework/wmt-common/target/*.txt

# 映射文件会显示：原始类名 -> 混淆后的类名
```

### 6. 验证jar包大小变化

**混淆后jar包大小可能会变化：**

```bash
# 对比jar包大小
ls -lh wmt-framework/wmt-common/target/wmt-common-*.jar

# 混淆后可能会：
# - 略微增大（ProGuard添加元数据）
# - 或略微减小（移除了调试信息）
```

## 常见问题排查

### 问题1：ProGuard插件未执行

**症状：** 构建日志中没有ProGuard相关信息

**解决方案：**

1. **检查子模块是否引用了插件**：
   在子模块的pom.xml中添加：
   ```xml
   <build>
       <plugins>
           <plugin>
               <groupId>com.github.wvengen</groupId>
               <artifactId>proguard-maven-plugin</artifactId>
           </plugin>
       </plugins>
   </build>
   ```

2. **检查skip属性**：
   ```bash
   # 确认属性值
   mvn help:effective-pom -Pobfuscate | grep skip.proguard
   ```

### 问题2：所有类都被保留了

**症状：** 混淆后类名和方法名都没有变化

**原因：** `proguard.conf`中的保留规则太宽泛

**解决方案：**
- 移除 `-keep public class * { public protected *; }` 这样的宽泛规则
- 只保留业务方真正需要的API类
- 工具类可以保留类名，但允许混淆内部实现

### 问题3：混淆后功能异常

**症状：** 混淆后的jar包无法正常使用

**解决方案：**
- 检查反射调用的类是否已保留
- 检查Spring配置类是否已保留
- 检查序列化类是否已保留

## 快速验证

### Windows用户

直接运行根目录的验证脚本：

```bash
verify-obfuscation.bat
```

脚本会自动：
1. 执行不混淆打包
2. 执行混淆打包
3. 提示验证方法

### 手动验证（推荐）

#### 步骤1：检查构建日志

```bash
mvn clean package -Pobfuscate -DskipTests=true 2>&1 | findstr /i "proguard"
```

**应该看到：**
```
[INFO] --- proguard-maven-plugin:2.6.0:proguard (default) @ wmt-common ---
[INFO] ProGuard, version 7.4.2
```

#### 步骤2：查看jar包中的类名

```bash
# 查看混淆后的类名
jar tf wmt-framework\wmt-common\target\wmt-common-*.jar | findstr "\.class$" | findstr /v "$"
```

**预期：** 应该看到很多短名称的类，如 `a.class`, `b.class` 等

#### 步骤3：使用JD-GUI验证

1. 下载JD-GUI：https://java-decompiler.github.io/
2. 打开jar包：`wmt-framework\wmt-common\target\wmt-common-*.jar`
3. 查看类：
   - **未混淆**：`com.wmt.framework.common.util.json.JsonUtils`
   - **混淆后**：`com.wmt.framework.common.util.json.a` 或类似

## 快速验证脚本

### Linux/Mac用户

创建 `verify-obfuscation.sh`：

```bash
#!/bin/bash

echo "=== 验证代码混淆效果 ==="

# 1. 清理并打包（不混淆）
echo "1. 打包（不混淆）..."
mvn clean package -DskipTests=true -q
JAR_NORMAL=$(find . -name "wmt-common-*.jar" -path "*/target/*" | head -1)
echo "   未混淆jar: $JAR_NORMAL"

# 2. 清理并打包（混淆）
echo "2. 打包（混淆）..."
mvn clean package -Pobfuscate -DskipTests=true -q
JAR_OBFUSCATED=$(find . -name "wmt-common-*.jar" -path "*/target/*" | head -1)
echo "   混淆后jar: $JAR_OBFUSCATED"

# 3. 对比类名
echo "3. 对比类名..."
echo "   未混淆的类（前10个）："
jar tf "$JAR_NORMAL" | grep "\.class$" | grep -v "\\$" | head -10

echo "   混淆后的类（前10个）："
jar tf "$JAR_OBFUSCATED" | grep "\.class$" | grep -v "\\$" | head -10

# 4. 检查特定类
echo "4. 检查JsonUtils类："
if jar tf "$JAR_NORMAL" | grep -q "JsonUtils"; then
    echo "   ✓ 未混淆jar包含JsonUtils"
else
    echo "   ✗ 未混淆jar不包含JsonUtils"
fi

if jar tf "$JAR_OBFUSCATED" | grep -q "JsonUtils"; then
    echo "   ⚠ 混淆后jar仍包含JsonUtils（可能被保留了）"
else
    echo "   ✓ 混淆后jar不包含JsonUtils（已被混淆）"
fi

echo "=== 验证完成 ==="
```

Windows版本 `verify-obfuscation.bat`：

```batch
@echo off
echo === 验证代码混淆效果 ===

echo 1. 打包（不混淆）...
call mvn clean package -DskipTests=true -q
echo    完成

echo 2. 打包（混淆）...
call mvn clean package -Pobfuscate -DskipTests=true -q
echo    完成

echo 3. 请手动检查以下jar包：
echo    - wmt-framework\wmt-common\target\wmt-common-*.jar
echo    使用JD-GUI或IntelliJ IDEA打开查看类名是否被混淆

echo === 验证完成 ===
pause
```

## 预期结果

### 混淆成功的标志：

1. ✅ **构建日志中有ProGuard输出**
2. ✅ **类名被混淆**：`JsonUtils` → `a` 或类似短名称
3. ✅ **方法内部变量被混淆**：`userName` → `a`, `userId` → `b`
4. ✅ **公共API类名保持不变**：`CommonResult`, `PageResult` 等
5. ✅ **反编译后代码难以阅读**

### 混淆失败的标志：

1. ❌ **构建日志中没有ProGuard输出**
2. ❌ **所有类名都保持原样**
3. ❌ **jar包内容完全一致**

## 下一步

如果验证发现混淆未生效：

1. **检查ProGuard插件配置**
2. **调整proguard.conf保留规则**
3. **确保子模块正确引用插件**
4. **查看详细构建日志排查问题**

