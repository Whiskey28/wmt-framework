# WMT Biz Tenant Starter

多租户业务组件，提供多租户数据隔离、租户管理等功能。

## 功能特性

- 🏢 **多租户支持**: 支持多租户数据隔离
- 🔐 **租户认证**: 支持租户身份认证
- 📊 **数据隔离**: 支持数据库级别的数据隔离
- 🔄 **租户切换**: 支持动态租户切换
- 📝 **租户管理**: 提供租户管理功能
- 🎯 **权限控制**: 支持租户级别的权限控制
- 🔧 **配置灵活**: 支持多种租户配置方式
- 📱 **多端支持**: 支持Web、移动端多租户

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-tenant</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  tenant:
    enabled: true
    # 租户字段名
    tenant-id-column: tenant_id
    # 忽略租户的表
    ignore-tables:
      - sys_tenant
      - sys_tenant_package
    # 租户数据源配置
    datasource:
      # 租户数据源前缀
      prefix: tenant_
      # 默认租户数据源
      default: master
```

### 3. 创建租户实体

```java
@Data
@TableName("sys_tenant")
public class TenantDO extends BaseDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("name")
    private String name;
    
    @TableField("code")
    private String code;
    
    @TableField("contact_user_name")
    private String contactUserName;
    
    @TableField("contact_mobile")
    private String contactMobile;
    
    @TableField("status")
    private Integer status;
    
    @TableField("domain")
    private String domain;
    
    @TableField("package_id")
    private Long packageId;
    
    @TableField("expire_time")
    private LocalDateTime expireTime;
    
    @TableField("account_count")
    private Integer accountCount;
}
```

### 4. 创建租户服务

```java
@Service
public class TenantService {
    
    @Resource
    private TenantMapper tenantMapper;
    
    /**
     * 创建租户
     */
    public Long createTenant(TenantCreateReqVO reqVO) {
        // 校验租户代码唯一性
        validateTenantCodeUnique(reqVO.getCode());
        
        // 创建租户
        TenantDO tenant = BeanUtils.toBean(reqVO, TenantDO.class);
        tenantMapper.insert(tenant);
        
        // 初始化租户数据
        initTenantData(tenant.getId());
        
        return tenant.getId();
    }
    
    /**
     * 获取租户信息
     */
    public TenantDO getTenant(Long tenantId) {
        return tenantMapper.selectById(tenantId);
    }
    
    /**
     * 更新租户信息
     */
    public void updateTenant(TenantUpdateReqVO reqVO) {
        TenantDO tenant = BeanUtils.toBean(reqVO, TenantDO.class);
        tenantMapper.updateById(tenant);
    }
    
    /**
     * 删除租户
     */
    public void deleteTenant(Long tenantId) {
        // 删除租户数据
        deleteTenantData(tenantId);
        
        // 删除租户
        tenantMapper.deleteById(tenantId);
    }
}
```

### 5. 使用租户上下文

```java
@Service
public class UserService {
    
    @Resource
    private UserMapper userMapper;
    
    /**
     * 创建用户（自动添加租户ID）
     */
    public Long createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        // 自动设置租户ID
        userMapper.insert(user);
        return user.getId();
    }
    
    /**
     * 查询用户（自动过滤租户）
     */
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        return userMapper.selectPage(reqVO);
    }
    
    /**
     * 更新用户（自动过滤租户）
     */
    public void updateUser(UserUpdateReqVO reqVO) {
        userMapper.updateById(BeanUtils.toBean(reqVO, UserDO.class));
    }
}
```

### 6. 租户数据隔离

```java
@Mapper
public interface UserMapper extends BaseMapperX<UserDO> {
    
    /**
     * 查询用户（自动过滤租户）
     */
    default PageResult<UserDO> selectPage(UserPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(UserDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(UserDO::getId));
    }
    
