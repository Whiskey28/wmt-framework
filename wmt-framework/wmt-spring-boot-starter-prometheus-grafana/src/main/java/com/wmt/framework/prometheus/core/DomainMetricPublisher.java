package com.wmt.framework.prometheus.core;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tag;
import io.micrometer.core.instrument.Tags;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Arrays;
import java.util.concurrent.TimeUnit;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;

/**
 * 业务指标发布器：提供静态方法，让业务系统无需直接依赖 MeterRegistry 即可发布指标。
 * <p>
 * 使用示例：
 * <pre>
 * // 计数
 * DomainMetricPublisher.counter("order.create.total", Tag.of("channel", "APP"));
 * 
 * // 计时
 * Timer.Sample sample = DomainMetricPublisher.startTimer("order.process.duration");
 * try {
 *     // 业务逻辑
 * } finally {
 *     sample.stop(Timer.builder("order.process.duration").register(/* MeterRegistry 会自动注入 *\/));
 * }
 * 
 * // 状态值
 * DomainMetricPublisher.gauge("inventory.count", () -> getInventoryCount(), Tag.of("product", "P001"));
 * </pre>
 *
 * @author wmt-framework
 */
@Slf4j
@Component
public class DomainMetricPublisher {

    private static MeterRegistry staticRegistry;

    @Autowired
    private MeterRegistry meterRegistry;

    @PostConstruct
    public void init() {
        staticRegistry = meterRegistry;
        log.info("[WmtPrometheus] DomainMetricPublisher 已初始化");
    }

    /**
     * 发布计数器指标（自动 +1）
     *
     * @param name 指标名称（建议格式：biz.module.action.total）
     * @param tags 标签数组
     */
    public static void counter(String name, Tag... tags) {
        if (staticRegistry == null) {
            log.warn("[WmtPrometheus] MeterRegistry 未初始化，跳过指标记录: {}", name);
            return;
        }
        try {
            Counter.builder(name)
                    .description("业务指标: " + name)
                    .tags(Tags.of(Arrays.asList(tags)))
                    .register(staticRegistry)
                    .increment();
        } catch (Exception ex) {
            log.warn("[WmtPrometheus] 记录计数器指标失败: {} - {}", name, ex.getMessage());
        }
    }

    /**
     * 发布计数器指标（指定增量）
     *
     * @param name  指标名称
     * @param value 增量值
     * @param tags  标签数组
     */
    public static void counter(String name, double value, Tag... tags) {
        if (staticRegistry == null) {
            log.warn("[WmtPrometheus] MeterRegistry 未初始化，跳过指标记录: {}", name);
            return;
        }
        try {
            Counter.builder(name)
                    .description("业务指标: " + name)
                    .tags(Tags.of(Arrays.asList(tags)))
                    .register(staticRegistry)
                    .increment(value);
        } catch (Exception ex) {
            log.warn("[WmtPrometheus] 记录计数器指标失败: {} - {}", name, ex.getMessage());
        }
    }

    /**
     * 开始计时器（返回 Sample，需在 finally 中调用 stop）
     * <p>
     * 注意：如果 MeterRegistry 未初始化，将返回 null，调用方需要检查 null 以避免 NPE。
     *
     * @param name 指标名称（建议格式：biz.module.action.duration）
     * @return Timer.Sample 实例，如果 MeterRegistry 未初始化则返回 null
     */
    public static Timer.Sample startTimer(String name) {
        if (staticRegistry == null) {
            log.warn("[WmtPrometheus] MeterRegistry 未初始化，跳过计时器: {}", name);
            return null;
        }
        return Timer.start(staticRegistry);
    }

    /**
     * 记录耗时（直接记录，无需手动管理 Sample）
     *
     * @param name     指标名称
     * @param duration 耗时（毫秒）
     * @param tags     标签数组
     */
    public static void recordTimer(String name, long duration, Tag... tags) {
        if (staticRegistry == null) {
            log.warn("[WmtPrometheus] MeterRegistry 未初始化，跳过指标记录: {}", name);
            return;
        }
        try {
            Timer.builder(name)
                    .description("业务耗时指标: " + name)
                    .tags(Tags.of(Arrays.asList(tags)))
                    .register(staticRegistry)
                    .record(duration, TimeUnit.MILLISECONDS);
        } catch (Exception ex) {
            log.warn("[WmtPrometheus] 记录计时器指标失败: {} - {}", name, ex.getMessage());
        }
    }

    /**
     * 发布状态值指标（Gauge）
     *
     * @param name     指标名称
     * @param supplier 获取当前值的函数
     * @param tags     标签数组
     */
    public static void gauge(String name, Supplier<Number> supplier, Tag... tags) {
        if (staticRegistry == null) {
            log.warn("[WmtPrometheus] MeterRegistry 未初始化，跳过指标记录: {}", name);
            return;
        }
        try {
            Gauge.builder(name, supplier, s -> {
                Number value = supplier.get();
                return value != null ? value.doubleValue() : 0.0;
            })
                    .description("业务状态指标: " + name)
                    .tags(Tags.of(Arrays.asList(tags)))
                    .register(staticRegistry);
        } catch (Exception ex) {
            log.warn("[WmtPrometheus] 记录状态值指标失败: {} - {}", name, ex.getMessage());
        }
    }

    /**
     * 发布状态值指标（Gauge）- 使用对象引用
     *
     * @param name      指标名称
     * @param obj       对象引用
     * @param valueFunc 从对象获取值的函数（返回 double）
     * @param tags      标签数组
     * @param <T>       对象类型
     */
    public static <T> void gauge(String name, T obj, ToDoubleFunction<T> valueFunc, Tag... tags) {
        if (staticRegistry == null) {
            log.warn("[WmtPrometheus] MeterRegistry 未初始化，跳过指标记录: {}", name);
            return;
        }
        try {
            Gauge.builder(name, obj, valueFunc)
                    .description("业务状态指标: " + name)
                    .tags(Tags.of(Arrays.asList(tags)))
                    .register(staticRegistry);
        } catch (Exception ex) {
            log.warn("[WmtPrometheus] 记录状态值指标失败: {} - {}", name, ex.getMessage());
        }
    }

}
