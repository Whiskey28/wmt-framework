package com.wmt.framework.esb.core;

import com.wmt.framework.esb.core.model.EsbSysHead;

/**
 * ESB 提供方交易处理器（业务系统实现并注册为 Spring Bean）。
 *
 * <p>框架负责 TCP 帧、XML Envelope、SysHead 回填与按 {@link #svcCd()}/{@link #svcScn()} 路由；
 * 实现类只处理 Body。业务失败时仍返回 Body（含 BsnRetCd），框架头保持 {@code TranRetSt=S}。</p>
 *
 * @param <REQ>  Body 请求类型
 * @param <RESP> Body 响应类型
 */
public interface EsbProviderHandler<REQ, RESP> {

    /**
     * 服务代码 SvcCd。空白则框架跳过注册（联调前由业务 yaml 填写）。
     */
    String svcCd();

    /**
     * 服务场景 SvcScn，默认 {@code 01}。
     */
    default String svcScn() {
        return EsbProviderConstants.DEFAULT_SVC_SCN;
    }

    Class<REQ> requestType();

    /**
     * 处理业务并返回响应 Body；框架头由 {@link EsbProviderResponseFactory} 统一回填。
     */
    RESP handle(EsbSysHead requestSysHead, REQ request);

}
