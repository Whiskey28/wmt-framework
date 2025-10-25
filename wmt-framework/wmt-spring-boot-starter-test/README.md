# WMT Test Starter

基于Spring Boot Test的测试组件，提供单元测试、集成测试等测试功能。

## 功能特性

- 🧪 **单元测试**: 基于JUnit 5的单元测试支持
- 🔗 **集成测试**: 基于Spring Boot Test的集成测试
- 🗄️ **数据库测试**: 支持H2内存数据库测试
- 🔴 **Redis测试**: 支持内嵌Redis测试
- 🎭 **Mock支持**: 基于Mockito的Mock功能
- 📊 **测试数据**: 支持随机测试数据生成
- 🔧 **配置灵活**: 支持多种测试配置
- 📝 **测试工具**: 提供测试工具类和断言

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-test</artifactId>
    <version>${wmt.version}</version>
    <scope>test</scope>
</dependency>
```

### 2. 创建单元测试

```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // 执行测试
        Long userId = userService.createUser(reqVO);
        
        // 验证结果
        AssertUtils.assertNotNull(userId);
        AssertUtils.assertTrue(userId > 0);
    }
    
    @Test
    void testGetUserById() {
        // 准备测试数据
        Long userId = 1L;
        
        // 执行测试
        UserDO user = userService.getUserById(userId);
        
        // 验证结果
        AssertUtils.assertNotNull(user);
        AssertUtils.assertEquals(userId, user.getId());
    }
}
```

### 3. 创建集成测试

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UserControllerTest {
    
    @Resource
    private TestRestTemplate restTemplate;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // 执行测试
        ResponseEntity<CommonResult<Long>> response = restTemplate.postForEntity(
            "/admin-api/system/user/create", reqVO, CommonResult.class);
        
        // 验证结果
        AssertUtils.assertEquals(HttpStatus.OK, response.getStatusCode());
        AssertUtils.assertNotNull(response.getBody());
        AssertUtils.assertTrue(response.getBody().getCode() == 0);
    }
}
```

### 4. 使用数据库测试

```java
@SpringBootTest
@Sql(scripts = "/sql/clean.sql", executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD)
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // 执行测试
        Long userId = userService.createUser(reqVO);
        
        // 验证结果
        AssertUtils.assertNotNull(userId);
        AssertUtils.assertTrue(userId > 0);
    }
}
```

### 5. 使用Redis测试

```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @Test
    void testCacheUser() {
        // 准备测试数据
        Long userId = 1L;
        
        // 执行测试
        UserDO user = userService.getUserById(userId);
        
        // 验证结果
        AssertUtils.assertNotNull(user);
        AssertUtils.assertEquals(userId, user.getId());
    }
}
```

### 6. 使用Mock测试

```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @MockBean
    private UserMapper userMapper;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // Mock行为
        when(userMapper.insert(any(UserDO.class))).thenReturn(1);
        
        // 执行测试
        Long userId = userService.createUser(reqVO);
        
        // 验证结果
        AssertUtils.assertNotNull(userId);
        verify(userMapper, times(1)).insert(any(UserDO.class));
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.test.db.enabled` | boolean | true | 是否启用数据库测试 |
| `wmt.test.redis.enabled` | boolean | true | 是否启用Redis测试 |
| `wmt.test.mock.enabled` | boolean | true | 是否启用Mock测试 |

### 数据库测试配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.test.db.url` | String | jdbc:h2:mem:testdb | 测试数据库URL |
| `wmt.test.db.username` | String | sa | 测试数据库用户名 |
| `wmt.test.db.password` | String | - | 测试数据库密码 |

### Redis测试配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.test.redis.host` | String | localhost | 测试Redis主机 |
| `wmt.test.redis.port` | int | 6379 | 测试Redis端口 |
| `wmt.test.redis.password` | String | - | 测试Redis密码 |

## 核心功能

### 单元测试基类

#### BaseDbUnitTest

数据库单元测试基类：

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE, classes = BaseDbUnitTest.Application.class)
@ActiveProfiles("unit-test")
@Sql(scripts = "/sql/clean.sql", executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD)
public class BaseDbUnitTest {
    
