# WMT Biz IP Starter

IP业务组件，提供IP地址解析、地理位置查询、IP白名单等功能。

## 功能特性

- 🌍 **IP地址解析**: 支持IP地址到地理位置的解析
- 📍 **地理位置查询**: 支持国家、省份、城市等地理位置信息
- 🛡️ **IP白名单**: 支持IP白名单功能
- 🚫 **IP黑名单**: 支持IP黑名单功能
- 📊 **IP统计**: 提供IP访问统计功能
- 🔍 **IP查询**: 支持IP地址查询和验证
- 🔧 **配置灵活**: 支持多种IP配置方式
- 📱 **多端支持**: 支持Web、移动端IP功能

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-biz-ip</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  ip:
    enabled: true
    # IP数据库文件路径
    database-path: classpath:ip2region.xdb
    # IP白名单
    whitelist:
      - 127.0.0.1
      - 192.168.1.0/24
      - 10.0.0.0/8
    # IP黑名单
    blacklist:
      - 192.168.100.1
      - 10.0.0.100
    # IP统计配置
    statistics:
      enabled: true
      max-records: 10000
```

### 3. 使用IP解析

```java
@Service
public class IpService {
    
    @Resource
    private Ip2RegionSearcher ip2RegionSearcher;
    
    /**
     * 解析IP地址
     */
    public IpInfo parseIp(String ip) {
        try {
            String region = ip2RegionSearcher.search(ip);
            return parseRegion(region);
        } catch (Exception e) {
            log.error("IP解析失败: {}", ip, e);
            return new IpInfo();
        }
    }
    
    /**
     * 解析地区信息
     */
    private IpInfo parseRegion(String region) {
        if (StringUtils.isEmpty(region)) {
            return new IpInfo();
        }
        
        String[] parts = region.split("\\|");
        IpInfo ipInfo = new IpInfo();
        
        if (parts.length >= 1) {
            ipInfo.setCountry(parts[0]);
        }
        if (parts.length >= 2) {
            ipInfo.setProvince(parts[1]);
        }
        if (parts.length >= 3) {
            ipInfo.setCity(parts[2]);
        }
        if (parts.length >= 4) {
            ipInfo.setIsp(parts[3]);
        }
        
        return ipInfo;
    }
}
```

### 4. 使用IP白名单

```java
@Service
public class IpWhitelistService {
    
    @Resource
    private IpWhitelistMapper ipWhitelistMapper;
    
    /**
     * 检查IP是否在白名单中
     */
    public boolean isWhitelisted(String ip) {
        // 检查配置的白名单
        if (isConfiguredWhitelisted(ip)) {
            return true;
        }
        
        // 检查数据库中的白名单
        return ipWhitelistMapper.selectCount(new LambdaQueryWrapperX<IpWhitelistDO>()
                .eq(IpWhitelistDO::getIp, ip)
                .eq(IpWhitelistDO::getStatus, 1)) > 0;
    }
    
