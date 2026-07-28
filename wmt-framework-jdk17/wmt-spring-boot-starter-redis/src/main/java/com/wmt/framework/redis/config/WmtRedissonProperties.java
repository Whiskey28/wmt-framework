package com.wmt.framework.redis.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

/**
 * Redisson 连接行为配置（地址/密码仍走 {@code spring.data.redis.*}）。
 *
 * <p>字段为 null 时不覆盖 Redisson 默认值；不稳定网络（如 VPN）环境可在业务 yaml 收紧池、ping、重试。</p>
 */
@ConfigurationProperties(prefix = "wmt.redis.redisson")
@Data
@Validated
public class WmtRedissonProperties {

    /**
     * 连接池最小空闲连接数（SingleServer 默认 24）
     */
    private Integer connectionMinimumIdleSize;

    /**
     * 连接池大小（SingleServer 默认 64）
     */
    private Integer connectionPoolSize;

    /**
     * 空闲连接超时（毫秒，默认 10000）
     */
    private Integer idleConnectionTimeout;

    /**
     * PING 探活间隔（毫秒，默认 30000）；VPN/NAT 半开连接建议缩短
     */
    private Integer pingConnectionInterval;

    /**
     * 命令发送失败重试次数（默认 4）；坏连接上过大易触发请求风暴
     */
    private Integer retryAttempts;

    /**
     * 重试间隔（毫秒，默认 1500）
     */
    private Integer retryInterval;

    /**
     * 是否启用 TCP keepalive
     */
    private Boolean keepAlive;

    /**
     * TCP keepalive idle（秒，依赖 OS；0 表示不设置）
     */
    private Integer tcpKeepAliveIdle;

    /**
     * TCP keepalive interval（秒；0 表示不设置）
     */
    private Integer tcpKeepAliveInterval;

    /**
     * TCP keepalive probe 次数（0 表示不设置）
     */
    private Integer tcpKeepAliveCount;

}
