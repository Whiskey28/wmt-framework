package com.wmt.framework.partner.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 伙伴 HTTP 集成配置。
 *
 * <pre>
 * wmt:
 *   partner:
 *     enabled: true
 *     apps:
 *       modelfactory:
 *         app-id: modelfactory-dev
 *         app-secret: change-me
 * </pre>
 */
@Data
@ConfigurationProperties(prefix = "wmt.partner")
public class PartnerHttpProperties {

    private boolean enabled = true;

    /**
     * 伙伴编码 → 凭证（启动时写入 Redis Hash api_signature_app）
     */
    private Map<String, PartnerAppProperties> apps = new LinkedHashMap<>();

}
