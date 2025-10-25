package com.wmt.framework.cache.annotation;

import java.lang.annotation.*;

/**
 * 多级缓存注解
 * 支持L1(本地缓存) + L2(Redis缓存) + L3(数据库)的三级缓存
 *
 * @author Wmt
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MultiLevelCache {

    /**
     * 缓存键，支持SpEL表达式
     * 例如: "#userId", "#user.id", "#user.name + ':' + #user.id"
     */
    String key();

    /**
     * 缓存级别，支持的值: local, redis, database
     * 默认使用所有级别
     */
    String[] levels() default {"local", "redis", "database"};

    /**
     * 缓存过期时间
     * 格式: 数字+单位，支持的单位: d(天), h(小时), m(分钟), s(秒)
     * 例如: "1h", "30m", "3600s"
     */
    String ttl() default "1h";

    /**
     * 是否缓存空值，防止缓存穿透
     */
    boolean cacheNull() default true;

    /**
     * 空值缓存时间
     */
    String nullTtl() default "5m";

    /**
     * 缓存条件，支持SpEL表达式
     * 只有条件为true时才缓存
     */
    String condition() default "";

    /**
     * 缓存更新条件，支持SpEL表达式
     * 只有条件为true时才更新缓存
     */
    String unless() default "";

    /**
     * 缓存描述
     */
    String description() default "";
}
