# WMT Demo 测试指南

本文档提供详细的测试步骤，帮助你验证 WMT 组件库的各项功能。

## 测试前准备

### 1. 启动必要的服务

```bash
# 启动 MySQL
# 启动 Redis
# （可选）启动 XXL-JOB 调度中心
```

### 2. 初始化数据库

```bash
mysql -u root -p < src/main/resources/sql/schema.sql
```

### 3. 启动应用

```bash
mvn spring-boot:run
```

## 功能测试清单

### ✅ 1. Web 组件测试

#### 1.1 访问 Swagger 文档

```
URL: http://localhost:8080/demo/swagger-ui/index.html
预期结果: 能够看到完整的API文档界面
```

#### 1.2 测试跨域配置

```bash
curl -X OPTIONS http://localhost:8080/demo/api/user/list \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: GET" \
  -v

预期结果: 响应头包含 Access-Control-Allow-Origin
```

#### 1.3 测试全局异常处理

```bash
curl http://localhost:8080/demo/api/user/99999

预期结果: 返回统一的错误格式
```

### ✅ 2. MyBatis 组件测试

#### 2.1 查询用户列表

```bash
curl http://localhost:8080/demo/api/user/list

预期结果: 
{
  "code": 200,
  "data": [
    {
      "id": 1,
      "username": "admin",
      "nickname": "管理员",
      ...
    }
  ],
  "msg": "操作成功"
}
```

#### 2.2 根据ID查询用户

```bash
curl http://localhost:8080/demo/api/user/1

预期结果: 返回ID为1的用户信息
```

#### 2.3 创建用户

```bash
curl -X POST http://localhost:8080/demo/api/user \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test001",
    "password": "123456",
    "nickname": "测试用户",
    "email": "test@example.com",
    "mobile": "13800138888",
    "status": 1
  }'

预期结果: 返回新创建用户的ID
```

#### 2.4 更新用户

```bash
curl -X PUT http://localhost:8080/demo/api/user \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "nickname": "超级管理员"
  }'

预期结果: 返回 true，用户昵称被更新
```

#### 2.5 删除用户

```bash
curl -X DELETE http://localhost:8080/demo/api/user/4

预期结果: 返回 true，用户被删除
```

### ✅ 3. Redis 组件测试

#### 3.1 测试 Redis 基本操作

```bash
curl -X POST "http://localhost:8080/demo/api/user/redis/test?key=mykey&value=myvalue"

预期结果: 
{
  "code": 200,
  "data": "存储成功，读取值：myvalue",
  "msg": "操作成功"
}
```

#### 3.2 测试 Redis 缓存注解

```bash
# 第一次查询（会从数据库查询并缓存）
curl http://localhost:8080/demo/api/user/username/admin

# 第二次查询（会从缓存读取，速度更快）
curl http://localhost:8080/demo/api/user/username/admin

预期结果: 
- 查看日志，第一次会打印 "查询用户: admin"
- 第二次不会打印，说明从缓存读取
```

#### 3.3 验证缓存过期

```bash
# 创建新用户（会清空缓存）
curl -X POST http://localhost:8080/demo/api/user \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testcache",
    "password": "123456",
    "nickname": "缓存测试",
    "status": 1
  }'

# 再次查询 admin（会重新从数据库读取）
curl http://localhost:8080/demo/api/user/username/admin

预期结果: 日志中会再次打印 "查询用户: admin"
```

#### 3.4 使用 Redis 客户端验证

```bash
redis-cli
> keys *
> get user::admin
> ttl user::admin

预期结果: 能看到缓存的数据和过期时间
```

### ✅ 4. Excel 组件测试

#### 4.1 导出用户 Excel

```bash
curl "http://localhost:8080/demo/api/user/export" -o users.xlsx

预期结果: 
- 下载 users.xlsx 文件
- 用 Excel 打开，包含所有用户数据
- 表头为：用户名、昵称、邮箱、手机号、状态
```

#### 4.2 验证导出数据格式

```
打开下载的 users.xlsx 文件
预期结果:
- 第一行是表头（中文）
- 数据格式正确
- 状态显示为 "正常" 或 "禁用"
```

### ✅ 5. Security 组件测试

#### 5.1 访问公开接口（无需认证）

```bash
curl http://localhost:8080/demo/api/user/list

预期结果: 正常返回数据
```

#### 5.2 访问受保护接口（需要认证）

```bash
# 如果配置了需要认证的接口
curl http://localhost:8080/demo/api/user/protected

预期结果: 返回 401 或 403 错误
```

#### 5.3 使用 Token 访问

