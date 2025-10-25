package com.wmt.framework.search.annotation;

import java.lang.annotation.*;

/**
 * 搜索字段注解，用于标记实体类中的搜索字段
 *
 * @author wmt
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface SearchField {
    
    /**
     * 字段名称（在ES中的字段名）
     */
    String name() default "";
    
    /**
     * 字段类型
     */
    FieldType type() default FieldType.TEXT;
    
    /**
     * 是否参与搜索
     */
    boolean searchable() default true;
    
    /**
     * 是否参与排序
     */
    boolean sortable() default false;
    
    /**
     * 是否参与聚合
     */
    boolean aggregatable() default false;
    
    /**
     * 是否存储
     */
    boolean stored() default true;
    
    /**
     * 分析器
     */
    String analyzer() default "standard";
    
    /**
     * 搜索分析器
     */
    String searchAnalyzer() default "standard";
    
    /**
     * 字段类型枚举
     */
    enum FieldType {
        TEXT("text"),
        KEYWORD("keyword"),
        LONG("long"),
        INTEGER("integer"),
        SHORT("short"),
        BYTE("byte"),
        DOUBLE("double"),
        FLOAT("float"),
        HALF_FLOAT("half_float"),
        SCALED_FLOAT("scaled_float"),
        DATE("date"),
        BOOLEAN("boolean"),
        BINARY("binary"),
        RANGE("range"),
        OBJECT("object"),
        NESTED("nested"),
        GEO_POINT("geo_point"),
        GEO_SHAPE("geo_shape"),
        IP("ip"),
        COMPLETION("completion"),
        TOKEN_COUNT("token_count"),
        MURMUR3("murmur3");
        
        private final String value;
        
        FieldType(String value) {
            this.value = value;
        }
        
        public String getValue() {
            return value;
        }
    }
}
