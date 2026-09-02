package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import com.wmt.framework.esb.core.model.EsbAppHead;
import com.wmt.framework.esb.core.model.EsbEnvelope;
import com.wmt.framework.esb.core.model.EsbRetMsgArray;
import com.wmt.framework.esb.core.model.EsbSysHead;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;

import java.net.InetAddress;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 组装 ESB 提供方响应 Envelope。
 *
 * <p>业务失败仍使用 {@code TranRetSt=S} + 成功框架 RetCd，由 Body.BsnRetCd 表达业务结果；
 * 仅系统级失败（未注册服务、编解码异常等）使用 {@code TranRetSt=F}。</p>
 */
@RequiredArgsConstructor
public class EsbProviderResponseFactory {

    private static final DateTimeFormatter TRAN_DATE = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final DateTimeFormatter TRAN_TIME = DateTimeFormatter.ofPattern("HHmmss");

    private final EsbProperties esbProperties;
    private final EsbSequenceService sequenceService;

    public <T> EsbEnvelope<T> success(EsbSysHead requestHead, EsbAppHead requestAppHead, T body) {
        EsbEnvelope<T> envelope = new EsbEnvelope<>();
        envelope.setSysHead(buildSysHead(requestHead, EsbProviderConstants.TRAN_RET_SUCCESS,
                EsbProviderConstants.RET_CD_SUCCESS, "交易成功"));
        envelope.setAppHead(echoAppHead(requestAppHead));
        envelope.setBody(body);
        return envelope;
    }

    public EsbEnvelope<Object> systemFailure(EsbSysHead requestHead, EsbAppHead requestAppHead,
                                             String retCd, String retMsg) {
        EsbEnvelope<Object> envelope = new EsbEnvelope<>();
        envelope.setSysHead(buildSysHead(requestHead, EsbProviderConstants.TRAN_RET_FAILURE,
                retCd, retMsg));
        envelope.setAppHead(echoAppHead(requestAppHead));
        envelope.setBody(null);
        return envelope;
    }

    private EsbSysHead buildSysHead(EsbSysHead requestHead, String tranRetSt, String retCd, String retMsg) {
        LocalDateTime now = LocalDateTime.now();
        EsbSysHead head = new EsbSysHead();
        if (requestHead != null) {
            head.setSvcCd(requestHead.getSvcCd());
            head.setSvcScn(requestHead.getSvcScn());
            head.setCnsmSysId(requestHead.getCnsmSysId());
            head.setChnlTp(requestHead.getChnlTp());
            head.setSrcSysId(requestHead.getSrcSysId());
            head.setCnsmSysSeqNo(requestHead.getCnsmSysSeqNo());
            head.setSrcSysSeqNo(requestHead.getSrcSysSeqNo());
            head.setFileFlg(StringUtils.hasText(requestHead.getFileFlg())
                    ? requestHead.getFileFlg() : EsbProviderConstants.FILE_FLG_NONE);
        } else {
            head.setFileFlg(EsbProviderConstants.FILE_FLG_NONE);
        }
        head.setPrvdSysId(resolvePrvdSysId());
        head.setPrvdSysSeqNo(sequenceService.nextCnsmSysSeqNo());
        head.setTranDt(now.format(TRAN_DATE));
        head.setTranTm(now.format(TRAN_TIME));
        head.setTranRetSt(tranRetSt);
        head.setPrvdSysSvrId(resolveServerId());
        EsbRetMsgArray retMsgArray = new EsbRetMsgArray();
        retMsgArray.setRetCd(retCd);
        retMsgArray.setRetMsg(retMsg);
        head.setRetMsgArray(retMsgArray);
        return head;
    }

    private EsbAppHead echoAppHead(EsbAppHead requestAppHead) {
        if (requestAppHead == null) {
            return null;
        }
        EsbAppHead appHead = new EsbAppHead();
        appHead.setTlrNo(requestAppHead.getTlrNo());
        appHead.setBranchId(requestAppHead.getBranchId());
        return appHead;
    }

    private String resolvePrvdSysId() {
        if (StringUtils.hasText(esbProperties.getCnsmSysId())) {
            return esbProperties.getCnsmSysId().trim();
        }
        return "UNKNOWN";
    }

    private String resolveServerId() {
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (Exception ex) {
            return esbProperties.resolveCnsmSysSvrId();
        }
    }

}
