package com.wmt.framework.partner.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wmt.framework.partner.core.PartnerHttpClient;
import com.wmt.framework.signature.core.redis.ApiSignatureRedisDAO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

/**
 * 伙伴 HTTP 自动配置。
 */
@Slf4j
@AutoConfiguration
@ConditionalOnProperty(prefix = "wmt.partner", name = "enabled", havingValue = "true", matchIfMissing = true)
@EnableConfigurationProperties(PartnerHttpProperties.class)
public class PartnerHttpAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean
    public PartnerAppSecretInitializer partnerAppSecretInitializer(PartnerHttpProperties properties,
                                                                   ApiSignatureRedisDAO apiSignatureRedisDAO) {
        return new PartnerAppSecretInitializer(properties, apiSignatureRedisDAO);
    }

    @Bean
    @ConditionalOnMissingBean
    public PartnerHttpClient partnerHttpClient(RestTemplate restTemplate, ObjectMapper objectMapper) {
        return new PartnerHttpClient(restTemplate, objectMapper);
    }

}
