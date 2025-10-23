package com.wmt.framework.web.core.aspect;

import cn.hutool.core.util.StrUtil;
import com.wmt.framework.common.util.json.JsonUtils;
import com.wmt.framework.common.util.servlet.ServletUtils;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Map;

/**
 * 请求日志切面
 * 用于记录详细的请求响应信息到日志中
 *
 * @author Wmt
 */
@Slf4j
@Aspect
@Component
public class RequestLogAspect {

    private static final String STATUS_KEY = "status";
    private static final String RESULT_CODE_KEY = "resultCode";
    private static final String RESULT_MSG_KEY = "resultMsg";
    private static final String RT_MS_KEY = "rtMs";
    private static final String BYTES_IN_KEY = "bytesIn";
    private static final String BYTES_OUT_KEY = "bytesOut";
    private static final String EXCEPTION_CLASS_KEY = "exceptionClass";
    private static final String ROOT_CAUSE_KEY = "rootCause";
    private static final String STACK_DIGEST_KEY = "stackDigest";

    /**
     * 切点：所有Controller方法
     */
    @Pointcut("execution(* com.wmt..controller..*(..))")
    public void controllerPointcut() {
    }

    /**
     * 环绕通知：记录请求响应日志
     */
    @Around("controllerPointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return joinPoint.proceed();
        }

        HttpServletRequest request = attributes.getRequest();
        HttpServletResponse response = attributes.getResponse();

        if (request == null || response == null) {
            return joinPoint.proceed();
        }

        // 记录请求开始时间
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();

        // 记录请求体大小
        String requestBody = ServletUtils.isJsonRequest(request) ? ServletUtils.getBody(request) : null;
        int bytesIn = requestBody != null ? requestBody.getBytes().length : 0;
        MDC.put(BYTES_IN_KEY, String.valueOf(bytesIn));

        Object result = null;
        Throwable exception = null;

        try {
            // 执行目标方法
            result = joinPoint.proceed();

            // 记录响应状态
            MDC.put(STATUS_KEY, String.valueOf(response.getStatus()));

            // 记录响应体大小
            if (result != null) {
                String resultJson = JsonUtils.toJsonString(result);
                int bytesOut = resultJson.getBytes().length;
                MDC.put(BYTES_OUT_KEY, String.valueOf(bytesOut));

                // 尝试提取结果码和消息
                extractResultInfo(result);
            }

            return result;

        } catch (Throwable e) {
            exception = e;

            // 记录异常信息
            MDC.put(STATUS_KEY, "500");
            MDC.put(EXCEPTION_CLASS_KEY, e.getClass().getSimpleName());

            // 记录根本原因
            Throwable rootCause = getRootCause(e);
            if (rootCause != null && rootCause != e) {
                MDC.put(ROOT_CAUSE_KEY, rootCause.getClass().getSimpleName());
            }

            // 记录堆栈摘要
            String stackDigest = generateStackDigest(e);
            MDC.put(STACK_DIGEST_KEY, stackDigest);

            throw e;

        } finally {
            // 记录响应时间
            stopWatch.stop();
            long rtMs = stopWatch.getTotalTimeMillis();
            MDC.put(RT_MS_KEY, String.valueOf(rtMs));

            // 记录请求日志
            logRequestInfo(request, result, exception, rtMs);

            // 清理MDC中的临时字段
            clearTemporaryMdc();
        }
    }

    /**
     * 提取结果信息
     */
    private void extractResultInfo(Object result) {
        try {
            if (result instanceof Map) {
                Map<?, ?> resultMap = (Map<?, ?>) result;

                // 尝试提取code字段
                Object code = resultMap.get("code");
                if (code != null) {
                    MDC.put(RESULT_CODE_KEY, String.valueOf(code));
                }

                // 尝试提取msg字段
                Object msg = resultMap.get("msg");
                if (msg != null) {
                    MDC.put(RESULT_MSG_KEY, String.valueOf(msg));
                }
            }
        } catch (Exception e) {
            // 忽略异常，避免影响正常流程
            log.debug("提取结果信息失败", e);
        }
    }

    /**
     * 获取根本原因
     */
    private Throwable getRootCause(Throwable throwable) {
        Throwable rootCause = throwable;
        while (rootCause.getCause() != null && rootCause.getCause() != rootCause) {
            rootCause = rootCause.getCause();
        }
        return rootCause;
    }

    /**
     * 生成堆栈摘要
     */
    private String generateStackDigest(Throwable throwable) {
        try {
            StackTraceElement[] stackTrace = throwable.getStackTrace();
            if (stackTrace.length == 0) {
                return "empty";
            }

            // 取前3个堆栈元素生成摘要
            StringBuilder digest = new StringBuilder();
            int maxElements = Math.min(3, stackTrace.length);

            for (int i = 0; i < maxElements; i++) {
                StackTraceElement element = stackTrace[i];
                if (i > 0) {
                    digest.append("|");
                }
                digest.append(element.getClassName())
                      .append(".")
                      .append(element.getMethodName())
                      .append(":")
                      .append(element.getLineNumber());
            }

            return digest.toString();
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 记录请求信息
     */
    private void logRequestInfo(HttpServletRequest request, Object result, Throwable exception, long rtMs) {
        try {
            String method = request.getMethod();
            String uri = request.getRequestURI();
            String queryString = request.getQueryString();
            String fullUrl = queryString != null ? uri + "?" + queryString : uri;

            if (exception != null) {
                log.error("请求异常 - {} {} 耗时:{}ms 异常:{}",
                         method, fullUrl, rtMs, exception.getMessage());
            } else {
                log.info("请求完成 - {} {} 耗时:{}ms", method, fullUrl, rtMs);
            }
        } catch (Exception e) {
            log.debug("记录请求信息失败", e);
        }
    }

    /**
     * 清理MDC中的临时字段
     */
    private void clearTemporaryMdc() {
        String[] keys = {
            STATUS_KEY, RESULT_CODE_KEY, RESULT_MSG_KEY, RT_MS_KEY,
            BYTES_IN_KEY, BYTES_OUT_KEY, EXCEPTION_CLASS_KEY,
            ROOT_CAUSE_KEY, STACK_DIGEST_KEY
        };

        for (String key : keys) {
            MDC.remove(key);
        }
    }
}
