package com.wmt.framework.web.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Auto-bind TongWeb local license when license.dat exists in classpath root.
 */
public class TongWebLicenseEnvironmentPostProcessor implements EnvironmentPostProcessor, Ordered {

    private static final String SOURCE_NAME = "wmtTongWebLicenseDefaults";
    private static final String TONGWEB_MARKER_CLASS = "com.t.springboot.starter.TongWebServer";

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        if (!isTongWebOnClasspath()) {
            return;
        }
        if (!hasClasspathLicenseDat()) {
            return;
        }
        Map<String, Object> defaults = new LinkedHashMap<>();
        if (isBlank(environment.getProperty("server.tongweb.license.type"))) {
            defaults.put("server.tongweb.license.type", "file");
        }
        if (isBlank(environment.getProperty("server.tongweb.license.path"))) {
            defaults.put("server.tongweb.license.path", "classpath:license.dat");
        }
        if (!defaults.isEmpty()) {
            environment.getPropertySources().addLast(new MapPropertySource(SOURCE_NAME, defaults));
        }
    }

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;
    }

    private boolean isTongWebOnClasspath() {
        try {
            Class.forName(TONGWEB_MARKER_CLASS);
            return true;
        } catch (ClassNotFoundException ignored) {
            return false;
        }
    }

    private boolean hasClasspathLicenseDat() {
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        return classLoader != null && classLoader.getResource("license.dat") != null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
