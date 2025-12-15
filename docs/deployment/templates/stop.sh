#!/bin/bash

###############################################################################
# 应用停止脚本
# 
# 使用方法：
#   ./stop.sh
###############################################################################

APP_NAME="your-app"
APP_HOME="/opt/apps/your-app"
PID_FILE="${APP_HOME}/temp/${APP_NAME}.pid"

if [ ! -f "${PID_FILE}" ]; then
    echo "${APP_NAME} is not running"
    exit 1
fi

PID=$(cat ${PID_FILE})

if ! ps -p ${PID} > /dev/null 2>&1; then
    echo "${APP_NAME} is not running"
    rm -f ${PID_FILE}
    exit 1
fi

echo "Stopping ${APP_NAME} (PID: ${PID})..."

# 优雅停止（发送 SIGTERM）
kill ${PID}

# 等待进程结束（最多 30 秒）
for i in {1..30}; do
    if ! ps -p ${PID} > /dev/null 2>&1; then
        echo "${APP_NAME} stopped successfully"
        rm -f ${PID_FILE}
        exit 0
    fi
    sleep 1
done

# 强制停止
if ps -p ${PID} > /dev/null 2>&1; then
    echo "Force stopping ${APP_NAME}..."
    kill -9 ${PID}
    rm -f ${PID_FILE}
    echo "${APP_NAME} force stopped"
fi

