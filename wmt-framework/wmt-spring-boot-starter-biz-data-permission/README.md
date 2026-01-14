# WMT Biz Data Permission Starter

数据权限业务组件，提供数据权限控制、权限规则配置等功能。

## 功能特性

- 🔐 **数据权限**: 支持基于用户、角色、部门的数据权限控制
- 📊 **权限规则**: 支持多种数据权限规则配置
- 🎯 **精确控制**: 支持字段级别的权限控制
- 🔄 **动态权限**: 支持动态权限规则配置
- 📝 **权限审计**: 提供数据权限审计功能
- 🛡️ **安全防护**: 防止越权访问数据
- 🔧 **配置灵活**: 支持多种权限配置方式
- 📱 **多端支持**: 支持Web、移动端数据权限

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-data-permission</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  data-permission:
    enabled: true
    # 数据权限规则
    rules:
      # 全部数据权限
      - type: ALL
        name: 全部数据权限
        description: 可以查看所有数据
      # 部门数据权限
      - type: DEPT
        name: 部门数据权限
        description: 只能查看本部门数据
      # 部门及以下数据权限
      - type: DEPT_AND_CHILD
        name: 部门及以下数据权限
        description: 只能查看本部门及以下数据
      # 仅本人数据权限
      - type: SELF
        name: 仅本人数据权限
        description: 只能查看本人数据
```

### 3. 创建数据权限实体

```java
@Data
@TableName("sys_data_permission")
public class DataPermissionDO extends BaseDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("user_id")
    private Long userId;
    
    @TableField("role_id")
    private Long roleId;
    
    @TableField("dept_id")
    private Long deptId;
    
    @TableField("permission_type")
    private String permissionType;
    
    @TableField("resource_type")
    private String resourceType;
    
    @TableField("resource_id")
    private Long resourceId;
    
    @TableField("permission_rules")
    private String permissionRules;
    
    @TableField("status")
    private Integer status;
}
```

### 4. 创建数据权限服务

```java
@Service
public class DataPermissionService {
    
    @Resource
    private DataPermissionMapper dataPermissionMapper;
    
    /**
     * 创建数据权限
     */
    public Long createDataPermission(DataPermissionCreateReqVO reqVO) {
        DataPermissionDO dataPermission = BeanUtils.toBean(reqVO, DataPermissionDO.class);
        dataPermissionMapper.insert(dataPermission);
        return dataPermission.getId();
    }
    
    /**
     * 获取用户数据权限
     */
    public List<DataPermissionDO> getUserDataPermissions(Long userId) {
        return dataPermissionMapper.selectList(new LambdaQueryWrapperX<DataPermissionDO>()
                .eq(DataPermissionDO::getUserId, userId)
                .eq(DataPermissionDO::getStatus, 1));
    }
    
    /**
     * 获取角色数据权限
     */
    public List<DataPermissionDO> getRoleDataPermissions(Long roleId) {
        return dataPermissionMapper.selectList(new LambdaQueryWrapperX<DataPermissionDO>()
                .eq(DataPermissionDO::getRoleId, roleId)
                .eq(DataPermissionDO::getStatus, 1));
    }
    
    /**
     * 检查数据权限
     */
    public boolean checkDataPermission(String resourceType, Long resourceId) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId == null) {
            return false;
        }
        
        // 获取用户数据权限
        List<DataPermissionDO> permissions = getUserDataPermissions(userId);
        
        // 检查权限
        return checkPermission(permissions, resourceType, resourceId);
    }
}
```

### 5. 使用数据权限注解

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "READ")
    public CommonResult<PageResult<User>> getUsers() {
        return CommonResult.success(userService.getUsers());
    }
    
    @PostMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "CREATE")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
    
    @PutMapping("/users/{id}")
    @DataPermission(resourceType = "user", permissionType = "UPDATE")
    public CommonResult<Void> updateUser(@PathVariable Long id, @RequestBody UserUpdateReqVO reqVO) {
        userService.updateUser(id, reqVO);
        return CommonResult.success();
    }
    
    @DeleteMapping("/users/{id}")
    @DataPermission(resourceType = "user", permissionType = "DELETE")
    public CommonResult<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return CommonResult.success();
    }
}
```

### 6. 使用数据权限规则

