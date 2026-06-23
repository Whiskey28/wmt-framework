package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import org.springframework.util.StringUtils;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * ESB 19 位流水号生成器。
 *
 * <p>规则：系统 ID(7) + 保留(00) + 组合位(0) + 前段(2) + 外围标志(9) + 后段(6)。</p>
 * <p>生产环境如需满足「3 天内不重复」，请替换为 Redis/DB 等持久化实现。</p>
 */
public class EsbSequenceService {

    private static final String PERIPHERAL_FLAG = "9";

    private final EsbProperties properties;

    private final AtomicInteger frontSegment = new AtomicInteger(0);

    private final AtomicInteger backSegment = new AtomicInteger(0);

    public EsbSequenceService(EsbProperties properties) {
        this.properties = properties;
    }

    /**
     * 生成调用方系统流水号 CnsmSysSeqNo。
     */
    public String nextCnsmSysSeqNo() {
        return nextSequence();
    }

    /**
     * 生成源发起系统流水号 SrcSysSeqNo；单笔直连 ESB 场景可与 CnsmSysSeqNo 相同。
     */
    public String nextSrcSysSeqNo() {
        return nextSequence();
    }

    private String nextSequence() {
        String systemId = normalizeSystemId(properties.getCnsmSysId());
        int front = frontSegment.updateAndGet(value -> value >= 99 ? 0 : value + 1);
        int back = backSegment.updateAndGet(value -> value >= 999_999 ? 0 : value + 1);
        return systemId + "00" + "0"
                + String.format("%02d", front)
                + PERIPHERAL_FLAG
                + String.format("%06d", back);
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
