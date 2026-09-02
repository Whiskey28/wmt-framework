package com.wmt.framework.esb.config;

import com.wmt.framework.esb.core.EsbProviderHandler;
import com.wmt.framework.esb.core.EsbProviderResponseFactory;
import com.wmt.framework.esb.core.EsbProviderRouter;
import com.wmt.framework.esb.core.EsbProviderTcpServer;
import com.wmt.framework.esb.core.EsbSequenceService;
import com.wmt.framework.esb.core.EsbXmlCodec;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;

import java.util.ArrayList;
import java.util.List;

/**
 * ESB 提供方（入站）自动配置。
 *
 * <p>Router / ResponseFactory 在 {@code wmt.esb.enabled=true} 时注册；
 * TCP Server 仅在 {@code wmt.esb.provider.enabled=true} 时启动。</p>
 */
@Slf4j
@AutoConfiguration(after = EsbAutoConfiguration.class)
@ConditionalOnProperty(prefix = "wmt.esb", name = "enabled", havingValue = "true", matchIfMissing = true)
public class EsbProviderAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean
    public EsbProviderResponseFactory esbProviderResponseFactory(EsbProperties esbProperties,
                                                                 EsbSequenceService sequenceService) {
        return new EsbProviderResponseFactory(esbProperties, sequenceService);
    }

    @Bean
    @ConditionalOnMissingBean
    public EsbProviderRouter esbProviderRouter(EsbXmlCodec xmlCodec,
                                               EsbProviderResponseFactory responseFactory,
                                               EsbProperties esbProperties,
                                               ObjectProvider<EsbProviderHandler<?, ?>> handlers) {
        List<EsbProviderHandler<?, ?>> handlerList = new ArrayList<>();
        handlers.orderedStream().forEach(handlerList::add);
        return new EsbProviderRouter(xmlCodec, responseFactory, esbProperties.getCnsmSysId(), handlerList);
    }

    @Bean(destroyMethod = "stop")
    @ConditionalOnProperty(prefix = "wmt.esb.provider", name = "enabled", havingValue = "true")
    @ConditionalOnMissingBean
    public EsbProviderTcpServer esbProviderTcpServer(EsbProperties esbProperties,
                                                     EsbProviderRouter router) throws Exception {
        EsbProviderTcpServer server = new EsbProviderTcpServer(esbProperties, router);
        server.start();
        log.info("[esb-provider] 已启用入站监听 port={} routes={}",
                esbProperties.getProvider().getPort(), router.registeredRouteCount());
        return server;
    }

}
