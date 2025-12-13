# 多阶段构建：构建阶段
FROM maven:3.8.6-openjdk-8-slim AS builder

# 设置工作目录
WORKDIR /app

# 复制 pom.xml 和源代码
COPY pom.xml .
COPY src ./src

# 构建应用
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:8-jre-slim

# 设置维护者信息
LABEL maintainer="wmt-framework-team"

# 设置工作目录
WORKDIR /app

# 创建应用用户（非 root）
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 从构建阶段复制 JAR 包
COPY --from=builder /app/target/*.jar app.jar

# 创建日志目录
RUN mkdir -p /var/log/apps && \
    chown -R appuser:appuser /var/log/apps && \
    chown -R appuser:appuser /app

# 切换到非 root 用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# 启动应用
ENTRYPOINT ["java", \
    "-Xms2g", "-Xmx2g", \
    "-XX:+UseG1GC", \
    "-XX:MaxGCPauseMillis=200", \
    "-XX:+HeapDumpOnOutOfMemoryError", \
    "-XX:HeapDumpPath=/var/log/apps/heap_dump.hprof", \
    "-jar", "app.jar"]

