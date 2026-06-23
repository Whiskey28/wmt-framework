package com.wmt.framework.esb.core;

import com.wmt.framework.esb.core.model.EsbAppHead;
import lombok.Builder;
import lombok.Data;

/**
 * 单次 ESB 调用的可选覆盖项（服务码、流水号、AppHead 等）。
 */
@Data
@Builder
public class EsbInvokeOptions {

    private String svcCd;

    private String svcScn;

    private EsbAppHead appHead;

    /**
     * 源发起系统流水号；跨系统业务链路应透传同一值
     */
    private String srcSysSeqNo;

    /**
     * 调用方系统流水号；默认每次调用自动生成
     */
    private String cnsmSysSeqNo;

    private String chnlTp;

    private String fileFlg;

    private String filePath;

    public static EsbInvokeOptions of(String svcCd, String svcScn) {
        return EsbInvokeOptions.builder().svcCd(svcCd).svcScn(svcScn).build();
    }

}
