package com.wmt.framework.esb.core;

import com.fasterxml.jackson.databind.JsonNode;
import com.wmt.framework.esb.core.model.EsbAppHead;
import com.wmt.framework.esb.core.model.EsbEnvelope;
import com.wmt.framework.esb.core.model.EsbSysHead;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 按 {@code SvcCd|SvcScn} 路由到 {@link EsbProviderHandler}。
 */
@Slf4j
public class EsbProviderRouter {

    private final EsbXmlCodec xmlCodec;
    private final EsbProviderResponseFactory responseFactory;
    private final Map<String, EsbProviderHandler<?, ?>> handlersByKey = new LinkedHashMap<>();
    private final String providerSysId;

    public EsbProviderRouter(EsbXmlCodec xmlCodec,
                             EsbProviderResponseFactory responseFactory,
                             String providerSysId,
                             List<EsbProviderHandler<?, ?>> handlers) {
        this.xmlCodec = xmlCodec;
        this.responseFactory = responseFactory;
        this.providerSysId = StringUtils.hasText(providerSysId) ? providerSysId.trim() : "UNKNOWN";
        if (handlers != null) {
            for (EsbProviderHandler<?, ?> handler : handlers) {
                register(handler);
            }
        }
    }

    private void register(EsbProviderHandler<?, ?> handler) {
        if (handler == null || !StringUtils.hasText(handler.svcCd())) {
            log.warn("[esb-provider] Handler {} 未配置 SvcCd，跳过路由注册",
                    handler == null ? "null" : handler.getClass().getSimpleName());
            return;
        }
        String key = routeKey(handler.svcCd(), handler.svcScn());
        EsbProviderHandler<?, ?> previous = handlersByKey.put(key, handler);
        if (previous != null) {
            log.warn("[esb-provider] 路由 {} 被覆盖：{} -> {}",
                    key, previous.getClass().getSimpleName(), handler.getClass().getSimpleName());
        } else {
            log.info("[esb-provider] 注册路由 {} -> {}", key, handler.getClass().getSimpleName());
        }
    }

    public String dispatch(String requestXml) {
        EsbSysHead peekHead = null;
        EsbAppHead peekApp = null;
        try {
            JsonNode root = xmlCodec.getXmlMapper().readTree(requestXml);
            peekHead = xmlCodec.getXmlMapper().treeToValue(root.path("SysHead"), EsbSysHead.class);
            if (root.has("AppHead") && !root.path("AppHead").isMissingNode()) {
                peekApp = xmlCodec.getXmlMapper().treeToValue(root.path("AppHead"), EsbAppHead.class);
            }
            if (peekHead == null || !StringUtils.hasText(peekHead.getSvcCd())) {
                EsbEnvelope<Object> fail = responseFactory.systemFailure(peekHead, peekApp,
                        systemRetCd("00000001"), "请求缺少 SvcCd");
                return xmlCodec.encode(fail);
            }
            String key = routeKey(peekHead.getSvcCd(), peekHead.getSvcScn());
            EsbProviderHandler<?, ?> handler = handlersByKey.get(key);
            if (handler == null) {
                EsbEnvelope<Object> fail = responseFactory.systemFailure(peekHead, peekApp,
                        systemRetCd("00000002"), "未注册的服务: " + key);
                return xmlCodec.encode(fail);
            }
            return invoke(handler, requestXml, peekHead, peekApp);
        } catch (Exception ex) {
            log.error("[esb-provider] 处理请求失败", ex);
            EsbEnvelope<Object> fail = responseFactory.systemFailure(peekHead, peekApp,
                    systemRetCd("00000099"), abbreviate(ex.getMessage(), 200));
            return xmlCodec.encode(fail);
        }
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    private String invoke(EsbProviderHandler handler, String requestXml,
                          EsbSysHead peekHead, EsbAppHead peekApp) throws Exception {
        EsbEnvelope request = xmlCodec.decode(requestXml, handler.requestType());
        EsbSysHead sysHead = request.getSysHead() != null ? request.getSysHead() : peekHead;
        EsbAppHead appHead = request.getAppHead() != null ? request.getAppHead() : peekApp;
        Object body = handler.handle(sysHead, request.getBody());
        EsbEnvelope response = responseFactory.success(sysHead, appHead, body);
        return xmlCodec.encode(response);
    }

    static String routeKey(String svcCd, String svcScn) {
        String scn = StringUtils.hasText(svcScn) ? svcScn.trim() : EsbProviderConstants.DEFAULT_SVC_SCN;
        return svcCd.trim() + "|" + scn;
    }

    private String systemRetCd(String seq8) {
        return providerSysId + seq8;
    }

    private static String abbreviate(String text, int max) {
        if (text == null) {
            return "系统处理失败";
        }
        String trimmed = text.replaceAll("\\s+", " ").trim();
        if (trimmed.length() <= max) {
            return trimmed;
        }
        return trimmed.substring(0, max);
    }

    public int registeredRouteCount() {
        return handlersByKey.size();
    }

}
