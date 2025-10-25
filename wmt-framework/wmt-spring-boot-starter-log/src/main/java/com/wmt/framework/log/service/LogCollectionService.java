package com.wmt.framework.log.service;

import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.model.LogAnalysisResult;
import com.wmt.framework.log.model.LogAlert;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 日志收集服务接口
 *
 * @author WMT
 */
public interface LogCollectionService {
    
    /**
     * 收集日志
     *
     * @param logRecord 日志记录
     */
    void collect(LogRecord logRecord);
    
    /**
     * 批量收集日志
     *
     * @param logRecords 日志记录列表
     */
    void collectBatch(List<LogRecord> logRecords);
    
    /**
     * 启动收集服务
     */
    void start();
    
    /**
     * 停止收集服务
     */
    void stop();
    
    /**
     * 获取收集状态
     *
     * @return 收集状态信息
     */
    Map<String, Object> getStatus();
}