    @Import({
        // DB配置类
        WmtDataSourceAutoConfiguration.class,
        DataSourceAutoConfiguration.class,
        DataSourceTransactionManagerAutoConfiguration.class,
        DruidDataSourceAutoConfigure.class,
        SqlInitializationTestConfiguration.class,
        // MyBatis配置类
        WmtMybatisAutoConfiguration.class,
        MybatisPlusAutoConfiguration.class,
        // 其它配置类
        SpringUtil.class
    })
    public static class Application {
    }
}
```

#### BaseRedisUnitTest

Redis单元测试基类：

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE, classes = BaseRedisUnitTest.Application.class)
@ActiveProfiles("unit-test")
public class BaseRedisUnitTest {
    
    @Import({
        // Redis配置类
        RedisTestConfiguration.class,
        RedisAutoConfiguration.class,
        WmtRedisAutoConfiguration.class,
        RedissonAutoConfiguration.class,
        // 其它配置类
        SpringUtil.class
    })
    public static class Application {
    }
}
```

#### BaseDbAndRedisUnitTest

数据库+Redis单元测试基类：

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE, classes = BaseDbAndRedisUnitTest.Application.class)
@ActiveProfiles("unit-test")
@Sql(scripts = "/sql/clean.sql", executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD)
public class BaseDbAndRedisUnitTest {
    
    @Import({
        // DB配置类
        WmtDataSourceAutoConfiguration.class,
        DataSourceAutoConfiguration.class,
        DataSourceTransactionManagerAutoConfiguration.class,
        DruidDataSourceAutoConfigure.class,
        SqlInitializationTestConfiguration.class,
        // MyBatis配置类
        WmtMybatisAutoConfiguration.class,
        MybatisPlusAutoConfiguration.class,
        // Redis配置类
        RedisTestConfiguration.class,
        WmtRedisAutoConfiguration.class,
        RedisAutoConfiguration.class,
        RedissonAutoConfiguration.class,
        // 其它配置类
        SpringUtil.class
    })
    public static class Application {
    }
}
```

#### BaseMockitoUnitTest

Mockito单元测试基类：

```java
@ExtendWith(MockitoExtension.class)
public class BaseMockitoUnitTest {
    
    @Mock
    protected UserMapper userMapper;
    
    @Mock
    protected UserService userService;
}
```

### 测试工具类

#### AssertUtils

断言工具类：

```java
public class AssertUtils {
    
    /**
     * 断言对象不为空
     */
    public static void assertNotNull(Object object) {
        assertNotNull(object, "对象不能为空");
    }
    
    /**
     * 断言对象不为空（带消息）
     */
    public static void assertNotNull(Object object, String message) {
        assert object != null : message;
    }
    
    /**
     * 断言对象为空
     */
    public static void assertNull(Object object) {
        assertNull(object, "对象必须为空");
    }
    
    /**
     * 断言对象为空（带消息）
     */
    public static void assertNull(Object object, String message) {
        assert object == null : message;
    }
    
    /**
     * 断言条件为真
     */
    public static void assertTrue(boolean condition) {
        assertTrue(condition, "条件必须为真");
    }
    
    /**
     * 断言条件为真（带消息）
     */
    public static void assertTrue(boolean condition, String message) {
        assert condition : message;
    }
    
    /**
     * 断言条件为假
     */
    public static void assertFalse(boolean condition) {
        assertFalse(condition, "条件必须为假");
    }
    
    /**
     * 断言条件为假（带消息）
     */
    public static void assertFalse(boolean condition, String message) {
        assert !condition : message;
    }
    
    /**
     * 断言两个对象相等
     */
    public static void assertEquals(Object expected, Object actual) {
        assertEquals(expected, actual, "对象不相等");
    }
    
    /**
     * 断言两个对象相等（带消息）
     */
    public static void assertEquals(Object expected, Object actual, String message) {
        assert Objects.equals(expected, actual) : message;
    }
}
```

#### RandomUtils

随机数据工具类：

```java
public class RandomUtils {
    
    /**
     * 生成随机用户名
     */
    public static String randomUsername() {
        return "testuser" + System.currentTimeMillis();
    }
    
