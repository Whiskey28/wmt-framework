# WMT 技术组件库

> WMT技术组件库 - 提供企业级Spring Boot技术组件封装

## 📖 项目介绍

WMT是一个基于Spring Boot的企业级技术组件库，提供了一系列开箱即用的技术组件，帮助开发者快速构建企业级应用。所有组件都经过精心设计和封装，遵循Spring Boot Starter规范，可以通过Maven依赖方式快速集成。

### 特性

- ✨ **开箱即用**：遵循Spring Boot自动配置规范，零配置或少量配置即可使用
- 🔒 **源码保护**：支持代码混淆，保护核心技术不被轻易反编译
- 📦 **模块化设计**：各组件独立打包，按需引入，不引入无关依赖
- 🎯 **企业级实践**：基于实际项目经验提炼，满足企业级应用需求
- 📚 **完善文档**：提供详细的使用文档和示例代码

## 🚀 快速开始

### 环境要求

- JDK 1.8+
- Maven 3.6+
- Spring Boot 2.7.x

### 方式一：使用依赖管理（推荐）

在你的Spring Boot项目的`pom.xml`中添加依赖管理：

```xml
<dependencyManagement>
    <dependencies>
        <!-- 引入WMT依赖管理 -->
        <dependency>
            <groupId>com.wmt</groupId>
            <artifactId>wmt-dependencies</artifactId>
            <version>2025.10-jdk8-SNAPSHOT</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

然后根据需要引入具体的组件（不需要指定版本）：

```xml
<dependencies>
    <!-- Web组件 -->
    <dependency>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- MyBatis组件 -->
    <dependency>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
    </dependency>
    
    <!-- Redis组件 -->
    <dependency>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-spring-boot-starter-redis</artifactId>
    </dependency>
</dependencies>
```

### 方式二：直接依赖组件

如果您不想使用依赖管理，也可以直接依赖具体组件：

```xml
<dependencies>
    <!-- Web组件 -->
    <dependency>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-spring-boot-starter-web</artifactId>
        <version>2025.10-jdk8-SNAPSHOT</version>
    </dependency>
    
    <!-- MyBatis组件 -->
    <dependency>
        <groupId>com.wmt</groupId>
        <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
        <version>2025.10-jdk8-SNAPSHOT</version>
    </dependency>
</dependencies>
```

**推荐使用方式一**，因为：
- 统一管理所有组件版本，避免版本冲突
- 简化pom配置，不需要重复指定版本号
- 便于批量升级组件版本

### 配置示例

在`application.yml`中添加相应的配置：

```yaml
spring:
  application:
    name: your-application
    
# 根据引入的组件添加对应的配置
```

## 📦 组件清单

### 框架技术组件

| 组件名称 | 说明 | Maven坐标 |
|---------|------|----------|
| wmt-common | 公共工具类和基础组件 | `com.wmt:wmt-common` |
| wmt-spring-boot-starter-web | Web增强组件（统一异常处理、参数校验、API日志等） | `com.wmt:wmt-spring-boot-starter-web` |
| wmt-spring-boot-starter-mybatis | MyBatis增强组件（分页、数据源等） | `com.wmt:wmt-spring-boot-starter-mybatis` |
| wmt-spring-boot-starter-redis | Redis组件（缓存、分布式锁等） | `com.wmt:wmt-spring-boot-starter-redis` |
| wmt-spring-boot-starter-security | 安全组件（认证、授权等） | `com.wmt:wmt-spring-boot-starter-security` |
| wmt-spring-boot-starter-websocket | WebSocket组件 | `com.wmt:wmt-spring-boot-starter-websocket` |
| wmt-spring-boot-starter-monitor | 监控组件（链路追踪等） | `com.wmt:wmt-spring-boot-starter-monitor` |
| wmt-spring-boot-starter-protection | 服务保护组件（限流、熔断、幂等等） | `com.wmt:wmt-spring-boot-starter-protection` |
| wmt-spring-boot-starter-job | 定时任务组件（基于Quartz） | `com.wmt:wmt-spring-boot-starter-job` |
| wmt-spring-boot-starter-xxljob | XXL-JOB集成组件 | `com.wmt:wmt-spring-boot-starter-xxljob` |
| wmt-spring-boot-starter-mq | 消息队列组件 | `com.wmt:wmt-spring-boot-starter-mq` |
| wmt-spring-boot-starter-excel | Excel导入导出组件 | `com.wmt:wmt-spring-boot-starter-excel` |
| wmt-spring-boot-starter-test | 测试组件 | `com.wmt:wmt-spring-boot-starter-test` |

### 业务技术组件

| 组件名称 | 说明 | Maven坐标 |
|---------|------|----------|
| wmt-spring-boot-starter-biz-tenant | 多租户组件 | `com.wmt:wmt-spring-boot-starter-biz-tenant` |
| wmt-spring-boot-starter-biz-data-permission | 数据权限组件 | `com.wmt:wmt-spring-boot-starter-biz-data-permission` |
| wmt-spring-boot-starter-biz-ip | IP地理位置组件 | `com.wmt:wmt-spring-boot-starter-biz-ip` |

## 💡 使用示例

### Web组件使用

引入Web组件后，自动获得以下功能：

1. **统一异常处理**：自动处理全局异常并返回统一的错误响应
2. **API日志记录**：自动记录所有API请求和响应
3. **参数校验增强**：基于JSR-303的参数校验
4. **跨域配置**：支持跨域请求配置

```java
@RestController
@RequestMapping("/api/user")
public class UserController {
    
