package com.wmt.framework.logging.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "wmt.logging")
public class WmtLoggingProperties {

    /** 是否启用组件 */
    private boolean enabled = true;

    /** 输出目标：logstash | file */
    private String output = "file";

    /** Logstash 主机 */
    private String logstashHost = "127.0.0.1";

    /** Logstash 端口 */
    private int logstashPort = 5000;

    /** 文件输出路径（生产） */
    private String filePath = "/data/logs/${spring.application.name}/app.log";

    /** 是否自动将 logstash/file 追加到 spring.profiles.active */
    private boolean autoActivateProfile = false;
}


