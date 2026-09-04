package com.wmt.framework.esb.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.util.StringUtils;

import java.io.Serializable;
import java.net.InetAddress;
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
 *     cnsm-sys-svr-id: 1721600100   # SysHead.CnsmSysSvrId；行方给定优先
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
     * 调用方服务器标识，对应 SysHead.CnsmSysSvrId（行方必填）；缺省回退本机 IP 去点
     */
    private String cnsmSysSvrId;

    /**
     * 源发起服务器标识，对应 SysHead.SrcSysSvrId；缺省时与 {@link #cnsmSysSvrId} 解析结果相同
     */
    private String srcSysSvrId;

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

    /**
     * 联盟路由相关配置（MAC：Body.KeyInd 由消费方上送，SysHead.Mac 由行内 ESB 生成）。
     */
    private final Alliance alliance = new Alliance();

    /**
     * ESB 提供方（入站 TCP XML）。默认关闭监听，联调前显式打开。
     *
     * <pre>
     * wmt:
     *   esb:
     *     provider:
     *       enabled: true
     *       port: 10002
     * </pre>
     */
    private final Provider provider = new Provider();

    public String resolveSrcSysId() {
        return srcSysId != null && !srcSysId.isBlank() ? srcSysId : cnsmSysId;
    }

    /**
     * 解析 CnsmSysSvrId：配置优先，否则本机 IP 去点（如 172.16.0.100 → 1721600100）。
     */
    public String resolveCnsmSysSvrId() {
        if (StringUtils.hasText(cnsmSysSvrId)) {
            return cnsmSysSvrId.trim();
        }
        return fallbackLocalServerId();
    }

    /**
     * 解析 SrcSysSvrId：配置优先，否则与 {@link #resolveCnsmSysSvrId()} 相同。
     */
    public String resolveSrcSysSvrId() {
        if (StringUtils.hasText(srcSysSvrId)) {
            return srcSysSvrId.trim();
        }
        return resolveCnsmSysSvrId();
    }

    static String fallbackLocalServerId() {
        try {
            String hostAddress = InetAddress.getLocalHost().getHostAddress();
            if (StringUtils.hasText(hostAddress)) {
                return hostAddress.replace(".", "").replace(":", "");
            }
        } catch (Exception ignored) {
            // fall through
        }
        return "127001";
    }

    /**
     * 联盟路由相关配置。
     *
     * <pre>
     * wmt:
     *   esb:
     *     alliance:
     *       key-ind: DMPF.861BY861XXXX.zak
     *       branch-id: "4190001"   # AppHead.BranchId；联盟核心报文头必输
     * </pre>
     *
     * <p>联盟渠道号 {@code 09}、系统编号 {@code 8610716} 由 {@code EsbClient} 封装常量覆盖，
     * 不在此重复配置，以免与行内 {@code chnl-tp}/{@code cnsm-sys-id} 双源。</p>
     */
    @Data
    public static class Alliance implements Serializable {

        /**
         * 联盟密钥标识，上送到请求 Body 的 {@code KeyInd}。
         * 格式通常为：{@code {系统简称}.861BY861XXXX.zak}
         */
        private String keyInd;

        /**
         * 联盟出站 AppHead.BranchId（机构代号，长度 ≥ 3）。
         */
        private String branchId;

    }

    /**
     * ESB 提供方入站监听配置（前缀 {@code wmt.esb.provider}）。
     */
    @Data
    public static class Provider implements Serializable {

        /**
         * 是否启动 TCP 监听。默认 false，避免本地无意占端口。
         */
        private boolean enabled = false;

        /** 监听端口（ESB → 本系统） */
        private int port = 10002;

        /** 工作线程数 */
        private int workerThreads = 16;

        /** 单连接读超时（毫秒），建议 ≤ P1≈60s */
        private int soTimeoutMs = 60_000;

        /** ServerSocket backlog */
        private int backlog = 128;

    }

}