    /**
     * 生成随机邮箱
     */
    public static String randomEmail() {
        return "test" + System.currentTimeMillis() + "@example.com";
    }
    
    /**
     * 生成随机手机号
     */
    public static String randomMobile() {
        return "138" + String.format("%08d", new Random().nextInt(100000000));
    }
    
    /**
     * 生成随机用户
     */
    public static UserDO randomUser() {
        UserDO user = new UserDO();
        user.setUsername(randomUsername());
        user.setEmail(randomEmail());
        user.setMobile(randomMobile());
        user.setStatus(1);
        return user;
    }
}
```

### 测试配置

#### SqlInitializationTestConfiguration

SQL初始化测试配置：

```java
@Configuration
public class SqlInitializationTestConfiguration {
    
    @Bean
    @Primary
    public DataSource dataSource() {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl("jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE");
        dataSource.setUsername("sa");
        dataSource.setPassword("");
        dataSource.setDriverClassName("org.h2.Driver");
        return dataSource;
    }
}
```

#### RedisTestConfiguration

Redis测试配置：

```java
@Configuration
public class RedisTestConfiguration {
    
    @Bean
    public RedisServer redisServer() {
        RedisServer redisServer = new RedisServer(6379);
        redisServer.start();
        return redisServer;
    }
}
```

## 最佳实践

### 1. 单元测试设计

```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // 执行测试
        Long userId = userService.createUser(reqVO);
        
        // 验证结果
        AssertUtils.assertNotNull(userId);
        AssertUtils.assertTrue(userId > 0);
    }
}
```

### 2. 集成测试设计

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UserControllerTest {
    
    @Resource
    private TestRestTemplate restTemplate;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // 执行测试
        ResponseEntity<CommonResult<Long>> response = restTemplate.postForEntity(
            "/admin-api/system/user/create", reqVO, CommonResult.class);
        
        // 验证结果
        AssertUtils.assertEquals(HttpStatus.OK, response.getStatusCode());
        AssertUtils.assertNotNull(response.getBody());
        AssertUtils.assertTrue(response.getBody().getCode() == 0);
    }
}
```

### 3. Mock测试设计

```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @MockBean
    private UserMapper userMapper;
    
    @Test
    void testCreateUser() {
        // 准备测试数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername("testuser");
        reqVO.setEmail("test@example.com");
        reqVO.setMobile("13800138000");
        
        // Mock行为
        when(userMapper.insert(any(UserDO.class))).thenReturn(1);
        
        // 执行测试
        Long userId = userService.createUser(reqVO);
        
        // 验证结果
        AssertUtils.assertNotNull(userId);
        verify(userMapper, times(1)).insert(any(UserDO.class));
    }
}
```

### 4. 测试数据管理

```java
@SpringBootTest
class UserServiceTest {
    
    @Resource
    private UserService userService;
    
    @Test
    void testCreateUser() {
        // 使用随机数据
        UserCreateReqVO reqVO = new UserCreateReqVO();
        reqVO.setUsername(RandomUtils.randomUsername());
        reqVO.setEmail(RandomUtils.randomEmail());
        reqVO.setMobile(RandomUtils.randomMobile());
        
        // 执行测试
        Long userId = userService.createUser(reqVO);
        
        // 验证结果
        AssertUtils.assertNotNull(userId);
        AssertUtils.assertTrue(userId > 0);
    }
}
```

## 故障排除

### 常见问题

1. **测试数据库连接失败**
   - 检查H2数据库配置是否正确
   - 确认测试配置文件是否正确
   - 验证数据库初始化脚本是否正确

2. **Redis测试失败**
   - 检查Redis测试配置是否正确
   - 确认Redis服务器是否启动
   - 验证Redis连接配置是否正确

3. **Mock测试不生效**
   - 确认使用了`@MockBean`注解
   - 检查Mock行为是否正确设置
   - 验证测试方法是否正确调用

4. **测试数据不清理**
   - 检查`@Sql`注解配置是否正确
   - 确认清理脚本是否正确
   - 验证测试执行顺序是否正确

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.test: DEBUG
    org.springframework.test: DEBUG
    org.h2: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- JUnit 5: 5.8.x
- Mockito: 4.11.x
- H2: 2.1.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
