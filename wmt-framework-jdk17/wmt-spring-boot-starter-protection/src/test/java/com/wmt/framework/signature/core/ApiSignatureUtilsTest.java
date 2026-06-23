package com.wmt.framework.signature.core;

import cn.hutool.core.util.IdUtil;
import cn.hutool.crypto.digest.DigestUtil;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ApiSignatureUtilsTest {

    @Test
    void sign_shouldMatchAspectUnitTestExample() {
        long timestamp = System.currentTimeMillis();
        String nonce = IdUtil.randomUUID();
        String appId = "xxxxxx";
        String appSecret = "yyyyyy";
        String body = "test";
        String queryString = ApiSignatureUtils.buildQueryString(Map.of("k1", "v1", "v1", "k1"));

        String signString = queryString + body
                + "appId=" + appId + "&nonce=" + nonce + "&timestamp=" + timestamp
                + appSecret;
        String expected = DigestUtil.sha256Hex(signString);

        String actual = ApiSignatureUtils.sign(queryString, body, appId, String.valueOf(timestamp), nonce, appSecret);
        assertEquals(expected, actual);
    }

}
