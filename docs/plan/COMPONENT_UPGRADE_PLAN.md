# WMT技术组件库升级清单

## 当前组件库现状分析

### 已有组件模块

#### 1. 基础组件
- **wmt-common**: 基础工具类、枚举、异常定义
- **wmt-spring-boot-starter-web**: Web框架，全局异常、API日志、XSS防护、API文档
- **wmt-spring-boot-starter-security**: 安全认证框架
- **wmt-spring-boot-starter-test**: 测试工具

#### 2. 数据存储组件
- **wmt-spring-boot-starter-mybatis**: MyBatis增强，多数据源、数据翻译
- **wmt-spring-boot-starter-redis**: Redis缓存、分布式锁
- **wmt-spring-boot-starter-excel**: Excel导入导出，基于FastExcel

#### 3. 任务调度组件
- **wmt-spring-boot-starter-job**: 基于Quartz的任务调度
- **wmt-spring-boot-starter-xxljob**: 基于XXL-Job的分布式任务调度

#### 4. 消息队列组件
- **wmt-spring-boot-starter-mq**: 支持Redis、RocketMQ、RabbitMQ、Kafka

#### 5. 监控组件
- **wmt-spring-boot-starter-monitor**: 链路追踪、性能监控
- **wmt-spring-boot-starter-protection**: 幂等性、分布式锁、限流

#### 6. 业务组件
- **wmt-spring-boot-starter-biz-tenant**: 多租户支持
- **wmt-spring-boot-starter-biz-data-permission**: 数据权限
- **wmt-spring-boot-starter-biz-ip**: IP地址解析

#### 7. 其他组件
- **wmt-spring-boot-starter-websocket**: WebSocket支持

## 升级清单设计

### 阶段一：存储与文件管理（高优先级）

#### 1.1 wmt-spring-boot-starter-storage
**目标**: 统一文件存储管理，支持多种存储方式

**核心功能**:
- **多存储支持**: 本地存储、MinIO、阿里云OSS、腾讯云COS、AWS S3
- **文件操作**: 上传、下载、删除、预览、批量操作
- **文件管理**: 文件分类、标签、元数据管理
- **安全控制**: 访问权限、防盗链、文件加密
- **性能优化**: 分片上传、断点续传、CDN集成

**技术实现**:
```java
// 核心接口
public interface StorageService {
    String upload(FileUploadRequest request);
    InputStream download(String fileKey);
    void delete(String fileKey);
    FileInfo getFileInfo(String fileKey);
}

// 配置类
@ConfigurationProperties(prefix = "wmt.storage")
public class StorageProperties {
    private StorageType type = StorageType.LOCAL;
    private LocalStorageConfig local;
    private MinioConfig minio;
    private OssConfig oss;
    // ...
}
```

**依赖关系**: 依赖wmt-common，可选依赖各云服务SDK

#### 1.2 wmt-spring-boot-starter-file
**目标**: 文件处理增强，支持多种文件格式

**核心功能**:
- **文件转换**: PDF、Word、Excel、图片格式转换
- **文件压缩**: ZIP、RAR、7Z压缩解压
- **文件预览**: 在线预览多种格式文件
- **文件校验**: 文件类型、大小、内容校验
- **文件处理**: 图片处理、文档解析、内容提取

**技术实现**:
```java
// 文件转换服务
public interface FileConvertService {
    ConvertResult convert(FileConvertRequest request);
    boolean support(String sourceFormat, String targetFormat);
}

// 文件预览服务
public interface FilePreviewService {
    PreviewResult preview(String fileKey);
    boolean support(String fileType);
}
```

### 阶段二：数据与缓存增强（中优先级）

#### 2.1 wmt-spring-boot-starter-cache
**目标**: 多级缓存管理，提升系统性能

**核心功能**:
- **多级缓存**: 本地缓存 + Redis缓存 + 数据库
- **缓存策略**: LRU、LFU、TTL、定时刷新
- **缓存预热**: 系统启动时预加载热点数据
- **缓存穿透防护**: 布隆过滤器、空值缓存
- **缓存一致性**: 分布式缓存同步、失效通知

**技术实现**:
```java
// 缓存管理器
public interface CacheManager {
    <T> T get(String key, Class<T> type);
    void put(String key, Object value, Duration ttl);
    void evict(String key);
    void clear();
}

// 缓存注解
@Cacheable(key = "#userId", ttl = "1h")
public User getUserById(Long userId);
```

#### 2.2 wmt-spring-boot-starter-search
**目标**: 全文搜索支持，提升数据检索能力

**核心功能**:
- **搜索引擎**: Elasticsearch、Solr集成
- **搜索功能**: 全文搜索、模糊搜索、分词搜索
- **搜索优化**: 搜索建议、搜索高亮、搜索结果排序
- **数据同步**: 数据库到搜索引擎的数据同步
- **搜索分析**: 搜索统计、热门搜索、搜索日志

**技术实现**:
```java
// 搜索服务
public interface SearchService {
    SearchResult search(SearchRequest request);
    void index(String index, Object document);
    void delete(String index, String id);
}

// 搜索注解
@Searchable(index = "user", fields = {"name", "email"})
public class User {
    // ...
}
```

### 阶段三：业务增强组件（中优先级）

