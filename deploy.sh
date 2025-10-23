#!/bin/bash
###############################################################################
# Guarantee 技术组件库部署脚本
# 
# 使用方法：
#   1. 普通部署（不混淆）：./deploy.sh
#   2. 混淆部署：./deploy.sh obfuscate
#   3. 发布版本（包含GPG签名）：./deploy.sh release
###############################################################################

# 设置错误时退出
set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取部署模式
MODE=${1:-normal}

print_info "开始部署 Guarantee 技术组件库..."
print_info "部署模式: $MODE"

# 清理之前的构建
print_info "清理之前的构建..."
mvn clean

# 根据不同模式执行部署
case $MODE in
    "obfuscate")
        print_info "使用代码混淆模式部署..."
        mvn deploy -P obfuscate -DskipTests
        ;;
    "release")
        print_info "使用发布模式部署（包含GPG签名）..."
        mvn deploy -P release -DskipTests
        ;;
    "normal")
        print_info "使用普通模式部署..."
        mvn deploy -DskipTests
        ;;
    *)
        print_error "未知的部署模式: $MODE"
        print_info "支持的模式: normal, obfuscate, release"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    print_info "部署成功！"
else
    print_error "部署失败！"
    exit 1
fi

