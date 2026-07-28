package com.wmt.framework.redis.config;

import org.redisson.config.Config;
import org.redisson.config.SingleServerConfig;
import org.redisson.spring.starter.RedissonAutoConfigurationCustomizer;
import org.redisson.spring.starter.RedissonAutoConfigurationV2;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

/**
 * 将 {@link WmtRedissonProperties} 应用到 Redisson SingleServer 连接行为。
 *
 * <p>不改变 {@code spring.data.redis} 地址/密码装配；仅在属性非空时覆盖 Redisson 默认。
 * 业务侧通过 {@code wmt.redis.redisson.*} 配置即可（如 VPN 本地联调收紧池/ping/重试）。</p>
 */
@AutoConfiguration(before = RedissonAutoConfigurationV2.class)
@EnableConfigurationProperties(WmtRedissonProperties.class)
public class WmtRedissonAutoConfiguration {

    @Bean
    public RedissonAutoConfigurationCustomizer wmtRedissonCustomizer(WmtRedissonProperties properties) {
        return (Config config) -> {
            if (!config.isSingleConfig()) {
                return;
            }
            applySingleServer(config.useSingleServer(), properties);
        };
    }

    private static void applySingleServer(SingleServerConfig server, WmtRedissonProperties properties) {
        if (properties.getConnectionMinimumIdleSize() != null) {
            server.setConnectionMinimumIdleSize(properties.getConnectionMinimumIdleSize());
        }
        if (properties.getConnectionPoolSize() != null) {
            server.setConnectionPoolSize(properties.getConnectionPoolSize());
        }
        if (properties.getIdleConnectionTimeout() != null) {
            server.setIdleConnectionTimeout(properties.getIdleConnectionTimeout());
        }
        if (properties.getPingConnectionInterval() != null) {
            server.setPingConnectionInterval(properties.getPingConnectionInterval());
        }
        if (properties.getRetryAttempts() != null) {
            server.setRetryAttempts(properties.getRetryAttempts());
        }
        if (properties.getRetryInterval() != null) {
            server.setRetryInterval(properties.getRetryInterval());
        }
        if (properties.getKeepAlive() != null) {
            server.setKeepAlive(properties.getKeepAlive());
        }
        if (properties.getTcpKeepAliveIdle() != null && properties.getTcpKeepAliveIdle() > 0) {
            server.setTcpKeepAliveIdle(properties.getTcpKeepAliveIdle());
        }
        if (properties.getTcpKeepAliveInterval() != null && properties.getTcpKeepAliveInterval() > 0) {
            server.setTcpKeepAliveInterval(properties.getTcpKeepAliveInterval());
        }
        if (properties.getTcpKeepAliveCount() != null && properties.getTcpKeepAliveCount() > 0) {
            server.setTcpKeepAliveCount(properties.getTcpKeepAliveCount());
        }
    }

}
