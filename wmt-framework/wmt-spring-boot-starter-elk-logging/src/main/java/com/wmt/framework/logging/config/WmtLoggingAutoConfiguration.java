package com.wmt.framework.logging.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.context.event.ApplicationEnvironmentPreparedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.core.env.ConfigurableEnvironment;

@Slf4j
@AutoConfiguration
@EnableConfigurationProperties(WmtLoggingProperties.class)
@Import(com.wmt.framework.logging.web.TraceMdcFilter.class)
public class WmtLoggingAutoConfiguration {

    // 早期系统属性与 profile 追加已经迁移到 WmtLoggingEnvironmentPostProcessor，
    // 这里保留自动配置以便后续扩展（如注册额外 Bean）。
}


