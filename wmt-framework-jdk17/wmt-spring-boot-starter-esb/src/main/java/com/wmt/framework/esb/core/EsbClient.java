package com.wmt.framework.esb.core;

import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import com.wmt.framework.esb.config.EsbProperties;
import com.wmt.framework.esb.core.model.EsbAppHead;
import com.wmt.framework.esb.core.model.EsbEnvelope;
import com.wmt.framework.esb.core.model.EsbSysHead;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 内蒙古银行 ESB 通用客户端（TCP + 8 位长度头 + XML）。
 *
 * <p>业务模块在 integration 层封装具体 SvcCd/Body，注入本客户端完成联机调用。</p>
 *
 * <pre>{@code
 * @Resource
 * private EsbClient esbClient;
 *
 * MyResp resp = esbClient.invokeForBody(
 *         EsbInvokeOptions.of("11003000003", "01"),
 *         req,
 *         MyResp.class
 * );
 *
 * // 联盟路由：options.alliance=true 且 Body 实现 EsbAllianceBody，
 * // 会自动注入 wmt.esb.alliance.key-ind → Body.KeyInd（SysHead.Mac 仍由行内 ESB 生成）；
 * // 并覆盖 ChnlTp=09、CnsmSysId/SrcSysId=8610716，AppHead.BranchId 取自
 * // options 或 wmt.esb.alliance.branch-id（行内路径不受影响）
 * }</pre>
 */
@Slf4j
public class EsbClient {

    private static final DateTimeFormatter TRAN_DATE = DateTimeFormatter.ofPattern("yyyyMMdd");

    private static final DateTimeFormatter TRAN_TIME = DateTimeFormatter.ofPattern("HHmmss");

    /**
     * 联盟核心报文头渠道号（群公告「渠道号」；与行内 {@code wmt.esb.chnl-tp} 分离）。
     */
    static final String ALLIANCE_CHNL_TP = "09";

    /**
     * 联盟核心报文头请求方系统编号（群公告「系统编号」；与行内 {@code wmt.esb.cnsm-sys-id} 分离）。
     */
    static final String ALLIANCE_CNSM_SYS_ID = "8610716";

    private static final int ALLIANCE_BRANCH_ID_MIN_LEN = 3;

    private final EsbProperties properties;

    private final EsbTcpTransport transport;

    private final EsbXmlCodec xmlCodec;

    private final EsbSequenceService sequenceService;

    private final EsbResponseHandler responseHandler;

    public EsbClient(EsbProperties properties,
                     EsbTcpTransport transport,
                     EsbXmlCodec xmlCodec,
                     EsbSequenceService sequenceService,
                     EsbResponseHandler responseHandler) {
        this.properties = properties;
        this.transport = transport;
        this.xmlCodec = xmlCodec;
        this.sequenceService = sequenceService;
        this.responseHandler = responseHandler;
    }

    public <T> EsbResponse<T> invoke(EsbInvokeOptions options, Object body, Class<T> bodyType) {
        validateOptions(options);
        injectAllianceKeyIndIfNeeded(options, body);
        EsbEnvelope<Object> requestEnvelope = buildRequestEnvelope(options, body);
        String requestXml = xmlCodec.encode(requestEnvelope);
        log.info("[esb] request svcCd={} svcScn={} alliance={} body={}",
                options.getSvcCd(), options.getSvcScn(), options.isAlliance(),
                abbreviate(requestXml, 2000));

        String responseXml = transport.sendAndReceive(requestXml);
        log.info("[esb] response svcCd={} svcScn={} body={}", options.getSvcCd(), options.getSvcScn(),
                abbreviate(responseXml, 2000));

        EsbEnvelope<T> responseEnvelope = xmlCodec.decode(responseXml, bodyType);
        responseHandler.checkSuccessOrThrow(responseEnvelope.getSysHead());

        EsbResponse<T> response = new EsbResponse<>();
        response.setSysHead(responseEnvelope.getSysHead());
        response.setAppHead(responseEnvelope.getAppHead());
        response.setBody(responseEnvelope.getBody());
        return response;
    }

    public <T> T invokeForBody(EsbInvokeOptions options, Object body, Class<T> bodyType) {
        return invoke(options, body, bodyType).getBody();
    }

    public <T> EsbResponse<T> invoke(String svcCd, String svcScn, Object body, Class<T> bodyType) {
        return invoke(EsbInvokeOptions.of(svcCd, svcScn), body, bodyType);
    }

    public <T> T invokeForBody(String svcCd, String svcScn, Object body, Class<T> bodyType) {
        return invokeForBody(EsbInvokeOptions.of(svcCd, svcScn), body, bodyType);
    }

    private EsbEnvelope<Object> buildRequestEnvelope(EsbInvokeOptions options, Object body) {
        EsbEnvelope<Object> envelope = new EsbEnvelope<>();
        envelope.setSysHead(buildRequestSysHead(options));
        envelope.setAppHead(resolveAppHead(options));
        envelope.setBody(body);
        return envelope;
    }

