package com.wmt.framework.search.aspect;

import com.wmt.framework.search.annotation.Searchable;
import com.wmt.framework.search.core.SearchService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

/**
 * 搜索切面，自动处理搜索索引
 *
 * @author wmt
 */
@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class SearchAspect {
    
    private final SearchService searchService;
    
    /**
     * 保存实体后自动索引
     */
    @AfterReturning(pointcut = "@annotation(org.springframework.data.jpa.repository.Modifying) && " +
            "execution(* com..*.save(..))", returning = "result")
    public void afterSave(JoinPoint joinPoint, Object result) {
        if (result != null) {
            indexEntity(result);
        }
    }
    
    /**
     * 更新实体后自动索引
     */
    @AfterReturning(pointcut = "@annotation(org.springframework.data.jpa.repository.Modifying) && " +
            "execution(* com..*.update*(..))", returning = "result")
    public void afterUpdate(JoinPoint joinPoint, Object result) {
        if (result != null) {
            indexEntity(result);
        }
    }
    
    /**
     * 删除实体后自动删除索引
     */
    @AfterReturning(pointcut = "@annotation(org.springframework.data.jpa.repository.Modifying) && " +
            "execution(* com..*.delete*(..))")
    public void afterDelete(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        if (args.length > 0) {
            Object entity = args[0];
            deleteEntityFromIndex(entity);
        }
    }
    
    /**
     * 索引实体
     */
    private void indexEntity(Object entity) {
        try {
            Searchable searchable = entity.getClass().getAnnotation(Searchable.class);
            if (searchable == null) {
                return;
            }
            
            String index = searchable.index();
            String id = getId(entity);
            Map<String, Object> document = convertToDocument(entity);
            
            searchService.index(index, id, document);
            log.debug("自动索引实体: {} -> {}", entity.getClass().getSimpleName(), id);
        } catch (Exception e) {
            log.error("自动索引实体失败", e);
        }
    }
    
    /**
     * 从索引中删除实体
     */
    private void deleteEntityFromIndex(Object entity) {
        try {
            Searchable searchable = entity.getClass().getAnnotation(Searchable.class);
            if (searchable == null) {
                return;
            }
            
            String index = searchable.index();
            String id = getId(entity);
            
            searchService.delete(index, id);
            log.debug("自动删除索引实体: {} -> {}", entity.getClass().getSimpleName(), id);
        } catch (Exception e) {
            log.error("自动删除索引实体失败", e);
        }
    }
    
    /**
     * 获取实体ID
     */
    private String getId(Object entity) {
        try {
            // 尝试获取id字段
            Field idField = entity.getClass().getDeclaredField("id");
            idField.setAccessible(true);
            Object idValue = idField.get(entity);
            return idValue != null ? idValue.toString() : null;
        } catch (Exception e) {
            // 如果没有id字段，使用hashCode
            return String.valueOf(entity.hashCode());
        }
    }
    
    /**
     * 转换实体为文档
     */
    private Map<String, Object> convertToDocument(Object entity) {
        Map<String, Object> document = new HashMap<>();
        
        Field[] fields = entity.getClass().getDeclaredFields();
        for (Field field : fields) {
            try {
                field.setAccessible(true);
                Object value = field.get(entity);
                
                if (value != null) {
                    String fieldName = getFieldName(field);
                    document.put(fieldName, value);
                }
            } catch (Exception e) {
                log.warn("转换字段失败: {}", field.getName(), e);
            }
        }
        
        return document;
    }
    
    /**
     * 获取字段名称
     */
    private String getFieldName(Field field) {
        com.wmt.framework.search.annotation.SearchField searchField = 
                field.getAnnotation(com.wmt.framework.search.annotation.SearchField.class);
        
        if (searchField != null && !searchField.name().isEmpty()) {
            return searchField.name();
        }
        
        return field.getName();
    }
}