    @GetMapping("/{id}")
    public CommonResult<UserVO> getUser(@PathVariable Long id) {
        // 业务逻辑
        return CommonResult.success(userVO);
    }
    
    @PostMapping
    public CommonResult<Long> createUser(@Valid @RequestBody UserCreateDTO dto) {
        // 参数自动校验
        return CommonResult.success(userId);
    }
}
```

### Redis组件使用

```java
@Service
public class UserService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public void cacheUser(Long userId, User user) {
        redisTemplate.opsForValue().set("user:" + userId, user, 1, TimeUnit.HOURS);
    }
    
    public User getUser(Long userId) {
        return (User) redisTemplate.opsForValue().get("user:" + userId);
    }
}
```

### 数据权限组件使用

```java
@Service
public class UserService {
    
    @DataPermission(enable = true) // 启用数据权限
    public List<User> getUserList() {
        // 自动根据当前用户的数据权限过滤数据
        return userMapper.selectList();
    }
}
```

### 多租户组件使用

```yaml
# application.yml
wmt:
  tenant:
    enable: true
    ignore-tables:
      - sys_config
      - sys_dict
```

```java
@Service
public class OrderService {
    
    public List<Order> getOrderList() {
        // 自动根据当前租户ID过滤数据
        return orderMapper.selectList();
    }
    
    @TenantIgnore // 忽略租户隔离
    public List<Order> getAllOrders() {
        return orderMapper.selectList();
    }
}
```

## 🔧 本地安装与部署

### 本地安装到Maven仓库

```bash
# 克隆代码
git clone https://github.com/Wmt/wmt-framework.git
cd wmt-framework

# 安装到本地仓库
mvn clean install -DskipTests
```

### 部署到私有Maven仓库

1. 配置Maven仓库地址（在`pom.xml`的`distributionManagement`节点）

2. 配置认证信息（在`~/.m2/settings.xml`中）

```bash
# 参考 settings.xml.example 文件配置你的settings.xml
cp settings.xml.example ~/.m2/settings.xml
# 编辑 ~/.m2/settings.xml，填入实际的仓库地址和认证信息
```

3. 执行部署

```bash
# Linux/Mac
./deploy.sh

# Windows
deploy.bat

# 使用代码混淆方式部署
./deploy.sh obfuscate
```

### 发布到Maven中央仓库

```bash
# 使用release profile（包含GPG签名）
./deploy.sh release
```

## 🔐 源码保护

为了保护技术组件的源代码不被轻易反编译，项目提供了代码混淆功能：

### 启用代码混淆

```bash
# 使用混淆方式打包
mvn clean package -P obfuscate

# 使用混淆方式部署
mvn deploy -P obfuscate
```

### 混淆配置

混淆配置文件位于项目根目录的`proguard.conf`，你可以根据需要调整混淆规则。

**注意**：
- 混淆后的jar包依然可以正常使用，不影响功能
- 保留了所有公共API，确保外部调用不受影响
- 保留了Spring相关注解和配置，确保自动配置正常工作
- 反编译后的代码可读性大大降低，有效保护核心逻辑

## 📋 版本规范

- `x.x-jdk8-SNAPSHOT`：快照版本，用于开发和测试
- `x.x-jdk8`：正式版本，用于生产环境

当前版本：`2025.10-jdk8-SNAPSHOT`

## 🔨 组件开发指南

如果您需要为WMT框架开发新组件，请参阅 [组件开发指南](docs/COMPONENT_DEVELOPMENT.md)

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

## 📄 许可证

本项目采用 [LICENSE](LICENSE) 许可证。

## 📞 联系方式

如有问题或建议，请通过以下方式联系：

- 提交Issue：https://github.com/Wmt/wmt-framework/issues
- 邮箱：support@wmt.com

## 🙏 致谢

感谢所有为本项目做出贡献的开发者！
