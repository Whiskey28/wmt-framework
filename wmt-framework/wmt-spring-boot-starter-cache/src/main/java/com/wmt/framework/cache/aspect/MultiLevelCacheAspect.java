package com.wmt.framework.cache.aspect;

import com.wmt.framework.cache.annotation.MultiLevelCache;
import com.wmt.framework.cache.core.MultiLevelCacheManager;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.DefaultParameterNameDiscoverer;
import org.springframework.expression.EvaluationContext;
import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.lang.reflect.Method;
import java.time.Duration;

/**
 * 多级缓存切面处理器
 *
 * @author Wmt
 */
@Slf4j
@Aspect
@Component
@ConditionalOnProperty(prefix = "wmt.cache.multi-level", name = "enabled", havingValue = "true")
public class MultiLevelCacheAspect {

    @Resource
    private MultiLevelCacheManager cacheManager;

    private final ExpressionParser parser = new SpelExpressionParser();
    private final DefaultParameterNameDiscoverer nameDiscoverer = new DefaultParameterNameDiscoverer();

    @Around("@annotation(multiLevelCache)")
    public Object around(ProceedingJoinPoint joinPoint, MultiLevelCache multiLevelCache) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        Object[] args = joinPoint.getArgs();

        // 构建缓存键
        String cacheKey = buildCacheKey(multiLevelCache.key(), method, args);
        log.debug("多级缓存处理，方法: {}, 缓存键: {}", method.getName(), cacheKey);

        // 检查缓存条件
        if (!evaluateCondition(multiLevelCache.condition(), method, args)) {
            log.debug("缓存条件不满足，直接执行方法: {}", method.getName());
            return joinPoint.proceed();
        }

        // 从缓存获取
        Object result = cacheManager.get(cacheKey, Object.class, () -> {
            try {
                return joinPoint.proceed();
            } catch (Throwable throwable) {
                throw new RuntimeException(throwable);
            }
        });

        // 检查更新条件
        if (result != null && !evaluateCondition(multiLevelCache.unless(), method, args)) {
            log.debug("缓存更新条件不满足，更新缓存: {}", cacheKey);
            cacheManager.put(cacheKey, result);
        }

        return result;
    }

    /**
     * 构建缓存键
     */
    private String buildCacheKey(String keyExpression, Method method, Object[] args) {
        if (keyExpression.startsWith("#")) {
            // 使用SpEL表达式构建键
            Expression expression = parser.parseExpression(keyExpression);
            EvaluationContext context = new StandardEvaluationContext();
            
            // 设置方法参数
            String[] paramNames = nameDiscoverer.getParameterNames(method);
            if (paramNames != null) {
                for (int i = 0; i < paramNames.length; i++) {
                    context.setVariable(paramNames[i], args[i]);
                }
            }
            
            Object keyValue = expression.getValue(context);
            return String.valueOf(keyValue);
        } else {
            // 直接使用字符串作为键
            return keyExpression;
        }
    }

    /**
     * 评估条件表达式
     */
    private boolean evaluateCondition(String condition, Method method, Object[] args) {
        if (condition == null || condition.trim().isEmpty()) {
            return true;
        }

        try {
            Expression expression = parser.parseExpression(condition);
            EvaluationContext context = new StandardEvaluationContext();
            
            // 设置方法参数
            String[] paramNames = nameDiscoverer.getParameterNames(method);
            if (paramNames != null) {
                for (int i = 0; i < paramNames.length; i++) {
                    context.setVariable(paramNames[i], args[i]);
                }
            }
            
            Boolean result = expression.getValue(context, Boolean.class);
            return result != null && result;
        } catch (Exception e) {
            log.warn("条件表达式评估失败: {}", condition, e);
            return true;
        }
    }

}
