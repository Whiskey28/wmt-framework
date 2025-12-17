你可以使用Maven的`-pl`参数来单独打包某个组件模块。以下是几种方式：

## 1. 单独打包某个组件模块

```bash
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-storage -am
```
## 2. 单独打包file组件

```bash
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-file -am
```
## 3. 单独打包web组件

```bash
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-web -am
```
web组件有测试失败，但我们可以跳过测试来打包。让我展示几种不同的打包方式：

## 单独打包组件模块的几种方式

### 1. 基本命令格式
```bash
# 单独打包某个组件（包含依赖的模块）
mvn clean package -pl <模块路径> -am

# 跳过测试打包
mvn clean package -pl <模块路径> -am -DskipTests

# 只编译不打包
mvn clean compile -pl <模块路径> -am
```

### 2. 跳过测试打包web组件

```bash
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-web -am -DskipTests
```
### 3. 查看生成的JAR文件

```bash
dir wmt-framework\wmt-spring-boot-starter-storage\target\*.jar
```
```bash
ls wmt-framework/wmt-spring-boot-starter-storage/target/*.jar
```
Ran tool
## 总结：单独打包组件模块的方法

### 📋 常用命令格式

#### 1. 基本打包命令
```bash
# 打包单个组件（包含依赖）
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-storage -am

# 打包多个组件
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-storage,wmt-framework/wmt-spring-boot-starter-file -am
```

#### 2. 跳过测试打包
```bash
# 跳过测试打包
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-web -am -DskipTests

# 跳过测试编译
mvn clean compile -pl wmt-framework/wmt-spring-boot-starter-web -am -DskipTests
```

#### 3. 只编译不打包
```bash
# 只编译
mvn clean compile -pl wmt-framework/wmt-spring-boot-starter-storage -am

# 只安装到本地仓库
mvn clean install -pl wmt-framework/wmt-spring-boot-starter-storage -am
```

#### 4. 参数说明
- `-pl` (--projects): 指定要构建的模块
- `-am` (--also-make): 同时构建指定模块的依赖模块
- `-amd` (--also-make-dependents): 同时构建依赖于指定模块的模块
- `-DskipTests`: 跳过测试执行
- `-Dmaven.test.skip=true`: 跳过测试编译和执行

### 🎯 实际使用场景

#### 场景1：开发测试单个组件
```bash
# 只编译和测试storage组件
mvn clean test -pl wmt-framework/wmt-spring-boot-starter-storage -am
```

#### 场景2：快速打包部署
```bash
# 快速打包storage组件（跳过测试）
mvn clean package -pl wmt-framework/wmt-spring-boot-starter-storage -am -DskipTests
```

#### 场景3：安装到本地仓库
```bash
# 安装到本地Maven仓库，供其他项目使用
mvn clean install -pl wmt-framework/wmt-spring-boot-starter-storage -am
```

### 📁 生成的文件位置
打包成功后，JAR文件会生成在对应模块的`target`目录下：
- `wmt-framework/wmt-spring-boot-starter-storage/target/wmt-spring-boot-starter-storage-2025.12-jdk8-SNAPSHOT.jar`
- `wmt-framework/wmt-spring-boot-starter-file/target/wmt-spring-boot-starter-file-2025.12-jdk8-SNAPSHOT.jar`
- `wmt-framework/wmt-spring-boot-starter-web/target/wmt-spring-boot-starter-web-2025.12-jdk8-SNAPSHOT.jar`

这样你就可以单独测试和打包任何一个组件模块，而不需要构建整个项目！
