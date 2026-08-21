package com.wmt.framework.esb.core;

import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import com.wmt.framework.esb.core.model.EsbSysHead;
import org.springframework.util.StringUtils;

import java.util.Set;

/**
 * 统一解析 ESB 响应 SysHead 中的 {@code TranRetSt} / {@code RetCd}。
 *
 * <p>成功码因提供方而异：信贷/CFCA 等为 {@code 000000}，DMCP/外部统一接入为 {@code 00000}。</p>
 */
public class EsbResponseHandler {

    /** 信贷 / CFCA 等 SysHead 成功码 */
    public static final String SUCCESS_RET_CD = "000000";

    /** DMCP / 外部统一接入 SysHead 成功码 */
    public static final String SUCCESS_RET_CD_DMCP = "00000";

    public static final Set<String> SUCCESS_RET_CDS = Set.of(SUCCESS_RET_CD, SUCCESS_RET_CD_DMCP);

    public static final String TRAN_RET_SUCCESS = "S";

    /**
     * 判定交易是否成功；失败时抛出 {@link ServiceException}，消息优先取 RetMsg。
     */
    public void checkSuccessOrThrow(EsbSysHead sysHead) {
        if (sysHead == null) {
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "ESB 响应缺少 SysHead");
        }
        if (isSuccess(sysHead)) {
            return;
        }
        String retCd = sysHead.resolveRetCd();
        String retMsg = sysHead.resolveRetMsg();
        if (!StringUtils.hasText(retMsg)) {
            retMsg = "ESB 交易失败";
        }
        if (StringUtils.hasText(retCd)) {
            retMsg = retCd + ": " + retMsg;
        }
        throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(), retMsg);
    }

    public boolean isSuccess(EsbSysHead sysHead) {
        if (sysHead == null) {
            return false;
        }
        return TRAN_RET_SUCCESS.equals(sysHead.getTranRetSt())
                && SUCCESS_RET_CDS.contains(sysHead.resolveRetCd());
    }

}
