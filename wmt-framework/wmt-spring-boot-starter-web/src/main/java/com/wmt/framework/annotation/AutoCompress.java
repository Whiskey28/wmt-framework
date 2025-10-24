package com.wmt.framework.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 自动压缩注解
 * 根据前端的Accept-Encoding情况自动选择压缩形式
 * 如果压缩形式都存在，首选brotli压缩，其次gzip
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AutoCompress {
    
    /**
     * 最小压缩阈值（字节），默认2MB
     */
    int minSize() default 2048 * 1024;
}
