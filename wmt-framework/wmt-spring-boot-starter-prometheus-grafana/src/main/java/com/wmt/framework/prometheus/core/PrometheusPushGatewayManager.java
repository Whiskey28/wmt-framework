package com.wmt.framework.prometheus.core;

import com.wmt.framework.prometheus.config.WmtPrometheusGrafanaProperties;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.prometheus.client.exporter.PushGateway;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.context.SmartLifecycle;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.Duration;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;

/**
 * 简单的 PushGateway 推送器：按固定频率将 Prometheus 指标推送到 PushGateway。
 */
@Slf4j
public class PrometheusPushGatewayManager implements SmartLifecycle, DisposableBean {

    private final PrometheusMeterRegistry registry;
    private final WmtPrometheusGrafanaProperties.PushGateway properties;
    private final ScheduledExecutorService scheduler;
    private final PushGateway pushGateway;
    private volatile ScheduledFuture<?> pushTask;
    private volatile boolean running;

    public PrometheusPushGatewayManager(PrometheusMeterRegistry registry,
                                        WmtPrometheusGrafanaProperties.PushGateway properties) {
        this.registry = registry;
        this.properties = properties;
        this.pushGateway = new PushGateway(properties.getBaseUrl());
        this.scheduler = Executors.newSingleThreadScheduledExecutor(new NamedThreadFactory("wmt-prometheus-push"));
    }

    @Override
    public void start() {
        if (this.running) {
            return;
        }
        Duration rate = properties.getPushRate();
        if (rate == null) {
            rate = Duration.ofSeconds(30);
        }
        long interval = Math.max(rate.toMillis(), 5000L);
        this.pushTask = scheduler.scheduleAtFixedRate(this::safePush, 0, interval, TimeUnit.MILLISECONDS);
        this.running = true;
        log.info("[WmtPrometheus] PushGateway 推送已开启 -> {}", properties.getBaseUrl());
    }

    @Override
    public void stop() {
        if (!this.running) {
            return;
        }
        if (this.pushTask != null) {
            this.pushTask.cancel(true);
        }
        if (properties.isDeleteOnShutdown()) {
            safeDelete();
        }
        this.running = false;
        log.info("[WmtPrometheus] PushGateway 推送已停止");
    }

    @Override
    public boolean isRunning() {
        return running;
    }

    @Override
    public void stop(Runnable callback) {
        this.stop();
        callback.run();
    }

    @Override
    public boolean isAutoStartup() {
        return true;
    }

    @Override
    public int getPhase() {
        return Integer.MAX_VALUE;
    }

    @Override
    public void destroy() {
        stop();
        scheduler.shutdownNow();
    }

    private void safePush() {
        try {
            Map<String, String> grouping = buildGroupingKey();
            pushGateway.pushAdd(registry.getPrometheusRegistry(), properties.getJob(), grouping);
        } catch (IOException ex) {
            log.warn("[WmtPrometheus] PushGateway 推送失败：{}", ex.getMessage());
        }
    }

    private void safeDelete() {
        try {
            pushGateway.delete(properties.getJob(), buildGroupingKey());
        } catch (IOException ex) {
            log.warn("[WmtPrometheus] PushGateway 删除失败：{}", ex.getMessage());
        }
    }

    private Map<String, String> buildGroupingKey() {
        if (properties.getGrouping().isEmpty()) {
            return Collections.singletonMap("instance", resolveHostname());
        }
        Map<String, String> grouping = new HashMap<>(properties.getGrouping());
        grouping.putIfAbsent("instance", resolveHostname());
        return grouping;
    }

    private String resolveHostname() {
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException ex) {
            return "unknown";
        }
    }

    private static final class NamedThreadFactory implements ThreadFactory {
        private final String prefix;

        private NamedThreadFactory(String prefix) {
            this.prefix = prefix;
        }

        @Override
        public Thread newThread(Runnable r) {
            Thread thread = new Thread(r);
            thread.setName(prefix);
            thread.setDaemon(true);
            return thread;
        }
    }
}

