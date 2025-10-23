package com.wmt.demo.mock;

import com.wmt.framework.common.biz.infra.logger.ApiAccessLogCommonApi;
import com.wmt.framework.common.biz.infra.logger.dto.ApiAccessLogCreateReqDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * Mock implementation of ApiAccessLogCommonApi for demo purposes
 * 
 * @author WMT
 */
@Slf4j
@Component
public class MockApiAccessLogCommonApi implements ApiAccessLogCommonApi {

    @Override
    public void createApiAccessLog(ApiAccessLogCreateReqDTO createDTO) {
        log.debug("Mock API Access Log: {}", createDTO);
    }
}

