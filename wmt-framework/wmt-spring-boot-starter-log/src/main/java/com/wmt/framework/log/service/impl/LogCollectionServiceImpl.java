package com.wmt.framework.log.service.impl;

import com.wmt.framework.log.config.WmtLogProperties;
import com.wmt.framework.log.model.LogRecord;
import com.wmt.framework.log.service.LogCollectionService;
import com.wmt.framework.log.service.LogStorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 日志收集服务实现
 *
 * @author WMT
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LogCollectionServiceImpl implements LogCollectionService {
    
    private final WmtLogProperties properties;
    private final LogStorageService storageService;
    
    private BlockingQueue<LogRecord> logQueue;
    private volatile boolean running = false;
    private final AtomicLong collectedCount = new AtomicLong(0);
    private final AtomicLong errorCount = new AtomicLong(0);
    
    @PostConstruct
    public void init() {
        if (properties.getCollection().isEnabled()) {
            logQueue = new LinkedBlockingQueue<>(properties.getCollection().getQueueSize());
            start();
        }
    }
    
    @PreDestroy
    public void destroy() {
        stop();
    }
    
    @Override
    public void collect(LogRecord logRecord) {
        if (!properties.getCollection().isEnabled()) {
            return;
        }
        
        try {
            // 过滤日志级别
            if (!properties.getCollection().getLevels().contains(logRecord.getLevel())) {
                return;
            }
            
            // 过滤日志来源
            if (!properties.getCollection().getSources().contains(logRecord.getSource())) {
                return;
            }
            
            if (properties.getCollection().isAsync()) {
                // 异步收集
                if (!logQueue.offer(logRecord)) {
                    log.warn("日志队列已满，丢弃日志: {}", logRecord.getId());
                }
            } else {
                // 同步收集
                storageService.store(logRecord);
                collectedCount.incrementAndGet();
            }
        } catch (Exception e) {
            errorCount.incrementAndGet();
            log.error("收集日志失败: {}", logRecord.getId(), e);
        }
    }
    
    @Override
    public void collectBatch(List<LogRecord> logRecords) {
        if (!properties.getCollection().isEnabled()) {
            return;
        }
        
        try {
            if (properties.getCollection().isAsync()) {
                // 异步批量收集
                for (LogRecord logRecord : logRecords) {
                    collect(logRecord);
                }
            } else {
                // 同步批量收集
                storageService.storeBatch(logRecords);
                collectedCount.addAndGet(logRecords.size());
            }
        } catch (Exception e) {
            errorCount.incrementAndGet();
            log.error("批量收集日志失败", e);
        }
    }
    
    @Override
    public void start() {
        if (running) {
            return;
        }
        
        running = true;
        log.info("启动日志收集服务");
        
        // 启动异步处理线程
        if (properties.getCollection().isAsync()) {
            startAsyncProcessor();
        }
    }
    
    @Override
    public void stop() {
        if (!running) {
            return;
        }
        
        running = false;
        log.info("停止日志收集服务");
        
        // 处理剩余日志
        if (logQueue != null && !logQueue.isEmpty()) {
            log.info("处理剩余日志: {} 条", logQueue.size());
            List<LogRecord> remainingLogs = Collections.emptyList();
            logQueue.drainTo(remainingLogs);
            if (!remainingLogs.isEmpty()) {
                storageService.storeBatch(remainingLogs);
            }
        }
    }
    
    @Override
    public Map<String, Object> getStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("enabled", properties.getCollection().isEnabled());
        status.put("running", running);
        status.put("async", properties.getCollection().isAsync());
        status.put("queueSize", logQueue != null ? logQueue.size() : 0);
        status.put("collectedCount", collectedCount.get());
        status.put("errorCount", errorCount.get());
        return status;
    }
    
    /**
     * 启动异步处理器
     */
    private void startAsyncProcessor() {
        Thread processorThread = new Thread(() -> {
            while (running) {
                try {
                    List<LogRecord> batch = Collections.emptyList();
                    int batchSize = properties.getCollection().getBatchSize();
                    
                    // 批量取出日志
                    for (int i = 0; i < batchSize; i++) {
                        LogRecord logRecord = logQueue.poll();
                        if (logRecord == null) {
                            break;
                        }
                        batch.add(logRecord);
                    }
                    
                    if (!batch.isEmpty()) {
                        storageService.storeBatch(batch);
                        collectedCount.addAndGet(batch.size());
                    } else {
                        // 队列为空，短暂休眠
                        Thread.sleep(100);
                    }
                } catch (Exception e) {
                    errorCount.incrementAndGet();
                    log.error("异步处理日志失败", e);
                }
            }
        }, "log-collection-processor");
        
        processorThread.setDaemon(true);
        processorThread.start();
    }
}
