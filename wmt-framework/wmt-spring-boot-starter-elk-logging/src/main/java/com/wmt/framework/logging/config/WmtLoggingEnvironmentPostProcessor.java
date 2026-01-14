package com.wmt.framework.logging.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;

/**
 * 提前（在日志系统初始化前）根据 wmt.logging 配置设置 System properties，
 * 并按需追加 file/logstash Profile，确保 logback-spring.xml 的占位符可用。
 */
@Slf4j
public class WmtLoggingEnvironmentPostProcessor implements EnvironmentPostProcessor, Ordered {

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        String output = environment.getProperty("wmt.logging.output", "file");
        String logstashHost = environment.getProperty("wmt.logging.logstash-host", "127.0.0.1");
        String logstashPort = environment.getProperty("wmt.logging.logstash-port", "5000");
        String filePath = environment.getProperty("wmt.logging.file-path", "/data/logs/${spring.application.name}/app.log");
        boolean enabled = environment.getProperty("wmt.logging.enabled", Boolean.class, true);
        boolean autoActivateProfile = environment.getProperty("wmt.logging.auto-activate-profile", Boolean.class, false);

        if (!enabled) {
            return;
        }

        // 提前设置占位符给 logback 使用
        System.setProperty("wmt.logging.output", output);
        System.setProperty("wmt.logging.logstash-host", logstashHost);
        System.setProperty("wmt.logging.logstash-port", logstashPort);
        System.setProperty("wmt.logging.file-path", filePath);

        if (autoActivateProfile) {
            String profile = "logstash".equalsIgnoreCase(output) ? "logstash" : "file";
            boolean alreadyActive = false;
            for (String ap : environment.getActiveProfiles()) {
                if (ap.equalsIgnoreCase(profile)) {
                    alreadyActive = true;
                    break;
                }
            }
            if (!alreadyActive) {
                environment.addActiveProfile(profile);
                log.info("[WmtLogging] activate profile: {} (output={})", profile, output);
            }
        }
    }

    // 确保尽早执行（比大部分自定义处理器更早）；数值越小优先级越高
    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE + 10;
    }
}


