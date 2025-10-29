package com.wmt.framework.logging.web;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.wmt.framework.common.util.servlet.ServletUtils;
import com.wmt.framework.web.config.WebProperties;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * 链路追踪MDC过滤器
 * 用于在日志中添加链路追踪、用户信息、租户信息等字段
 * 移除循环依赖，通过反射或接口方式获取用户和租户信息
 *
 * @author Wmt
 */
@Configuration
@Slf4j
public class TraceMdcFilter {

    public static final String REQUEST_ID_KEY = "requestId";
    public static final String TRACE_ID_KEY = "traceId";
    public static final String SPAN_ID_KEY = "spanId";
    public static final String TENANT_ID_KEY = "tenantId";
    public static final String USER_ID_KEY = "userId";
    public static final String ROLE_IDS_KEY = "roleIds";
    public static final String REQUEST_PATH_KEY = "requestPath";
    public static final String HTTP_METHOD_KEY = "httpMethod";
    public static final String CLIENT_IP_KEY = "clientIp";
    public static final String USER_AGENT_KEY = "userAgent";
    public static final String APP_VERSION_KEY = "appVersion";
    public static final String CHANNEL_KEY = "channel";
    public static final String ENV_KEY = "env";
    public static final String NODE_ID_KEY = "nodeId";

    @Bean
    @ConditionalOnMissingBean(name = "wmtTraceMdcFilter")
    @ConditionalOnProperty(prefix = "wmt.logging", name = "enabled", havingValue = "true", matchIfMissing = true)
    public FilterRegistrationBean<Filter> wmtTraceMdcFilter(WebProperties webProperties) {
        FilterRegistrationBean<Filter> bean = new FilterRegistrationBean<>();
        bean.setName("wmtTraceMdcFilter");
        bean.setFilter(new TraceMdcFilterImpl(webProperties));
        bean.setOrder(Integer.MIN_VALUE + 100); // 足够靠前
        return bean;
    }

    /**
     * 链路追踪MDC过滤器实现
     */
    public static class TraceMdcFilterImpl extends com.wmt.framework.web.core.filter.ApiRequestFilter {

        public TraceMdcFilterImpl(WebProperties webProperties) {
            super(webProperties);
        }

        @Override
        protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
                throws ServletException, IOException {

            try {
                // 设置基础请求信息
                setBasicRequestInfo(request);

                // 设置链路追踪信息
                setTraceInfo(request);

                // 设置用户信息
                setUserInfo();

                // 设置租户信息
                setTenantInfo(request);

                // 设置环境信息
                setEnvironmentInfo();

                // 继续过滤链
                filterChain.doFilter(request, response);

            } finally {
                // 清理MDC，避免内存泄漏
                clearMdc();
            }
        }

        /**
         * 设置基础请求信息
         */
        private void setBasicRequestInfo(HttpServletRequest request) {
            // 生成请求ID
            String requestId = IdUtil.fastSimpleUUID();
            MDC.put(REQUEST_ID_KEY, requestId);

            // 请求路径
            String requestPath = request.getRequestURI();
            MDC.put(REQUEST_PATH_KEY, requestPath);

            // HTTP方法
            MDC.put(HTTP_METHOD_KEY, request.getMethod());

            // 客户端IP
            String clientIp = ServletUtils.getClientIP(request);
            MDC.put(CLIENT_IP_KEY, clientIp);

            // User-Agent
            String userAgent = request.getHeader("User-Agent");
            if (StrUtil.isNotBlank(userAgent)) {
                MDC.put(USER_AGENT_KEY, userAgent);
            }

            // 应用版本
            String appVersion = request.getHeader("X-App-Version");
            if (StrUtil.isNotBlank(appVersion)) {
                MDC.put(APP_VERSION_KEY, appVersion);
            }

            // 渠道
            String channel = request.getHeader("X-Channel");
            if (StrUtil.isNotBlank(channel)) {
                MDC.put(CHANNEL_KEY, channel);
            }
        }

        /**
         * 设置链路追踪信息
         */
        private void setTraceInfo(HttpServletRequest request) {
            // 优先使用SkyWalking的TraceId
            String traceId = request.getHeader("sw8");
            if (StrUtil.isBlank(traceId)) {
                // 如果没有SkyWalking，使用自定义的TraceId
                traceId = request.getHeader("X-Trace-Id");
                if (StrUtil.isBlank(traceId)) {
                    traceId = IdUtil.fastSimpleUUID();
                }
            }
            MDC.put(TRACE_ID_KEY, traceId);

            // SpanId
            String spanId = request.getHeader("X-Span-Id");
            if (StrUtil.isBlank(spanId)) {
                spanId = IdUtil.fastSimpleUUID();
            }
            MDC.put(SPAN_ID_KEY, spanId);
        }

