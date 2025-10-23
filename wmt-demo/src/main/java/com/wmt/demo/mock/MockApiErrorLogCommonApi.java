package com.wmt.demo.mock;

import com.wmt.framework.common.biz.infra.logger.ApiErrorLogCommonApi;
import com.wmt.framework.common.biz.infra.logger.dto.ApiErrorLogCreateReqDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * Mock implementation of ApiErrorLogCommonApi for demo purposes
 * 
 * @author WMT
 */
@Slf4j
@Component
public class MockApiErrorLogCommonApi implements ApiErrorLogCommonApi {

    @Override
    public void createApiErrorLog(ApiErrorLogCreateReqDTO createDTO) {
        log.error("Mock API Error Log: {}", createDTO);
    }
}

