package com.wmt.framework.esb.core;

import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.esb.core.model.EsbRetMsgArray;
import com.wmt.framework.esb.core.model.EsbSysHead;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

class EsbResponseHandlerTest {

    private final EsbResponseHandler handler = new EsbResponseHandler();

    @Test
    void checkSuccessOrThrow_shouldPassOnSuccess() {
        EsbSysHead sysHead = new EsbSysHead();
        sysHead.setTranRetSt(EsbResponseHandler.TRAN_RET_SUCCESS);
        EsbRetMsgArray retMsgArray = new EsbRetMsgArray();
        retMsgArray.setRetCd(EsbResponseHandler.SUCCESS_RET_CD);
        retMsgArray.setRetMsg("交易成功");
        sysHead.setRetMsgArray(retMsgArray);

        assertDoesNotThrow(() -> handler.checkSuccessOrThrow(sysHead));
    }

    @Test
    void checkSuccessOrThrow_shouldThrowOnFailure() {
        EsbSysHead sysHead = new EsbSysHead();
        sysHead.setTranRetSt("F");
        EsbRetMsgArray retMsgArray = new EsbRetMsgArray();
        retMsgArray.setRetCd("86100010000000553");
        retMsgArray.setRetMsg("柜员不存在");
        sysHead.setRetMsgArray(retMsgArray);

        assertThrows(ServiceException.class, () -> handler.checkSuccessOrThrow(sysHead));
    }

}