    /**
     * 检查配置的白名单
     */
    private boolean isConfiguredWhitelisted(String ip) {
        List<String> whitelist = ipProperties.getWhitelist();
        if (whitelist == null || whitelist.isEmpty()) {
            return false;
        }
        
        for (String whitelistIp : whitelist) {
            if (isIpInRange(ip, whitelistIp)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 检查IP是否在范围内
     */
    private boolean isIpInRange(String ip, String range) {
        if (range.contains("/")) {
            // CIDR格式
            return isIpInCidr(ip, range);
        } else {
            // 单个IP
            return ip.equals(range);
        }
    }
}
```

### 5. 使用IP黑名单

```java
@Service
public class IpBlacklistService {
    
    @Resource
    private IpBlacklistMapper ipBlacklistMapper;
    
    /**
     * 检查IP是否在黑名单中
     */
    public boolean isBlacklisted(String ip) {
        // 检查配置的黑名单
        if (isConfiguredBlacklisted(ip)) {
            return true;
        }
        
        // 检查数据库中的黑名单
        return ipBlacklistMapper.selectCount(new LambdaQueryWrapperX<IpBlacklistDO>()
                .eq(IpBlacklistDO::getIp, ip)
                .eq(IpBlacklistDO::getStatus, 1)) > 0;
    }
    
    /**
     * 添加IP到黑名单
     */
    public void addToBlacklist(String ip, String reason) {
        IpBlacklistDO blacklist = new IpBlacklistDO();
        blacklist.setIp(ip);
        blacklist.setReason(reason);
        blacklist.setStatus(1);
        blacklist.setCreateTime(LocalDateTime.now());
        
        ipBlacklistMapper.insert(blacklist);
    }
    
    /**
     * 从黑名单中移除IP
     */
    public void removeFromBlacklist(String ip) {
        ipBlacklistMapper.update(null, new LambdaUpdateWrapperX<IpBlacklistDO>()
                .eq(IpBlacklistDO::getIp, ip)
                .set(IpBlacklistDO::getStatus, 0));
    }
}
```

### 6. 使用IP统计

```java
@Service
public class IpStatisticsService {
    
    @Resource
    private IpStatisticsMapper ipStatisticsMapper;
    
    /**
     * 记录IP访问
     */
    public void recordIpAccess(String ip, String url, String userAgent) {
        IpStatisticsDO statistics = new IpStatisticsDO();
        statistics.setIp(ip);
        statistics.setUrl(url);
        statistics.setUserAgent(userAgent);
        statistics.setAccessTime(LocalDateTime.now());
        
        ipStatisticsMapper.insert(statistics);
    }
    
    /**
     * 获取IP访问统计
     */
    public List<IpStatisticsDO> getIpStatistics(String ip, LocalDateTime startTime, LocalDateTime endTime) {
        return ipStatisticsMapper.selectList(new LambdaQueryWrapperX<IpStatisticsDO>()
                .eq(IpStatisticsDO::getIp, ip)
                .between(IpStatisticsDO::getAccessTime, startTime, endTime)
                .orderByDesc(IpStatisticsDO::getAccessTime));
    }
    
    /**
     * 获取热门IP
     */
    public List<IpStatisticsDO> getHotIps(int limit) {
        return ipStatisticsMapper.selectList(new LambdaQueryWrapperX<IpStatisticsDO>()
                .groupBy(IpStatisticsDO::getIp)
                .orderByDesc(IpStatisticsDO::getAccessTime)
                .last("LIMIT " + limit));
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.ip.enabled` | boolean | true | 是否启用IP功能 |
| `wmt.ip.database-path` | String | classpath:ip2region.xdb | IP数据库文件路径 |

### 白名单配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.ip.whitelist` | String[] | - | IP白名单列表 |
| `wmt.ip.whitelist.enabled` | boolean | true | 是否启用白名单 |

### 黑名单配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.ip.blacklist` | String[] | - | IP黑名单列表 |
| `wmt.ip.blacklist.enabled` | boolean | true | 是否启用黑名单 |

### 统计配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.ip.statistics.enabled` | boolean | true | 是否启用IP统计 |
| `wmt.ip.statistics.max-records` | int | 10000 | 最大记录数 |

## 核心功能

### IP地址解析

#### Ip2RegionSearcher

IP地址解析器：

```java
@Component
public class Ip2RegionSearcher {
    
    private Searcher searcher;
    
    @PostConstruct
    public void init() throws Exception {
        String dbPath = ipProperties.getDatabasePath();
        byte[] dbBytes = ResourceUtils.getResourceAsBytes(dbPath);
        searcher = Searcher.newWithBuffer(dbBytes);
    }
    
    /**
     * 搜索IP地址
     */
    public String search(String ip) throws Exception {
        return searcher.search(ip);
    }
    
    /**
     * 解析IP信息
     */
    public IpInfo parseIp(String ip) {
        try {
            String region = search(ip);
            return parseRegion(region);
        } catch (Exception e) {
            log.error("IP解析失败: {}", ip, e);
            return new IpInfo();
        }
    }
}
```

#### 使用IP解析

```java
@Service
public class IpService {
    
    @Resource
    private Ip2RegionSearcher ip2RegionSearcher;
    
    public IpInfo parseIp(String ip) {
        return ip2RegionSearcher.parseIp(ip);
    }
    
    public String getCountry(String ip) {
        IpInfo ipInfo = parseIp(ip);
        return ipInfo.getCountry();
    }
    
    public String getProvince(String ip) {
        IpInfo ipInfo = parseIp(ip);
        return ipInfo.getProvince();
    }
    
    public String getCity(String ip) {
        IpInfo ipInfo = parseIp(ip);
        return ipInfo.getCity();
    }
}
```

### IP白名单

#### 白名单检查

```java
@Service
public class IpWhitelistService {
    
    @Resource
    private IpWhitelistMapper ipWhitelistMapper;
    
    public boolean isWhitelisted(String ip) {
        // 检查配置的白名单
        if (isConfiguredWhitelisted(ip)) {
            return true;
        }
        
        // 检查数据库中的白名单
        return ipWhitelistMapper.selectCount(new LambdaQueryWrapperX<IpWhitelistDO>()
                .eq(IpWhitelistDO::getIp, ip)
                .eq(IpWhitelistDO::getStatus, 1)) > 0;
    }
    
    private boolean isConfiguredWhitelisted(String ip) {
        List<String> whitelist = ipProperties.getWhitelist();
        if (whitelist == null || whitelist.isEmpty()) {
            return false;
        }
        
        for (String whitelistIp : whitelist) {
            if (isIpInRange(ip, whitelistIp)) {
                return true;
            }
        }
        
        return false;
    }
}
```

#### 白名单管理

```java
@Service
public class IpWhitelistService {
    
    /**
     * 添加IP到白名单
     */
    public void addToWhitelist(String ip, String reason) {
        IpWhitelistDO whitelist = new IpWhitelistDO();
        whitelist.setIp(ip);
        whitelist.setReason(reason);
        whitelist.setStatus(1);
        whitelist.setCreateTime(LocalDateTime.now());
        
        ipWhitelistMapper.insert(whitelist);
    }
    
    /**
     * 从白名单中移除IP
     */
    public void removeFromWhitelist(String ip) {
        ipWhitelistMapper.update(null, new LambdaUpdateWrapperX<IpWhitelistDO>()
                .eq(IpWhitelistDO::getIp, ip)
                .set(IpWhitelistDO::getStatus, 0));
    }
    
    /**
     * 获取白名单列表
     */
    public List<IpWhitelistDO> getWhitelist() {
        return ipWhitelistMapper.selectList(new LambdaQueryWrapperX<IpWhitelistDO>()
                .eq(IpWhitelistDO::getStatus, 1)
                .orderByDesc(IpWhitelistDO::getCreateTime));
    }
}
```

### IP黑名单

#### 黑名单检查

```java
@Service
public class IpBlacklistService {
    
    @Resource
    private IpBlacklistMapper ipBlacklistMapper;
    
    public boolean isBlacklisted(String ip) {
        // 检查配置的黑名单
        if (isConfiguredBlacklisted(ip)) {
            return true;
        }
        
        // 检查数据库中的黑名单
        return ipBlacklistMapper.selectCount(new LambdaQueryWrapperX<IpBlacklistDO>()
                .eq(IpBlacklistDO::getIp, ip)
                .eq(IpBlacklistDO::getStatus, 1)) > 0;
    }
    
    private boolean isConfiguredBlacklisted(String ip) {
        List<String> blacklist = ipProperties.getBlacklist();
        if (blacklist == null || blacklist.isEmpty()) {
            return false;
        }
        
        for (String blacklistIp : blacklist) {
            if (ip.equals(blacklistIp)) {
                return true;
            }
        }
        
        return false;
    }
}
```

#### 黑名单管理

```java
@Service
public class IpBlacklistService {
    
    /**
     * 添加IP到黑名单
     */
    public void addToBlacklist(String ip, String reason) {
        IpBlacklistDO blacklist = new IpBlacklistDO();
        blacklist.setIp(ip);
        blacklist.setReason(reason);
        blacklist.setStatus(1);
        blacklist.setCreateTime(LocalDateTime.now());
        
        ipBlacklistMapper.insert(blacklist);
    }
    
    /**
     * 从黑名单中移除IP
     */
    public void removeFromBlacklist(String ip) {
        ipBlacklistMapper.update(null, new LambdaUpdateWrapperX<IpBlacklistDO>()
                .eq(IpBlacklistDO::getIp, ip)
                .set(IpBlacklistDO::getStatus, 0));
    }
    
    /**
     * 获取黑名单列表
     */
    public List<IpBlacklistDO> getBlacklist() {
        return ipBlacklistMapper.selectList(new LambdaQueryWrapperX<IpBlacklistDO>()
                .eq(IpBlacklistDO::getStatus, 1)
                .orderByDesc(IpBlacklistDO::getCreateTime));
    }
}
```

### IP统计

#### 访问统计

```java
@Service
public class IpStatisticsService {
    
    @Resource
    private IpStatisticsMapper ipStatisticsMapper;
    
    /**
     * 记录IP访问
     */
    public void recordIpAccess(String ip, String url, String userAgent) {
        IpStatisticsDO statistics = new IpStatisticsDO();
        statistics.setIp(ip);
        statistics.setUrl(url);
        statistics.setUserAgent(userAgent);
        statistics.setAccessTime(LocalDateTime.now());
        
        ipStatisticsMapper.insert(statistics);
    }
    
    /**
     * 获取IP访问统计
     */
    public List<IpStatisticsDO> getIpStatistics(String ip, LocalDateTime startTime, LocalDateTime endTime) {
        return ipStatisticsMapper.selectList(new LambdaQueryWrapperX<IpStatisticsDO>()
                .eq(IpStatisticsDO::getIp, ip)
                .between(IpStatisticsDO::getAccessTime, startTime, endTime)
                .orderByDesc(IpStatisticsDO::getAccessTime));
    }
    
    /**
     * 获取热门IP
     */
    public List<IpStatisticsDO> getHotIps(int limit) {
        return ipStatisticsMapper.selectList(new LambdaQueryWrapperX<IpStatisticsDO>()
                .groupBy(IpStatisticsDO::getIp)
                .orderByDesc(IpStatisticsDO::getAccessTime)
                .last("LIMIT " + limit));
    }
}
```

## 注解说明

### @IpWhitelist

IP白名单注解：

```java
@IpWhitelist
@GetMapping("/admin/users")
public CommonResult<PageResult<User>> getUsers() {
    return CommonResult.success(userService.getUsers());
}
```

### @IpBlacklist

IP黑名单注解：

```java
@IpBlacklist
@PostMapping("/admin/users")
public CommonResult<Long> createUser(@RequestBody UserCreateReqVO reqVO) {
    return CommonResult.success(userService.createUser(reqVO));
}
```

## 工具类

### IpUtils

IP工具类：

```java
public class IpUtils {
    
    /**
     * 获取客户端IP地址
     */
    public static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    /**
     * 检查IP是否在范围内
     */
    public static boolean isIpInRange(String ip, String range) {
        if (range.contains("/")) {
            return isIpInCidr(ip, range);
        } else {
            return ip.equals(range);
        }
    }
    
    /**
     * 检查IP是否在CIDR范围内
     */
    public static boolean isIpInCidr(String ip, String cidr) {
        try {
            String[] parts = cidr.split("/");
            String network = parts[0];
            int prefixLength = Integer.parseInt(parts[1]);
            
            long ipLong = ipToLong(ip);
            long networkLong = ipToLong(network);
            long mask = (0xFFFFFFFFL << (32 - prefixLength)) & 0xFFFFFFFFL;
            
            return (ipLong & mask) == (networkLong & mask);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * IP地址转长整型
     */
    public static long ipToLong(String ip) {
        String[] parts = ip.split("\\.");
        long result = 0;
        for (int i = 0; i < 4; i++) {
            result = result << 8 | Integer.parseInt(parts[i]);
        }
        return result;
    }
}
```

## 最佳实践

### 1. IP解析设计

```java
@Service
public class IpService {
    
    @Resource
    private Ip2RegionSearcher ip2RegionSearcher;
    
    public IpInfo parseIp(String ip) {
        try {
            return ip2RegionSearcher.parseIp(ip);
        } catch (Exception e) {
            log.error("IP解析失败: {}", ip, e);
            return new IpInfo();
        }
    }
}
```

### 2. 白名单设计

```java
@Service
public class IpWhitelistService {
    
    public boolean isWhitelisted(String ip) {
        // 检查配置的白名单
        if (isConfiguredWhitelisted(ip)) {
            return true;
        }
        
        // 检查数据库中的白名单
        return ipWhitelistMapper.selectCount(new LambdaQueryWrapperX<IpWhitelistDO>()
                .eq(IpWhitelistDO::getIp, ip)
                .eq(IpWhitelistDO::getStatus, 1)) > 0;
    }
}
```

### 3. 黑名单设计

```java
@Service
public class IpBlacklistService {
    
    public boolean isBlacklisted(String ip) {
        // 检查配置的黑名单
        if (isConfiguredBlacklisted(ip)) {
            return true;
        }
        
        // 检查数据库中的黑名单
        return ipBlacklistMapper.selectCount(new LambdaQueryWrapperX<IpBlacklistDO>()
                .eq(IpBlacklistDO::getIp, ip)
                .eq(IpBlacklistDO::getStatus, 1)) > 0;
    }
}
```

### 4. 统计设计

```java
@Service
public class IpStatisticsService {
    
    public void recordIpAccess(String ip, String url, String userAgent) {
        IpStatisticsDO statistics = new IpStatisticsDO();
        statistics.setIp(ip);
        statistics.setUrl(url);
        statistics.setUserAgent(userAgent);
        statistics.setAccessTime(LocalDateTime.now());
        
        ipStatisticsMapper.insert(statistics);
    }
}
```

## 故障排除

### 常见问题

1. **IP解析失败**
   - 检查IP数据库文件是否存在
   - 确认IP地址格式是否正确
   - 验证数据库文件是否损坏

2. **白名单不生效**
   - 检查白名单配置是否正确
   - 确认IP地址格式是否正确
   - 验证CIDR格式是否正确

3. **黑名单不生效**
   - 检查黑名单配置是否正确
   - 确认IP地址格式是否正确
   - 验证黑名单状态是否正确

4. **统计不记录**
   - 检查统计配置是否正确
   - 确认数据库连接是否正常
   - 验证统计表结构是否正确

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.ip: DEBUG
    org.lionsoul.ip2region: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- IP2Region: 2.7.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
