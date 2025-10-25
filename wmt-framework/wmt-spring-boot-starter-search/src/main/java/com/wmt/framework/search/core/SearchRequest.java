package com.wmt.framework.search.core;

import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Map;

/**
 * 搜索请求
 *
 * @author wmt
 */
@Data
@Accessors(chain = true)
public class SearchRequest {
    
    /**
     * 索引名称
     */
    private String index;
    
    /**
     * 搜索关键词
     */
    private String keyword;
    
    /**
     * 搜索字段
     */
    private List<String> fields;
    
    /**
     * 分页参数
     */
    private Integer page = 1;
    
    /**
     * 每页大小
     */
    private Integer size = 10;
    
    /**
     * 排序字段
     */
    private String sortField;
    
    /**
     * 排序方向 asc/desc
     */
    private String sortOrder = "desc";
    
    /**
     * 过滤条件
     */
    private Map<String, Object> filters;
    
    /**
     * 高亮字段
     */
    private List<String> highlightFields;
    
    /**
     * 聚合字段
     */
    private List<String> aggregationFields;
    
    /**
     * 是否启用搜索建议
     */
    private Boolean suggest = false;
    
    /**
     * 搜索类型：match、match_phrase、wildcard、fuzzy
     */
    private String searchType = "match";
    
    /**
     * 最小匹配度（用于fuzzy搜索）
     */
    private Integer fuzziness = 1;
}
