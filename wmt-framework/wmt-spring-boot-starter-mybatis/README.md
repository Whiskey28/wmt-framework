# WMT MyBatis Starter

基于MyBatis Plus的数据库操作增强组件，提供数据库连接池、多数据源、事务管理、MyBatis扩展等功能。

## 功能特性

- 🗄️ **多数据源支持**: 支持动态数据源切换，支持读写分离
- 🔄 **事务管理**: 基于Spring事务管理，支持分布式事务
- 📊 **分页查询**: 自动分页插件，支持多种分页方式
- 🔐 **数据加密**: 支持字段级数据加密存储
- 🌐 **多租户**: 支持多租户数据隔离
- 📝 **自动填充**: 自动填充创建时间、更新时间等字段
- 🔍 **数据翻译**: 支持数据字典、枚举等数据翻译
- 🛡️ **SQL安全**: 防止SQL注入，支持SQL审计

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-mybatis</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
spring:
  datasource:
    druid:
      url: jdbc:mysql://localhost:3306/wmt_demo
      username: root
      password: password
      driver-class-name: com.mysql.cj.jdbc.Driver
      
# MyBatis Plus配置
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0
```

### 3. 创建实体类

```java
@TableName("sys_user")
public class UserDO extends BaseDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("username")
    private String username;
    
    @TableField("email")
    private String email;
    
    @TableField("mobile")
    private String mobile;
    
    @TableField("deleted")
    @TableLogic
    private Integer deleted;
    
    // getters and setters
}
```

### 4. 创建Mapper接口

```java
@Mapper
public interface UserMapper extends BaseMapperX<UserDO> {
    
    /**
     * 根据用户名查询用户
     */
    default UserDO selectByUsername(String username) {
        return selectOne(new LambdaQueryWrapperX<UserDO>()
                .eq(UserDO::getUsername, username));
    }
    
    /**
     * 分页查询用户
     */
    default PageResult<UserDO> selectPage(UserPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(UserDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(UserDO::getId));
    }
}
```

### 5. 使用Service

```java
@Service
public class UserServiceImpl implements UserService {
    
    @Resource
    private UserMapper userMapper;
    
    @Override
    public Long createUser(UserCreateReqVO reqVO) {
        // 校验用户名唯一性
        validateUsernameUnique(reqVO.getUsername());
        
        // 创建用户
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
    
    @Override
    public PageResult<UserDO> getUserPage(UserPageReqVO reqVO) {
        return userMapper.selectPage(reqVO);
    }
}
```

## 配置说明

### 数据源配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `spring.datasource.druid.url` | String | - | 数据库连接URL |
| `spring.datasource.druid.username` | String | - | 数据库用户名 |
| `spring.datasource.druid.password` | String | - | 数据库密码 |
| `spring.datasource.druid.driver-class-name` | String | - | 数据库驱动类名 |

### MyBatis Plus配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `mybatis-plus.configuration.map-underscore-to-camel-case` | boolean | true | 驼峰命名转换 |
| `mybatis-plus.configuration.log-impl` | String | - | 日志实现类 |
| `mybatis-plus.global-config.db-config.logic-delete-field` | String | deleted | 逻辑删除字段 |
| `mybatis-plus.global-config.db-config.logic-delete-value` | String | 1 | 逻辑删除值 |
| `mybatis-plus.global-config.db-config.logic-not-delete-value` | String | 0 | 逻辑未删除值 |

### 多数据源配置

```yaml
spring:
  datasource:
    dynamic:
      primary: master
      datasource:
        master:
          url: jdbc:mysql://localhost:3306/wmt_master
          username: root
          password: password
          driver-class-name: com.mysql.cj.jdbc.Driver
        slave:
          url: jdbc:mysql://localhost:3306/wmt_slave
          username: root
          password: password
          driver-class-name: com.mysql.cj.jdbc.Driver
```

## 核心功能

### 基础实体类

#### BaseDO

基础数据对象，包含通用字段：

```java
public class BaseDO {
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    @TableField(fill = FieldFill.INSERT)
    private Long creator;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Long updater;
    
    @TableLogic
    private Integer deleted;
}
```

#### BaseMapperX

扩展的Mapper接口，提供常用查询方法：

```java
public interface BaseMapperX<T> extends BaseMapper<T> {
    
    /**
     * 根据条件查询单个对象
     */
    default T selectOne(Wrapper<T> queryWrapper) {
        List<T> list = selectList(queryWrapper);
        return CollUtil.getFirst(list);
    }
    
