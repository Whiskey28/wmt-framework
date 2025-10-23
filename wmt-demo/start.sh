#!/bin/bash

echo "=========================================="
echo "  WMT Demo 应用启动脚本"
echo "=========================================="
echo ""

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "❌ 错误: 未找到 Java 环境，请先安装 JDK 1.8+"
    exit 1
fi

echo "✅ Java 版本:"
java -version
echo ""

# 检查Maven
if ! command -v mvn &> /dev/null; then
    echo "❌ 错误: 未找到 Maven，请先安装 Maven 3.6+"
    exit 1
fi

echo "✅ Maven 版本:"
mvn -version
echo ""

# 检查MySQL连接
echo "检查 MySQL 连接..."
if command -v mysql &> /dev/null; then
    mysql -h127.0.0.1 -uroot -proot -e "SELECT 1" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ MySQL 连接成功"
    else
        echo "⚠️  警告: MySQL 连接失败，请检查配置"
    fi
else
    echo "⚠️  警告: 未找到 MySQL 客户端，跳过连接检查"
fi
echo ""

# 检查Redis连接
echo "检查 Redis 连接..."
if command -v redis-cli &> /dev/null; then
    redis-cli ping &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Redis 连接成功"
    else
        echo "⚠️  警告: Redis 连接失败，请检查配置"
    fi
else
    echo "⚠️  警告: 未找到 Redis 客户端，跳过连接检查"
fi
echo ""

# 清理并编译
echo "开始编译项目..."
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "❌ 编译失败"
    exit 1
fi
echo "✅ 编译成功"
echo ""

# 启动应用
echo "=========================================="
echo "  启动 WMT Demo 应用"
echo "=========================================="
echo ""
echo "访问地址："
echo "  - 应用首页: http://localhost:8080/demo"
echo "  - API文档: http://localhost:8080/demo/swagger-ui/index.html"
echo "  - Druid监控: http://localhost:8080/demo/druid/index.html"
echo ""

mvn spring-boot:run

