package com.wmt.framework.partner.core;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import com.wmt.framework.signature.core.ApiSignatureUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.Map;

/**
 * 伙伴 HTTP 出站客户端（自动附加 appId/timestamp/nonce/sign Header）。
 */
@Slf4j
public class PartnerHttpClient {

    private final RestTemplate restTemplate;

    private final ObjectMapper objectMapper;

    public PartnerHttpClient(RestTemplate restTemplate, ObjectMapper objectMapper) {
        this.restTemplate = restTemplate;
        this.objectMapper = objectMapper;
    }

    public <T> T postJson(String url, String appId, String appSecret, Object body, Class<T> responseType) {
        if (!StringUtils.hasText(url)) {
            throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(), "伙伴 HTTP 地址未配置");
        }
        String bodyJson = toJson(body);
        Map<String, String> signedHeaders = ApiSignatureUtils.buildSignedHeaders(
                appId, appSecret, Collections.emptyMap(), bodyJson);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        signedHeaders.forEach(headers::add);

        log.info("[partner-http] POST url={} appId={} body={}", url, appId, abbreviate(bodyJson, 2000));
        try {
            ResponseEntity<T> response = restTemplate.postForEntity(url, new HttpEntity<>(bodyJson, headers), responseType);
            return response.getBody();
        } catch (RestClientException ex) {
            log.error("[partner-http] POST error url={}", url, ex);
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "调用伙伴 HTTP 接口失败：" + ex.getMessage());
        }
    }

    private String toJson(Object body) {
        try {
            return objectMapper.writeValueAsString(body);
        } catch (JsonProcessingException ex) {
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(), "JSON 序列化失败");
        }
    }

    private String abbreviate(String text, int max) {
        if (text == null || text.length() <= max) {
            return text;
        }
        return text.substring(0, max) + "...";
    }

}