```java
@Service
public class UserService {
    
    @Resource
    private UserMapper userMapper;
    
    /**
     * 查询用户（应用数据权限）
     */
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        // 应用数据权限规则
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(UserDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(UserDO::getId);
        
        // 应用数据权限
        applyDataPermission(queryWrapper);
        
        return userMapper.selectPage(reqVO, queryWrapper);
    }
    
    /**
     * 应用数据权限
     */
    private void applyDataPermission(LambdaQueryWrapperX<UserDO> queryWrapper) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId == null) {
            return;
        }
        
        // 获取用户数据权限类型
        String permissionType = getUserDataPermissionType(userId);
        
        switch (permissionType) {
            case "ALL":
                // 全部数据权限，不添加条件
                break;
            case "DEPT":
                // 部门数据权限
                Long deptId = getUserDeptId(userId);
                queryWrapper.eq(UserDO::getDeptId, deptId);
                break;
            case "DEPT_AND_CHILD":
                // 部门及以下数据权限
                List<Long> deptIds = getDeptAndChildIds(userId);
                queryWrapper.in(UserDO::getDeptId, deptIds);
                break;
            case "SELF":
                // 仅本人数据权限
                queryWrapper.eq(UserDO::getId, userId);
                break;
        }
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.data-permission.enabled` | boolean | true | 是否启用数据权限 |
| `wmt.data-permission.default-permission-type` | String | SELF | 默认权限类型 |

### 权限规则配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.data-permission.rules[].type` | String | - | 权限类型 |
| `wmt.data-permission.rules[].name` | String | - | 权限名称 |
| `wmt.data-permission.rules[].description` | String | - | 权限描述 |

### 权限类型

| 类型 | 说明 |
|------|------|
| `ALL` | 全部数据权限 |
| `DEPT` | 部门数据权限 |
| `DEPT_AND_CHILD` | 部门及以下数据权限 |
| `SELF` | 仅本人数据权限 |

## 核心功能

### 数据权限注解

#### @DataPermission

数据权限注解：

```java
@DataPermission(
    resourceType = "user",        // 资源类型
    permissionType = "READ",      // 权限类型
    description = "用户数据权限"   // 权限描述
)
public CommonResult<PageResult<User>> getUsers() {
    return CommonResult.success(userService.getUsers());
}
```

#### 使用数据权限注解

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "READ")
    public CommonResult<PageResult<User>> getUsers() {
        return CommonResult.success(userService.getUsers());
    }
    
    @PostMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "CREATE")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

### 数据权限规则

#### 全部数据权限

```java
@Service
public class UserService {
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .orderByDesc(UserDO::getId);
        
        // 全部数据权限，不添加额外条件
        return userMapper.selectPage(reqVO, queryWrapper);
    }
}
```

#### 部门数据权限

```java
@Service
public class UserService {
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .orderByDesc(UserDO::getId);
        
        // 部门数据权限
        Long deptId = getUserDeptId(SecurityFrameworkUtils.getLoginUserId());
        queryWrapper.eq(UserDO::getDeptId, deptId);
        
        return userMapper.selectPage(reqVO, queryWrapper);
    }
}
```

#### 部门及以下数据权限

```java
@Service
public class UserService {
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .orderByDesc(UserDO::getId);
        
        // 部门及以下数据权限
        List<Long> deptIds = getDeptAndChildIds(SecurityFrameworkUtils.getLoginUserId());
        queryWrapper.in(UserDO::getDeptId, deptIds);
        
        return userMapper.selectPage(reqVO, queryWrapper);
    }
}
```

#### 仅本人数据权限

```java
@Service
public class UserService {
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .orderByDesc(UserDO::getId);
        
        // 仅本人数据权限
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        queryWrapper.eq(UserDO::getId, userId);
        
        return userMapper.selectPage(reqVO, queryWrapper);
    }
}
```

### 数据权限服务

#### DataPermissionService

数据权限服务：

```java
@Service
public class DataPermissionService {
    
    @Resource
    private DataPermissionMapper dataPermissionMapper;
    
    /**
     * 获取用户数据权限类型
     */
    public String getUserDataPermissionType(Long userId) {
        // 获取用户角色
        List<Long> roleIds = getUserRoleIds(userId);
        
        // 获取角色数据权限
        List<DataPermissionDO> permissions = dataPermissionMapper.selectList(
            new LambdaQueryWrapperX<DataPermissionDO>()
                .in(DataPermissionDO::getRoleId, roleIds)
                .eq(DataPermissionDO::getStatus, 1)
                .orderByDesc(DataPermissionDO::getPermissionType)
        );
        
        if (permissions.isEmpty()) {
            return "SELF"; // 默认权限
        }
        
        return permissions.get(0).getPermissionType();
    }
    
    /**
     * 检查数据权限
     */
    public boolean checkDataPermission(String resourceType, Long resourceId) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId == null) {
            return false;
        }
        
        String permissionType = getUserDataPermissionType(userId);
        
        switch (permissionType) {
            case "ALL":
                return true;
            case "DEPT":
                return checkDeptPermission(userId, resourceId);
            case "DEPT_AND_CHILD":
                return checkDeptAndChildPermission(userId, resourceId);
            case "SELF":
                return checkSelfPermission(userId, resourceId);
            default:
                return false;
        }
    }
}
```

## 注解说明

### @DataPermission

数据权限注解：

```java
@DataPermission(
    resourceType = "user",        // 资源类型
    permissionType = "READ",      // 权限类型
    description = "用户数据权限"   // 权限描述
)
public CommonResult<PageResult<User>> getUsers() {
    return CommonResult.success(userService.getUsers());
}
```

