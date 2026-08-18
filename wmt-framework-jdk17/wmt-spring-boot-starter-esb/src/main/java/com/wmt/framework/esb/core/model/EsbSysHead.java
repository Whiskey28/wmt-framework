package com.wmt.framework.esb.core.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * ESB 标准报文系统头 SysHead（请求/响应共用字段模型）。
 *
 * <p>规范字段为 {@code Mac}，不含 {@code Nac}。未知节点忽略，避免提供方笔误挡解包。</p>
 */
@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@JsonIgnoreProperties(ignoreUnknown = true)
public class EsbSysHead implements Serializable {

    @JacksonXmlProperty(localName = "SvcCd")
    private String svcCd;

    @JacksonXmlProperty(localName = "SvcScn")
    private String svcScn;

    @JacksonXmlProperty(localName = "CnsmSysId")
    private String cnsmSysId;

    @JacksonXmlProperty(localName = "ChnlTp")
    private String chnlTp;

    @JacksonXmlProperty(localName = "SrcSysId")
    private String srcSysId;

    @JacksonXmlProperty(localName = "CnsmSysSeqNo")
    private String cnsmSysSeqNo;

    @JacksonXmlProperty(localName = "SrcSysSeqNo")
    private String srcSysSeqNo;

    @JacksonXmlProperty(localName = "Mac")
    private String mac;

    @JacksonXmlProperty(localName = "TranDt")
    private String tranDt;

    @JacksonXmlProperty(localName = "TranTm")
    private String tranTm;

    @JacksonXmlProperty(localName = "TmnlNo")
    private String tmnlNo;

    @JacksonXmlProperty(localName = "SrcSysTmnlNo")
    private String srcSysTmnlNo;

    @JacksonXmlProperty(localName = "CnsmSysSvrId")
    private String cnsmSysSvrId;

    @JacksonXmlProperty(localName = "SrcSysSvrId")
    private String srcSysSvrId;

    @JacksonXmlProperty(localName = "FileFlg")
    private String fileFlg;

    @JacksonXmlProperty(localName = "FilePath")
    private String filePath;

    // ---------- 响应字段 ----------

    @JacksonXmlProperty(localName = "PrvdSysId")
    private String prvdSysId;

    @JacksonXmlProperty(localName = "PrvdSysSeqNo")
    private String prvdSysSeqNo;

    @JacksonXmlProperty(localName = "TranRetSt")
    private String tranRetSt;

    @JacksonXmlProperty(localName = "RetMsgArray")
    private EsbRetMsgArray retMsgArray;

    @JacksonXmlProperty(localName = "PrvdSysSvrId")
    private String prvdSysSvrId;

    public String resolveRetCd() {
        return retMsgArray != null ? retMsgArray.getRetCd() : null;
    }

    public String resolveRetMsg() {
        return retMsgArray != null ? retMsgArray.getRetMsg() : null;
    }

}
