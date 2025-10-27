package com.wmt.framework.log.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 日志记录模型
 *
 * @author WMT
 */
@Data
public class LogRecord {
    
    /**
     * 日志ID
     */
    private String id;
    
    /**
     * 时间戳
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    private LocalDateTime timestamp;
    
    /**
     * 日志级别
     */
    private String level;
    
    /**
     * 日志消息
     */
    private String message;
    
    /**
     * 日志来源
     */
    private String source;
    
    /**
     * 应用名称
     */
    private String appName;
    
    /**
     * 环境名称
     */
    private String env;
    
    /**
     * 节点ID
     */
    private String nodeId;
    
    /**
     * 线程名
     */
    private String threadName;
    
    /**
     * 类名
     */
    private String className;
    
    /**
     * 方法名
     */
    private String methodName;
    
    /**
     * 行号
     */
    private Integer lineNumber;
    
    /**
     * 异常信息
     */
    private String exception;
    
    /**
     * 堆栈跟踪
     */
    private String stackTrace;
    
    /**
     * 请求ID
     */
    private String requestId;
    
    /**
     * 用户ID
     */
    private String userId;
    
    /**
     * IP地址
     */
    private String ipAddress;
    
    /**
     * 用户代理
     */
    private String userAgent;
    
    /**
     * 请求URL
     */
    private String requestUrl;
    
    /**
     * 请求方法
     */
    private String requestMethod;
    
    /**
     * 响应状态码
     */
    private Integer responseStatus;
    
    /**
     * 响应时间（毫秒）
     */
    private Long responseTime;
    
    /**
     * 额外属性
     */
    private Map<String, Object> extra;
    
    /**
     * MDC上下文
     */
    private Map<String, String> mdc;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    private LocalDateTime createTime;
}
