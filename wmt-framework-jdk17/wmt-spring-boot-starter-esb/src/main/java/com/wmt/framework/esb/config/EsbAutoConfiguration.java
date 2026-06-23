package com.wmt.framework.esb.config;

import com.wmt.framework.esb.core.EsbClient;
import com.wmt.framework.esb.core.EsbResponseHandler;
import com.wmt.framework.esb.core.EsbSequenceService;
import com.wmt.framework.esb.core.EsbTcpTransport;
import com.wmt.framework.esb.core.EsbXmlCodec;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

/**
 * 内蒙古银行 ESB 自动配置。
 *
 * <p>当业务系统引入 starter 且 {@code wmt.esb.enabled=true} 时，自动注册 {@link EsbClient}。</p>
 * <p>接入地址、系统 ID 等在业务工程 {@code application-*.yml} 中配置 {@code wmt.esb.*}。</p>
 */
@Slf4j
@AutoConfiguration
@ConditionalOnProperty(prefix = "wmt.esb", name = "enabled", havingValue = "true", matchIfMissing = true)
@EnableConfigurationProperties(EsbProperties.class)
public class EsbAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean
    public EsbSequenceService esbSequenceService(EsbProperties properties) {
        return new EsbSequenceService(properties);
    }

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
        log.info("[esb] 初始化 ESB 客户端，host={} port={} cnsmSysId={}",
                properties.getHost(), properties.getPort(), properties.getCnsmSysId());
        return new EsbClient(properties, esbTcpTransport, esbXmlCodec, esbSequenceService, esbResponseHandler);
    }

}
