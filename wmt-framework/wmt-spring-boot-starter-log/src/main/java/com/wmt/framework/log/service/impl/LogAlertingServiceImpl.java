package com.wmt.framework.log.service.impl;

import com.wmt.framework.log.config.WmtLogProperties;
import com.wmt.framework.log.model.LogAlert;
import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.service.LogAlertingService;
import com.wmt.framework.log.service.LogStorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 日志告警服务实现
 *
 * @author WMT
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LogAlertingServiceImpl implements LogAlertingService {
    
    private final WmtLogProperties properties;
    private final LogStorageService storageService;
    
    // 内存中存储告警信息（实际项目中应该使用数据库）
    private final Map<String, LogAlert> alertStorage = new ConcurrentHashMap<>();
    
    @Override
    public List<LogAlert> checkAlerts(LocalDateTime startTime, LocalDateTime endTime) {
        if (!properties.getAlerting().isEnabled()) {
            return Collections.emptyList();
        }
        
        List<LogAlert> triggeredAlerts = new ArrayList<>();
        
        try {
            for (WmtLogProperties.Alerting.AlertRule rule : properties.getAlerting().getRules()) {
                if (!rule.isEnabled()) {
                    continue;
                }
                
                LogAlert alert = checkRule(rule, startTime, endTime);
                if (alert != null) {
                    triggeredAlerts.add(alert);
                    alertStorage.put(alert.getId(), alert);
                }
            }
        } catch (Exception e) {
            log.error("检查告警规则失败", e);
        }
        
        return triggeredAlerts;
    }
    
    @Override
    public void sendAlert(LogAlert alert) {
        try {
            log.warn("发送告警: {} - {}", alert.getTitle(), alert.getContent());
            
            // 这里可以集成各种告警渠道
            // 1. 邮件告警
            if (properties.getAlerting().getChannels().contains("email")) {
                sendEmailAlert(alert);
            }
            
            // 2. Webhook告警
            if (properties.getAlerting().getChannels().contains("webhook")) {
                sendWebhookAlert(alert);
            }
            
            // 3. 短信告警
            if (properties.getAlerting().getChannels().contains("sms")) {
                sendSmsAlert(alert);
            }
            
        } catch (Exception e) {
            log.error("发送告警失败: {}", alert.getId(), e);
        }
    }
    
    @Override
    public void sendAlerts(List<LogAlert> alerts) {
        for (LogAlert alert : alerts) {
            sendAlert(alert);
        }
    }
    
    @Override
    public void handleAlert(String alertId, String handler, String handleNote) {
        LogAlert alert = alertStorage.get(alertId);
        if (alert != null) {
            alert.setStatus("handled");
            alert.setHandler(handler);
            alert.setHandleTime(LocalDateTime.now());
            alert.setHandleNote(handleNote);
            alertStorage.put(alertId, alert);
            
            log.info("告警已处理: {} by {}", alertId, handler);
        }
    }
    
    @Override
    public List<LogAlert> getAlertHistory(LocalDateTime startTime, LocalDateTime endTime) {
        return alertStorage.values().stream()
            .filter(alert -> alert.getAlertTime().isAfter(startTime) && alert.getAlertTime().isBefore(endTime))
            .collect(java.util.stream.Collectors.toList());
    }
    
    @Override
    public List<LogAlert> getUnhandledAlerts() {
        return alertStorage.values().stream()
            .filter(alert -> !"handled".equals(alert.getStatus()))
            .collect(java.util.stream.Collectors.toList());
    }
    
    @Override
    public Map<String, Object> getAlertStatistics() {
        Map<String, Object> stats = new java.util.HashMap<>();
        
        long totalAlerts = alertStorage.size();
        long unhandledAlerts = alertStorage.values().stream()
            .filter(alert -> !"handled".equals(alert.getStatus()))
            .count();
        
        stats.put("totalAlerts", totalAlerts);
        stats.put("unhandledAlerts", unhandledAlerts);
        stats.put("handledAlerts", totalAlerts - unhandledAlerts);
        
        return stats;
    }
    
    /**
     * 检查单个告警规则
     */
    private LogAlert checkRule(WmtLogProperties.Alerting.AlertRule rule, LocalDateTime startTime, LocalDateTime endTime) {
        try {
            Map<String, Object> query = new HashMap<>();
            query.put("startTime", startTime);
            query.put("endTime", endTime);
            
            List<LogRecord> logs = storageService.query(query);
            
            // 根据规则条件计算实际值
            Object actualValue = calculateActualValue(rule.getCondition(), logs);
            
            // 检查是否超过阈值
            if (isThresholdExceeded(actualValue, rule.getThreshold())) {
                LogAlert alert = new LogAlert();
                alert.setId(UUID.randomUUID().toString());
                alert.setRuleName(rule.getName());
                alert.setLevel("WARNING");
                alert.setTitle("日志告警: " + rule.getName());
                alert.setContent(rule.getDescription());
                alert.setAlertTime(LocalDateTime.now());
                alert.setCondition(rule.getCondition());
                alert.setActualValue(actualValue);
                alert.setThreshold(rule.getThreshold());
                alert.setStatus("active");
                alert.setCreateTime(LocalDateTime.now());
                
                return alert;
            }
            
            return null;
        } catch (Exception e) {
            log.error("检查告警规则失败: {}", rule.getName(), e);
            return null;
        }
    }
    
    /**
     * 计算实际值
     */
    private Object calculateActualValue(String condition, List<LogRecord> logs) {
        // 简化的条件计算，实际项目中可以使用更复杂的表达式引擎
        if ("error_count".equals(condition)) {
            return logs.stream().filter(log -> "ERROR".equals(log.getLevel())).count();
        } else if ("error_rate".equals(condition)) {
            long totalLogs = logs.size();
            long errorLogs = logs.stream().filter(log -> "ERROR".equals(log.getLevel())).count();
            return totalLogs > 0 ? (double) errorLogs / totalLogs : 0.0;
        } else if ("avg_response_time".equals(condition)) {
            return logs.stream()
                .filter(log -> log.getResponseTime() != null)
                .mapToLong(LogRecord::getResponseTime)
                .average()
                .orElse(0.0);
        }
        
        return 0;
    }
    
    /**
     * 检查是否超过阈值
     */
    private boolean isThresholdExceeded(Object actualValue, Object threshold) {
        if (actualValue instanceof Number && threshold instanceof Number) {
            return ((Number) actualValue).doubleValue() > ((Number) threshold).doubleValue();
        }
        return false;
    }
    
    /**
     * 发送邮件告警
     */
    private void sendEmailAlert(LogAlert alert) {
        // 实现邮件发送逻辑
        log.info("发送邮件告警: {}", alert.getTitle());
    }
    
    /**
     * 发送Webhook告警
     */
    private void sendWebhookAlert(LogAlert alert) {
        // 实现Webhook发送逻辑
        log.info("发送Webhook告警: {}", alert.getTitle());
    }
    
    /**
     * 发送短信告警
     */
    private void sendSmsAlert(LogAlert alert) {
        // 实现短信发送逻辑
        log.info("发送短信告警: {}", alert.getTitle());
    }
}
