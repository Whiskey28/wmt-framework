package com.wmt.framework.web.core.filter;

import com.wmt.framework.web.config.WebProperties;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import java.io.IOException;

import static org.mockito.Mockito.*;

/**
 * LogMdcFilter 测试类
 * 验证过滤器能正常工作且不会因为循环依赖而编译失败
 */
public class LogMdcFilterTest {

    @Test
    public void testLogMdcFilter() throws ServletException, IOException {
        // 创建测试用的WebProperties
        WebProperties webProperties = new WebProperties();
        WebProperties.Api adminApi = new WebProperties.Api();
        adminApi.setPrefix("/admin-api");
        webProperties.setAdminApi(adminApi);
        
        WebProperties.Api appApi = new WebProperties.Api();
        appApi.setPrefix("/app-api");
        webProperties.setAppApi(appApi);

        // 创建过滤器实例
        LogMdcFilter filter = new LogMdcFilter(webProperties);

        // 创建模拟请求和响应
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRequestURI("/admin-api/test");
        request.setMethod("GET");
        request.addHeader("User-Agent", "Test-Agent");
        request.addHeader("X-App-Version", "1.0.0");
        request.addHeader("X-Channel", "web");

        MockHttpServletResponse response = new MockHttpServletResponse();
        FilterChain filterChain = mock(FilterChain.class);

        // 执行过滤器
        filter.doFilter(request, response, filterChain);

        // 验证过滤器链被调用
        verify(filterChain).doFilter(request, response);
    }
}
