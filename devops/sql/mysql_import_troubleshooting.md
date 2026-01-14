# MySQL导入错误排查与解决方案

## 错误信息
```
cannot connect to local mysql server through socket /var/lib/mysql/mysql.sock
```

## 问题原因
在Kubernetes Pod中，MySQL客户端默认尝试通过Unix socket连接，但：
1. MySQL可能运行在另一个容器中，socket文件不存在
2. 需要通过TCP协议连接，而不是socket

## 解决方案

### 方案1：使用TCP连接（推荐）
```bash
# 使用 -h 参数指定host，强制使用TCP连接
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql

# 或者使用 localhost（如果MySQL在同一Pod中）
mysql -h localhost -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 方案2：使用 --protocol=TCP 参数
```bash
mysql --protocol=TCP -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 方案3：如果MySQL在另一个Pod中
```bash
# 需要指定MySQL服务的实际地址
# 例如：MySQL服务在另一个Pod中，使用Service名称
mysql -h mysql-service-name -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql

# 或者使用Pod IP
mysql -h <mysql-pod-ip> -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 方案4：使用端口号（如果MySQL不在默认端口）
```bash
mysql -h 127.0.0.1 -P 3306 -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

## 完整命令示例

### 如果MySQL在同一Pod中
```bash
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 如果MySQL在另一个Pod中（通过Service）
```bash
# 先查看MySQL Service名称
kubectl get svc | grep mysql

# 然后使用Service名称连接
mysql -h <mysql-service-name>.<namespace>.svc.cluster.local -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 如果MySQL在另一个Pod中（直接使用Pod IP）
```bash
# 先查看MySQL Pod IP
kubectl get pods -o wide | grep mysql

# 然后使用Pod IP连接
mysql -h <mysql-pod-ip> -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

## 排查步骤

### 1. 确认MySQL是否在运行
```bash
# 检查MySQL进程
ps aux | grep mysql

# 检查MySQL端口是否监听
netstat -tlnp | grep 3306
# 或
ss -tlnp | grep 3306
```

### 2. 测试MySQL连接
```bash
# 测试TCP连接
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 -e "SELECT 1;"

# 如果失败，尝试指定端口
mysql -h 127.0.0.1 -P 3306 -uroot -pHc@Cloud01 -e "SELECT 1;"
```

### 3. 检查MySQL配置
```bash
# 查看MySQL配置，确认bind-address设置
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 -e "SHOW VARIABLES LIKE 'bind_address';"

# 如果bind-address是127.0.0.1，只能本地连接
# 如果是0.0.0.0，可以从其他Pod连接
```

## 常见场景

### 场景1：MySQL在同一Pod中
```bash
# 最简单的方式
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 场景2：MySQL在另一个Pod中（通过Service）
```bash
# 假设MySQL Service名称是 mysql，namespace是 default
mysql -h mysql.default.svc.cluster.local -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 场景3：MySQL在另一个Pod中（直接使用Pod IP）
```bash
# 先获取Pod IP
MYSQL_POD_IP=$(kubectl get pod <mysql-pod-name> -o jsonpath='{.status.podIP}')

# 然后连接
mysql -h $MYSQL_POD_IP -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

## 其他注意事项

### 1. 密码包含特殊字符
如果密码包含特殊字符（如 `@`），需要转义或使用引号：
```bash
# 使用单引号
mysql -h 127.0.0.1 -uroot -p'Hc@Cloud01' yanlian_devops_trustworthy < /tmp/devops_leak.sql

# 或者使用 -p 后不跟密码，会提示输入
mysql -h 127.0.0.1 -uroot -p yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 2. 大文件导入
如果文件很大（如170MB），可能需要调整MySQL参数：
```bash
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 \
  --max_allowed_packet=512M \
  yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

### 3. 使用docker exec（如果MySQL在Docker容器中）
```bash
# 如果MySQL在另一个Docker容器中
docker exec -i <mysql-container-name> mysql -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

## 推荐方案

根据你的情况，最可能的是MySQL在同一Pod中或另一个Pod中。推荐使用：

```bash
# 方案1：如果MySQL在同一Pod中
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql

# 方案2：如果MySQL在另一个Pod中（通过Service）
mysql -h <mysql-service-name> -uroot -pHc@Cloud01 yanlian_devops_trustworthy < /tmp/devops_leak.sql
```

## 验证导入是否成功
```bash
# 导入后验证数据
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy -e "SELECT COUNT(*) FROM devops_leak;"
```

