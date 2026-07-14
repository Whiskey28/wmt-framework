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
 * // 会自动注入 wmt.esb.alliance.key-ind → Body.KeyInd（SysHead.Mac 仍由行内 ESB 生成）
 * }</pre>
 */
@Slf4j
public class EsbClient {

    private static final DateTimeFormatter TRAN_DATE = DateTimeFormatter.ofPattern("yyyyMMdd");

    private static final DateTimeFormatter TRAN_TIME = DateTimeFormatter.ofPattern("HHmmss");

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
        envelope.setAppHead(options.getAppHead() != null ? options.getAppHead() : new EsbAppHead());
        envelope.setBody(body);
        return envelope;
    }

    private EsbSysHead buildRequestSysHead(EsbInvokeOptions options) {
        LocalDateTime now = LocalDateTime.now();
        EsbSysHead sysHead = new EsbSysHead();
        sysHead.setSvcCd(options.getSvcCd());
        sysHead.setSvcScn(options.getSvcScn());
        sysHead.setCnsmSysId(EsbSequenceService.normalizeSystemId(properties.getCnsmSysId()));
        sysHead.setSrcSysId(EsbSequenceService.normalizeSystemId(properties.resolveSrcSysId()));
        sysHead.setChnlTp(StringUtils.hasText(options.getChnlTp()) ? options.getChnlTp() : properties.getChnlTp());
        sysHead.setCnsmSysSeqNo(StringUtils.hasText(options.getCnsmSysSeqNo())
                ? options.getCnsmSysSeqNo()
                : sequenceService.nextCnsmSysSeqNo());
        sysHead.setSrcSysSeqNo(StringUtils.hasText(options.getSrcSysSeqNo())
                ? options.getSrcSysSeqNo()
                : sequenceService.nextSrcSysSeqNo());
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
