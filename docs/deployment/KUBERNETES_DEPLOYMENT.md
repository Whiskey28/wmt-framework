# Kubernetes 部署规范

> 基于 WMT Framework 的业务系统 Kubernetes 部署详细指南（命令级别）

## 📋 目录

- [一、Kubernetes 环境准备](#一kubernetes-环境准备)
- [二、命名空间与配置](#二命名空间与配置)
- [三、中间件部署](#三中间件部署)
- [四、应用部署](#四应用部署)
- [五、服务暴露](#五服务暴露)
- [六、监控与日志](#六监控与日志)
- [七、运维管理](#七运维管理)

---

## 一、Kubernetes 环境准备

### 1.1 安装 kubectl

#### 1.1.1 Linux

```bash
# 下载 kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# 安装 kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# 验证安装
kubectl version --client
```

#### 1.1.2 macOS

```bash
# 使用 Homebrew 安装
brew install kubectl

# 验证安装
kubectl version --client
```

### 1.2 配置 kubectl

```bash
# 配置 kubeconfig（如果使用云服务商，参考其文档）
# 例如：阿里云 ACK
export KUBECONFIG=~/.kube/config

# 测试连接
kubectl cluster-info

# 查看节点
kubectl get nodes

# 查看命名空间
kubectl get namespaces
```

### 1.3 安装 Helm（可选，用于部署中间件）

```bash
# 下载 Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 验证安装
helm version

# 添加常用仓库
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

---

## 二、命名空间与配置

### 2.1 创建命名空间

```bash
# 创建命名空间 YAML
vi k8s/namespace.yaml
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: wmt-app
  labels:
    name: wmt-app
    environment: production
```

```bash
# 应用命名空间
kubectl apply -f k8s/namespace.yaml

# 查看命名空间
kubectl get namespace wmt-app

# 设置默认命名空间
kubectl config set-context --current --namespace=wmt-app
```

### 2.2 创建 ConfigMap

```bash
# 创建应用配置 ConfigMap
vi k8s/configmap.yaml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: wmt-app
data:
  application.yml: |
    spring:
      application:
        name: your-app
      profiles:
        active: prod
      
      datasource:
        dynamic:
          primary: master
          datasource:
            master:
              name: master
              url: jdbc:mysql://mysql:3306/your_app_db?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai
              username: appuser
              driver-class-name: com.mysql.cj.jdbc.Driver
      
      data:
        redis:
          host: redis
          port: 6379
          database: 0
          timeout: 3000ms
      
      cloud:
        nacos:
          discovery:
            server-addr: nacos:8848
            namespace: prod
          config:
            server-addr: nacos:8848
            namespace: prod
            file-extension: yml
    
    management:
      endpoints:
        web:
          exposure:
            include: health,info,prometheus,metrics
      metrics:
        export:
          prometheus:
            enabled: true
```

```bash
# 应用 ConfigMap
kubectl apply -f k8s/configmap.yaml

# 查看 ConfigMap
kubectl get configmap -n wmt-app

# 查看 ConfigMap 内容
kubectl describe configmap app-config -n wmt-app
```

### 2.3 创建 Secret

```bash
# 创建 Secret（包含敏感信息）
vi k8s/secret.yaml
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: wmt-app
type: Opaque
stringData:
  mysql-root-password: RootPassword123!
  mysql-password: YourStrongPassword123!
  redis-password: YourRedisPassword123!
  nacos-auth-token: SecretKey012345678901234567890123456789012345678901234567890123456789
```

```bash
# 应用 Secret
kubectl apply -f k8s/secret.yaml

# 查看 Secret（密码会被 base64 编码）
kubectl get secret app-secret -n wmt-app

# 查看 Secret 内容（解码）
kubectl get secret app-secret -n wmt-app -o jsonpath='{.data.mysql-password}' | base64 -d
```

---

## 三、中间件部署

### 3.1 MySQL 8.0 部署

#### 3.1.1 使用 StatefulSet 部署 MySQL

```bash
# 创建 MySQL StatefulSet
vi k8s/mysql-statefulset.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: wmt-app
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None
  selector:
    app: mysql
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  namespace: wmt-app
spec:
  serviceName: mysql
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
          name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: mysql-root-password
        - name: MYSQL_DATABASE
          value: "your_app_db"
        - name: MYSQL_USER
          value: "appuser"
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: mysql-password
        command:
        - mysqld
        - --character-set-server=utf8mb4
        - --collation-server=utf8mb4_unicode_ci
        - --default-authentication-plugin=mysql_native_password
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
        livenessProbe:
          exec:
            command:
            - mysqladmin
            - ping
            - -h
            - localhost
            - -uroot
            - -p$(MYSQL_ROOT_PASSWORD)
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
        readinessProbe:
          exec:
            command:
            - mysqladmin
            - ping
            - -h
            - localhost
            - -uroot
            - -p$(MYSQL_ROOT_PASSWORD)
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 3
  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "standard"  # 根据实际存储类调整
      resources:
        requests:
          storage: 20Gi
```

```bash
# 应用 MySQL StatefulSet
kubectl apply -f k8s/mysql-statefulset.yaml

# 查看 MySQL Pod
kubectl get pods -n wmt-app -l app=mysql

# 查看 MySQL 日志
kubectl logs -f mysql-0 -n wmt-app

# 连接 MySQL（进入 Pod）
kubectl exec -it mysql-0 -n wmt-app -- mysql -u root -p
```

#### 3.1.2 使用 Helm 部署 MySQL（推荐）

```bash
# 添加 Bitnami 仓库
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# 安装 MySQL
helm install mysql bitnami/mysql \
  --namespace wmt-app \
  --create-namespace \
  --set auth.rootPassword=RootPassword123! \
  --set auth.database=your_app_db \
  --set auth.username=appuser \
  --set auth.password=YourStrongPassword123! \
  --set primary.persistence.size=20Gi \
  --set primary.resources.requests.memory=2Gi \
  --set primary.resources.requests.cpu=1000m

# 查看 MySQL 状态
helm list -n wmt-app
kubectl get pods -n wmt-app -l app.kubernetes.io/name=mysql
```

### 3.2 Redis 6.x 部署

#### 3.2.1 使用 Deployment 部署 Redis

```bash
# 创建 Redis Deployment
vi k8s/redis-deployment.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: wmt-app
spec:
  ports:
  - port: 6379
    targetPort: 6379
    name: redis
  selector:
    app: redis
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: wmt-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:6.2-alpine
        ports:
        - containerPort: 6379
          name: redis
        command:
        - redis-server
        - --requirepass
        - $(REDIS_PASSWORD)
        - --appendonly
        - "yes"
        env:
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: redis-password
        volumeMounts:
        - name: redis-data
          mountPath: /data
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        livenessProbe:
          exec:
            command:
            - redis-cli
            - --raw
            - incr
            - ping
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - redis-cli
            - --raw
            - incr
            - ping
          initialDelaySeconds: 5
          periodSeconds: 5
      volumes:
      - name: redis-data
        persistentVolumeClaim:
          claimName: redis-pvc
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: wmt-app
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 10Gi
```

```bash
# 应用 Redis Deployment
kubectl apply -f k8s/redis-deployment.yaml

# 查看 Redis Pod
kubectl get pods -n wmt-app -l app=redis

# 连接 Redis
kubectl exec -it redis-xxx -n wmt-app -- redis-cli -a YourRedisPassword123!
```

#### 3.2.2 使用 Helm 部署 Redis

```bash
# 安装 Redis
helm install redis bitnami/redis \
  --namespace wmt-app \
  --set auth.password=YourRedisPassword123! \
  --set master.persistence.size=10Gi \
  --set master.resources.requests.memory=512Mi \
  --set master.resources.requests.cpu=250m

# 获取 Redis 密码（如果使用随机密码）
kubectl get secret --namespace wmt-app redis -o jsonpath="{.data.redis-password}" | base64 -d
```

### 3.3 Nacos 部署

```bash
# 创建 Nacos Deployment
vi k8s/nacos-deployment.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nacos
  namespace: wmt-app
spec:
  ports:
  - port: 8848
    targetPort: 8848
    name: http
  - port: 9848
    targetPort: 9848
    name: grpc
  selector:
    app: nacos
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nacos
  namespace: wmt-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nacos
  template:
    metadata:
      labels:
        app: nacos
    spec:
      containers:
      - name: nacos
        image: nacos/nacos-server:v2.2.0
        ports:
        - containerPort: 8848
          name: http
        - containerPort: 9848
          name: grpc
        env:
        - name: MODE
          value: "standalone"
        - name: SPRING_DATASOURCE_PLATFORM
          value: "mysql"
        - name: MYSQL_SERVICE_HOST
          value: "mysql"
        - name: MYSQL_SERVICE_PORT
          value: "3306"
        - name: MYSQL_SERVICE_DB_NAME
          value: "nacos_config"
        - name: MYSQL_SERVICE_USER
          value: "appuser"
        - name: MYSQL_SERVICE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: mysql-password
        - name: NACOS_AUTH_ENABLE
          value: "true"
        - name: NACOS_AUTH_TOKEN
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: nacos-auth-token
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /nacos/
            port: 8848
          initialDelaySeconds: 60
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /nacos/
            port: 8848
          initialDelaySeconds: 30
          periodSeconds: 5
```

```bash
# 应用 Nacos Deployment
kubectl apply -f k8s/nacos-deployment.yaml

# 查看 Nacos Pod
kubectl get pods -n wmt-app -l app=nacos

# 访问 Nacos（需要端口转发或 Ingress）
kubectl port-forward svc/nacos 8848:8848 -n wmt-app
# 然后访问 http://localhost:8848/nacos
```

---

## 四、应用部署

### 4.1 创建应用 Deployment

```bash
# 创建应用 Deployment
vi k8s/app-deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: your-app
  namespace: wmt-app
  labels:
    app: your-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: your-app
  template:
    metadata:
      labels:
        app: your-app
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        prometheus.io/path: "/actuator/prometheus"
    spec:
      containers:
      - name: app
        image: your-app:1.0.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
          name: http
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "prod"
        - name: SPRING_DATASOURCE_URL
          value: "jdbc:mysql://mysql:3306/your_app_db?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai"
        - name: SPRING_DATASOURCE_USERNAME
          value: "appuser"
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: mysql-password
        - name: SPRING_REDIS_HOST
          value: "redis"
        - name: SPRING_REDIS_PORT
          value: "6379"
        - name: SPRING_REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: redis-password
        - name: SPRING_CLOUD_NACOS_DISCOVERY_SERVER_ADDR
          value: "nacos:8848"
        - name: SPRING_CLOUD_NACOS_CONFIG_SERVER_ADDR
          value: "nacos:8848"
        volumeMounts:
        - name: config
          mountPath: /app/config
          readOnly: true
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
        startupProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 0
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 30
      volumes:
      - name: config
        configMap:
          name: app-config
      restartPolicy: Always
```

```bash
# 应用 Deployment
kubectl apply -f k8s/app-deployment.yaml

# 查看 Deployment
kubectl get deployment your-app -n wmt-app

# 查看 Pod
kubectl get pods -n wmt-app -l app=your-app

# 查看 Pod 详细信息
kubectl describe pod your-app-xxx -n wmt-app

# 查看 Pod 日志
kubectl logs -f your-app-xxx -n wmt-app
```

### 4.2 创建应用 Service

```bash
# 创建 Service
vi k8s/app-service.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: your-app
  namespace: wmt-app
  labels:
    app: your-app
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: your-app
```

```bash
# 应用 Service
kubectl apply -f k8s/app-service.yaml

# 查看 Service
kubectl get svc your-app -n wmt-app

# 测试 Service（在集群内）
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- curl http://your-app:8080/actuator/health
```

### 4.3 滚动更新

```bash
# 更新镜像
kubectl set image deployment/your-app app=your-app:1.0.1 -n wmt-app

# 查看滚动更新状态
kubectl rollout status deployment/your-app -n wmt-app

# 查看更新历史
kubectl rollout history deployment/your-app -n wmt-app

# 回滚到上一个版本
kubectl rollout undo deployment/your-app -n wmt-app

# 回滚到指定版本
kubectl rollout undo deployment/your-app --to-revision=2 -n wmt-app
```

### 4.4 水平扩缩容

```bash
# 手动扩缩容
kubectl scale deployment your-app --replicas=5 -n wmt-app

# 创建 HPA（水平 Pod 自动扩缩容）
vi k8s/app-hpa.yaml
```

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: your-app-hpa
  namespace: wmt-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: your-app
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
      - type: Pods
        value: 2
        periodSeconds: 15
      selectPolicy: Max
```

```bash
# 应用 HPA
kubectl apply -f k8s/app-hpa.yaml

# 查看 HPA
kubectl get hpa your-app-hpa -n wmt-app

# 查看 HPA 详细信息
kubectl describe hpa your-app-hpa -n wmt-app
```

---

## 五、服务暴露

### 5.1 使用 NodePort

```bash
# 修改 Service 为 NodePort 类型
vi k8s/app-service-nodeport.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: your-app-nodeport
  namespace: wmt-app
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 30080
    protocol: TCP
    name: http
  selector:
    app: your-app
```

```bash
# 应用 Service
kubectl apply -f k8s/app-service-nodeport.yaml

# 访问应用（通过节点 IP + 端口）
# http://<node-ip>:30080
```

### 5.2 使用 Ingress

#### 5.2.1 安装 Ingress Controller

```bash
# 使用 Nginx Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

# 或使用 Helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace
```

#### 5.2.2 创建 Ingress

```bash
# 创建 Ingress
vi k8s/app-ingress.yaml
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: your-app-ingress
  namespace: wmt-app
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  ingressClassName: nginx
  rules:
  - host: your-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: your-app
            port:
              number: 8080
```

```bash
# 应用 Ingress
kubectl apply -f k8s/app-ingress.yaml

# 查看 Ingress
kubectl get ingress -n wmt-app

# 查看 Ingress 详细信息
kubectl describe ingress your-app-ingress -n wmt-app
```

### 5.3 使用 LoadBalancer（云服务商）

```yaml
apiVersion: v1
kind: Service
metadata:
  name: your-app-lb
  namespace: wmt-app
spec:
  type: LoadBalancer
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: your-app
```

---

## 六、监控与日志

### 6.1 Prometheus 部署

详见 [监控部署指南](../monitoring/PROMETHEUS_GRAFANA.md)

### 6.2 ELK Stack 部署

详见 [ELK 部署指南](../logging/ELK_STACK.md)

### 6.3 应用监控

```bash
# 查看 Pod 资源使用
kubectl top pods -n wmt-app

# 查看节点资源使用
kubectl top nodes

# 查看 Pod 详细信息
kubectl describe pod your-app-xxx -n wmt-app

# 查看事件
kubectl get events -n wmt-app --sort-by='.lastTimestamp'
```

---

## 七、运维管理

### 7.1 日志管理

```bash
# 查看 Pod 日志
kubectl logs your-app-xxx -n wmt-app

# 实时查看日志
kubectl logs -f your-app-xxx -n wmt-app

# 查看所有 Pod 日志
kubectl logs -l app=your-app -n wmt-app --all-containers=true

# 导出日志
kubectl logs your-app-xxx -n wmt-app > app.log

# 查看前 N 行日志
kubectl logs --tail=100 your-app-xxx -n wmt-app
```

### 7.2 备份与恢复

```bash
# 备份 ConfigMap
kubectl get configmap app-config -n wmt-app -o yaml > app-config-backup.yaml

# 备份 Secret
kubectl get secret app-secret -n wmt-app -o yaml > app-secret-backup.yaml

# 备份 Deployment
kubectl get deployment your-app -n wmt-app -o yaml > app-deployment-backup.yaml

# 恢复
kubectl apply -f app-config-backup.yaml
```

### 7.3 故障排查

```bash
# 查看 Pod 状态
kubectl get pods -n wmt-app

# 查看 Pod 详细信息
kubectl describe pod your-app-xxx -n wmt-app

# 进入 Pod
kubectl exec -it your-app-xxx -n wmt-app -- sh

# 查看 Pod 日志
kubectl logs your-app-xxx -n wmt-app

# 查看事件
kubectl get events -n wmt-app

# 查看资源使用
kubectl top pod your-app-xxx -n wmt-app
```

### 7.4 清理资源

```bash
# 删除 Deployment
kubectl delete deployment your-app -n wmt-app

# 删除 Service
kubectl delete svc your-app -n wmt-app

# 删除 ConfigMap
kubectl delete configmap app-config -n wmt-app

# 删除 Secret
kubectl delete secret app-secret -n wmt-app

# 删除命名空间（会删除所有资源）
kubectl delete namespace wmt-app
```

---

**文档版本**：v1.0.0  
**最后更新**：2025-01-XX  
**维护者**：WMT Framework Team

