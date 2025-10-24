package com.wmt.framework.common.aspectj;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.util.Objects;
import java.util.zip.GZIPOutputStream;

@Aspect
@Slf4j
@Component
public class GzipAspect {

    @Pointcut("@annotation(com.wmt.framework.common.annotation.Gzip)")
public void gzipPointCut() {}

    @AfterReturning(pointcut = "gzipPointCut()", returning = "result")
    public void applyGzipCompression(JoinPoint joinPoint, Object result) {
        HttpServletResponse response = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getResponse();
        if (Objects.isNull(response)) return;
        try {
            ObjectMapper mapper = new ObjectMapper();
            // 注册JavaTimeModule以支持Java 8日期时间类型（如LocalDateTime）
            mapper.registerModule(new JavaTimeModule());
            byte[] data = mapper.writeValueAsBytes(result);
            // 当返回体大于2048KB开启Gzip
            if (data.length < 2048 * 1024) {
                return;
            }
            response.setHeader("Content-Encoding", "gzip");
            response.setHeader("Vary", "Accept-Encoding");
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            GZIPOutputStream gzipOutputStream = new GZIPOutputStream(byteArrayOutputStream);
            gzipOutputStream.write(data);
            gzipOutputStream.close();
            byte[] compressedData = byteArrayOutputStream.toByteArray();
            response.setContentLength(compressedData.length);
            ServletOutputStream servletOutputStream = response.getOutputStream();
            servletOutputStream.write(compressedData);
            servletOutputStream.flush();
            servletOutputStream.close();
        } catch (Throwable e) {
            log.error("开启Gzip返回失败");
            log.error("错误详情: {}", e.getMessage(), e);
        }
    }
}
