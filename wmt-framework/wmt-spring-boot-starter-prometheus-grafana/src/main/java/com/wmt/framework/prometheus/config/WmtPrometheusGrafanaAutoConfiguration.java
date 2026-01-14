package com.wmt.framework.prometheus.config;

import com.wmt.framework.prometheus.core.DomainMetricPublisher;
import com.wmt.framework.prometheus.core.PrometheusPushGatewayManager;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tag;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.actuate.autoconfigure.metrics.MeterRegistryCustomizer;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

/**
 * 自动注册 Prometheus + Grafana 相关 Bean。
 */
@Slf4j
@AutoConfiguration
@ConditionalOnClass(MeterRegistry.class)
@EnableConfigurationProperties(WmtPrometheusGrafanaProperties.class)
@ConditionalOnProperty(prefix = "wmt.prometheus", name = "enabled", havingValue = "true", matchIfMissing = true)
@ComponentScan(basePackageClasses = DomainMetricPublisher.class)
public class WmtPrometheusGrafanaAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean(name = "wmtPrometheusCommonTagsCustomizer")
    public MeterRegistryCustomizer<MeterRegistry> wmtPrometheusCommonTagsCustomizer(WmtPrometheusGrafanaProperties properties,
                                                                                   Environment environment) {
        return registry -> {
            WmtPrometheusGrafanaProperties.CommonTags tagsProperties = properties.getCommonTags();
            if (!tagsProperties.isEnabled()) {
                return;
            }

            List<Tag> tags = new ArrayList<>();
            String service = StringUtils.hasText(tagsProperties.getService())
                    ? tagsProperties.getService()
                    : environment.getProperty("spring.application.name", "wmt-app");
            tags.add(Tag.of("service", service));

            String env = StringUtils.hasText(tagsProperties.getEnvironment())
                    ? tagsProperties.getEnvironment()
                    : environment.getProperty("spring.profiles.active", "default");
            tags.add(Tag.of("env", env));

            tagsProperties.getExtra().forEach((k, v) -> {
                if (StringUtils.hasText(k) && StringUtils.hasText(v)) {
                    tags.add(Tag.of(k, v));
                }
            });

            registry.config().commonTags(tags);
        };
    }

    @Bean
    @ConditionalOnBean(PrometheusMeterRegistry.class)
    @ConditionalOnProperty(prefix = "wmt.prometheus.push-gateway", name = "enabled", havingValue = "true")
    public PrometheusPushGatewayManager wmtPrometheusPushGatewayManager(PrometheusMeterRegistry registry,
                                                                        WmtPrometheusGrafanaProperties properties,
                                                                        Environment environment) {
        WmtPrometheusGrafanaProperties.PushGateway pushGateway = properties.getPushGateway();
        if (!StringUtils.hasText(pushGateway.getGrouping().get("service"))) {
            pushGateway.getGrouping().putIfAbsent("service", environment.getProperty("spring.application.name", "wmt-app"));
        }
        return new PrometheusPushGatewayManager(registry, pushGateway);
    }

    @Bean
    @ConditionalOnProperty(prefix = "wmt.prometheus.dashboard", name = "export-path")
    public ApplicationRunner wmtPrometheusDashboardExporter(WmtPrometheusGrafanaProperties properties,
                                                            ResourcePatternResolver resolver) {
        return args -> exportResources("classpath*:/wmt/prometheus/dashboards/*.json",
                properties.getDashboard().getExportPath(),
                "Grafana Dashboard", resolver);
    }

    @Bean
    @ConditionalOnProperty(prefix = "wmt.prometheus.alerts", name = "export-path")
    public ApplicationRunner wmtPrometheusAlertRuleExporter(WmtPrometheusGrafanaProperties properties,
                                                            ResourcePatternResolver resolver) {
        return args -> exportResources("classpath*:/wmt/prometheus/alerts/*.yml",
                properties.getAlerts().getExportPath(),
                "Prometheus Alert Rules", resolver);
    }

    private void exportResources(String pattern, String exportPath, String label, ResourcePatternResolver resolver) throws IOException {
        if (!StringUtils.hasText(exportPath)) {
            return;
        }
        Resource[] resources = resolver.getResources(pattern);
        if (resources.length == 0) {
            log.warn("[WmtPrometheus] 未找到 {} 模板，pattern={}", label, pattern);
            return;
        }
        Path targetDir = Paths.get(exportPath).toAbsolutePath();
        Files.createDirectories(targetDir);
        for (Resource resource : resources) {
            if (!resource.exists() || resource.getFilename() == null) {
                continue;
            }
            Path target = targetDir.resolve(resource.getFilename());
            try (InputStream in = resource.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
        }
        log.info("[WmtPrometheus] {} 模板已导出至 {}", label, targetDir);
    }
}