#### 3.1 wmt-spring-boot-starter-workflow
**目标**: 工作流引擎，支持业务流程自动化

**核心功能**:
- **流程定义**: 可视化流程设计、流程版本管理
- **流程执行**: 流程启动、任务处理、流程监控
- **任务管理**: 任务分配、任务提醒、任务超时处理
- **流程监控**: 流程状态、执行时间、异常处理
- **集成能力**: 与业务系统集成、API接口

**技术实现**:
```java
// 工作流引擎
public interface WorkflowEngine {
    String startProcess(String processKey, Map<String, Object> variables);
    void completeTask(String taskId, Map<String, Object> variables);
    List<Task> getTasksByUser(String userId);
}

// 流程定义注解
@ProcessDefinition(key = "approval", name = "审批流程")
public class ApprovalProcess {
    // ...
}
```

#### 3.2 wmt-spring-boot-starter-notification
**目标**: 多渠道消息通知，提升用户体验

**核心功能**:
- **多渠道支持**: 短信、邮件、站内信、推送、微信
- **消息模板**: 模板管理、变量替换、多语言支持
- **消息队列**: 异步发送、批量发送、发送失败重试
- **消息统计**: 发送统计、到达率、点击率
- **消息管理**: 消息历史、消息状态、消息撤回

**技术实现**:
```java
// 通知服务
public interface NotificationService {
    void send(NotificationRequest request);
    void sendBatch(List<NotificationRequest> requests);
    NotificationResult getStatus(String messageId);
}

// 通知注解
@Notification(channel = "email", template = "welcome")
public void sendWelcomeEmail(String email, String name);
```

### 阶段四：系统增强组件（低优先级）

#### 4.1 wmt-spring-boot-starter-gateway
**目标**: API网关功能，统一入口管理

**核心功能**:
- **路由管理**: 动态路由、负载均衡、服务发现
- **安全控制**: 认证授权、限流熔断、黑白名单
- **监控统计**: 请求统计、性能监控、异常告警
- **协议转换**: HTTP/HTTPS、WebSocket、gRPC
- **插件扩展**: 自定义插件、第三方集成

#### 4.2 wmt-spring-boot-starter-config
**目标**: 配置中心，统一配置管理

**核心功能**:
- **配置管理**: 配置存储、版本管理、配置推送
- **动态配置**: 实时更新、配置回滚、配置对比
- **环境管理**: 多环境配置、配置隔离、配置继承
- **配置安全**: 配置加密、权限控制、审计日志
- **集成能力**: Spring Cloud Config、Apollo、Nacos

#### 4.3 wmt-spring-boot-starter-log
**目标**: 日志管理增强，提升运维效率

**核心功能**:
- **日志收集**: 多源日志收集、日志解析、日志清洗
- **日志存储**: 日志压缩、日志归档、日志检索
- **日志分析**: 日志统计、异常检测、趋势分析
- **日志告警**: 异常告警、阈值告警、自定义告警
- **日志可视化**: 日志图表、日志大屏、日志报表

## 功能重复分析与迁移建议

### 1. 文件存储功能重复

**现状分析**:
- **Excel组件**: 已有文件上传下载功能，但仅限于Excel格式
- **Web组件**: 有文件上传的基础支持，但功能简单

**迁移建议**:
- **保留Excel组件**: 专门处理Excel相关功能
- **新增Storage组件**: 统一处理所有文件存储需求
- **Web组件简化**: 移除文件上传功能，统一使用Storage组件

### 2. 缓存功能重复

**现状分析**:
- **Redis组件**: 提供基础的Redis操作
- **Protection组件**: 包含分布式锁功能

**迁移建议**:
- **新增Cache组件**: 提供高级缓存功能
- **Redis组件保留**: 作为Cache组件的底层实现
- **Protection组件**: 专注于幂等性和限流功能

### 3. 消息队列功能重复

**现状分析**:
- **MQ组件**: 支持多种消息队列
- **Redis组件**: 提供Redis Pub/Sub功能

**迁移建议**:
- **MQ组件保留**: 作为统一消息队列接口
- **Redis组件**: 移除Pub/Sub功能，专注于缓存和锁

### 4. 监控功能重复

**现状分析**:
- **Monitor组件**: 链路追踪和性能监控
- **Web组件**: API日志记录

**迁移建议**:
- **Monitor组件增强**: 整合所有监控功能
- **Web组件**: 移除日志功能，专注于Web框架功能

## 实施建议

### 优先级排序
1. **高优先级**: Storage、File组件（业务急需）
2. **中优先级**: Cache、Search、Workflow、Notification组件
3. **低优先级**: Gateway、Config、Log组件

### 开发策略
1. **渐进式开发**: 先实现核心功能，再逐步完善
2. **向后兼容**: 新组件不影响现有组件使用
3. **文档先行**: 每个组件都有完整的使用文档
4. **测试覆盖**: 确保组件质量和稳定性

### 技术选型原则
1. **成熟稳定**: 选择经过验证的技术方案
2. **性能优先**: 考虑高并发和大数据量场景
3. **易于集成**: 与现有组件无缝集成
4. **可扩展性**: 支持未来功能扩展

这个升级清单将帮助你的技术组件库更加完善，更好地服务于单体框架的业务系统。
