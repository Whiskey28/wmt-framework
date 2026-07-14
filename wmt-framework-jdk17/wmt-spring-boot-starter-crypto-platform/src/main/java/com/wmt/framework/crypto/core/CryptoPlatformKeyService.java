package com.wmt.framework.crypto.core;

import com.union.api.UnionCSSP;
import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

/**
 * 加密平台密钥服务：封装 Union CSSP 对称密钥导入/删除。
 *
 * <p>对照《企业服务总线 MAC 加密流程》：密钥同步交易拿到 PIK/MAK 后，
 * 调用本服务 {@link #importSymmetricKey} 写入行内加密机。</p>
 *
 * <p>日常联盟 MAC 计算由行内 ESB 完成，业务热路径不应调用本服务。</p>
 */
@Slf4j
public class CryptoPlatformKeyService {

    /** LMK 保护导入（MAC 文档密钥同步后常用） */
    public static final String PROTECT_FLAG_LMK = "3";

    private final UnionCSSP cssp;

    public CryptoPlatformKeyService(UnionCSSP cssp) {
        this.cssp = cssp;
    }

    /**
     * 导入对称密钥到加密机（E112）。
     *
     * @param keyName     密钥名称，如 {@code DMPF.861BY861XXXX.zak}
     * @param keyValue    密钥密文（HEX）
     * @param checkValue  校验值，可空
     * @param protectFlag 保护方式：1 指定密钥名 / 2 外带 ZMK / 3 LMK
     * @param protectKey  保护密钥（protectFlag=1 时为名称；=2 时为值；=3 时可空）
     * @param activeDate  生效日期 yyyyMMdd，可空表示当前
     */
    public CryptoPlatformKeyResult importSymmetricKey(String keyName,
                                                      String keyValue,
                                                      String checkValue,
                                                      String protectFlag,
                                                      String protectKey,
                                                      String activeDate) {
        requireText(keyName, "keyName");
        requireText(keyValue, "keyValue");
        requireText(protectFlag, "protectFlag");

        log.info("[crypto-platform] E112 import keyName={} protectFlag={}", keyName, protectFlag);
        UnionCSSP.Recv recv = cssp.servE112(
                keyName,
                keyValue,
                nullToEmpty(checkValue),
                protectFlag,
                nullToEmpty(protectKey),
                nullToEmpty(activeDate)
        );
        return toResult(recv, "E112");
    }

    /**
     * 导入对称密钥（LMK 保护），适用于 MAC 文档密钥同步后的本地入库。
     */
    public CryptoPlatformKeyResult importSymmetricKeyByLmk(String keyName, String keyValue) {
        return importSymmetricKey(keyName, keyValue, "", PROTECT_FLAG_LMK, "", "");
    }

    /**
     * 导入密钥并要求成功，失败抛出 {@link ServiceException}。
     */
    public CryptoPlatformKeyResult importSymmetricKeyByLmkOrThrow(String keyName, String keyValue) {
        CryptoPlatformKeyResult result = importSymmetricKeyByLmk(keyName, keyValue);
        if (!result.isSuccess()) {
            String remark = StringUtils.hasText(result.getResponseRemark())
                    ? result.getResponseRemark()
                    : "未知错误";
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "加密平台导入密钥失败[" + result.getResponseCode() + "]: " + remark);
        }
        return result;
    }

    /**
     * 删除密钥（E116）。
     */
    public CryptoPlatformKeyResult deleteKey(String keyName) {
        requireText(keyName, "keyName");
        log.info("[crypto-platform] E116 delete keyName={}", keyName);
        UnionCSSP.Recv recv = cssp.servE116(keyName);
        return toResult(recv, "E116");
    }

    private CryptoPlatformKeyResult toResult(UnionCSSP.Recv recv, String serviceCode) {
        if (recv == null) {
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "加密平台 " + serviceCode + " 无响应（Recv=null）");
        }
        Integer code = recv.getResponseCode();
        int responseCode = code != null ? code : -1;
        CryptoPlatformKeyResult result = CryptoPlatformKeyResult.builder()
                .responseCode(responseCode)
                .responseRemark(recv.getResponseRemark())
                .keyName(recv.getKeyName())
                .checkValue(recv.getCheckValue())
                .build();
        if (!result.isSuccess()) {
            log.warn("[crypto-platform] {} failed code={} remark={}",
                    serviceCode, result.getResponseCode(), result.getResponseRemark());
        }
        return result;
    }

    private static void requireText(String value, String field) {
        if (!StringUtils.hasText(value)) {
            throw new ServiceException(GlobalErrorCodeConstants.BAD_REQUEST.getCode(),
                    "加密平台参数 " + field + " 不能为空");
        }
    }

    private static String nullToEmpty(String value) {
        return value != null ? value : "";
    }

}
