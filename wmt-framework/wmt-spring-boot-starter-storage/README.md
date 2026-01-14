# WMT存储组件使用说明

## 概述

WMT存储组件提供统一的文件存储管理功能，支持多种存储方式，包括本地存储、MinIO对象存储等。通过统一的接口，业务系统可以轻松切换不同的存储后端，而无需修改业务代码。

## 功能特性

### 核心功能
- **统一存储接口**：提供统一的`StorageService`接口，屏蔽底层存储差异
- **多存储支持**：支持本地存储、MinIO、阿里云OSS、腾讯云COS、AWS S3等
- **文件操作**：上传、下载、删除、批量删除、获取文件信息
- **URL生成**：支持生成文件访问URL，支持临时访问链接
- **存储切换**：支持运行时动态切换存储方式

### 存储方式
1. **本地存储**：基于文件系统的本地存储，适合单机部署
2. **MinIO存储**：基于MinIO的对象存储，适合分布式部署
3. **云存储**：支持主流云服务商的对象存储服务

## 快速开始

### 1. 添加依赖

在项目的`pom.xml`中添加存储组件依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-storage</artifactId>
    <version>2025.12-jdk8-SNAPSHOT</version>
</dependency>
```

### 2. 配置存储方式

#### 本地存储配置

```yaml
wmt:
  storage:
    type: local
    local:
      base-path: /data/files
      url-prefix: http://localhost:8080/files
```

#### MinIO存储配置

```yaml
wmt:
  storage:
    type: minio
    minio:
      endpoint: http://localhost:9000
      access-key: minioadmin
      secret-key: minioadmin
      bucket-name: wmt-files
      url-prefix: http://localhost:9000/wmt-files
```

### 3. 使用存储服务

#### 方式一：使用StorageUtils工具类（推荐）

```java
@RestController
public class FileController {
    
    @Autowired
    private StorageUtils storageUtils;
    
    @PostMapping("/upload")
    public String uploadFile(@RequestParam("file") MultipartFile file) {
        // 上传文件
        String fileKey = storageUtils.uploadFile(file, "images", "avatar");
        return fileKey;
    }
    
    @GetMapping("/download/{fileKey}")
    public void downloadFile(@PathVariable String fileKey, HttpServletResponse response) {
        // 下载文件
        storageUtils.downloadFile(fileKey, response);
    }
    
    @GetMapping("/url/{fileKey}")
    public String getFileUrl(@PathVariable String fileKey) {
        // 获取文件访问URL
        return storageUtils.getFileUrl(fileKey);
    }
}
```

#### 方式二：直接使用StorageService

```java
@Service
public class FileService {
    
    @Autowired
    private StorageService storageService;
    
    public String uploadFile(MultipartFile file) {
        FileUploadRequest request = new FileUploadRequest();
        request.setMultipartFile(file);
        request.setPath("documents");
        request.setFileName(file.getOriginalFilename());
        
        return storageService.upload(request);
    }
    
    public InputStream downloadFile(String fileKey) {
        return storageService.download(fileKey);
    }
    
    public void deleteFile(String fileKey) {
        storageService.delete(fileKey);
    }
}
```

## 配置说明

### 完整配置示例

```yaml
wmt:
  storage:
    # 存储类型：local, minio, oss, cos, s3
    type: minio
    
    # 本地存储配置
    local:
      base-path: /data/files
      url-prefix: http://localhost:8080/files
      
    # MinIO存储配置
    minio:
      endpoint: http://localhost:9000
      access-key: minioadmin
      secret-key: minioadmin
      bucket-name: wmt-files
      url-prefix: http://localhost:9000/wmt-files
      
    # 阿里云OSS配置
    oss:
      endpoint: https://oss-cn-hangzhou.aliyuncs.com
      access-key-id: your-access-key-id
      access-key-secret: your-access-key-secret
      bucket-name: wmt-files
      url-prefix: https://wmt-files.oss-cn-hangzhou.aliyuncs.com
```

### 配置参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `wmt.storage.type` | String | local | 存储类型 |
| `wmt.storage.local.base-path` | String | /tmp/files | 本地存储根路径 |
| `wmt.storage.local.url-prefix` | String | - | 本地存储URL前缀 |
| `wmt.storage.minio.endpoint` | String | - | MinIO服务端点 |
| `wmt.storage.minio.access-key` | String | - | MinIO访问密钥 |
| `wmt.storage.minio.secret-key` | String | - | MinIO秘密密钥 |
| `wmt.storage.minio.bucket-name` | String | wmt-files | MinIO存储桶名称 |
| `wmt.storage.minio.url-prefix` | String | - | MinIO URL前缀 |

## API参考

### StorageService接口

```java
public interface StorageService {
    /**
     * 上传文件
     */
    String upload(FileUploadRequest request);
    
    /**
     * 下载文件
     */
    InputStream download(String fileKey);
    
    /**
     * 删除文件
     */
    void delete(String fileKey);
    
    /**
     * 批量删除文件
     */
    int deleteBatch(List<String> fileKeys);
    
    /**
     * 获取文件信息
     */
    FileInfo getFileInfo(String fileKey);
    
    /**
     * 获取文件访问URL
     */
    String getFileUrl(String fileKey);
}
```

### StorageUtils工具类

```java
public class StorageUtils {
    /**
     * 上传文件（简化版）
     */
    public String uploadFile(MultipartFile file, String path, String fileName);
    
    /**
     * 下载文件到响应流
     */
    public void downloadFile(String fileKey, HttpServletResponse response);
    
    /**
     * 获取文件访问URL
     */
    public String getFileUrl(String fileKey);
    
    /**
     * 删除文件
     */
    public void deleteFile(String fileKey);
}
```

## 最佳实践

### 1. 文件路径规划

建议按业务模块和文件类型组织文件路径：

```
/images/avatar/2024/01/15/xxx.jpg
/documents/contract/2024/01/15/xxx.pdf
/temp/upload/2024/01/15/xxx.xlsx
```

### 2. 文件命名策略

- 使用UUID避免文件名冲突
- 保留原始文件扩展名
- 添加时间戳便于管理

### 3. 错误处理

```java
@Service
public class FileService {
    
    @Autowired
    private StorageService storageService;
    
    public String uploadFile(MultipartFile file) {
        try {
            FileUploadRequest request = new FileUploadRequest();
            request.setMultipartFile(file);
            request.setPath("documents");
            request.setFileName(file.getOriginalFilename());
            
            return storageService.upload(request);
        } catch (Exception e) {
            log.error("文件上传失败", e);
            throw new RuntimeException("文件上传失败：" + e.getMessage());
        }
    }
}
```

### 4. 性能优化

- 大文件上传使用分片上传
- 合理设置文件缓存策略
- 定期清理临时文件

## 常见问题

### Q1: 如何切换存储方式？

A: 修改配置文件中的`wmt.storage.type`参数即可，无需修改业务代码。

### Q2: 如何获取文件的完整URL？

A: 使用`StorageUtils.getFileUrl(fileKey)`或`StorageService.getFileUrl(fileKey)`方法。

### Q3: 如何处理文件上传失败？

A: 组件会自动重试，如果仍然失败会抛出异常，建议在业务层进行异常处理。

### Q4: 支持哪些文件类型？

A: 存储组件本身不限制文件类型，支持任意格式的文件存储。

## 版本历史

- **1.0.0**: 初始版本，支持本地存储和MinIO存储
