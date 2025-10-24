# WMT文件处理组件使用说明

## 概述

WMT文件处理组件提供丰富的文件处理功能，支持文件转换、预览、压缩、校验等多种操作。通过统一的接口，业务系统可以轻松处理各种文件格式，提升用户体验。

## 功能特性

### 核心功能
- **文件转换**：支持Office文档、图片格式转换
- **文件预览**：在线预览多种格式文件
- **文件压缩**：ZIP格式压缩解压
- **文件校验**：文件类型、大小、内容校验，MD5/SHA1计算

### 支持格式
1. **Office文档**：Word、Excel、PowerPoint
2. **图片格式**：JPG、PNG、GIF、BMP、WebP
3. **压缩格式**：ZIP、RAR、7Z
4. **其他格式**：PDF、TXT、CSV等

## 快速开始

### 1. 添加依赖

在项目的`pom.xml`中添加文件处理组件依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-file</artifactId>
    <version>2025.10-jdk8-SNAPSHOT</version>
</dependency>
```

### 2. 使用文件处理服务

#### 方式一：使用FileUtils工具类（推荐）

```java
@RestController
public class FileProcessController {
    
    @Autowired
    private FileUtils fileUtils;
    
    @PostMapping("/convert")
    public ResponseEntity<byte[]> convertFile(@RequestParam("file") MultipartFile file,
                                           @RequestParam("targetFormat") String targetFormat) {
        try {
            // 文件格式转换
            ConvertResult result = fileUtils.convertFile(
                file.getInputStream(), 
                getFileExtension(file.getOriginalFilename()), 
                targetFormat
            );
            
            if (result.isSuccess()) {
                return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=converted." + targetFormat)
                    .body(result.getConvertedContent());
            } else {
                return ResponseEntity.badRequest().build();
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @PostMapping("/preview")
    public ResponseEntity<String> previewFile(@RequestParam("file") MultipartFile file) {
        try {
            // 文件预览
            PreviewResult result = fileUtils.previewFile(
                file.getInputStream(),
                file.getOriginalFilename(),
                getFileExtension(file.getOriginalFilename())
            );
            
            if (result.isSuccess()) {
                return ResponseEntity.ok(result.getPreviewUrl());
            } else {
                return ResponseEntity.badRequest().build();
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
```

#### 方式二：直接使用服务接口

```java
@Service
public class FileProcessService {
    
    @Autowired
    private FileConvertService convertService;
    
    @Autowired
    private FilePreviewService previewService;
    
    @Autowired
    private FileCompressService compressService;
    
    @Autowired
    private FileValidateService validateService;
    
    public byte[] convertFile(InputStream inputStream, String sourceFormat, String targetFormat) {
        FileConvertRequest request = new FileConvertRequest();
        request.setSourceStream(inputStream);
        request.setSourceFormat(sourceFormat);
        request.setTargetFormat(targetFormat);
        
        ConvertResult result = convertService.convert(request);
        return result.isSuccess() ? result.getConvertedContent() : null;
    }
    
    public String previewFile(InputStream inputStream, String fileName, String fileType) {
        FilePreviewRequest request = new FilePreviewRequest();
        request.setFileStream(inputStream);
        request.setFileName(fileName);
        request.setFileType(fileType);
        
        PreviewResult result = previewService.preview(request);
        return result.isSuccess() ? result.getPreviewUrl() : null;
    }
}
```

## 功能详解

### 1. 文件转换

支持多种文件格式之间的转换：

```java
// Word转PDF
ConvertResult result = fileUtils.convertFile(
    inputStream, "docx", "pdf"
);

// Excel转CSV
ConvertResult result = fileUtils.convertFile(
    inputStream, "xlsx", "csv"
);

// 图片格式转换
ConvertResult result = fileUtils.convertFile(
    inputStream, "jpg", "png"
);
```

**支持的转换格式：**
- Word ↔ PDF
- Excel ↔ CSV
- PowerPoint ↔ PDF
- 图片格式互转（JPG、PNG、GIF、BMP、WebP）

### 2. 文件预览

支持在线预览多种格式文件：

```java
// 预览Office文档
PreviewResult result = fileUtils.previewFile(
    inputStream, "document.docx", "docx"
);

// 预览图片
PreviewResult result = fileUtils.previewFile(
    inputStream, "image.jpg", "jpg"
);

// 预览文本文件
PreviewResult result = fileUtils.previewFile(
    inputStream, "readme.txt", "txt"
);
```

**支持的预览格式：**
- 图片：JPG、PNG、GIF、BMP、WebP
- Office文档：Word、Excel、PowerPoint
- 文本文件：TXT、CSV、JSON、XML

### 3. 文件压缩

支持ZIP格式的压缩和解压：

```java
// 压缩文件
FileCompressRequest compressRequest = new FileCompressRequest();
compressRequest.addFile("document1.pdf", pdfContent);
compressRequest.addFile("document2.docx", docxContent);
compressRequest.setCompressFormat("zip");

CompressResult result = fileUtils.compressFiles(compressRequest);

// 解压文件
FileDecompressRequest decompressRequest = new FileDecompressRequest();
decompressRequest.setCompressStream(zipInputStream);
decompressRequest.setCompressFormat("zip");

DecompressResult result = fileUtils.decompressFiles(decompressRequest);
```

### 4. 文件校验

支持文件类型、大小、内容校验：

```java
// 校验文件
FileValidateRequest validateRequest = new FileValidateRequest();
validateRequest.setFileStream(inputStream);
validateRequest.setFileName("document.pdf");
validateRequest.setFileSize(fileSize);
validateRequest.setExpectedType("pdf");

ValidateResult result = fileUtils.validateFile(validateRequest);

if (result.isValid()) {
    System.out.println("文件校验通过");
    System.out.println("MD5: " + result.getMd5());
    System.out.println("SHA1: " + result.getSha1());
} else {
    System.out.println("文件校验失败: " + result.getErrorMessage());
}
```

## 配置说明

### 完整配置示例

```yaml
wmt:
  file:
    # 文件转换配置
    convert:
      # 临时文件存储路径
      temp-path: /tmp/file-convert
      # 最大文件大小（字节）
      max-file-size: 104857600  # 100MB
      # 支持的文件格式
      supported-formats:
        - docx
        - xlsx
        - pptx
        - pdf
        - jpg
        - png
        - gif
        
    # 文件预览配置
    preview:
      # 预览服务地址
      service-url: http://localhost:8080/preview
      # 预览文件存储路径
      storage-path: /tmp/file-preview
      # 预览文件过期时间（小时）
      expire-hours: 24
      
    # 文件压缩配置
    compress:
      # 压缩级别（1-9）
      compression-level: 6
      # 最大压缩文件大小（字节）
      max-compress-size: 1073741824  # 1GB
      
    # 文件校验配置
    validate:
      # 启用MD5校验
      enable-md5: true
      # 启用SHA1校验
      enable-sha1: true
      # 启用文件类型检测
      enable-type-detection: true
```

### 配置参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `wmt.file.convert.temp-path` | String | /tmp/file-convert | 转换临时文件路径 |
| `wmt.file.convert.max-file-size` | Long | 104857600 | 最大文件大小（100MB） |
| `wmt.file.preview.service-url` | String | - | 预览服务地址 |
| `wmt.file.preview.storage-path` | String | /tmp/file-preview | 预览文件存储路径 |
| `wmt.file.preview.expire-hours` | Integer | 24 | 预览文件过期时间 |
| `wmt.file.compress.compression-level` | Integer | 6 | 压缩级别 |
| `wmt.file.validate.enable-md5` | Boolean | true | 启用MD5校验 |
| `wmt.file.validate.enable-sha1` | Boolean | true | 启用SHA1校验 |

## API参考

### FileConvertService接口

```java
public interface FileConvertService {
    /**
     * 转换文件格式
     */
    ConvertResult convert(FileConvertRequest request);
    
    /**
     * 检查是否支持转换
     */
    boolean support(String sourceFormat, String targetFormat);
}
```

### FilePreviewService接口

```java
public interface FilePreviewService {
    /**
     * 预览文件
     */
    PreviewResult preview(FilePreviewRequest request);
    
    /**
     * 检查是否支持预览
     */
    boolean support(String fileType);
}
```

### FileCompressService接口

```java
public interface FileCompressService {
    /**
     * 压缩文件
     */
    CompressResult compress(FileCompressRequest request);
    
    /**
     * 解压文件
     */
    DecompressResult decompress(FileDecompressRequest request);
}
```

### FileValidateService接口

```java
public interface FileValidateService {
    /**
     * 校验文件
     */
    ValidateResult validate(FileValidateRequest request);
}
```

## 最佳实践

### 1. 文件大小限制

```java
@PostMapping("/upload")
public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
    // 检查文件大小
    if (file.getSize() > 100 * 1024 * 1024) { // 100MB
        return ResponseEntity.badRequest().body("文件大小超过限制");
    }
    
    // 处理文件上传
    return ResponseEntity.ok("上传成功");
}
```

### 2. 异步处理大文件

```java
@Service
public class FileProcessService {
    
    @Async
    public CompletableFuture<ConvertResult> convertFileAsync(FileConvertRequest request) {
        return CompletableFuture.completedFuture(convertService.convert(request));
    }
}
```

### 3. 错误处理

```java
@RestControllerAdvice
public class FileProcessExceptionHandler {
    
    @ExceptionHandler(FileConvertException.class)
    public ResponseEntity<String> handleConvertException(FileConvertException e) {
        return ResponseEntity.badRequest().body("文件转换失败：" + e.getMessage());
    }
    
    @ExceptionHandler(FilePreviewException.class)
    public ResponseEntity<String> handlePreviewException(FilePreviewException e) {
        return ResponseEntity.badRequest().body("文件预览失败：" + e.getMessage());
    }
}
```

### 4. 性能优化

- 使用缓存减少重复转换
- 异步处理大文件操作
- 定期清理临时文件
- 合理设置文件大小限制

## 常见问题

### Q1: 支持哪些文件格式转换？

A: 目前支持Word、Excel、PowerPoint、PDF、图片等格式的转换，具体支持的格式请参考配置说明。

### Q2: 如何处理大文件？

A: 建议使用异步处理，并设置合理的文件大小限制。对于超大文件，可以考虑分片处理。

### Q3: 预览功能如何工作？

A: 预览功能会将文件转换为可预览的格式（如HTML、图片），并生成临时访问链接。

### Q4: 如何清理临时文件？

A: 组件会自动清理过期的临时文件，也可以通过配置设置清理策略。

## 版本历史

- **1.0.0**: 初始版本，支持文件转换、预览、压缩、校验功能
