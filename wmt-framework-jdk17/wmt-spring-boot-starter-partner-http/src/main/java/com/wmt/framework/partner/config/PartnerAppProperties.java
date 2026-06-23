package com.wmt.framework.partner.config;

import lombok.Data;

/**
 * 单个伙伴应用的 appId / appSecret 配置。
 */
@Data
public class PartnerAppProperties {

    /**
     * 伙伴应用 ID（HTTP Header appId）
     */
    private String appId;

    /**
     * 伙伴应用密钥（仅服务端保存，启动时写入 Redis 供验签使用）
     */
    private String appSecret;

    public boolean isConfigured() {
        return appId != null && !appId.isBlank() && appSecret != null && !appSecret.isBlank();
    }

}
