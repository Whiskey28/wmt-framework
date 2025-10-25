package com.wmt.framework.search.core;

import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Map;

/**
 * 搜索结果
 *
 * @author wmt
 */
@Data
@Accessors(chain = true)
public class SearchResult<T> {
    
    /**
     * 搜索结果列表
     */
    private List<T> records;
    
    /**
     * 总记录数
     */
    private Long total;
    
    /**
     * 当前页码
     */
    private Integer page;
    
    /**
     * 每页大小
     */
    private Integer size;
    
    /**
     * 总页数
     */
    private Integer totalPages;
    
    /**
     * 搜索耗时（毫秒）
     */
    private Long took;
    
    /**
     * 高亮结果
     */
    private Map<String, List<String>> highlights;
    
    /**
     * 聚合结果
     */
    private Map<String, Object> aggregations;
    
    /**
     * 搜索建议
     */
    private List<String> suggestions;
    
    /**
     * 是否超时
     */
    private Boolean timedOut;
    
    /**
     * 分片信息
     */
    private ShardInfo shardInfo;
    
    @Data
    @Accessors(chain = true)
    public static class ShardInfo {
        private Integer total;
        private Integer successful;
        private Integer skipped;
        private Integer failed;
    }
}
