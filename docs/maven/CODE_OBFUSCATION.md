# WMT框架代码混淆配置说明

## 概述

本文档说明如何启用WMT框架的代码混淆功能，以保护源代码不被反编译。

## 当前保护措施

### 1. 已实施的保护

- ✅ **禁用源码jar生成**：业务方无法直接获得源代码
- ✅ **禁用javadoc生成**：不提供API文档（业务方可通过IDE自动补全获得提示）
- ⚠️ **代码混淆（可选）**：已配置但默认未启用，需要手动启用

### 2. 为什么需要代码混淆？

虽然已禁用源码jar，但**class文件仍然可以被反编译工具还原为近似源码**，例如：
- JD-GUI
- Fernflower（IntelliJ IDEA内置）
- CFR
- Procyon

**代码混淆的作用：**
- 将类名、方法名、变量名混淆为无意义的字符（如 `a`, `b`, `c`）
- 移除调试信息（行号、局部变量名等）
- 使反编译后的代码难以阅读和理解
- **大幅增加逆向工程的难度**

## 启用代码混淆

### 方法1：使用obfuscate profile（推荐）

```bash
# 启用混淆打包
mvn clean package -Pobfuscate -DskipTests=true
```

### 方法2：直接设置属性

```bash
# 启用混淆打包
mvn clean package -Dskip.proguard=false -DskipTests=true
```

### 方法3：修改pom.xml（永久启用）

在根目录 `pom.xml` 中修改：

```xml
<properties>
    <!-- 启用代码混淆 -->
    <skip.proguard>false</skip.proguard>
</properties>
```

然后执行：
```bash
mvn clean package -DskipTests=true
```

## 混淆配置说明

### ProGuard配置文件

配置文件位置：`proguard.conf`

**关键配置说明：**

1. **保留公共API**：业务方需要调用的接口不会被混淆
   ```proguard
   -keep public class * {
       public protected *;
   }
   ```

2. **保留Spring配置类**：确保Spring Boot自动配置正常工作
   ```proguard
   -keep @org.springframework.context.annotation.Configuration class * { *; }
   -keep @org.springframework.boot.context.properties.ConfigurationProperties class * { *; }
   ```

3. **保留公共POJO/DTO/VO**：业务方需要使用的数据传输对象
   ```proguard
   -keep class com.wmt.framework.**.pojo.** { *; }
   -keep class com.wmt.framework.**.vo.** { *; }
   -keep class com.wmt.framework.**.dto.** { *; }
   ```

4. **保留Mapper接口**：MyBatis Mapper接口需要保留
   ```proguard
   -keep interface com.wmt.framework.**.mapper.** { *; }
   ```

5. **混淆实现类**：内部实现类会被混淆，保护业务逻辑

## 验证混淆效果

### 1. 构建验证

```bash
# 启用混淆打包
mvn clean package -Pobfuscate -DskipTests=true

# 检查生成的jar包
ls -lh wmt-framework/wmt-common/target/*.jar
```

### 2. 反编译验证

使用反编译工具验证混淆效果：

1. **使用JD-GUI**：
   ```bash
   # 下载JD-GUI：https://java-decompiler.github.io/
   # 打开混淆后的jar包，查看类名和方法名是否被混淆
   ```

2. **使用IntelliJ IDEA**：
   - 在IDEA中打开混淆后的jar包
   - 查看反编译后的代码
   - 验证内部实现类是否被混淆

**预期效果：**
- ✅ 公共API类名和方法名保持不变（如 `CommonResult`, `PageResult`）
- ✅ 内部实现类被混淆（如 `a`, `b`, `c`）
- ✅ 方法体中的变量名被混淆
- ✅ 代码逻辑难以理解

## 注意事项

### 1. 混淆对性能的影响

- **运行时性能**：几乎无影响，混淆只是重命名，不改变代码逻辑
- **启动性能**：可能略微增加（首次加载时需要解析混淆后的类名）

### 2. 混淆对功能的影响

- **公共API**：不受影响，已配置保留规则
- **Spring自动配置**：不受影响，配置类已保留
- **反射调用**：需要特别注意，确保反射调用的类已配置保留规则
- **序列化**：不受影响，已配置保留序列化相关类

### 3. 调试问题

- **混淆后的代码难以调试**：建议在开发环境禁用混淆
- **生产环境启用混淆**：保护源代码

### 4. 版本管理

建议在版本控制中：
- **开发分支**：`skip.proguard=true`（禁用混淆）
- **发布分支**：`skip.proguard=false`（启用混淆）

## 常见问题

### Q1: 混淆后业务方无法使用某些功能？

**A:** 检查 `proguard.conf` 中的保留规则，确保相关类已配置保留：
```proguard
-keep class com.wmt.framework.**.YourClass { *; }
```

### Q2: Spring Boot自动配置不生效？

**A:** 确保配置类已保留：
```proguard
-keep @org.springframework.context.annotation.Configuration class * { *; }
```

### Q3: MyBatis Mapper接口报错？

**A:** 确保Mapper接口已保留：
```proguard
-keep interface com.wmt.framework.**.mapper.** { *; }
```

### Q4: 混淆后jar包大小增加？

**A:** 这是正常的，ProGuard会添加一些元数据。可以通过优化配置减少大小。

## 最佳实践

1. **开发阶段**：禁用混淆，便于调试
2. **测试阶段**：启用混淆，验证混淆后的功能是否正常
3. **发布阶段**：启用混淆，保护源代码
4. **持续优化**：根据实际使用情况，调整 `proguard.conf` 中的保留规则

## 总结

通过启用代码混淆，WMT框架可以：

1. ✅ **保护源代码**：防止被反编译工具轻易还原
2. ✅ **保持API可用**：业务方仍可正常使用公共API
3. ✅ **不影响功能**：Spring Boot、MyBatis等功能正常工作
4. ✅ **灵活控制**：通过profile或属性控制是否启用

**推荐使用方式：**
```bash
# 开发环境（不混淆）
mvn clean package -DskipTests=true

# 生产环境（混淆）
mvn clean package -Pobfuscate -DskipTests=true
```

