package com.wmt.framework.log.service;

import com.wmt.framework.log.model.LogAnalysisResult;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 日志分析服务接口
 *
 * @author WMT
 */
public interface LogAnalysisService {
    
    /**
     * 执行日志分析
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 分析结果
     */
    LogAnalysisResult analyze(LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * 异常检测
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 异常检测结果
     */
    LogAnalysisResult.ExceptionDetectionResult detectExceptions(LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * 趋势分析
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 趋势分析结果
     */
    LogAnalysisResult.TrendAnalysisResult analyzeTrend(LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * 统计信息
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    LogAnalysisResult.Statistics getStatistics(LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * 获取分析历史
     *
     * @param limit 限制数量
     * @return 分析历史列表
     */
    List<LogAnalysisResult> getAnalysisHistory(int limit);
}
