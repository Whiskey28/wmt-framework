package com.wmt.framework.esb.core.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * ESB 响应 SysHead.RetMsgArray（RetCd / RetMsg 直接位于该节点下）。
 */
@Data
public class EsbRetMsgArray implements Serializable {

    @JacksonXmlProperty(localName = "RetCd")
    private String retCd;

    @JacksonXmlProperty(localName = "RetMsg")
    private String retMsg;

}
