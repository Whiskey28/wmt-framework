package com.wmt.framework.log.service;

import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.model.LogAnalysisResult;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 日志存储服务接口
 *
 * @author WMT
 */
public interface LogStorageService {
    
    /**
     * 存储日志
     *
     * @param logRecord 日志记录
     */
    void store(LogRecord logRecord);
    
    /**
     * 批量存储日志
     *
     * @param logRecords 日志记录列表
     */
    void storeBatch(List<LogRecord> logRecords);
    
    /**
     * 查询日志
     *
     * @param query 查询条件
     * @return 日志记录列表
     */
    List<LogRecord> query(Map<String, Object> query);
    
    /**
     * 分页查询日志
     *
     * @param query 查询条件
     * @param page 页码
     * @param size 页大小
     * @return 分页结果
     */
    Map<String, Object> queryPage(Map<String, Object> query, int page, int size);
    
    /**
     * 删除过期日志
     *
     * @param beforeTime 删除此时间之前的日志
     * @return 删除数量
     */
    long deleteExpiredLogs(LocalDateTime beforeTime);
    
    /**
     * 获取存储统计信息
     *
     * @return 统计信息
     */
    Map<String, Object> getStatistics();
}
