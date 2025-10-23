@echo off
chcp 65001 >nul
setlocal

echo ==========================================
echo   WMT Demo 应用启动脚本
echo ==========================================
echo.

REM 检查Java环境
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到 Java 环境，请先安装 JDK 1.8+
    pause
    exit /b 1
)

echo ✅ Java 版本:
java -version
echo.

REM 检查Maven
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到 Maven，请先安装 Maven 3.6+
    pause
    exit /b 1
)

echo ✅ Maven 版本:
mvn -version
echo.

REM 清理并编译
echo 开始编译项目...
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo ❌ 编译失败
    pause
    exit /b 1
)
echo ✅ 编译成功
echo.

REM 启动应用
echo ==========================================
echo   启动 WMT Demo 应用
echo ==========================================
echo.
echo 访问地址：
echo   - 应用首页: http://localhost:8080/demo
echo   - API文档: http://localhost:8080/demo/swagger-ui/index.html
echo   - Druid监控: http://localhost:8080/demo/druid/index.html
echo.

call mvn spring-boot:run

pause