    /**
     * 分页查询
     */
    default PageResult<T> selectPage(PageParam pageParam, Wrapper<T> queryWrapper) {
        // 分页查询实现
    }
}
```

### 查询构造器

#### LambdaQueryWrapperX

类型安全的查询构造器：

```java
// 基础查询
List<UserDO> users = userMapper.selectList(new LambdaQueryWrapperX<UserDO>()
        .eq(UserDO::getStatus, 1)
        .like(UserDO::getUsername, "admin")
        .orderByDesc(UserDO::getCreateTime));

// 条件查询
List<UserDO> users = userMapper.selectList(new LambdaQueryWrapperX<UserDO>()
        .eqIfPresent(UserDO::getStatus, status)
        .likeIfPresent(UserDO::getUsername, username)
        .betweenIfPresent(UserDO::getCreateTime, startTime, endTime));
```

#### LambdaUpdateWrapperX

类型安全的更新构造器：

```java
// 更新操作
userMapper.update(null, new LambdaUpdateWrapperX<UserDO>()
        .eq(UserDO::getId, userId)
        .set(UserDO::getStatus, 0)
        .set(UserDO::getUpdateTime, LocalDateTime.now()));
```

### 分页查询

#### PageParam

分页参数：

```java
public class PageParam {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    
    // getters and setters
}
```

#### PageResult

分页结果：

```java
public class PageResult<T> {
    private List<T> list;
    private Long total;
    private Integer pageNum;
    private Integer pageSize;
    
    // getters and setters
}
```

### 多数据源

#### 数据源切换

```java
@Service
public class UserService {
    
    @DS("master")
    public void createUser(UserDO user) {
        // 使用主数据源
        userMapper.insert(user);
    }
    
    @DS("slave")
    public List<UserDO> getUsers() {
        // 使用从数据源
        return userMapper.selectList(null);
    }
}
```

### 数据加密

#### 字段加密

```java
public class UserDO extends BaseDO {
    
    @TableField(typeHandler = EncryptTypeHandler.class)
    private String mobile;  // 手机号加密存储
    
    @TableField(typeHandler = EncryptTypeHandler.class)
    private String email;    // 邮箱加密存储
}
```

### 数据翻译

#### 字典翻译

```java
public class UserDO extends BaseDO {
    
    @EasyTrans(dict = "user_status")
    private Integer status;  // 用户状态，自动翻译为中文
}
```

#### 枚举翻译

```java
public class UserDO extends BaseDO {
    
    @EasyTrans(type = TransType.ENUM, key = "getDesc")
    private Integer userType;  // 用户类型，自动翻译
}
```

## 注解说明

### @TableName

表名映射：

```java
@TableName("sys_user")
public class UserDO {
    // 实体类
}
```

### @TableId

主键映射：

```java
@TableId(type = IdType.AUTO)
private Long id;
```

### @TableField

字段映射：

```java
@TableField("username")
private String username;

@TableField(fill = FieldFill.INSERT)
private LocalDateTime createTime;

@TableLogic
private Integer deleted;
```

### @DS

数据源切换：

```java
@DS("slave")
public List<UserDO> getUsers() {
    return userMapper.selectList(null);
}
```

## 最佳实践

### 1. 实体类设计

```java
@TableName("sys_user")
public class UserDO extends BaseDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("username")
    private String username;
    
    @TableField("email")
    private String email;
    
    @TableField("mobile")
    private String mobile;
    
    @TableField("status")
    private Integer status;
    
    @TableLogic
    private Integer deleted;
}
```

### 2. Mapper接口设计

```java
@Mapper
public interface UserMapper extends BaseMapperX<UserDO> {
    
    /**
     * 根据用户名查询用户
     */
    default UserDO selectByUsername(String username) {
        return selectOne(new LambdaQueryWrapperX<UserDO>()
                .eq(UserDO::getUsername, username));
    }
    
    /**
     * 分页查询用户
     */
    default PageResult<UserDO> selectPage(UserPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(UserDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(UserDO::getId));
    }
}
```

### 3. Service层设计

```java
@Service
public class UserServiceImpl implements UserService {
    
    @Resource
    private UserMapper userMapper;
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createUser(UserCreateReqVO reqVO) {
        // 校验用户名唯一性
        validateUsernameUnique(reqVO.getUsername());
        
        // 创建用户
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        return user.getId();
    }
    
    @Override
    public PageResult<UserDO> getUserPage(UserPageReqVO reqVO) {
        return userMapper.selectPage(reqVO);
    }
}
```

### 4. 事务管理

```java
@Service
public class UserService {
    
    @Transactional(rollbackFor = Exception.class)
    public void createUserWithRole(UserCreateReqVO reqVO) {
        // 创建用户
        UserDO user = createUser(reqVO);
        
        // 分配角色
        roleService.assignRole(user.getId(), reqVO.getRoleIds());
    }
}
```

## 故障排除

### 常见问题

1. **数据库连接失败**
   - 检查数据库连接配置
   - 确认数据库服务是否启动
   - 验证用户名密码是否正确

2. **分页查询不生效**
   - 确认使用了`BaseMapperX`接口
   - 检查分页参数是否正确传递

3. **多数据源切换不生效**
   - 确认使用了`@DS`注解
   - 检查数据源配置是否正确

4. **自动填充不生效**
   - 确认实体类继承了`BaseDO`
   - 检查字段是否添加了`@TableField(fill = FieldFill.INSERT)`注解

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.mybatis: DEBUG
    org.springframework.jdbc: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- MyBatis Plus: 3.5.x
- Druid: 1.2.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
