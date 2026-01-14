package com.wmt.framework.log.autoconfigure;

import com.wmt.framework.log.config.WmtLogProperties;
import com.wmt.framework.log.service.LogAlertingService;
import com.wmt.framework.log.service.LogAnalysisService;
import com.wmt.framework.log.service.LogCollectionService;
import com.wmt.framework.log.service.LogStorageService;
import com.wmt.framework.log.service.LogVisualizationService;
import com.wmt.framework.log.service.impl.LogAlertingServiceImpl;
import com.wmt.framework.log.service.impl.LogAnalysisServiceImpl;
import com.wmt.framework.log.service.impl.LogCollectionServiceImpl;
import com.wmt.framework.log.service.impl.ElasticsearchLogStorageServiceImpl;
import com.wmt.framework.log.service.impl.LogVisualizationServiceImpl;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * WMT日志管理自动配置
 *
 * @author WMT
 */
@Configuration
@EnableConfigurationProperties(WmtLogProperties.class)
@ConditionalOnProperty(prefix = "wmt.log", name = "enabled", havingValue = "true", matchIfMissing = true)
@EnableAsync
@EnableScheduling
public class WmtLogAutoConfiguration {

    /**
     * 日志收集服务
     */
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "wmt.log.collection", name = "enabled", havingValue = "true", matchIfMissing = true)
    public LogCollectionService logCollectionService(WmtLogProperties properties, LogStorageService storageService) {
        return new LogCollectionServiceImpl(properties, storageService);
    }

    /**
     * Elasticsearch日志存储服务
     */
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "wmt.log.storage", name = "type", havingValue = "elasticsearch")
    public LogStorageService elasticsearchLogStorageService(WmtLogProperties properties) {
        return new ElasticsearchLogStorageServiceImpl(properties);
    }

    /**
     * 日志分析服务
     */
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "wmt.log.analysis", name = "enabled", havingValue = "true", matchIfMissing = true)
    public LogAnalysisService logAnalysisService(WmtLogProperties properties, LogStorageService storageService) {
        return new LogAnalysisServiceImpl(properties, storageService);
    }

    /**
     * 日志告警服务
     */
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "wmt.log.alerting", name = "enabled", havingValue = "true", matchIfMissing = true)
    public LogAlertingService logAlertingService(WmtLogProperties properties, LogStorageService storageService) {
        return new LogAlertingServiceImpl(properties, storageService);
    }

    /**
     * 日志可视化服务
     */
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "wmt.log.visualization", name = "enabled", havingValue = "true", matchIfMissing = true)
    public LogVisualizationService logVisualizationService(WmtLogProperties properties) {
        return new LogVisualizationServiceImpl(properties);
    }
}