```bash
# 先登录获取 Token（如果实现了登录接口）
# 然后带 Token 访问
curl http://localhost:8080/demo/api/user/protected \
  -H "Authorization: Bearer YOUR_TOKEN"

预期结果: 正常返回数据
```

### ✅ 6. XXL-JOB 组件测试

#### 6.1 检查执行器注册

```
访问 XXL-JOB 调度中心管理界面
导航: 执行器管理
预期结果: 看到 wmt-demo-executor 执行器（在线状态）
```

#### 6.2 创建测试任务

```
1. 登录 XXL-JOB 调度中心
2. 进入任务管理 -> 新增任务
3. 配置如下：
   - 执行器：wmt-demo-executor
   - JobHandler：demoJob
   - 运行模式：BEAN
   - Cron：0/10 * * * * ? （每10秒执行一次）
4. 保存并启动任务

预期结果: 
- 任务创建成功
- 查看应用日志，每10秒打印一次任务执行日志
```

#### 6.3 手动触发任务

```
在 XXL-JOB 调度中心点击任务的 "执行一次" 按钮

预期结果: 
- 立即看到应用日志中打印任务执行信息
- 显示执行时间戳
```

### ✅ 7. Druid 监控测试

#### 7.1 访问监控页面

```
URL: http://localhost:8080/demo/druid/index.html
账号: admin
密码: admin

预期结果: 能够看到 Druid 监控界面
```

#### 7.2 查看 SQL 监控

```
执行几次数据库查询操作后
导航: SQL监控

预期结果: 
- 能看到执行的SQL语句
- 显示执行时间
- 显示执行次数
```

## 性能测试

### 1. 并发测试

使用 Apache Bench 或 JMeter 进行并发测试：

```bash
# 使用 ab 工具
ab -n 1000 -c 100 http://localhost:8080/demo/api/user/list

预期结果: 
- 所有请求都成功
- 响应时间在合理范围内
```

### 2. Redis 缓存效果测试

```bash
# 比较有缓存和无缓存的响应时间
# 第一次查询（无缓存）
time curl http://localhost:8080/demo/api/user/username/admin

# 第二次查询（有缓存）
time curl http://localhost:8080/demo/api/user/username/admin

预期结果: 第二次查询明显更快
```

## 集成测试

### 完整业务流程测试

```bash
# 1. 创建用户
USER_ID=$(curl -s -X POST http://localhost:8080/demo/api/user \
  -H "Content-Type: application/json" \
  -d '{
    "username": "integration_test",
    "password": "123456",
    "nickname": "集成测试用户",
    "email": "test@example.com",
    "mobile": "13900139000",
    "status": 1
  }' | jq -r '.data')

echo "创建用户ID: $USER_ID"

# 2. 查询用户
curl http://localhost:8080/demo/api/user/$USER_ID

# 3. 更新用户
curl -X PUT http://localhost:8080/demo/api/user \
  -H "Content-Type: application/json" \
  -d "{
    \"id\": $USER_ID,
    \"nickname\": \"集成测试用户(已更新)\"
  }"

# 4. 再次查询验证
curl http://localhost:8080/demo/api/user/$USER_ID

# 5. 导出Excel
curl "http://localhost:8080/demo/api/user/export" -o integration_test.xlsx

# 6. 删除用户
curl -X DELETE http://localhost:8080/demo/api/user/$USER_ID

预期结果: 所有步骤都成功执行
```

## 测试报告模板

完成测试后，可以使用以下模板记录测试结果：

```
测试日期: ____________________
测试人员: ____________________

| 测试项 | 状态 | 备注 |
|--------|------|------|
| Web组件 | ✅/❌ |  |
| MyBatis组件 | ✅/❌ |  |
| Redis组件 | ✅/❌ |  |
| Excel组件 | ✅/❌ |  |
| Security组件 | ✅/❌ |  |
| XXL-JOB组件 | ✅/❌ |  |
| Druid监控 | ✅/❌ |  |

总体评价: 
____________________________________________
```

## 常见问题排查

如果测试失败，请检查：

1. ✅ 所有依赖服务（MySQL、Redis、XXL-JOB）是否正常运行
2. ✅ 配置文件是否正确
3. ✅ 数据库是否已初始化
4. ✅ 端口是否被占用
5. ✅ 日志中是否有错误信息
6. ✅ 防火墙是否阻止了连接

## 下一步

测试通过后，你可以：

1. 将这个项目作为模板创建自己的业务系统
2. 添加更多的业务功能
3. 集成更多的 WMT 组件
4. 部署到测试/生产环境

祝测试顺利！🎉

