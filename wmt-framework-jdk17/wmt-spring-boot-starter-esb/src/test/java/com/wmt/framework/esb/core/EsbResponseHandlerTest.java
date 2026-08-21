package com.wmt.framework.esb.core;

import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.esb.core.model.EsbRetMsgArray;
import com.wmt.framework.esb.core.model.EsbSysHead;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class EsbResponseHandlerTest {

    private final EsbResponseHandler handler = new EsbResponseHandler();

    @Test
    void checkSuccessOrThrow_shouldPassOnCreditSuccessRetCd() {
        assertDoesNotThrow(() -> handler.checkSuccessOrThrow(
                sysHead(EsbResponseHandler.TRAN_RET_SUCCESS, EsbResponseHandler.SUCCESS_RET_CD, "成功")));
    }

    @Test
    void checkSuccessOrThrow_shouldPassOnDmcpSuccessRetCd() {
        assertDoesNotThrow(() -> handler.checkSuccessOrThrow(
                sysHead(EsbResponseHandler.TRAN_RET_SUCCESS, EsbResponseHandler.SUCCESS_RET_CD_DMCP, "调用成功")));
    }

    @Test
    void checkSuccessOrThrow_shouldThrowOnFailure() {
        assertThrows(ServiceException.class, () -> handler.checkSuccessOrThrow(
                sysHead("F", "86100010000000553", "柜员不存在")));
    }

    @Test
    void isSuccess_shouldRejectSuccessStatusWithUnknownRetCd() {
        assertFalse(handler.isSuccess(sysHead(EsbResponseHandler.TRAN_RET_SUCCESS, "30001", "接口请求超时")));
    }

    @Test
    void isSuccess_shouldAcceptBothKnownSuccessRetCds() {
        assertTrue(handler.isSuccess(
                sysHead(EsbResponseHandler.TRAN_RET_SUCCESS, EsbResponseHandler.SUCCESS_RET_CD, "成功")));
        assertTrue(handler.isSuccess(
                sysHead(EsbResponseHandler.TRAN_RET_SUCCESS, EsbResponseHandler.SUCCESS_RET_CD_DMCP, "调用成功")));
    }

    private static EsbSysHead sysHead(String tranRetSt, String retCd, String retMsg) {
        EsbSysHead sysHead = new EsbSysHead();
        sysHead.setTranRetSt(tranRetSt);
        EsbRetMsgArray retMsgArray = new EsbRetMsgArray();
        retMsgArray.setRetCd(retCd);
        retMsgArray.setRetMsg(retMsg);
        sysHead.setRetMsgArray(retMsgArray);
        return sysHead;
    }

}
