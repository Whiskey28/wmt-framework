@echo off
REM ###############################################################################
REM Guarantee 技术组件库部署脚本 (Windows)
REM 
REM 使用方法：
REM   1. 普通部署（不混淆）：deploy.bat
REM   2. 混淆部署：deploy.bat obfuscate
REM   3. 发布版本（包含GPG签名）：deploy.bat release
REM ###############################################################################

setlocal enabledelayedexpansion

set MODE=%1
if "%MODE%"=="" set MODE=normal

echo [INFO] 开始部署 Guarantee 技术组件库...
echo [INFO] 部署模式: %MODE%

REM 清理之前的构建
echo [INFO] 清理之前的构建...
call mvn clean
if errorlevel 1 (
    echo [ERROR] 清理失败！
    exit /b 1
)

REM 根据不同模式执行部署
if "%MODE%"=="obfuscate" (
    echo [INFO] 使用代码混淆模式部署...
    call mvn deploy -P obfuscate -DskipTests
) else if "%MODE%"=="release" (
    echo [INFO] 使用发布模式部署（包含GPG签名）...
    call mvn deploy -P release -DskipTests
) else if "%MODE%"=="normal" (
    echo [INFO] 使用普通模式部署...
    call mvn deploy -DskipTests
) else (
    echo [ERROR] 未知的部署模式: %MODE%
    echo [INFO] 支持的模式: normal, obfuscate, release
    exit /b 1
)

if errorlevel 1 (
    echo [ERROR] 部署失败！
    exit /b 1
) else (
    echo [INFO] 部署成功！
)

endlocal

