package com.wmt.framework.log.service;

import com.wmt.framework.log.model.LogAlert;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 日志告警服务接口
 *
 * @author WMT
 */
public interface LogAlertingService {
    
    /**
     * 检查告警规则
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 触发的告警列表
     */
    List<LogAlert> checkAlerts(LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * 发送告警
     *
     * @param alert 告警信息
     */
    void sendAlert(LogAlert alert);
    
    /**
     * 批量发送告警
     *
     * @param alerts 告警列表
     */
    void sendAlerts(List<LogAlert> alerts);
    
    /**
     * 处理告警
     *
     * @param alertId 告警ID
     * @param handler 处理人
     * @param handleNote 处理备注
     */
    void handleAlert(String alertId, String handler, String handleNote);
    
    /**
     * 获取告警历史
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 告警历史列表
     */
    List<LogAlert> getAlertHistory(LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * 获取未处理告警
     *
     * @return 未处理告警列表
     */
    List<LogAlert> getUnhandledAlerts();
    
    /**
     * 获取告警统计
     *
     * @return 告警统计信息
     */
    Map<String, Object> getAlertStatistics();
}
