package com.wmt.framework.esb.config;

import com.wmt.framework.esb.core.EsbClient;
import com.wmt.framework.esb.core.EsbResponseHandler;
import com.wmt.framework.esb.core.EsbSequenceService;
import com.wmt.framework.esb.core.EsbTcpTransport;
import com.wmt.framework.esb.core.EsbXmlCodec;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;

/**
 * 内蒙古银行 ESB 自动配置。
 *
 * <p>当业务系统引入 starter 且 {@code wmt.esb.enabled=true} 时，自动注册 {@link EsbClient}。</p>
 * <p>接入地址、系统 ID 等在业务工程 {@code application-*.yml} 中配置 {@code wmt.esb.*}。</p>
 * <p>存在 {@link StringRedisTemplate} 时流水号走 Redis INCR；否则回退内存计数。
 * 本配置在 {@link RedisAutoConfiguration} 之后加载，避免启动顺序竞态导致内存回退抢先注册。</p>
 */
@Slf4j
@AutoConfiguration(after = RedisAutoConfiguration.class)
@ConditionalOnProperty(prefix = "wmt.esb", name = "enabled", havingValue = "true", matchIfMissing = true)
@EnableConfigurationProperties(EsbProperties.class)
public class EsbAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean
    public EsbTcpTransport esbTcpTransport(EsbProperties properties) {
        return new EsbTcpTransport(properties);
    }

    @Bean
    @ConditionalOnMissingBean
    public EsbXmlCodec esbXmlCodec() {
        return new EsbXmlCodec();
    }

    @Bean
    @ConditionalOnMissingBean
    public EsbResponseHandler esbResponseHandler() {
        return new EsbResponseHandler();
    }

    @Bean
    @ConditionalOnMissingBean
    public EsbClient esbClient(EsbProperties properties,
                               EsbTcpTransport esbTcpTransport,
                               EsbXmlCodec esbXmlCodec,
                               EsbSequenceService esbSequenceService,
                               EsbResponseHandler esbResponseHandler) {
        log.info("[esb] 初始化 ESB 客户端，host={} port={} cnsmSysId={} cnsmSysSvrId={}",
                properties.getHost(), properties.getPort(), properties.getCnsmSysId(),
                properties.resolveCnsmSysSvrId());
        return new EsbClient(properties, esbTcpTransport, esbXmlCodec, esbSequenceService, esbResponseHandler);
    }

    /**
     * 有 Redis 时注册持久化流水号（优先于内存实现）。
     */
    @Configuration(proxyBeanMethods = false)
    @ConditionalOnClass(StringRedisTemplate.class)
    @ConditionalOnBean(StringRedisTemplate.class)
    static class RedisSequenceConfiguration {

        @Bean
        @ConditionalOnMissingBean(EsbSequenceService.class)
        public EsbSequenceService esbSequenceService(EsbProperties properties,
                                                     StringRedisTemplate stringRedisTemplate) {
            log.info("[esb] 流水号使用 Redis INCR，cnsmSysId={}", properties.getCnsmSysId());
            return new EsbSequenceService(properties, stringRedisTemplate);
        }
    }

    /**
     * 无 Redis Bean 时的内存回退（单测 / 未引入 redis starter）。
     *
     * <p>必须同时缺少 {@link StringRedisTemplate}，否则在 Redis 自动配置尚未就绪时
     * 会抢先注册内存实现，导致有 Redis 环境仍走进程内计数。</p>
     */
    @Configuration(proxyBeanMethods = false)
    @ConditionalOnMissingBean(StringRedisTemplate.class)
    static class MemorySequenceConfiguration {

        @Bean
        @ConditionalOnMissingBean(EsbSequenceService.class)
        public EsbSequenceService esbSequenceService(EsbProperties properties) {
            return new EsbSequenceService(properties);
        }
    }

}