    /**
     * 行内：透传 options.AppHead（可空）。
     * 联盟：BranchId 优先 options，否则 {@code wmt.esb.alliance.branch-id}，且长度 ≥ 3。
     */
    private EsbAppHead resolveAppHead(EsbInvokeOptions options) {
        EsbAppHead appHead = options.getAppHead() != null ? options.getAppHead() : new EsbAppHead();
        if (!options.isAlliance()) {
            return appHead;
        }
        if (!StringUtils.hasText(appHead.getBranchId())) {
            String configured = properties.getAlliance() != null ? properties.getAlliance().getBranchId() : null;
            if (StringUtils.hasText(configured)) {
                appHead.setBranchId(configured.trim());
            }
        } else {
            appHead.setBranchId(appHead.getBranchId().trim());
        }
        String branchId = appHead.getBranchId();
        if (!StringUtils.hasText(branchId) || branchId.length() < ALLIANCE_BRANCH_ID_MIN_LEN) {
            throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                    "联盟 ESB 缺少 AppHead.BranchId（配置 wmt.esb.alliance.branch-id），或长度不能小于 "
                            + ALLIANCE_BRANCH_ID_MIN_LEN + " 位");
        }
        return appHead;
    }

    private EsbSysHead buildRequestSysHead(EsbInvokeOptions options) {
        LocalDateTime now = LocalDateTime.now();
        boolean alliance = options.isAlliance();
        EsbSysHead sysHead = new EsbSysHead();
        sysHead.setSvcCd(options.getSvcCd());
        sysHead.setSvcScn(options.getSvcScn());
        // 联盟：常量覆盖系统编号；行内：沿用 yaml
        String cnsmSysId = alliance ? ALLIANCE_CNSM_SYS_ID : properties.getCnsmSysId();
        String srcSysId = alliance ? ALLIANCE_CNSM_SYS_ID : properties.resolveSrcSysId();
        sysHead.setCnsmSysId(EsbSequenceService.normalizeSystemId(cnsmSysId));
        sysHead.setSrcSysId(EsbSequenceService.normalizeSystemId(srcSysId));
        // 联盟：常量渠道 09；options 显式 ChnlTp 仍可覆盖（透传场景）
        if (StringUtils.hasText(options.getChnlTp())) {
            sysHead.setChnlTp(options.getChnlTp());
        } else if (alliance) {
            sysHead.setChnlTp(ALLIANCE_CHNL_TP);
        } else {
            sysHead.setChnlTp(properties.getChnlTp());
        }
        // 单笔请求共用一号，避免 Cnsm/Src 各取一次导致连跳；联盟流水前缀用联盟系统号
        String sharedSeqNo = null;
        if (StringUtils.hasText(options.getCnsmSysSeqNo())) {
            sysHead.setCnsmSysSeqNo(options.getCnsmSysSeqNo());
        } else {
            sharedSeqNo = alliance
                    ? sequenceService.nextCnsmSysSeqNo(ALLIANCE_CNSM_SYS_ID)
                    : sequenceService.nextCnsmSysSeqNo();
            sysHead.setCnsmSysSeqNo(sharedSeqNo);
        }
        if (StringUtils.hasText(options.getSrcSysSeqNo())) {
            sysHead.setSrcSysSeqNo(options.getSrcSysSeqNo());
        } else {
            sysHead.setSrcSysSeqNo(sharedSeqNo != null
                    ? sharedSeqNo
                    : (alliance
                    ? sequenceService.nextSrcSysSeqNo(ALLIANCE_CNSM_SYS_ID)
                    : sequenceService.nextSrcSysSeqNo()));
        }
        String cnsmSysSvrId = properties.resolveCnsmSysSvrId();
        if (!StringUtils.hasText(properties.getCnsmSysSvrId())) {
            log.warn("[esb] wmt.esb.cnsm-sys-svr-id 未配置，CnsmSysSvrId 回退为 {}", cnsmSysSvrId);
        }
        sysHead.setCnsmSysSvrId(cnsmSysSvrId);
        sysHead.setSrcSysSvrId(properties.resolveSrcSysSvrId());
        sysHead.setTranDt(now.format(TRAN_DATE));
        sysHead.setTranTm(now.format(TRAN_TIME));
        sysHead.setFileFlg(StringUtils.hasText(options.getFileFlg()) ? options.getFileFlg() : properties.getFileFlg());
        sysHead.setFilePath(options.getFilePath());
        return sysHead;
    }

    private void validateOptions(EsbInvokeOptions options) {
        if (options == null || !StringUtils.hasText(options.getSvcCd()) || !StringUtils.hasText(options.getSvcScn())) {
            throw new ServiceException(GlobalErrorCodeConstants.BAD_REQUEST.getCode(),
                    "ESB 调用缺少 SvcCd 或 SvcScn");
        }
    }

    /**
     * 联盟路由：向 Body 注入 KeyInd（已有值不覆盖），SysHead.Mac 仍由行内 ESB 生成。
     */
    private void injectAllianceKeyIndIfNeeded(EsbInvokeOptions options, Object body) {
        if (options == null || !options.isAlliance()) {
            return;
        }
        if (!(body instanceof EsbAllianceBody allianceBody)) {
            throw new ServiceException(GlobalErrorCodeConstants.BAD_REQUEST.getCode(),
                    "联盟 ESB 调用（alliance=true）要求 Body 实现 EsbAllianceBody 以承载 KeyInd");
        }
        if (StringUtils.hasText(allianceBody.getKeyInd())) {
            return;
        }
        String keyInd = properties.getAlliance() != null ? properties.getAlliance().getKeyInd() : null;
        if (!StringUtils.hasText(keyInd)) {
            throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                    "未配置联盟密钥标识（wmt.esb.alliance.key-ind）");
        }
        allianceBody.setKeyInd(keyInd);
        log.debug("[esb] injected alliance KeyInd for svcCd={}", options.getSvcCd());
    }

    private String abbreviate(String text, int max) {
        if (text == null) {
            return null;
        }
        if (text.length() <= max) {
            return text;
        }
        return text.substring(0, max) + "...";
    }

}
