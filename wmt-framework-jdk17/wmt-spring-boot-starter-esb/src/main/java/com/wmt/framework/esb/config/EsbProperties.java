package com.wmt.framework.esb.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.io.Serializable;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

/**
 * 内蒙古银行 ESB 接入配置。
 *
 * <p>在业务系统 {@code application-*.yml} 中使用前缀 {@code wmt.esb}，例如：</p>
 * <pre>
 * wmt:
 *   esb:
 *     enabled: true
 *     host: 172.16.x.x
 *     port: 10001
 *     cnsm-sys-id: DMPF001
 *     src-sys-id: DMPF001
 * </pre>
 */
@Data
@ConfigurationProperties(prefix = "wmt.esb")
public class EsbProperties implements Serializable {

    /**
     * 是否启用 ESB 客户端自动配置
     */
    private boolean enabled = true;

    /**
     * ESB 接入主机
     */
    private String host;

    /**
     * ESB 标准接入端口（行方规划 10001~10099）
     */
    private Integer port;

    /**
     * 调用方系统 ID，7 位，对应 SysHead.CnsmSysId
     */
    private String cnsmSysId;

    /**
     * 源发起系统 ID，7 位，对应 SysHead.SrcSysId；缺省时与 {@link #cnsmSysId} 相同
     */
    private String srcSysId;

    /**
     * 渠道类型，对应 SysHead.ChnlTp
     */
    private String chnlTp;

    /**
     * 文件标志，默认 0-无文件
     */
    private String fileFlg = "0";

    /**
     * TCP 连接超时（毫秒）
     */
    private int connectTimeoutMs = 5_000;

    /**
     * 读超时（毫秒），行方建议接入侧 C1 约 65 秒
     */
    private int readTimeoutMs = 65_000;

    /**
     * 报文长度头字节数；行内标准 8 位，联盟通道为 7 位
     */
    private int lengthHeaderSize = 8;

    /**
     * 报文编码
     */
    private Charset charset = StandardCharsets.UTF_8;

    /**
     * 最大报文体字节数，行方限制 100KB
     */
    private int maxBodyBytes = 100 * 1024;

    public String resolveSrcSysId() {
        return srcSysId != null && !srcSysId.isBlank() ? srcSysId : cnsmSysId;
    }

}
