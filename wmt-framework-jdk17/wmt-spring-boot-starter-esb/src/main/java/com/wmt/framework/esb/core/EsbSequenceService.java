package com.wmt.framework.esb.core;

import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import com.wmt.framework.esb.config.EsbProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.util.StringUtils;

import java.util.concurrent.atomic.AtomicLong;

/**
 * ESB 19 位流水号生成器。
 *
 * <p>规则：系统 ID(7) + 保留(00) + 组合位(0) + 前段(2) + 外围标志(9) + 后段(6)。</p>
 * <p>优先 Redis {@code INCR}（键 {@code esb:seq:{cnsmSysId}}），保证重启/多实例不撞号；
 * 无 Redis Bean 时回退进程内计数并打 WARN（仅适合单测/无 Redis 本地）。</p>
 */
@Slf4j
public class EsbSequenceService {

    private static final String PERIPHERAL_FLAG = "9";

    static final String REDIS_KEY_PREFIX = "esb:seq:";

    private final EsbProperties properties;

    private final StringRedisTemplate stringRedisTemplate;

    private final AtomicLong memoryCounter = new AtomicLong(0);

    private final boolean redisEnabled;

    public EsbSequenceService(EsbProperties properties) {
        this(properties, null);
    }

    public EsbSequenceService(EsbProperties properties, StringRedisTemplate stringRedisTemplate) {
        this.properties = properties;
        this.stringRedisTemplate = stringRedisTemplate;
        this.redisEnabled = stringRedisTemplate != null;
        if (!redisEnabled) {
            log.warn("[esb] EsbSequenceService 未注入 StringRedisTemplate，流水号使用进程内存计数；"
                    + "重启后会从 0 回绕，生产/联调请确保 Redis 可用");
        }
    }

    /**
     * 生成调用方系统流水号 CnsmSysSeqNo（使用配置的 {@code wmt.esb.cnsm-sys-id}）。
     */
    public String nextCnsmSysSeqNo() {
        return nextSequence(properties.getCnsmSysId());
    }

    /**
     * 生成调用方系统流水号（显式系统 ID，供联盟覆盖等场景）。
     */
    public String nextCnsmSysSeqNo(String systemId) {
        return nextSequence(systemId);
    }

    /**
     * 生成源发起系统流水号 SrcSysSeqNo。
     *
     * <p>单笔直连 ESB 时通常与 {@link #nextCnsmSysSeqNo()} 相同；
     * {@link EsbClient} 组头时只取一次号并同时赋给两者，避免一次请求连跳两号。</p>
     */
    public String nextSrcSysSeqNo() {
        return nextSequence(properties.getCnsmSysId());
    }

    /**
     * 生成源发起系统流水号（显式系统 ID）。
     */
    public String nextSrcSysSeqNo(String systemId) {
        return nextSequence(systemId);
    }

    private String nextSequence(String systemIdRaw) {
        String systemId = normalizeSystemId(systemIdRaw);
        long n = nextCounter(systemId);
        int front = (int) (n % 100);
        int back = (int) (n % 1_000_000L);
        return systemId + "00" + "0"
                + String.format("%02d", front)
                + PERIPHERAL_FLAG
                + String.format("%06d", back);
    }

    private long nextCounter(String systemId) {
        if (redisEnabled) {
            try {
                Long value = stringRedisTemplate.opsForValue().increment(REDIS_KEY_PREFIX + systemId);
                if (value == null || value <= 0) {
                    throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                            "ESB Redis 流水号 INCR 返回非法值: " + value);
                }
                return value;
            } catch (ServiceException ex) {
                throw ex;
            } catch (Exception ex) {
                throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                        "ESB Redis 流水号生成失败: " + ex.getMessage());
            }
        }
        return memoryCounter.incrementAndGet();
    }

    static String normalizeSystemId(String systemId) {
        if (!StringUtils.hasText(systemId)) {
            throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                    "ESB 系统 ID（wmt.esb.cnsm-sys-id）未配置或为空");
        }
        String trimmed = systemId.trim();
        if (trimmed.length() != 7) {
            throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                    "ESB 系统 ID 必须为 7 位，当前=" + trimmed);
        }
        return trimmed;
    }

}
