# WMT Search Starter

基于Elasticsearch 7.23.x的搜索组件，提供全文搜索、搜索建议、热门搜索等功能。

## 功能特性

- 🔍 **全文搜索**: 支持多种搜索类型（match、match_phrase、wildcard、fuzzy）
- 📊 **搜索分析**: 搜索统计、热门搜索、搜索日志
- 🏷️ **自动索引**: 基于注解的自动索引管理
- 🔧 **灵活配置**: 支持多种Elasticsearch配置
- 📈 **性能优化**: 分片上传、断点续传、CDN集成
- 🛡️ **安全控制**: 访问权限、防盗链、文件加密

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-search</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  search:
    enabled: true
    elasticsearch:
      hosts:
        - localhost:9200
      username: elastic
      password: password
    search:
      default-page-size: 10
      suggest-enabled: true
```

### 3. 使用注解标记实体

```java
@Searchable(index = "user", fields = {"name", "email"})
public class User {
    
    @SearchField(type = FieldType.TEXT, searchable = true)
    private String name;
    
    @SearchField(type = FieldType.KEYWORD, sortable = true)
    private String email;
    
    @SearchField(type = FieldType.LONG, aggregatable = true)
    private Long age;
    
    // getters and setters
}
```

### 4. 使用搜索服务

```java
@Service
public class UserSearchService {
    
    @Autowired
    private SearchService searchService;
    
    public SearchResult<User> searchUsers(String keyword, int page, int size) {
        SearchRequest request = new SearchRequest()
                .setIndex("user")
                .setKeyword(keyword)
                .setPage(page)
                .setSize(size)
                .setFields(Arrays.asList("name", "email"));
        
        return searchService.search(request, User.class);
    }
    
    public void indexUser(User user) {
        searchService.index("user", user.getId().toString(), user);
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.search.enabled` | boolean | true | 是否启用搜索功能 |
| `wmt.search.elasticsearch.hosts` | List&lt;String&gt; | localhost:9200 | Elasticsearch节点地址 |
| `wmt.search.elasticsearch.username` | String | - | 用户名 |
| `wmt.search.elasticsearch.password` | String | - | 密码 |

### 搜索配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.search.search.default-page-size` | int | 10 | 默认分页大小 |
| `wmt.search.search.max-page-size` | int | 1000 | 最大分页大小 |
| `wmt.search.search.suggest-enabled` | boolean | true | 是否启用搜索建议 |
| `wmt.search.search.search-log-enabled` | boolean | true | 是否启用搜索日志 |

### 索引配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.search.index.default-shards` | int | 1 | 默认分片数 |
| `wmt.search.index.default-replicas` | int | 0 | 默认副本数 |
| `wmt.search.index.auto-create-index` | boolean | true | 是否自动创建索引 |

## 注解说明

### @Searchable

用于标记可搜索的实体类：

```java
@Searchable(
    index = "product",           // 索引名称
    fields = {"name", "desc"},   // 搜索字段
    autoIndex = true,           // 是否自动索引
    autoDelete = true,          // 是否自动删除
    settings = @IndexSettings(
        shards = 3,             // 分片数
        replicas = 1,           // 副本数
        refreshInterval = 5     // 刷新间隔
    )
)
public class Product {
    // ...
}
```

### @SearchField

用于标记搜索字段：

```java
@SearchField(
    name = "product_name",      // 字段名称
    type = FieldType.TEXT,      // 字段类型
    searchable = true,          // 是否参与搜索
    sortable = true,            // 是否参与排序
    aggregatable = true,        // 是否参与聚合
    analyzer = "ik_max_word"    // 分析器
)
private String name;
```

## API 接口

### SearchService

核心搜索服务接口：

```java
// 搜索文档
<T> SearchResult<T> search(SearchRequest request, Class<T> clazz);

// 索引文档
void index(String index, String id, Object document);

// 批量索引文档
void indexBatch(String index, List<Map<String, Object>> documents);

// 删除文档
void delete(String index, String id);

// 批量删除文档
void deleteBatch(String index, List<String> ids);

// 获取文档
<T> T get(String index, String id, Class<T> clazz);

// 创建索引
void createIndex(String index, Map<String, Object> mapping);

// 删除索引
void deleteIndex(String index);
```

### SearchRequest

搜索请求对象：

```java
SearchRequest request = new SearchRequest()
    .setIndex("user")                    // 索引名称
    .setKeyword("张三")                  // 搜索关键词
    .setFields(Arrays.asList("name"))    // 搜索字段
    .setPage(1)                          // 页码
    .setSize(10)                         // 每页大小
    .setSortField("createTime")          // 排序字段
    .setSortOrder("desc")                // 排序方向
    .setSearchType("match")              // 搜索类型
    .setSuggest(true);                  // 是否启用建议
```

### SearchResult

搜索结果对象：

```java
SearchResult<User> result = searchService.search(request, User.class);

List<User> users = result.getRecords();     // 搜索结果
Long total = result.getTotal();             // 总记录数
Integer page = result.getPage();            // 当前页码
Integer size = result.getSize();            // 每页大小
Long took = result.getTook();               // 搜索耗时
```

## 高级功能

### 搜索建议

```java
// 获取搜索建议
List<String> suggestions = searchService.getSuggestions("user", "张", "name");
```

### 热门搜索

```java
// 获取热门搜索
List<String> hotSearches = searchService.getHotSearches("user", 10);
```

### 搜索日志

```java
// 记录搜索日志
searchService.recordSearchLog("user", "张三", "user123");
```

## 性能优化

### 1. 索引优化

- 合理设置分片数和副本数
- 选择合适的分析器
- 定期清理无用索引

### 2. 查询优化

- 使用过滤器而非查询
- 合理使用聚合
- 避免深度分页

### 3. 缓存策略

- 启用查询缓存
- 使用结果缓存
- 合理设置TTL

## 故障排除

### 常见问题

1. **连接失败**
   - 检查Elasticsearch服务是否启动
   - 验证网络连接和端口
   - 确认认证信息

2. **索引创建失败**
   - 检查索引名称格式
   - 验证映射配置
   - 查看Elasticsearch日志

3. **搜索无结果**
   - 检查索引是否存在
   - 验证搜索字段配置
   - 确认数据已索引

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.search: DEBUG
    org.elasticsearch.client: DEBUG
```

## 版本兼容性

- Elasticsearch: 7.23.x
- Spring Boot: 2.7.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
