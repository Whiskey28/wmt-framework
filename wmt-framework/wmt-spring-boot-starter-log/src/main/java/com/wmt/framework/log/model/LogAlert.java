package com.wmt.framework.log.model;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 日志告警模型
 *
 * @author WMT
 */
@Data
public class LogAlert {
    
    /**
     * 告警ID
     */
    private String id;
    
    /**
     * 告警规则名称
     */
    private String ruleName;
    
    /**
     * 告警级别
     */
    private String level;
    
    /**
     * 告警标题
     */
    private String title;
    
    /**
     * 告警内容
     */
    private String content;
    
    /**
     * 告警时间
     */
    private LocalDateTime alertTime;
    
    /**
     * 触发条件
     */
    private String condition;
    
    /**
     * 实际值
     */
    private Object actualValue;
    
    /**
     * 阈值
     */
    private Object threshold;
    
    /**
     * 告警状态
     */
    private String status;
    
    /**
     * 处理人
     */
    private String handler;
    
    /**
     * 处理时间
     */
    private LocalDateTime handleTime;
    
    /**
     * 处理备注
     */
    private String handleNote;
    
    /**
     * 相关日志ID列表
     */
    private String[] relatedLogIds;
    
    /**
     * 额外信息
     */
    private Map<String, Object> extra;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}
