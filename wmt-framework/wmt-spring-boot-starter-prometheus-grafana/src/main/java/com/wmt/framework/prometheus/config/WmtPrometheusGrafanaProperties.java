package com.wmt.framework.prometheus.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;

@Data
@ConfigurationProperties(prefix = "wmt.prometheus")
public class WmtPrometheusGrafanaProperties {

    /**
     * 是否启用组件
     */
    private boolean enabled = true;

    /**
     * 指标暴露端点，默认 /actuator/prometheus
     */
    private String endpoint = "/actuator/prometheus";

    /**
     * 是否自动补充 management.endpoints.web.exposure.include
     */
    private boolean autoExposeEndpoint = true;

    /**
     * 公共标签配置
     */
    private CommonTags commonTags = new CommonTags();

    /**
     * Grafana Dashboard 导出配置
     */
    private Dashboard dashboard = new Dashboard();

    /**
     * Prometheus Alert Rules 导出配置
     */
    private Alerts alerts = new Alerts();

    /**
     * PushGateway 推送配置
     */
    private PushGateway pushGateway = new PushGateway();

    @Data
    public static class CommonTags {
        private boolean enabled = true;
        private String service;
        private String environment;
        private Map<String, String> extra = new LinkedHashMap<>();
    }

    @Data
    public static class Dashboard {
        private boolean enabled = true;
        /**
         * 导出路径，为空则仅保留在 classpath
         */
        private String exportPath;
    }

    @Data
    public static class Alerts {
        private boolean enabled = true;
        /**
         * 导出路径，为空则仅保留在 classpath
         */
        private String exportPath;
    }

    @Data
    public static class PushGateway {
        private boolean enabled = false;
        private String baseUrl = "http://localhost:9091";
        private String job = "wmt-app";
        private Map<String, String> grouping = new LinkedHashMap<>();
        private Duration pushRate = Duration.ofSeconds(30);
        private boolean deleteOnShutdown = true;
    }
}

