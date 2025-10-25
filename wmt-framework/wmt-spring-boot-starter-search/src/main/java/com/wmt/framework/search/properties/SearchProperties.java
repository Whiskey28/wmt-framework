package com.wmt.framework.search.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.ArrayList;
import java.util.List;

/**
 * 搜索配置属性
 *
 * @author wmt
 */
@Data
@ConfigurationProperties(prefix = "wmt.search")
public class SearchProperties {
    
    /**
     * 是否启用搜索功能
     */
    private boolean enabled = true;
    
    /**
     * Elasticsearch配置
     */
    private Elasticsearch elasticsearch = new Elasticsearch();
    
    /**
     * 搜索配置
     */
    private Search search = new Search();
    
    /**
     * 索引配置
     */
    private Index index = new Index();
    
    @Data
    public static class Elasticsearch {
        /**
         * 集群名称
         */
        private String clusterName = "elasticsearch";
        
        /**
         * 节点地址列表
         */
        private List<String> hosts = new ArrayList<>();
        
        /**
         * 连接超时时间（毫秒）
         */
        private int connectTimeout = 5000;
        
        /**
         * 读取超时时间（毫秒）
         */
        private int readTimeout = 30000;
        
        /**
         * 最大连接数
         */
        private int maxConnections = 100;
        
        /**
         * 每个路由的最大连接数
         */
        private int maxConnectionsPerRoute = 10;
        
        /**
         * 用户名
         */
        private String username;
        
        /**
         * 密码
         */
        private String password;
        
        /**
         * 是否启用SSL
         */
        private boolean ssl = false;
        
        /**
         * 证书路径
         */
        private String certificatePath;
        
        /**
         * 是否验证证书
         */
        private boolean verifyCertificate = true;
    }
    
    @Data
    public static class Search {
        /**
         * 默认分页大小
         */
        private int defaultPageSize = 10;
        
        /**
         * 最大分页大小
         */
        private int maxPageSize = 1000;
        
        /**
         * 默认搜索字段
         */
        private List<String> defaultSearchFields = new ArrayList<>();
        
        /**
         * 是否启用搜索建议
         */
        private boolean suggestEnabled = true;
        
        /**
         * 搜索建议字段
         */
        private String suggestField = "suggest";
        
        /**
         * 是否启用搜索日志
         */
        private boolean searchLogEnabled = true;
        
        /**
         * 搜索日志索引
         */
        private String searchLogIndex = "search_log";
        
        /**
         * 是否启用热门搜索
         */
        private boolean hotSearchEnabled = true;
        
        /**
         * 热门搜索索引
         */
        private String hotSearchIndex = "hot_search";
    }
    
    @Data
    public static class Index {
        /**
         * 默认分片数
         */
        private int defaultShards = 1;
        
        /**
         * 默认副本数
         */
        private int defaultReplicas = 0;
        
        /**
         * 默认刷新间隔（秒）
         */
        private int defaultRefreshInterval = 1;
        
        /**
         * 是否自动创建索引
         */
        private boolean autoCreateIndex = true;
        
        /**
         * 索引前缀
         */
        private String prefix = "";
        
        /**
         * 索引后缀
         */
        private String suffix = "";
    }
}
