package com.wmt.demo.mock;

import com.wmt.framework.common.biz.system.oauth2.OAuth2TokenCommonApi;
import com.wmt.framework.common.biz.system.oauth2.dto.OAuth2AccessTokenCheckRespDTO;
import com.wmt.framework.common.biz.system.oauth2.dto.OAuth2AccessTokenCreateReqDTO;
import com.wmt.framework.common.biz.system.oauth2.dto.OAuth2AccessTokenRespDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * Mock implementation of OAuth2TokenCommonApi for demo purposes
 * 
 * @author WMT
 */
@Slf4j
@Component
public class MockOAuth2TokenCommonApi implements OAuth2TokenCommonApi {

    @Override
    public OAuth2AccessTokenRespDTO createAccessToken(OAuth2AccessTokenCreateReqDTO reqDTO) {
        log.debug("Mock create OAuth2 access token: {}", reqDTO);
        OAuth2AccessTokenRespDTO respDTO = new OAuth2AccessTokenRespDTO();
        respDTO.setAccessToken("mock-access-token");
        respDTO.setRefreshToken("mock-refresh-token");
        respDTO.setUserId(1L);
        respDTO.setUserType(1);
        respDTO.setExpiresTime(LocalDateTime.now().plusHours(2)); // 2 hours
        return respDTO;
    }

    @Override
    public OAuth2AccessTokenCheckRespDTO checkAccessToken(String accessToken) {
        log.debug("Mock check OAuth2 access token: {}", accessToken);
        OAuth2AccessTokenCheckRespDTO respDTO = new OAuth2AccessTokenCheckRespDTO();
        respDTO.setUserId(1L);
        respDTO.setUserType(1);
        respDTO.setTenantId(1L);
        return respDTO;
    }

    @Override
    public OAuth2AccessTokenRespDTO refreshAccessToken(String refreshToken, String clientId) {
        log.debug("Mock refresh OAuth2 access token: {}", refreshToken);
        return createAccessToken(new OAuth2AccessTokenCreateReqDTO());
    }

    @Override
    public OAuth2AccessTokenRespDTO removeAccessToken(String accessToken) {
        log.debug("Mock remove OAuth2 access token: {}", accessToken);
        return null;
    }
}

