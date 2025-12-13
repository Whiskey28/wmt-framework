# CI/CD 部署示例

> 基于 WMT Framework 的业务系统 CI/CD 配置示例（GitHub Actions / GitLab CI）

## 📋 目录

- [一、GitHub Actions 示例](#一github-actions-示例)
- [二、GitLab CI 示例](#二gitlab-ci-示例)
- [三、Jenkins Pipeline 示例](#三jenkins-pipeline-示例)

---

## 一、GitHub Actions 示例

### 1.1 基础 CI/CD 流程

```bash
# 创建 GitHub Actions 工作流目录
mkdir -p .github/workflows

# 创建 CI/CD 工作流文件
vi .github/workflows/ci-cd.yml
```

```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - main
  release:
    types: [created]

env:
  JAVA_VERSION: '8'
  MAVEN_VERSION: '3.8.6'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # 代码检查与测试
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Set up JDK 8
        uses: actions/setup-java@v3
        with:
          java-version: '8'
          distribution: 'temurin'
          cache: maven
      
      - name: Run tests
        run: mvn clean test
      
      - name: Upload test results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results
          path: target/surefire-reports

  # 构建与打包
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Set up JDK 8
        uses: actions/setup-java@v3
        with:
          java-version: '8'
          distribution: 'temurin'
          cache: maven
      
      - name: Build with Maven
        run: mvn clean package -DskipTests
      
      - name: Upload JAR artifact
        uses: actions/upload-artifact@v3
        with:
          name: jar-artifact
          path: target/*.jar

  # 构建 Docker 镜像
  build-docker:
    needs: build
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Log in to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}

  # 部署到测试环境
  deploy-test:
    needs: build-docker
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment:
      name: test
    steps:
      - name: Deploy to test environment
        run: |
          echo "Deploying to test environment..."
          # 添加部署脚本
          # kubectl set image deployment/your-app app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} -n test

  # 部署到生产环境
  deploy-prod:
    needs: build-docker
    runs-on: ubuntu-latest
    if: github.event_name == 'release'
    environment:
      name: production
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # 添加部署脚本
          # kubectl set image deployment/your-app app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.ref_name }} -n production
```

### 1.2 二进制部署工作流

```yaml
name: Binary Deployment

on:
  release:
    types: [created]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Set up JDK 8
        uses: actions/setup-java@v3
        with:
          java-version: '8'
          distribution: 'temurin'
          cache: maven
      
      - name: Build application
        run: mvn clean package -DskipTests
      
      - name: Upload to server
        uses: appleboy/scp-action@v0.1.4
        with:
          host: ${{ secrets.DEPLOY_HOST }}
          username: ${{ secrets.DEPLOY_USER }}
          key: ${{ secrets.DEPLOY_SSH_KEY }}
          source: "target/*.jar"
          target: "/opt/apps/your-app/lib/"
      
      - name: Deploy application
        uses: appleboy/ssh-action@v0.1.5
        with:
          host: ${{ secrets.DEPLOY_HOST }}
          username: ${{ secrets.DEPLOY_USER }}
          key: ${{ secrets.DEPLOY_SSH_KEY }}
          script: |
            cd /opt/apps/your-app
            ./bin/stop.sh
            ./bin/start.sh
```

---

## 二、GitLab CI 示例

### 2.1 .gitlab-ci.yml

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository"
  JAVA_VERSION: "8"
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG

# 测试阶段
test:
  stage: test
  image: maven:3.8.6-openjdk-8-slim
  script:
    - mvn clean test
  artifacts:
    reports:
      junit: target/surefire-reports/TEST-*.xml
    paths:
      - target/*.jar
    expire_in: 1 week

# 构建阶段
build:
  stage: build
  image: maven:3.8.6-openjdk-8-slim
  script:
    - mvn clean package -DskipTests
  artifacts:
    paths:
      - target/*.jar
    expire_in: 1 week
  only:
    - main
    - develop
    - tags

# 构建 Docker 镜像
build-docker:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE
  only:
    - main
    - develop
    - tags

# 部署到测试环境
deploy-test:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $DEPLOY_HOST >> ~/.ssh/known_hosts
  script:
    - scp target/*.jar $DEPLOY_USER@$DEPLOY_HOST:/opt/apps/your-app/lib/
    - ssh $DEPLOY_USER@$DEPLOY_HOST "cd /opt/apps/your-app && ./bin/stop.sh && ./bin/start.sh"
  environment:
    name: test
    url: http://test.example.com
  only:
    - develop

# 部署到生产环境
deploy-prod:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl set image deployment/your-app app=$DOCKER_IMAGE -n production
    - kubectl rollout status deployment/your-app -n production
  environment:
    name: production
    url: http://prod.example.com
  only:
    - tags
  when: manual
```

### 2.2 GitLab CI 变量配置

在 GitLab 项目设置中配置以下变量：

- `SSH_PRIVATE_KEY`: SSH 私钥（用于二进制部署）
- `DEPLOY_HOST`: 部署服务器地址
- `DEPLOY_USER`: 部署用户名
- `CI_REGISTRY`: 容器镜像仓库地址
- `CI_REGISTRY_USER`: 镜像仓库用户名
- `CI_REGISTRY_PASSWORD`: 镜像仓库密码

---

## 三、Jenkins Pipeline 示例

### 3.1 Jenkinsfile

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    tools {
        maven 'Maven-3.8.6'
        jdk 'JDK-8'
    }
    
    environment {
        DOCKER_REGISTRY = 'registry.example.com'
        IMAGE_NAME = 'your-app'
        KUBECONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn clean test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build -t ${imageTag} ."
                    sh "docker push ${imageTag}"
                }
            }
        }
        
        stage('Deploy to Test') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sh "kubectl set image deployment/your-app app=${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} -n test"
                    sh "kubectl rollout status deployment/your-app -n test"
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                script {
                    sh "kubectl set image deployment/your-app app=${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} -n production"
                    sh "kubectl rollout status deployment/your-app -n production"
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            cleanWs()
        }
    }
}
```

### 3.2 Jenkins 配置

1. 安装插件：
   - Pipeline
   - Docker Pipeline
   - Kubernetes CLI
   - Maven Integration

2. 配置凭据：
   - Docker Registry 凭据
   - Kubernetes kubeconfig
   - SSH 私钥（如需要）

---

## 四、通用部署脚本

### 4.1 二进制部署脚本

```bash
#!/bin/bash
# deploy-binary.sh

set -e

APP_NAME="your-app"
APP_VERSION="${1:-latest}"
DEPLOY_HOST="${DEPLOY_HOST:-localhost}"
DEPLOY_USER="${DEPLOY_USER:-appuser}"
DEPLOY_PATH="/opt/apps/${APP_NAME}"

echo "Deploying ${APP_NAME} version ${APP_VERSION} to ${DEPLOY_HOST}..."

# 上传文件
scp target/*.jar ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/lib/

# 部署
ssh ${DEPLOY_USER}@${DEPLOY_HOST} << EOF
    cd ${DEPLOY_PATH}
    ./bin/stop.sh
    ./bin/start.sh
    echo "Deployment completed!"
EOF
```

### 4.2 Docker 部署脚本

```bash
#!/bin/bash
# deploy-docker.sh

set -e

IMAGE_NAME="your-app"
IMAGE_TAG="${1:-latest}"
REGISTRY="${REGISTRY:-registry.example.com}"

echo "Building Docker image..."
docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .

echo "Pushing Docker image..."
docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

echo "Updating deployment..."
kubectl set image deployment/${IMAGE_NAME} app=${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} -n production

echo "Waiting for rollout..."
kubectl rollout status deployment/${IMAGE_NAME} -n production

echo "Deployment completed!"
```

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