    /**
     * 根据用户名查询用户（自动过滤租户）
     */
    default UserDO selectByUsername(String username) {
        return selectOne(new LambdaQueryWrapperX<UserDO>()
                .eq(UserDO::getUsername, username));
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.tenant.enabled` | boolean | true | 是否启用多租户 |
| `wmt.tenant.tenant-id-column` | String | tenant_id | 租户字段名 |
| `wmt.tenant.ignore-tables` | String[] | - | 忽略租户的表 |

### 数据源配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.tenant.datasource.prefix` | String | tenant_ | 租户数据源前缀 |
| `wmt.tenant.datasource.default` | String | master | 默认租户数据源 |

### 租户配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.tenant.max-account-count` | int | 100 | 最大账户数 |
| `wmt.tenant.default-expire-days` | int | 365 | 默认过期天数 |

## 核心功能

### 租户上下文

#### TenantContextHolder

租户上下文持有者：

```java
public class TenantContextHolder {
    
    private static final ThreadLocal<Long> TENANT_ID = new ThreadLocal<>();
    
    /**
     * 设置租户ID
     */
    public static void setTenantId(Long tenantId) {
        TENANT_ID.set(tenantId);
    }
    
    /**
     * 获取租户ID
     */
    public static Long getTenantId() {
        return TENANT_ID.get();
    }
    
    /**
     * 清除租户ID
     */
    public static void clear() {
        TENANT_ID.remove();
    }
}
```

#### 使用租户上下文

```java
@Service
public class UserService {
    
    public void createUser(UserCreateReqVO reqVO) {
        // 获取当前租户ID
        Long tenantId = TenantContextHolder.getTenantId();
        
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        user.setTenantId(tenantId);
        userMapper.insert(user);
    }
}
```

### 租户数据隔离

#### TenantLineHandler

租户数据隔离处理器：

```java
@Component
public class TenantLineHandler implements TenantLineHandler {
    
    @Override
    public Expression getTenantId() {
        Long tenantId = TenantContextHolder.getTenantId();
        if (tenantId == null) {
            return null;
        }
        return new LongValue(tenantId);
    }
    
    @Override
    public String getTenantIdColumn() {
        return "tenant_id";
    }
    
    @Override
    public boolean ignoreTable(String tableName) {
        return TenantIgnoreTables.contains(tableName);
    }
}
```

#### 使用租户数据隔离

```java
@Mapper
public interface UserMapper extends BaseMapperX<UserDO> {
    
    /**
     * 查询用户（自动过滤租户）
     */
    default List<UserDO> selectList() {
        return selectList(new LambdaQueryWrapperX<UserDO>()
                .eq(UserDO::getStatus, 1)
                .orderByDesc(UserDO::getCreateTime));
    }
}
```

### 租户管理

#### 租户创建

```java
@Service
public class TenantService {
    
    @Resource
    private TenantMapper tenantMapper;
    
    public Long createTenant(TenantCreateReqVO reqVO) {
        // 校验租户代码唯一性
        validateTenantCodeUnique(reqVO.getCode());
        
        // 创建租户
        TenantDO tenant = BeanUtils.toBean(reqVO, TenantDO.class);
        tenantMapper.insert(tenant);
        
        // 初始化租户数据
        initTenantData(tenant.getId());
        
        return tenant.getId();
    }
    
    /**
     * 初始化租户数据
     */
    private void initTenantData(Long tenantId) {
        // 设置租户上下文
        TenantContextHolder.setTenantId(tenantId);
        
        try {
            // 创建默认管理员
            createDefaultAdmin(tenantId);
            
            // 创建默认角色
            createDefaultRoles(tenantId);
            
            // 创建默认菜单
            createDefaultMenus(tenantId);
            
        } finally {
            // 清除租户上下文
            TenantContextHolder.clear();
        }
    }
}
```

#### 租户切换

```java
@Service
public class TenantService {
    
    /**
     * 切换租户
     */
    public void switchTenant(Long tenantId) {
        // 验证租户是否存在
        TenantDO tenant = getTenant(tenantId);
        if (tenant == null) {
            throw new ServiceException("租户不存在");
        }
        
        // 验证租户状态
        if (tenant.getStatus() != 1) {
            throw new ServiceException("租户已禁用");
        }
        
        // 验证租户是否过期
        if (tenant.getExpireTime() != null && tenant.getExpireTime().isBefore(LocalDateTime.now())) {
            throw new ServiceException("租户已过期");
        }
        
        // 设置租户上下文
        TenantContextHolder.setTenantId(tenantId);
    }
}
```

### 租户权限控制

#### 租户权限校验

```java
@Service
public class TenantPermissionService {
    
    /**
     * 校验租户权限
     */
    public void validateTenantPermission(Long tenantId) {
        Long currentTenantId = TenantContextHolder.getTenantId();
        if (currentTenantId == null) {
            throw new ServiceException("未设置租户");
        }
        
        if (!currentTenantId.equals(tenantId)) {
            throw new ServiceException("无权限访问该租户数据");
        }
    }
    
    /**
     * 校验租户管理员权限
     */
    public void validateTenantAdminPermission(Long tenantId) {
        validateTenantPermission(tenantId);
        
        // 校验是否为租户管理员
        if (!isTenantAdmin(tenantId)) {
            throw new ServiceException("无权限执行该操作");
        }
    }
}
```

## 注解说明

### @TenantIgnore

忽略租户注解：

```java
@TenantIgnore
@TableName("sys_tenant")
public class TenantDO extends BaseDO {
    // 租户表，忽略租户过滤
}
```

### @TenantRequired

租户必需注解：

```java
@TenantRequired
@TableName("sys_user")
public class UserDO extends BaseDO {
    // 用户表，必须设置租户ID
}
```

## 工具类

### TenantUtils

租户工具类：

```java
public class TenantUtils {
    
    /**
     * 获取当前租户ID
     */
    public static Long getCurrentTenantId() {
        return TenantContextHolder.getTenantId();
    }
    
    /**
     * 设置租户ID
     */
    public static void setTenantId(Long tenantId) {
        TenantContextHolder.setTenantId(tenantId);
    }
    
    /**
     * 清除租户ID
     */
    public static void clearTenantId() {
        TenantContextHolder.clear();
    }
    
    /**
     * 执行租户操作
     */
    public static <T> T executeWithTenant(Long tenantId, Supplier<T> supplier) {
        Long oldTenantId = getCurrentTenantId();
        try {
            setTenantId(tenantId);
            return supplier.get();
        } finally {
            if (oldTenantId != null) {
                setTenantId(oldTenantId);
            } else {
                clearTenantId();
            }
        }
    }
}
```

## 最佳实践

### 1. 租户实体设计

```java
@Data
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
    
    @TableField("tenant_id")
    private Long tenantId;  // 租户ID
}
```

### 2. 租户服务设计

```java
@Service
public class UserService {
    
    @Resource
    private UserMapper userMapper;
    
    public Long createUser(UserCreateReqVO reqVO) {
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        // 自动设置租户ID
        userMapper.insert(user);
        return user.getId();
    }
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        return userMapper.selectPage(reqVO);
    }
}
```

### 3. 租户切换设计

```java
@Service
public class TenantService {
    
    public void switchTenant(Long tenantId) {
        // 验证租户
        validateTenant(tenantId);
        
        // 切换租户
        TenantContextHolder.setTenantId(tenantId);
    }
    
    public <T> T executeWithTenant(Long tenantId, Supplier<T> supplier) {
        return TenantUtils.executeWithTenant(tenantId, supplier);
    }
}
```

### 4. 错误处理

```java
@Service
public class UserService {
    
    public UserDO getUserById(Long id) {
        UserDO user = userMapper.selectById(id);
        if (user == null) {
            throw new ServiceException("用户不存在");
        }
        
        // 校验租户权限
        Long currentTenantId = TenantContextHolder.getTenantId();
        if (currentTenantId == null || !currentTenantId.equals(user.getTenantId())) {
            throw new ServiceException("无权限访问该用户");
        }
        
        return user;
    }
}
```

## 故障排除

### 常见问题

1. **租户数据不隔离**
   - 检查租户配置是否正确
   - 确认实体类是否设置了租户字段
   - 验证租户上下文是否正确设置

2. **租户切换失败**
   - 检查租户是否存在
   - 确认租户状态是否正常
   - 验证租户是否过期

3. **权限校验失败**
   - 检查租户权限配置
   - 确认用户是否为租户管理员
   - 验证租户上下文是否正确

4. **数据查询异常**
   - 检查租户字段配置
   - 确认忽略表配置是否正确
   - 验证SQL是否正确

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.tenant: DEBUG
    com.baomidou.mybatisplus.extension.plugins.handler: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- MyBatis Plus: 3.5.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
