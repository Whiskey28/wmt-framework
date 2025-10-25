package com.wmt.framework.search.annotation;

import java.lang.annotation.*;

/**
 * 搜索注解，用于标记可搜索的实体类
 *
 * @author wmt
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Searchable {
    
    /**
     * 索引名称
     */
    String index();
    
    /**
     * 搜索字段
     */
    String[] fields() default {};
    
    /**
     * 是否启用自动索引
     */
    boolean autoIndex() default true;
    
    /**
     * 是否启用自动删除
     */
    boolean autoDelete() default true;
    
    /**
     * 索引设置
     */
    IndexSettings settings() default @IndexSettings;
    
    /**
     * 索引设置注解
     */
    @interface IndexSettings {
        /**
         * 分片数量
         */
        int shards() default 1;
        
        /**
         * 副本数量
         */
        int replicas() default 0;
        
        /**
         * 刷新间隔（秒）
         */
        int refreshInterval() default 1;
    }
}
