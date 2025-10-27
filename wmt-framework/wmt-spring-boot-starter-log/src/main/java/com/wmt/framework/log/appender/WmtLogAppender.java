package com.wmt.framework.log.appender;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.AppenderBase;
import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.service.LogCollectionService;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * WMT日志收集Appender
 *
 * @author WMT
 */
@Slf4j
public class WmtLogAppender extends AppenderBase<ILoggingEvent> {
    
    private LogCollectionService logCollectionService;
    private String appName;
    private String env;
    private String nodeId;
    
    @Override
    protected void append(ILoggingEvent event) {
        try {
            LogRecord logRecord = convertToLogRecord(event);
            if (logCollectionService != null) {
                logCollectionService.collect(logRecord);
            }
        } catch (Exception e) {
            // 避免在日志处理中产生循环日志
            System.err.println("WmtLogAppender处理日志失败: " + e.getMessage());
        }
    }
    
    /**
     * 将Logback事件转换为LogRecord
     */
    private LogRecord convertToLogRecord(ILoggingEvent event) {
        LogRecord logRecord = new LogRecord();
        
        // 基本信息
        logRecord.setId(UUID.randomUUID().toString());
        logRecord.setTimestamp(LocalDateTime.now());
        logRecord.setLevel(event.getLevel().toString());
        logRecord.setMessage(event.getFormattedMessage());
        logRecord.setSource("application");
        
        // 应用信息
        logRecord.setAppName(appName != null ? appName : "unknown");
        logRecord.setEnv(env != null ? env : "unknown");
        logRecord.setNodeId(nodeId != null ? nodeId : "unknown");
        
        // 线程信息
        logRecord.setThreadName(event.getThreadName());
        
        // 类和方法信息
        StackTraceElement[] callerData = event.getCallerData();
        if (callerData != null && callerData.length > 0) {
            StackTraceElement caller = callerData[0];
            logRecord.setClassName(caller.getClassName());
            logRecord.setMethodName(caller.getMethodName());
            logRecord.setLineNumber(caller.getLineNumber());
        }
        
        // 异常信息
        if (event.getThrowableProxy() != null) {
            logRecord.setException(event.getThrowableProxy().getClassName());
            // Java 8兼容：手动构建堆栈跟踪字符串
            StringBuilder stackTrace = new StringBuilder();
            for (int i = 0; i < event.getThrowableProxy().getStackTraceElementProxyArray().length; i++) {
                stackTrace.append(event.getThrowableProxy().getStackTraceElementProxyArray()[i].toString()).append("\n");
            }
            logRecord.setStackTrace(stackTrace.toString());
        }
        
        // MDC上下文
        Map<String, String> mdc = new HashMap<>();
        Map<String, String> mdcPropertyMap = event.getMDCPropertyMap();
        if (mdcPropertyMap != null) {
            mdc.putAll(mdcPropertyMap);
        }
        logRecord.setMdc(mdc);
        
        // 从MDC中提取特定字段
        logRecord.setRequestId(MDC.get("requestId"));
        logRecord.setUserId(MDC.get("userId"));
        logRecord.setIpAddress(MDC.get("ipAddress"));
        logRecord.setUserAgent(MDC.get("userAgent"));
        logRecord.setRequestUrl(MDC.get("requestUrl"));
        logRecord.setRequestMethod(MDC.get("requestMethod"));
        
        String responseStatus = MDC.get("responseStatus");
        if (responseStatus != null) {
            try {
                logRecord.setResponseStatus(Integer.parseInt(responseStatus));
            } catch (NumberFormatException e) {
                // 忽略解析错误
            }
        }
        
        String responseTime = MDC.get("responseTime");
        if (responseTime != null) {
            try {
                logRecord.setResponseTime(Long.parseLong(responseTime));
            } catch (NumberFormatException e) {
                // 忽略解析错误
            }
        }
        
        // 额外属性
        Map<String, Object> extra = new HashMap<>();
        extra.put("loggerName", event.getLoggerName());
        extra.put("timeStamp", event.getTimeStamp());
        logRecord.setExtra(extra);
        
        logRecord.setCreateTime(LocalDateTime.now());
        
        return logRecord;
    }
    
    // Getters and Setters
    public LogCollectionService getLogCollectionService() {
        return logCollectionService;
    }
    
    public void setLogCollectionService(LogCollectionService logCollectionService) {
        this.logCollectionService = logCollectionService;
    }
    
    public String getAppName() {
        return appName;
    }
    
    public void setAppName(String appName) {
        this.appName = appName;
    }
    
    public String getEnv() {
        return env;
    }
    
    public void setEnv(String env) {
        this.env = env;
    }
    
    public String getNodeId() {
        return nodeId;
    }
    
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
}
