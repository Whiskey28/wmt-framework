# MySQL权限错误解决方案

## 错误信息
```
ERROR 1227 (42000) at line 12: Access denied; you need (at least one of) the SUPER, SYSTEM_VARIABLES_ADMIN or SESSION_VARIABLES_ADMIN privilege
```

## 问题原因
SQL文件（通常是mysqldump导出的）中包含需要SUPER权限的语句，常见的有：
- `SET @@GLOBAL.GTID_PURGED = '...'`
- `SET @@SESSION.SQL_LOG_BIN = 0`
- `SET GLOBAL ...`
- 其他系统变量设置

## 解决方案

### 方案1：过滤掉需要SUPER权限的语句（推荐）

#### 方法1.1：使用sed/grep过滤（在Pod中执行）
```bash
# 进入Pod
kubectl exec -it mysq18-0 -ndevops -- bash

# 过滤掉GTID和SQL_LOG_BIN相关语句后导入
sed -e '/SET @@GLOBAL.GTID_PURGED/d' \
    -e '/SET @@SESSION.SQL_LOG_BIN/d' \
    -e '/SET @@GLOBAL.SQL_LOG_BIN/d' \
    /tmp/devops_cpe_group.sql | \
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy
```

#### 方法1.2：使用grep过滤
```bash
# 只保留INSERT和CREATE语句，过滤掉SET语句
grep -v "SET @@GLOBAL.GTID_PURGED" \
     -v "SET @@SESSION.SQL_LOG_BIN" \
     -v "SET @@GLOBAL.SQL_LOG_BIN" \
     /tmp/devops_cpe_group.sql | \
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy
```

#### 方法1.3：使用awk过滤
```bash
awk '!/SET @@GLOBAL.GTID_PURGED/ && !/SET @@SESSION.SQL_LOG_BIN/ && !/SET @@GLOBAL.SQL_LOG_BIN/' \
    /tmp/devops_cpe_group.sql | \
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy
```

### 方案2：手动编辑SQL文件（如果文件不大）

在导入前，先查看文件前20行：
```bash
head -20 /tmp/devops_cpe_group.sql
```

然后注释掉或删除包含以下内容的行：
- `SET @@GLOBAL.GTID_PURGED`
- `SET @@SESSION.SQL_LOG_BIN`
- `SET @@GLOBAL.SQL_LOG_BIN`

### 方案3：使用mysql客户端参数跳过某些语句

```bash
# 使用 --skip-gtid 参数（如果MySQL版本支持）
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 \
  --skip-gtid \
  yanlian_devops_trustworthy < /tmp/devops_cpe_group.sql
```

### 方案4：授予用户SUPER权限（不推荐，安全风险）

```sql
-- 连接MySQL
mysql -h 127.0.0.1 -uroot -pHc@Cloud01

-- 授予SUPER权限（不推荐）
GRANT SUPER ON *.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

**注意**：授予SUPER权限有安全风险，不推荐在生产环境使用。

### 方案5：使用具有SUPER权限的用户

如果MySQL配置了多个用户，使用具有SUPER权限的用户导入：
```bash
mysql -h 127.0.0.1 -u<super_user> -p<password> yanlian_devops_trustworthy < /tmp/devops_cpe_group.sql
```

## 完整导入脚本（推荐）

创建一个脚本，批量处理所有SQL文件：

```bash
#!/bin/bash
# 在Pod中执行

# 定义需要过滤的SQL文件
SQL_FILES=(
    "/tmp/devops_cpe_group.sql"
    "/tmp/devops_leak.sql"
    "/tmp/devops_leak_link.sql"
    "/tmp/devops_leak_match.sql"
)

# MySQL连接参数
MYSQL_HOST="127.0.0.1"
MYSQL_USER="root"
MYSQL_PASS="Hc@Cloud01"
MYSQL_DB="yanlian_devops_trustworthy"

# 遍历文件并导入
for sql_file in "${SQL_FILES[@]}"; do
    echo "Processing $sql_file..."
    
    # 过滤掉需要SUPER权限的语句并导入
    sed -e '/SET @@GLOBAL.GTID_PURGED/d' \
        -e '/SET @@SESSION.SQL_LOG_BIN/d' \
        -e '/SET @@GLOBAL.SQL_LOG_BIN/d' \
        "$sql_file" | \
    mysql -h "$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB"
    
    if [ $? -eq 0 ]; then
        echo "✓ Successfully imported $sql_file"
    else
        echo "✗ Failed to import $sql_file"
    fi
done
```

## 快速解决方案（一行命令）

对于单个文件，使用以下命令：

```bash
# 在Pod中执行
sed -e '/SET @@GLOBAL.GTID_PURGED/d' \
    -e '/SET @@SESSION.SQL_LOG_BIN/d' \
    -e '/SET @@GLOBAL.SQL_LOG_BIN/d' \
    /tmp/devops_cpe_group.sql | \
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy
```

## 验证导入是否成功

```bash
# 检查数据是否导入成功
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy -e "SELECT COUNT(*) FROM devops_cpe_group;"
mysql -h 127.0.0.1 -uroot -pHc@Cloud01 yanlian_devops_trustworthy -e "SELECT COUNT(*) FROM devops_leak;"
```

## 常见需要过滤的语句

根据mysqldump版本，可能包含以下语句，都需要过滤：

```sql
SET @@GLOBAL.GTID_PURGED='...'
SET @@SESSION.SQL_LOG_BIN=0
SET @@GLOBAL.SQL_LOG_BIN=0
SET @@SESSION.SQL_REQUIRE_PRIMARY_KEY=0
SET @@GLOBAL.SQL_REQUIRE_PRIMARY_KEY=0
```

## 注意事项

1. **GTID相关**：如果MySQL启用了GTID，过滤掉`SET @@GLOBAL.GTID_PURGED`不会影响数据导入，只是不会设置GTID历史
2. **SQL_LOG_BIN**：过滤掉`SET @@SESSION.SQL_LOG_BIN=0`不会影响数据导入，只是不会禁用binlog记录
3. **大文件处理**：对于大文件（如170MB），使用sed/grep过滤可能需要一些时间，请耐心等待

## 推荐方案

**最推荐使用方案1.1（sed过滤）**，因为：
- ✅ 不需要修改SQL文件
- ✅ 不需要授予额外权限
- ✅ 安全可靠
- ✅ 可以批量处理