        /**
         * 设置用户信息
         * 通过反射方式获取，避免循环依赖
         */
        private void setUserInfo() {
            try {
                // 通过反射获取SecurityFrameworkUtils
                Class<?> securityUtilsClass = Class.forName("com.wmt.framework.security.core.util.SecurityFrameworkUtils");
                Object loginUser = securityUtilsClass.getMethod("getLoginUser").invoke(null);

                if (loginUser != null) {
                    // 获取用户ID
                    Object userId = loginUser.getClass().getMethod("getId").invoke(loginUser);
                    if (userId != null) {
                        MDC.put(USER_ID_KEY, String.valueOf(userId));
                    }

                    // 获取角色IDs
                    Object roleIds = loginUser.getClass().getMethod("getRoleIds").invoke(loginUser);
                    if (roleIds != null && roleIds instanceof List) {
                        @SuppressWarnings("unchecked")
                        List<Object> roleIdList = (List<Object>) roleIds;
                        if (!roleIdList.isEmpty()) {
                            String roleIdsStr = String.join(",", roleIdList.stream()
                                    .map(String::valueOf)
                                    .toArray(String[]::new));
                            MDC.put(ROLE_IDS_KEY, roleIdsStr);
                        }
                    }
                }
            } catch (ClassNotFoundException e) {
                // 安全模块未引入，忽略
                log.debug("安全模块未引入，跳过用户信息设置", e);
            } catch (Exception e) {
                // 忽略异常，避免影响正常请求
                log.debug("设置用户信息到MDC失败", e);
            }
        }

        /**
         * 设置租户信息
         * 通过反射方式获取，避免循环依赖
         */
        private void setTenantInfo(HttpServletRequest request) {
            // 优先从请求头获取租户ID
            String tenantId = request.getHeader("tenant-id");
            if (StrUtil.isBlank(tenantId)) {
                tenantId = request.getHeader("X-Tenant-Id"); // 兼容大写
            }
            
            // 如果请求头没有，尝试从租户上下文获取
            if (StrUtil.isBlank(tenantId)) {
                try {
                    // 通过反射获取TenantContextHolder
                    Class<?> tenantContextClass = Class.forName("com.wmt.framework.tenant.core.context.TenantContextHolder");
                    Object tenantIdObj = tenantContextClass.getMethod("getTenantId").invoke(null);
                    if (tenantIdObj != null) {
                        tenantId = String.valueOf(tenantIdObj);
                    }
                } catch (ClassNotFoundException e) {
                    // 租户模块未引入，忽略
                    log.debug("租户模块未引入，跳过租户信息设置", e);
                } catch (Exception e) {
                    // 忽略异常，避免影响正常请求
                    log.debug("设置租户信息到MDC失败", e);
                }
            }

            if (StrUtil.isNotBlank(tenantId)) {
                MDC.put(TENANT_ID_KEY, tenantId);
            }
        }

        /**
         * 设置环境信息
         */
        private void setEnvironmentInfo() {
            // 环境
            String env = System.getProperty("spring.profiles.active", "local");
            MDC.put(ENV_KEY, env);

            // 节点ID
            String nodeId = System.getenv("HOSTNAME");
            if (StrUtil.isBlank(nodeId)) {
                nodeId = System.getProperty("spring.application.name");
            }
            if (StrUtil.isNotBlank(nodeId)) {
                MDC.put(NODE_ID_KEY, nodeId);
            }
        }

        /**
         * 清理MDC
         */
        private void clearMdc() {
            List<String> keys = Arrays.asList(
                    REQUEST_ID_KEY, TRACE_ID_KEY, SPAN_ID_KEY, TENANT_ID_KEY,
                    USER_ID_KEY, ROLE_IDS_KEY, REQUEST_PATH_KEY, HTTP_METHOD_KEY,
                    CLIENT_IP_KEY, USER_AGENT_KEY, APP_VERSION_KEY, CHANNEL_KEY,
                    ENV_KEY, NODE_ID_KEY
            );

            for (String key : keys) {
                MDC.remove(key);
            }
        }
    }
}


