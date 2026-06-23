package com.wmt.framework.partner.config;

import com.wmt.framework.signature.core.redis.ApiSignatureRedisDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;

/**
 * 将 {@code wmt.partner.apps} 中的 appId/appSecret 预加载到 Redis，供 {@code @ApiSignature} 验签使用。
 */
@Slf4j
@RequiredArgsConstructor
public class PartnerAppSecretInitializer {

    private final PartnerHttpProperties properties;

    private final ApiSignatureRedisDAO apiSignatureRedisDAO;

    @EventListener(ApplicationReadyEvent.class)
    public void loadAppSecrets() {
        properties.getApps().forEach((partnerCode, app) -> {
            if (!app.isConfigured()) {
                log.warn("[partner] 跳过未配置完整的伙伴凭证 partnerCode={}", partnerCode);
                return;
            }
            apiSignatureRedisDAO.setAppSecret(app.getAppId(), app.getAppSecret());
            log.info("[partner] 已加载伙伴验签凭证 partnerCode={} appId={}", partnerCode, app.getAppId());
        });
    }

}
