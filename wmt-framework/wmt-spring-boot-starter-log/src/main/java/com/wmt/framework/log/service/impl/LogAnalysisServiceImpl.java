package com.wmt.framework.log.service.impl;

import com.wmt.framework.log.config.WmtLogProperties;
import com.wmt.framework.log.model.LogAnalysisResult;
import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.service.LogAnalysisService;
import com.wmt.framework.log.service.LogStorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 日志分析服务实现
 *
 * @author WMT
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LogAnalysisServiceImpl implements LogAnalysisService {
    
    private final WmtLogProperties properties;
    private final LogStorageService storageService;
    
    @Override
    public LogAnalysisResult analyze(LocalDateTime startTime, LocalDateTime endTime) {
        if (!properties.getAnalysis().isEnabled()) {
            return null;
        }
        
        try {
            Map<String, Object> query = new HashMap<>();
            query.put("startTime", startTime);
            query.put("endTime", endTime);
            
            List<LogRecord> logs = storageService.query(query);
            
            LogAnalysisResult result = new LogAnalysisResult();
            result.setId(UUID.randomUUID().toString());
            result.setAnalysisType("comprehensive");
            result.setAnalysisTime(LocalDateTime.now());
            result.setStartTime(startTime);
            result.setEndTime(endTime);
            
            // 异常检测
            if (properties.getAnalysis().getExceptionDetection().isEnabled()) {
                result.setExceptionDetection(detectExceptions(startTime, endTime));
            }
            
            // 趋势分析
            if (properties.getAnalysis().getTrendAnalysis().isEnabled()) {
                result.setTrendAnalysis(analyzeTrend(startTime, endTime));
            }
            
            // 统计信息
            result.setStatistics(getStatistics(startTime, endTime));
            
            return result;
        } catch (Exception e) {
            log.error("日志分析失败", e);
            return null;
        }
    }
    
    @Override
    public LogAnalysisResult.ExceptionDetectionResult detectExceptions(LocalDateTime startTime, LocalDateTime endTime) {
        try {
            Map<String, Object> query = new HashMap<>();
            query.put("startTime", startTime);
            query.put("endTime", endTime);
            query.put("level", "ERROR");
            
            List<LogRecord> errorLogs = storageService.query(query);
            
            LogAnalysisResult.ExceptionDetectionResult result = new LogAnalysisResult.ExceptionDetectionResult();
            result.setHasException(!errorLogs.isEmpty());
            result.setExceptionCount(errorLogs.size());
            
            // 统计异常类型
            Map<String, Integer> exceptionTypes = errorLogs.stream()
                .collect(Collectors.groupingBy(
                    log -> log.getException() != null ? log.getException() : "Unknown",
                    Collectors.collectingAndThen(Collectors.counting(), Math::toIntExact)
                ));
            result.setExceptionTypes(exceptionTypes);
            
            // 简单的趋势判断
            if (errorLogs.size() > properties.getAnalysis().getExceptionDetection().getThreshold()) {
                result.setTrend("increasing");
            } else {
                result.setTrend("stable");
            }
            
            return result;
        } catch (Exception e) {
            log.error("异常检测失败", e);
            return new LogAnalysisResult.ExceptionDetectionResult();
        }
    }
    
    @Override
    public LogAnalysisResult.TrendAnalysisResult analyzeTrend(LocalDateTime startTime, LocalDateTime endTime) {
        try {
            Map<String, Object> query = new HashMap<>();
            query.put("startTime", startTime);
            query.put("endTime", endTime);
            
            List<LogRecord> logs = storageService.query(query);
            
            LogAnalysisResult.TrendAnalysisResult result = new LogAnalysisResult.TrendAnalysisResult();
            
            // 计算错误率趋势
            long totalLogs = logs.size();
            long errorLogs = logs.stream()
                .filter(log -> "ERROR".equals(log.getLevel()))
                .count();
            
            double errorRate = totalLogs > 0 ? (double) errorLogs / totalLogs : 0.0;
            
            if (errorRate > 0.1) {
                result.setErrorRateTrend("high");
            } else if (errorRate > 0.05) {
                result.setErrorRateTrend("medium");
            } else {
                result.setErrorRateTrend("low");
            }
            
            // 计算响应时间趋势
            List<Long> responseTimes = logs.stream()
                .filter(log -> log.getResponseTime() != null)
                .map(LogRecord::getResponseTime)
                .collect(Collectors.toList());
            
            if (!responseTimes.isEmpty()) {
                double avgResponseTime = responseTimes.stream()
                    .mapToLong(Long::longValue)
                    .average()
                    .orElse(0.0);
                
                if (avgResponseTime > 1000) {
                    result.setResponseTimeTrend("slow");
                } else if (avgResponseTime > 500) {
                    result.setResponseTimeTrend("medium");
                } else {
                    result.setResponseTimeTrend("fast");
                }
            } else {
                result.setResponseTimeTrend("unknown");
            }
            
            // 计算吞吐量趋势
            long durationMinutes = java.time.Duration.between(startTime, endTime).toMinutes();
            double throughput = durationMinutes > 0 ? (double) totalLogs / durationMinutes : 0.0;
            
            if (throughput > 100) {
                result.setThroughputTrend("high");
            } else if (throughput > 50) {
                result.setThroughputTrend("medium");
            } else {
                result.setThroughputTrend("low");
            }
            
            // 趋势数据点
            Map<String, Object> trendData = new HashMap<>();
            trendData.put("errorRate", errorRate);
            trendData.put("avgResponseTime", responseTimes.stream().mapToLong(Long::longValue).average().orElse(0.0));
            trendData.put("throughput", throughput);
            result.setTrendData(trendData);
            
            return result;
        } catch (Exception e) {
            log.error("趋势分析失败", e);
            return new LogAnalysisResult.TrendAnalysisResult();
        }
    }
    
    @Override
    public LogAnalysisResult.Statistics getStatistics(LocalDateTime startTime, LocalDateTime endTime) {
        try {
            Map<String, Object> query = new HashMap<>();
            query.put("startTime", startTime);
            query.put("endTime", endTime);
            
            List<LogRecord> logs = storageService.query(query);
            
            LogAnalysisResult.Statistics stats = new LogAnalysisResult.Statistics();
            stats.setTotalLogs(logs.size());
            stats.setErrorLogs(logs.stream().filter(log -> "ERROR".equals(log.getLevel())).count());
            stats.setWarnLogs(logs.stream().filter(log -> "WARN".equals(log.getLevel())).count());
            stats.setInfoLogs(logs.stream().filter(log -> "INFO".equals(log.getLevel())).count());
            
            // 响应时间统计
            List<Long> responseTimes = logs.stream()
                .filter(log -> log.getResponseTime() != null)
                .map(LogRecord::getResponseTime)
                .collect(Collectors.toList());
            
            if (!responseTimes.isEmpty()) {
                stats.setAvgResponseTime(responseTimes.stream().mapToLong(Long::longValue).average().orElse(0.0));
                stats.setMaxResponseTime(responseTimes.stream().mapToLong(Long::longValue).max().orElse(0L));
                stats.setMinResponseTime(responseTimes.stream().mapToLong(Long::longValue).min().orElse(0L));
            }
            
            return stats;
        } catch (Exception e) {
            log.error("获取统计信息失败", e);
            return new LogAnalysisResult.Statistics();
        }
    }
    
    @Override
    public List<LogAnalysisResult> getAnalysisHistory(int limit) {
        // 这里可以从数据库或缓存中获取分析历史
        // 简化实现，返回空列表
        return Collections.emptyList();
    }
}
