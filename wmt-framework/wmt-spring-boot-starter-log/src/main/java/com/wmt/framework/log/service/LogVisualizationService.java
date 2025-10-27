package com.wmt.framework.log.service;

import java.util.List;
import java.util.Map;

/**
 * 日志可视化服务接口
 *
 * @author WMT
 */
public interface LogVisualizationService {
    
    /**
     * 创建Kibana索引模式
     *
     * @param indexPattern 索引模式
     * @return 创建结果
     */
    Map<String, Object> createIndexPattern(String indexPattern);
    
    /**
     * 创建仪表板
     *
     * @param dashboardConfig 仪表板配置
     * @return 创建结果
     */
    Map<String, Object> createDashboard(Map<String, Object> dashboardConfig);
    
    /**
     * 获取可视化数据
     *
     * @param query 查询条件
     * @return 可视化数据
     */
    Map<String, Object> getVisualizationData(Map<String, Object> query);
    
    /**
     * 获取仪表板列表
     *
     * @return 仪表板列表
     */
    List<Map<String, Object>> getDashboards();
    
    /**
     * 获取索引模式列表
     *
     * @return 索引模式列表
     */
    List<Map<String, Object>> getIndexPatterns();
    
    /**
     * 导出仪表板配置
     *
     * @param dashboardId 仪表板ID
     * @return 仪表板配置
     */
    Map<String, Object> exportDashboard(String dashboardId);
    
    /**
     * 导入仪表板配置
     *
     * @param dashboardConfig 仪表板配置
     * @return 导入结果
     */
    Map<String, Object> importDashboard(Map<String, Object> dashboardConfig);
}
