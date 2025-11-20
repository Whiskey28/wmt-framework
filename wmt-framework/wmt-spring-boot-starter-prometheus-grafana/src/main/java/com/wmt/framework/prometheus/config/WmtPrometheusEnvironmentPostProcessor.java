package com.wmt.framework.prometheus.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.Properties;
import java.util.Set;

/**
 * 在 SpringBoot 早期阶段补充 Prometheus 相关默认配置，确保无需繁琐的手工设置即可导出指标。
 */
@Slf4j
public class WmtPrometheusEnvironmentPostProcessor implements EnvironmentPostProcessor, Ordered {

    private static final String PROPERTY_SOURCE = "wmtPrometheusDefaults";

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        boolean enabled = environment.getProperty("wmt.prometheus.enabled", Boolean.class, true);
        if (!enabled) {
            return;
        }

        Properties properties = new Properties();
        if (!environment.containsProperty("management.metrics.export.prometheus.enabled")) {
            properties.put("management.metrics.export.prometheus.enabled", "true");
        }
        if (!environment.containsProperty("management.endpoint.prometheus.enabled")) {
            properties.put("management.endpoint.prometheus.enabled", "true");
        }
        mergePrometheusEndpointExposure(environment, properties);

        if (!properties.isEmpty()) {
            MutablePropertySources propertySources = environment.getPropertySources();
            PropertiesPropertySource source = new PropertiesPropertySource(PROPERTY_SOURCE, properties);
            propertySources.addFirst(source);
            log.debug("[WmtPrometheus] 已追加默认配置：{}", properties);
        }
    }

    private void mergePrometheusEndpointExposure(ConfigurableEnvironment environment, Properties properties) {
        String includes = environment.getProperty("management.endpoints.web.exposure.include");
        Set<String> values = new LinkedHashSet<>();
        if (StringUtils.hasText(includes)) {
            values.addAll(Arrays.asList(includes.split(",")));
        } else {
            values.addAll(Arrays.asList("health", "info"));
        }
        values.add("prometheus");
        properties.put("management.endpoints.web.exposure.include", String.join(",", values));
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE + 20;
    }
}

