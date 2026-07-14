package com.wmt.framework.crypto.config;

import com.union.api.UnionCSSP;
import com.wmt.framework.crypto.core.CryptoPlatformKeyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.util.StringUtils;

import java.nio.file.Files;
import java.nio.file.Path;

/**
 * 加密平台自动配置。
 *
 * <p>启用条件：{@code wmt.crypto-platform.enabled=true}。</p>
 */
@Slf4j
@AutoConfiguration
@ConditionalOnProperty(prefix = "wmt.crypto-platform", name = "enabled", havingValue = "true")
@EnableConfigurationProperties(CryptoPlatformProperties.class)
public class CryptoPlatformAutoConfiguration {

    /** SDK 配置文件 JVM 属性（优先于 classpath 内置） */
    public static final String CONFIG_FILE_SYSTEM_PROPERTY = "cn.keyou.platform.api3.config.file";

    @Bean
    @ConditionalOnMissingBean
    public UnionCSSP unionCssp(CryptoPlatformProperties properties) {
        applyConfigFile(properties);
        log.info("[crypto-platform] 初始化 UnionCSSP，configFile={}", properties.getConfigFile());
        return new UnionCSSP();
    }

    @Bean
    @ConditionalOnMissingBean
    public CryptoPlatformKeyService cryptoPlatformKeyService(UnionCSSP unionCssp) {
        return new CryptoPlatformKeyService(unionCssp);
    }

    private void applyConfigFile(CryptoPlatformProperties properties) {
        String configFile = properties.getConfigFile();
        if (!StringUtils.hasText(configFile)) {
            if (properties.isFailOnConfigError()) {
                throw new IllegalStateException(
                        "未配置 wmt.crypto-platform.config-file（serverList.conf 路径）");
            }
            log.warn("[crypto-platform] config-file 未配置，将尝试 SDK 默认加载路径");
            return;
        }
        Path path = Path.of(configFile);
        if (!Files.isRegularFile(path)) {
            String msg = "加密平台配置文件不存在或不可读: " + path.toAbsolutePath();
            if (properties.isFailOnConfigError()) {
                throw new IllegalStateException(msg);
            }
            log.warn("[crypto-platform] {}", msg);
            return;
        }
        String absolute = path.toAbsolutePath().normalize().toString();
        System.setProperty(CONFIG_FILE_SYSTEM_PROPERTY, absolute);
        log.info("[crypto-platform] 已设置 {}={}", CONFIG_FILE_SYSTEM_PROPERTY, absolute);
    }

}
