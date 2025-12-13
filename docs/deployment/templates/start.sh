#!/bin/bash

###############################################################################
# 应用启动脚本
# 
# 使用方法：
#   ./start.sh
###############################################################################

set -e

# 应用配置
APP_NAME="your-app"
APP_JAR="/opt/apps/your-app/lib/your-app-1.0.0.jar"
APP_HOME="/opt/apps/your-app"
CONFIG_DIR="${APP_HOME}/config"
LOG_DIR="/var/log/apps/${APP_NAME}"
PID_FILE="${APP_HOME}/temp/${APP_NAME}.pid"

# JVM 参数
JVM_OPTS="-Xms2g -Xmx2g"
JVM_OPTS="${JVM_OPTS} -XX:+UseG1GC"
JVM_OPTS="${JVM_OPTS} -XX:MaxGCPauseMillis=200"
JVM_OPTS="${JVM_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
JVM_OPTS="${JVM_OPTS} -XX:HeapDumpPath=${LOG_DIR}/heap_dump.hprof"
JVM_OPTS="${JVM_OPTS} -XX:+PrintGCDetails"
JVM_OPTS="${JVM_OPTS} -XX:+PrintGCDateStamps"
JVM_OPTS="${JVM_OPTS} -Xloggc:${LOG_DIR}/gc.log"
JVM_OPTS="${JVM_OPTS} -XX:+UseGCLogFileRotation"
JVM_OPTS="${JVM_OPTS} -XX:NumberOfGCLogFiles=10"
JVM_OPTS="${JVM_OPTS} -XX:GCLogFileSize=10M"

# Spring Boot 参数
SPRING_OPTS="--spring.config.location=classpath:/,file:${CONFIG_DIR}/"
SPRING_OPTS="${SPRING_OPTS} --spring.profiles.active=prod"
SPRING_OPTS="${SPRING_OPTS} --server.port=8080"
SPRING_OPTS="${SPRING_OPTS} --logging.file.name=${LOG_DIR}/application.log"

# 创建必要目录
mkdir -p ${LOG_DIR}
mkdir -p ${APP_HOME}/temp

# 检查是否已运行
if [ -f "${PID_FILE}" ]; then
    PID=$(cat ${PID_FILE})
    if ps -p ${PID} > /dev/null 2>&1; then
        echo "${APP_NAME} is already running (PID: ${PID})"
        exit 1
    else
        rm -f ${PID_FILE}
    fi
fi

# 启动应用
echo "Starting ${APP_NAME}..."
nohup java ${JVM_OPTS} \
    -jar ${APP_JAR} \
    ${SPRING_OPTS} \
    > ${LOG_DIR}/startup.log 2>&1 &

# 保存 PID
echo $! > ${PID_FILE}

# 等待启动
sleep 5

# 检查启动状态
if [ -f "${PID_FILE}" ]; then
    PID=$(cat ${PID_FILE})
    if ps -p ${PID} > /dev/null 2>&1; then
        echo "${APP_NAME} started successfully (PID: ${PID})"
        echo "Logs: ${LOG_DIR}/application.log"
    else
        echo "${APP_NAME} failed to start"
        exit 1
    fi
else
    echo "${APP_NAME} failed to start"
    exit 1
fi

