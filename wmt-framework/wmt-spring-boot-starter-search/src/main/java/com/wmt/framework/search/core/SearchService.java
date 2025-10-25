package com.wmt.framework.search.core;

import java.util.List;
import java.util.Map;

/**
 * 搜索服务接口
 *
 * @author wmt
 */
public interface SearchService {
    
    /**
     * 搜索文档
     *
     * @param request 搜索请求
     * @param clazz   返回类型
     * @param <T>     泛型类型
     * @return 搜索结果
     */
    <T> SearchResult<T> search(SearchRequest request, Class<T> clazz);
    
    /**
     * 索引文档
     *
     * @param index    索引名称
     * @param id       文档ID
     * @param document 文档内容
     */
    void index(String index, String id, Object document);
    
    /**
     * 批量索引文档
     *
     * @param index     索引名称
     * @param documents 文档列表
     */
    void indexBatch(String index, List<Map<String, Object>> documents);
    
    /**
     * 删除文档
     *
     * @param index 索引名称
     * @param id    文档ID
     */
    void delete(String index, String id);
    
    /**
     * 批量删除文档
     *
     * @param index 索引名称
     * @param ids   文档ID列表
     */
    void deleteBatch(String index, List<String> ids);
    
    /**
     * 根据查询条件删除文档
     *
     * @param index 索引名称
     * @param query 查询条件
     */
    void deleteByQuery(String index, Map<String, Object> query);
    
    /**
     * 更新文档
     *
     * @param index    索引名称
     * @param id       文档ID
     * @param document 文档内容
     */
    void update(String index, String id, Object document);
    
    /**
     * 批量更新文档
     *
     * @param index     索引名称
     * @param documents 文档列表
     */
    void updateBatch(String index, List<Map<String, Object>> documents);
    
    /**
     * 获取文档
     *
     * @param index 索引名称
     * @param id    文档ID
     * @param clazz 返回类型
     * @param <T>   泛型类型
     * @return 文档内容
     */
    <T> T get(String index, String id, Class<T> clazz);
    
    /**
     * 检查索引是否存在
     *
     * @param index 索引名称
     * @return 是否存在
     */
    boolean indexExists(String index);
    
    /**
     * 创建索引
     *
     * @param index 索引名称
     * @param mapping 索引映射
     */
    void createIndex(String index, Map<String, Object> mapping);
    
    /**
     * 删除索引
     *
     * @param index 索引名称
     */
    void deleteIndex(String index);
    
    /**
     * 刷新索引
     *
     * @param index 索引名称
     */
    void refreshIndex(String index);
    
    /**
     * 获取搜索建议
     *
     * @param index   索引名称
     * @param keyword 关键词
     * @param field   建议字段
     * @return 建议列表
     */
    List<String> getSuggestions(String index, String keyword, String field);
    
    /**
     * 获取热门搜索
     *
     * @param index 索引名称
     * @param size  返回数量
     * @return 热门搜索列表
     */
    List<String> getHotSearches(String index, Integer size);
    
    /**
     * 记录搜索日志
     *
     * @param index   索引名称
     * @param keyword 搜索关键词
     * @param userId  用户ID
     */
    void recordSearchLog(String index, String keyword, String userId);
}
