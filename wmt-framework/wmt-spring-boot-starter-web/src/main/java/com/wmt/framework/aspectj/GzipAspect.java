package com.wmt.framework.aspectj;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.wmt.framework.compression.CompressionService;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Objects;

@Aspect
@Slf4j
@Component
public class GzipAspect {

    @Autowired
    private CompressionService compressionService;

    @Pointcut("@annotation(com.wmt.framework.annotation.Gzip)")
    public void gzipPointCut() {}

    @AfterReturning(pointcut = "gzipPointCut()", returning = "result")
    public void applyCompression(JoinPoint joinPoint, Object result) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        HttpServletResponse response = attributes.getResponse();
        
        if (Objects.isNull(response)) return;
        
        try {
            ObjectMapper mapper = new ObjectMapper();
            // 注册JavaTimeModule以支持Java 8日期时间类型（如LocalDateTime）
            mapper.registerModule(new JavaTimeModule());
            byte[] data = mapper.writeValueAsBytes(result);
            
            // 使用新的压缩服务进行压缩
            boolean compressed = compressionService.compressIfNeeded(request, response, data);
            
            if (!compressed) {
                // 如果压缩失败或不满足压缩条件，直接返回原始数据
                response.getOutputStream().write(data);
                response.getOutputStream().flush();
            }
            
        } catch (IOException e) {
            log.error("压缩处理失败: {}", e.getMessage(), e);
        } catch (Throwable e) {
            log.error("处理返回数据失败");
            log.error("错误详情: {}", e.getMessage(), e);
        }
    }
}
