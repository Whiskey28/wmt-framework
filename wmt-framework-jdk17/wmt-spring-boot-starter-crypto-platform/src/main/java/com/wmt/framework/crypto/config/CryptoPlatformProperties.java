package com.wmt.framework.crypto.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.io.Serializable;

/**
 * 内蒙古银行加密平台（Union CSSP）接入配置。
 *
 * <pre>
 * wmt:
 *   crypto-platform:
 *     enabled: true
 *     config-file: /opt/dmpf/crypto/serverList.conf
 *     fail-on-config-error: true
 * </pre>
 */
@Data
@ConfigurationProperties(prefix = "wmt.crypto-platform")
public class CryptoPlatformProperties implements Serializable {

    /**
     * 是否启用加密平台客户端；默认 false，避免未配置环境误连 CSSP。
     */
    private boolean enabled = false;

    /**
     * serverList.conf 绝对路径或相对工作目录路径。
     * <p>会写入 JVM 属性 {@code cn.keyou.platform.api3.config.file}
     * （SDK 优先读该属性，其次环境变量 {@code UNION_API_CONFIG_FILE}）。</p>
     */
    private String configFile;

    /**
     * 配置文件缺失或不可读时是否阻止启动。
     */
    private boolean failOnConfigError = true;

}
