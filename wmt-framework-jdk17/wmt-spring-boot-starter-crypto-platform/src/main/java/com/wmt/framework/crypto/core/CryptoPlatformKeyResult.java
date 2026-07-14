package com.wmt.framework.crypto.core;

import lombok.Builder;
import lombok.Data;

/**
 * 加密平台密钥操作结果（对 UnionCSSP.Recv 的稳定投影）。
 */
@Data
@Builder
public class CryptoPlatformKeyResult {

    /** 0 成功；负数 SDK/通讯异常；正数为平台业务错误码 */
    private int responseCode;

    private String responseRemark;

    /** 密钥名称（导入成功时可能回显） */
    private String keyName;

    /** 密钥校验值（导入时请求未上送 checkValue 时平台回填） */
    private String checkValue;

    public boolean isSuccess() {
        return responseCode == 0;
    }

}
