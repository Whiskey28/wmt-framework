package com.wmt.framework.log.model;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 日志分析结果模型
 *
 * @author WMT
 */
@Data
public class LogAnalysisResult {
    
    /**
     * 分析ID
     */
    private String id;
    
    /**
     * 分析类型
     */
    private String analysisType;
    
    /**
     * 分析时间
     */
    private LocalDateTime analysisTime;
    
    /**
     * 时间范围开始
     */
    private LocalDateTime startTime;
    
    /**
     * 时间范围结束
     */
    private LocalDateTime endTime;
    
    /**
     * 分析结果
     */
    private Map<String, Object> result;
    
    /**
     * 异常检测结果
     */
    private ExceptionDetectionResult exceptionDetection;
    
    /**
     * 趋势分析结果
     */
    private TrendAnalysisResult trendAnalysis;
    
    /**
     * 统计信息
     */
    private Statistics statistics;
    
    @Data
    public static class ExceptionDetectionResult {
        /**
         * 是否检测到异常
         */
        private boolean hasException;
        
        /**
         * 异常数量
         */
        private int exceptionCount;
        
        /**
         * 异常类型
         */
        private Map<String, Integer> exceptionTypes;
        
        /**
         * 异常趋势
         */
        private String trend;
    }
    
    @Data
    public static class TrendAnalysisResult {
        /**
         * 错误率趋势
         */
        private String errorRateTrend;
        
        /**
         * 响应时间趋势
         */
        private String responseTimeTrend;
        
        /**
         * 吞吐量趋势
         */
        private String throughputTrend;
        
        /**
         * 趋势数据点
         */
        private Map<String, Object> trendData;
    }
    
    @Data
    public static class Statistics {
        /**
         * 总日志数
         */
        private long totalLogs;
        
        /**
         * 错误日志数
         */
        private long errorLogs;
        
        /**
         * 警告日志数
         */
        private long warnLogs;
        
        /**
         * 信息日志数
         */
        private long infoLogs;
        
        /**
         * 平均响应时间
         */
        private double avgResponseTime;
        
        /**
         * 最大响应时间
         */
        private long maxResponseTime;
        
        /**
         * 最小响应时间
         */
        private long minResponseTime;
    }
}
