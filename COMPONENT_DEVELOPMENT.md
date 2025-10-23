# WMT 组件开发指南

本文档指导您如何为WMT框架开发新的技术组件。

## 📋 目录

1. [开发环境准备](#开发环境准备)
2. [组件目录结构](#组件目录结构)
3. [组件开发步骤](#组件开发步骤)
4. [最佳实践](#最佳实践)
5. [测试与发布](#测试与发布)

## 开发环境准备

### 必需工具

- JDK 1.8+
- Maven 3.6+
- IDE (推荐 IntelliJ IDEA)
- Git

### 克隆项目

```bash
git clone https://github.com/Wmt/wmt-framework.git
cd wmt-framework
```

### 导入IDE

1. 打开IDE
2. 选择 `Import Project` 或 `Open`
3. 选择项目根目录下的 `pom.xml`
4. 等待Maven依赖下载完成

## 组件目录结构

WMT框架的组件统一放在 `wmt-framework` 目录下，标准的组件目录结构如下：

```
wmt-framework/
└── wmt-spring-boot-starter-xxx/          # 组件根目录
    ├── src/
    │   ├── main/
    │   │   ├── java/
    │   │   │   └── com/
    │   │   │       └── wmt/
    │   │   │           └── framework/
    │   │   │               └── xxx/       # 组件包
    │   │   │                   ├── package-info.java
    │   │   │                   ├── config/           # 配置类
    │   │   │                   │   ├── WmtXxxAutoConfiguration.java
    │   │   │                   │   └── XxxProperties.java
    │   │   │                   ├── core/             # 核心实现
    │   │   │                   │   ├── annotation/   # 注解
    │   │   │                   │   ├── service/      # 服务接口和实现
    │   │   │                   │   └── util/         # 工具类
    │   │   │                   └── ...
    │   │   └── resources/
    │   │       ├── META-INF/
    │   │       │   └── spring/
    │   │       │       └── org.springframework.boot.autoconfigure.AutoConfiguration.imports
    │   │       └── (其他资源文件)
    │   └── test/
    │       └── java/
    │           └── com/
    │               └── wmt/
    │                   └── framework/
    │                       └── xxx/       # 测试代码
    └── pom.xml
```

## 组件开发步骤

### 1. 创建组件模块

#### 1.1 创建Maven模块

在 `wmt-framework/pom.xml` 中添加模块：

```xml
<modules>
    <!-- 其他模块 -->
    <module>wmt-spring-boot-starter-xxx</module>
</modules>
```

#### 1.2 创建组件pom.xml

在 `wmt-framework/wmt-spring-boot-starter-xxx/pom.xml` 创建：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-framework</artifactId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    
    <artifactId>wmt-spring-boot-starter-xxx</artifactId>
    <packaging>jar</packaging>
    
    <name>${project.artifactId}</name>
    <description>WMT XXX组件 - 用于...</description>
    <url>https://github.com/Wmt/wmt-framework</url>
    
    <dependencies>
        <!-- 通用组件依赖 -->
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-common</artifactId>
        </dependency>
        
        <!-- Spring Boot相关 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
        
        <!-- 其他依赖 -->
        
        <!-- 测试依赖 -->
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

### 2. 创建包结构

创建标准的包结构：

```bash
mkdir -p src/main/java/com/wmt/framework/xxx/config
mkdir -p src/main/java/com/wmt/framework/xxx/core
mkdir -p src/main/resources/META-INF/spring
mkdir -p src/test/java/com/wmt/framework/xxx
```

### 3. 编写配置类

#### 3.1 配置属性类

创建 `XxxProperties.java`：

```java
package com.wmt.framework.xxx.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "wmt.xxx")
public class XxxProperties {
    
    /**
     * 是否启用XXX功能
     */
    private Boolean enabled = true;
    
    /**
     * 其他配置项
     */
    private String someConfig;
}
```

#### 3.2 自动配置类

创建 `WmtXxxAutoConfiguration.java`：

```java
package com.wmt.framework.xxx.config;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

@AutoConfiguration
@ConditionalOnProperty(prefix = "wmt.xxx", value = "enabled", havingValue = "true", matchIfMissing = true)
@EnableConfigurationProperties(XxxProperties.class)
public class WmtXxxAutoConfiguration {
    
    @Bean
    public XxxService xxxService(XxxProperties properties) {
        return new XxxServiceImpl(properties);
    }
}
```

### 4. 注册自动配置

创建 `src/main/resources/META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`：

```
com.wmt.framework.xxx.config.WmtXxxAutoConfiguration
```

### 5. 实现核心功能

在 `core` 包下实现组件的核心功能：

```java
package com.wmt.framework.xxx.core.service;

public interface XxxService {
    void doSomething();
}
```

```java
package com.wmt.framework.xxx.core.service;

public class XxxServiceImpl implements XxxService {
    
    private final XxxProperties properties;
    
    public XxxServiceImpl(XxxProperties properties) {
        this.properties = properties;
    }
    
    @Override
    public void doSomething() {
        // 实现逻辑
    }
}
```

### 6. 添加package-info.java

创建 `package-info.java` 提供包级文档：

```java
/**
 * WMT XXX组件
 * 
 * <p>提供XXX功能的封装，包括：
 * <ul>
 *     <li>功能1</li>
 *     <li>功能2</li>
 * </ul>
 * 
 * <p>使用示例：
 * <pre>{@code
 * @Autowired
 * private XxxService xxxService;
 * 
 * public void demo() {
 *     xxxService.doSomething();
 * }
 * }</pre>
 *
 * @author Your Name
 * @since 2025-10-22
 */
package com.wmt.framework.xxx;
```

### 7. 编写单元测试

在 `src/test/java` 下创建测试类：

```java
package com.wmt.framework.xxx;

import com.wmt.framework.test.core.ut.BaseDbUnitTest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

class XxxServiceTest extends BaseDbUnitTest {
    
    @Autowired
    private XxxService xxxService;
    
    @Test
    void testDoSomething() {
        // 测试逻辑
        xxxService.doSomething();
        // 断言
    }
}
```

### 8. 更新依赖管理

在 `wmt-dependencies/pom.xml` 中添加组件依赖管理：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-xxx</artifactId>
    <version>${revision}</version>
</dependency>
```

## 最佳实践

### 命名规范

1. **模块名**：`wmt-spring-boot-starter-{功能名}`
2. **包名**：`com.wmt.framework.{功能名}`
3. **配置类**：`Wmt{功能名}AutoConfiguration`
4. **属性类**：`{功能名}Properties`
5. **配置前缀**：`wmt.{功能名}`

### 代码规范

1. **使用Lombok**：减少样板代码
   ```java
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   ```

2. **日志规范**：使用SLF4J
   ```java
   @Slf4j
   public class XxxService {
       public void method() {
           log.info("操作日志");
       }
   }
   ```

3. **异常处理**：使用框架统一异常
   ```java
   import com.wmt.framework.common.exception.ServiceException;
   import static com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants.*;
   
   throw new ServiceException(BAD_REQUEST.getCode(), "错误信息");
   ```

4. **注解说明**：添加详细的JavaDoc
   ```java
   /**
    * XXX服务接口
    *
    * @author Your Name
    * @since 2025-10-22
    */
   public interface XxxService {
       /**
        * 执行某操作
        *
        * @param param 参数说明
        * @return 返回值说明
        */
       Result doSomething(Param param);
   }
   ```

### 配置规范

1. **提供默认值**：让组件开箱即用
2. **支持开关**：提供 `enabled` 配置项
3. **配置验证**：使用 `@Valid` 验证配置项
4. **配置文档**：在属性类中添加注释

### 依赖管理

1. **最小化依赖**：只引入必需的依赖
2. **依赖范围**：正确设置 `scope`
   - `provided`：编译时需要，运行时由使用方提供
   - `optional`：可选依赖
   - `test`：测试依赖
3. **排除冲突**：使用 `<exclusions>` 排除冲突的传递依赖

## 测试与发布

### 本地测试

```bash
# 运行单元测试
mvn clean test

# 编译打包
mvn clean package -DskipTests

# 安装到本地仓库
mvn clean install -DskipTests
```

### 集成测试

创建一个示例项目，引入开发的组件进行集成测试：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-xxx</artifactId>
    <version>2025.10-jdk8-SNAPSHOT</version>
</dependency>
```

### 发布到仓库

```bash
# 发布到私有仓库
mvn deploy -DskipTests

# 发布混淆版本
mvn deploy -P obfuscate -DskipTests
```

## 常见问题

### Q: 如何调试自动配置？

A: 在 `application.yml` 中启用调试：

```yaml
debug: true
logging:
  level:
    org.springframework.boot.autoconfigure: DEBUG
```

### Q: 如何处理循环依赖？

A: 使用 `@Lazy` 注解或重构代码结构避免循环依赖。

### Q: 如何支持多数据源？

A: 参考 `wmt-spring-boot-starter-mybatis` 组件的实现。

### Q: 如何添加条件装配？

A: 使用Spring的条件注解：

- `@ConditionalOnClass`：当类路径存在某个类时
- `@ConditionalOnBean`：当容器中存在某个Bean时
- `@ConditionalOnProperty`：当配置属性满足条件时
- `@ConditionalOnMissingBean`：当容器中不存在某个Bean时

## 参考资料

- [Spring Boot 自动配置原理](https://docs.spring.io/spring-boot/docs/current/reference/html/using.html#using.auto-configuration)
- [创建自定义Starter](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-auto-configuration)
- [WMT现有组件源码](./wmt-framework/)

## 联系我们

如有疑问，请通过以下方式联系：

- 提交Issue：https://github.com/Wmt/wmt-framework/issues
- 邮箱：dev@wmt.com

