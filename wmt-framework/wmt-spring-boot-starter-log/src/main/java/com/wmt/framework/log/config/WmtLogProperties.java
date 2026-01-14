package com.wmt.framework.log.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.time.Duration;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * WMT日志管理配置属性
 *
 * @author WMT
 */
@Data
@ConfigurationProperties(prefix = "wmt.log")
public class WmtLogProperties {

    /**
     * 是否启用日志管理功能
     */
    private boolean enabled = true;

    /**
     * 日志收集配置
     */
    private Collection collection = new Collection();

    /**
     * 日志存储配置
     */
    private Storage storage = new Storage();

    /**
     * 日志分析配置
     */
    private Analysis analysis = new Analysis();

    /**
     * 日志告警配置
     */
    private Alerting alerting = new Alerting();

    /**
     * 日志可视化配置
     */
    private Visualization visualization = new Visualization();

    @Data
    public static class Collection {
        /**
         * 是否启用日志收集
         */
        private boolean enabled = true;

        /**
         * 收集的日志级别
         */
        private List<String> levels = Arrays.asList("INFO", "WARN", "ERROR");

        /**
         * 日志来源
         */
        private List<String> sources = Arrays.asList("application", "access", "error");

        /**
         * 收集间隔（秒）
         */
        private Duration interval = Duration.ofSeconds(30);

        /**
         * 批量大小
         */
        private int batchSize = 100;

        /**
         * 是否异步收集
         */
        private boolean async = true;

        /**
         * 异步队列大小
         */
        private int queueSize = 1000;
    }

    @Data
    public static class Storage {
        /**
         * 是否启用日志存储
         */
        private boolean enabled = true;

        /**
         * 存储类型：file, elasticsearch, database
         */
        private String type = "file";

        /**
         * 文件存储配置
         */
        private File file = new File();

        /**
         * Elasticsearch存储配置
         */
        private Elasticsearch elasticsearch = new Elasticsearch();

        /**
         * 数据库存储配置
         */
        private Database database = new Database();

        @Data
        public static class File {
            /**
             * 日志文件路径
             */
            private String path = "logs";

            /**
             * 文件保留天数
             */
            private int retentionDays = 30;

            /**
             * 文件压缩
             */
            private boolean compress = true;

            /**
             * 文件大小限制（MB）
             */
            private int maxFileSize = 100;
        }

        @Data
        public static class Elasticsearch {
            /**
             * Elasticsearch主机地址
             */
            private List<String> hosts = Arrays.asList("localhost:9200");

            /**
             * 索引前缀
             */
            private String indexPrefix = "wmt-logs";

            /**
             * 索引模板
             */
            private String indexTemplate = "wmt-logs-template";

            /**
             * 批量写入大小
             */
            private int bulkSize = 1000;

            /**
             * 刷新间隔
             */
            private Duration refreshInterval = Duration.ofSeconds(1);

            /**
             * 连接超时
             */
            private Duration connectTimeout = Duration.ofSeconds(10);

            /**
             * 读取超时
             */
            private Duration readTimeout = Duration.ofSeconds(30);
        }

        @Data
        public static class Database {
            /**
             * 表名
             */
            private String tableName = "wmt_logs";

            /**
             * 批量插入大小
             */
            private int batchSize = 100;

            /**
             * 数据保留天数
             */
            private int retentionDays = 90;
        }
    }

    @Data
    public static class Analysis {
        /**
         * 是否启用日志分析
         */
        private boolean enabled = true;

        /**
         * 分析间隔（分钟）
         */
        private Duration interval = Duration.ofMinutes(5);

        /**
         * 异常检测配置
         */
        private ExceptionDetection exceptionDetection = new ExceptionDetection();

        /**
         * 趋势分析配置
         */
        private TrendAnalysis trendAnalysis = new TrendAnalysis();

        @Data
        public static class ExceptionDetection {
            /**
             * 是否启用异常检测
             */
            private boolean enabled = true;

            /**
             * 异常阈值
             */
            private int threshold = 10;

            /**
             * 时间窗口（分钟）
             */
            private Duration timeWindow = Duration.ofMinutes(10);
        }

        @Data
        public static class TrendAnalysis {
            /**
             * 是否启用趋势分析
             */
            private boolean enabled = true;

            /**
             * 分析周期（小时）
             */
            private Duration period = Duration.ofHours(1);

            /**
             * 趋势指标
             */
            private List<String> metrics = Arrays.asList("error_rate", "response_time", "throughput");
        }
    }

    @Data
    public static class Alerting {
        /**
         * 是否启用日志告警
         */
        private boolean enabled = true;

        /**
         * 告警规则
         */
        private List<AlertRule> rules = Collections.emptyList();

        /**
         * 告警通知方式
         */
        private List<String> channels = Arrays.asList("email", "webhook");

        /**
         * 告警配置
         */
        private Map<String, Object> config = new HashMap<>();

        @Data
        public static class AlertRule {
            /**
             * 规则名称
             */
            private String name;

            /**
             * 规则描述
             */
            private String description;

            /**
             * 匹配条件
             */
            private String condition;

            /**
             * 阈值
             */
            private Object threshold;

            /**
             * 时间窗口
             */
            private Duration timeWindow;

            /**
             * 是否启用
             */
            private boolean enabled = true;
        }
    }

    @Data
    public static class Visualization {
        /**
         * 是否启用日志可视化
         */
        private boolean enabled = true;

        /**
         * Kibana配置
         */
        private Kibana kibana = new Kibana();

        /**
         * 自定义仪表板
         */
        private Dashboard dashboard = new Dashboard();

        @Data
        public static class Kibana {
            /**
             * Kibana地址
             */
            private String url = "http://localhost:5601";

            /**
             * 索引模式
             */
            private String indexPattern = "wmt-logs-*";

            /**
             * 默认时间范围
             */
            private String defaultTimeRange = "last 1 hour";
        }

        @Data
        public static class Dashboard {
            /**
             * 是否启用自定义仪表板
             */
            private boolean enabled = true;

            /**
             * 仪表板配置
             */
            private Map<String, Object> config = new HashMap<>();
        }
    }
}
