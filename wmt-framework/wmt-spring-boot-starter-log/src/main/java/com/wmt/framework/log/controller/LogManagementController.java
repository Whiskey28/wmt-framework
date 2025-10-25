package com.wmt.framework.log.controller;

import com.wmt.framework.log.model.LogAlert;
import com.wmt.framework.log.model.LogAnalysisResult;
import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.service.LogAlertingService;
import com.wmt.framework.log.service.LogAnalysisService;
import com.wmt.framework.log.service.LogCollectionService;
import com.wmt.framework.log.service.LogStorageService;
import com.wmt.framework.log.service.LogVisualizationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 日志管理API控制器
 *
 * @author WMT
 */
@Slf4j
@RestController
@RequestMapping("/api/logs")
@RequiredArgsConstructor
public class LogManagementController {
    
    private final LogCollectionService collectionService;
    private final LogStorageService storageService;
    private final LogAnalysisService analysisService;
    private final LogAlertingService alertingService;
    private final LogVisualizationService visualizationService;
    
    /**
     * 获取收集服务状态
     */
    @GetMapping("/collection/status")
    public Map<String, Object> getCollectionStatus() {
        return collectionService.getStatus();
    }
    
    /**
     * 查询日志
     */
    @PostMapping("/query")
    public List<LogRecord> queryLogs(@RequestBody Map<String, Object> query) {
        return storageService.query(query);
    }
    
    /**
     * 分页查询日志
     */
    @PostMapping("/query/page")
    public Map<String, Object> queryLogsPage(
            @RequestBody Map<String, Object> query,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return storageService.queryPage(query, page, size);
    }
    
    /**
     * 执行日志分析
     */
    @PostMapping("/analysis")
    public LogAnalysisResult analyzeLogs(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        return analysisService.analyze(startTime, endTime);
    }
    
    /**
     * 获取分析历史
     */
    @GetMapping("/analysis/history")
    public List<LogAnalysisResult> getAnalysisHistory(@RequestParam(defaultValue = "10") int limit) {
        return analysisService.getAnalysisHistory(limit);
    }
    
    /**
     * 获取告警历史
     */
    @GetMapping("/alerts/history")
    public List<LogAlert> getAlertHistory(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        return alertingService.getAlertHistory(startTime, endTime);
    }
    
    /**
     * 获取未处理告警
     */
    @GetMapping("/alerts/unhandled")
    public List<LogAlert> getUnhandledAlerts() {
        return alertingService.getUnhandledAlerts();
    }
    
    /**
     * 处理告警
     */
    @PostMapping("/alerts/{alertId}/handle")
    public void handleAlert(
            @PathVariable String alertId,
            @RequestParam String handler,
            @RequestParam(required = false) String handleNote) {
        alertingService.handleAlert(alertId, handler, handleNote);
    }
    
    /**
     * 获取告警统计
     */
    @GetMapping("/alerts/statistics")
    public Map<String, Object> getAlertStatistics() {
        return alertingService.getAlertStatistics();
    }
    
    /**
     * 创建索引模式
     */
    @PostMapping("/visualization/index-pattern")
    public Map<String, Object> createIndexPattern(@RequestParam String indexPattern) {
        return visualizationService.createIndexPattern(indexPattern);
    }
    
    /**
     * 创建仪表板
     */
    @PostMapping("/visualization/dashboard")
    public Map<String, Object> createDashboard(@RequestBody Map<String, Object> dashboardConfig) {
        return visualizationService.createDashboard(dashboardConfig);
    }
    
    /**
     * 获取仪表板列表
     */
    @GetMapping("/visualization/dashboards")
    public List<Map<String, Object>> getDashboards() {
        return visualizationService.getDashboards();
    }
    
    /**
     * 获取索引模式列表
     */
    @GetMapping("/visualization/index-patterns")
    public List<Map<String, Object>> getIndexPatterns() {
        return visualizationService.getIndexPatterns();
    }
    
    /**
     * 导出仪表板
     */
    @GetMapping("/visualization/dashboard/{dashboardId}/export")
    public Map<String, Object> exportDashboard(@PathVariable String dashboardId) {
        return visualizationService.exportDashboard(dashboardId);
    }
    
    /**
     * 导入仪表板
     */
    @PostMapping("/visualization/dashboard/import")
    public Map<String, Object> importDashboard(@RequestBody Map<String, Object> dashboardConfig) {
        return visualizationService.importDashboard(dashboardConfig);
    }
    
    /**
     * 获取存储统计信息
     */
    @GetMapping("/storage/statistics")
    public Map<String, Object> getStorageStatistics() {
        return storageService.getStatistics();
    }
}
