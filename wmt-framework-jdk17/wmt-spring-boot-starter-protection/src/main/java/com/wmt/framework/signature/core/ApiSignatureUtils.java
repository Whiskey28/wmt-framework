package com.wmt.framework.signature.core;

import cn.hutool.core.map.MapUtil;
import cn.hutool.crypto.digest.DigestUtil;

import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

/**
 * HTTP API 签名工具，与 {@link com.wmt.framework.signature.core.aop.ApiSignatureAspect} 验签规则一致。
 *
 * <p>供伙伴出站 HTTP 客户端与联调文档复用，与 {@link com.wmt.framework.signature.core.aop.ApiSignatureAspect} 验签规则一致。</p>
 */
public final class ApiSignatureUtils {

    public static final String HEADER_APP_ID = "appId";

    public static final String HEADER_TIMESTAMP = "timestamp";

    public static final String HEADER_NONCE = "nonce";

    public static final String HEADER_SIGN = "sign";

    private ApiSignatureUtils() {
    }

    /**
     * 计算签名：SHA256(query + body + headerParams + appSecret)。
     */
    public static String sign(String queryString, String body, String appId, String timestamp, String nonce, String appSecret) {
        return DigestUtil.sha256Hex(buildSignatureString(queryString, body, appId, timestamp, nonce, appSecret));
    }

    public static String buildSignatureString(String queryString, String body, String appId, String timestamp,
                                              String nonce, String appSecret) {
        String safeQuery = queryString == null ? "" : queryString;
        String safeBody = body == null ? "" : body;
        SortedMap<String, String> headerMap = buildHeaderMap(appId, timestamp, nonce);
        return safeQuery + safeBody + MapUtil.join(headerMap, "&", "=") + appSecret;
    }

    public static String buildQueryString(Map<String, String> queryParams) {
        if (queryParams == null || queryParams.isEmpty()) {
            return "";
        }
        SortedMap<String, String> sortedMap = new TreeMap<>(queryParams);
        return MapUtil.join(sortedMap, "&", "=");
    }

    public static SortedMap<String, String> buildHeaderMap(String appId, String timestamp, String nonce) {
        SortedMap<String, String> sortedMap = new TreeMap<>();
        sortedMap.put(HEADER_APP_ID, appId);
        sortedMap.put(HEADER_TIMESTAMP, timestamp);
        sortedMap.put(HEADER_NONCE, nonce);
        return sortedMap;
    }

    public static Map<String, String> buildSignedHeaders(String appId, String appSecret,
                                                         Map<String, String> queryParams, String body) {
        String timestamp = String.valueOf(System.currentTimeMillis());
        String nonce = cn.hutool.core.util.IdUtil.fastSimpleUUID();
        String queryString = buildQueryString(queryParams);
        String sign = sign(queryString, body, appId, timestamp, nonce, appSecret);
        return Map.of(
                HEADER_APP_ID, appId,
                HEADER_TIMESTAMP, timestamp,
                HEADER_NONCE, nonce,
                HEADER_SIGN, sign
        );
    }

}