### @DataPermissionField

数据权限字段注解：

```java
@DataPermissionField(
    field = "dept_id",            // 字段名
    permissionType = "DEPT"       // 权限类型
)
private Long deptId;
```

## 工具类

### DataPermissionUtils

数据权限工具类：

```java
public class DataPermissionUtils {
    
    /**
     * 获取用户数据权限类型
     */
    public static String getUserDataPermissionType(Long userId) {
        return dataPermissionService.getUserDataPermissionType(userId);
    }
    
    /**
     * 检查数据权限
     */
    public static boolean checkDataPermission(String resourceType, Long resourceId) {
        return dataPermissionService.checkDataPermission(resourceType, resourceId);
    }
    
    /**
     * 应用数据权限
     */
    public static <T> void applyDataPermission(LambdaQueryWrapperX<T> queryWrapper, String field) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId == null) {
            return;
        }
        
        String permissionType = getUserDataPermissionType(userId);
        
        switch (permissionType) {
            case "ALL":
                // 全部数据权限，不添加条件
                break;
            case "DEPT":
                // 部门数据权限
                Long deptId = getUserDeptId(userId);
                queryWrapper.eq(field, deptId);
                break;
            case "DEPT_AND_CHILD":
                // 部门及以下数据权限
                List<Long> deptIds = getDeptAndChildIds(userId);
                queryWrapper.in(field, deptIds);
                break;
            case "SELF":
                // 仅本人数据权限
                queryWrapper.eq(field, userId);
                break;
        }
    }
}
```

## 最佳实践

### 1. 数据权限设计

```java
@Service
public class UserService {
    
    public PageResult<UserDO> getUsers(UserPageReqVO reqVO) {
        LambdaQueryWrapperX<UserDO> queryWrapper = new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .eqIfPresent(UserDO::getStatus, reqVO.getStatus())
                .orderByDesc(UserDO::getId);
        
        // 应用数据权限
        applyDataPermission(queryWrapper);
        
        return userMapper.selectPage(reqVO, queryWrapper);
    }
    
    private void applyDataPermission(LambdaQueryWrapperX<UserDO> queryWrapper) {
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        if (userId == null) {
            return;
        }
        
        String permissionType = DataPermissionUtils.getUserDataPermissionType(userId);
        
        switch (permissionType) {
            case "ALL":
                break;
            case "DEPT":
                Long deptId = getUserDeptId(userId);
                queryWrapper.eq(UserDO::getDeptId, deptId);
                break;
            case "DEPT_AND_CHILD":
                List<Long> deptIds = getDeptAndChildIds(userId);
                queryWrapper.in(UserDO::getDeptId, deptIds);
                break;
            case "SELF":
                queryWrapper.eq(UserDO::getId, userId);
                break;
        }
    }
}
```

### 2. 权限注解使用

```java
@RestController
public class UserController {
    
    @GetMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "READ")
    public CommonResult<PageResult<User>> getUsers() {
        return CommonResult.success(userService.getUsers());
    }
    
    @PostMapping("/users")
    @DataPermission(resourceType = "user", permissionType = "CREATE")
    public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
        return CommonResult.success(userService.createUser(reqVO));
    }
}
```

### 3. 权限校验设计

```java
@Service
public class UserService {
    
    public UserDO getUserById(Long id) {
        UserDO user = userMapper.selectById(id);
        if (user == null) {
            throw new ServiceException("用户不存在");
        }
        
        // 校验数据权限
        if (!DataPermissionUtils.checkDataPermission("user", id)) {
            throw new ServiceException("无权限访问该用户");
        }
        
        return user;
    }
}
```

### 4. 错误处理

```java
@Service
public class UserService {
    
    public UserDO getUserById(Long id) {
        try {
            UserDO user = userMapper.selectById(id);
            if (user == null) {
                throw new ServiceException("用户不存在");
            }
            
            // 校验数据权限
            if (!DataPermissionUtils.checkDataPermission("user", id)) {
                throw new ServiceException("无权限访问该用户");
            }
            
            return user;
        } catch (ServiceException e) {
            throw e;
        } catch (Exception e) {
            log.error("获取用户失败", e);
            throw new ServiceException("获取用户失败");
        }
    }
}
```

## 故障排除

### 常见问题

1. **数据权限不生效**
   - 检查数据权限配置是否正确
   - 确认权限注解是否正确使用
   - 验证权限规则是否正确应用

2. **权限校验失败**
   - 检查用户权限配置
   - 确认权限类型是否正确
   - 验证权限规则是否正确

3. **数据查询异常**
   - 检查权限字段配置
   - 确认查询条件是否正确
   - 验证权限规则是否正确应用

4. **权限配置错误**
   - 检查权限配置是否正确
   - 确认权限类型是否支持
   - 验证权限规则是否正确

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.datapermission: DEBUG
    com.wmt.framework.security: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- MyBatis Plus: 3.5.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
