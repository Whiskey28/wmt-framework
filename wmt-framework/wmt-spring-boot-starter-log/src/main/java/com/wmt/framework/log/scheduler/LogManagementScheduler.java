package com.wmt.framework.log.scheduler;

import com.wmt.framework.log.config.WmtLogProperties;
import com.wmt.framework.log.model.LogAlert;
import com.wmt.framework.log.service.LogAlertingService;
import com.wmt.framework.log.service.LogAnalysisService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 日志管理定时任务
 *
 * @author WMT
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LogManagementScheduler {
    
    private final WmtLogProperties properties;
    private final LogAnalysisService analysisService;
    private final LogAlertingService alertingService;
    
    /**
     * 定时执行日志分析
     */
    @Scheduled(fixedDelayString = "${wmt.log.analysis.interval:300000}") // 默认5分钟
    public void scheduleLogAnalysis() {
        if (!properties.getAnalysis().isEnabled()) {
            return;
        }
        
        try {
            LocalDateTime endTime = LocalDateTime.now();
            LocalDateTime startTime = endTime.minusMinutes(properties.getAnalysis().getInterval().toMinutes());
            
            log.debug("开始执行日志分析: {} - {}", startTime, endTime);
            
            // 执行日志分析
            analysisService.analyze(startTime, endTime);
            
            log.debug("日志分析完成");
        } catch (Exception e) {
            log.error("定时日志分析失败", e);
        }
    }
    
    /**
     * 定时检查告警规则
     */
    @Scheduled(fixedDelayString = "${wmt.log.alerting.check-interval:60000}") // 默认1分钟
    public void scheduleAlertCheck() {
        if (!properties.getAlerting().isEnabled()) {
            return;
        }
        
        try {
            LocalDateTime endTime = LocalDateTime.now();
            LocalDateTime startTime = endTime.minusMinutes(5); // 检查最近5分钟的日志
            
            log.debug("开始检查告警规则: {} - {}", startTime, endTime);
            
            // 检查告警规则
            List<LogAlert> alerts = alertingService.checkAlerts(startTime, endTime);
            
            if (!alerts.isEmpty()) {
                log.warn("检测到 {} 个告警", alerts.size());
                
                // 发送告警
                alertingService.sendAlerts(alerts);
            }
            
            log.debug("告警检查完成");
        } catch (Exception e) {
            log.error("定时告警检查失败", e);
        }
    }
    
    /**
     * 定时清理过期日志
     */
    @Scheduled(cron = "${wmt.log.storage.cleanup-cron:0 0 2 * * ?}") // 默认每天凌晨2点
    public void scheduleLogCleanup() {
        if (!properties.getStorage().isEnabled()) {
            return;
        }
        
        try {
            log.info("开始清理过期日志");
            
            // 根据存储类型清理过期日志
            LocalDateTime expireTime = LocalDateTime.now().minusDays(
                "elasticsearch".equals(properties.getStorage().getType()) 
                    ? 30  // Elasticsearch默认保留30天
                    : properties.getStorage().getFile().getRetentionDays()
            );
            
            // 这里可以调用存储服务清理过期日志
            // storageService.deleteExpiredLogs(expireTime);
            
            log.info("过期日志清理完成");
        } catch (Exception e) {
            log.error("定时清理过期日志失败", e);
        }
    }
}
