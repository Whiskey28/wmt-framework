package com.wmt.framework.esb.core.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * ESB 标准报文应用头 AppHead。
 */
@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class EsbAppHead implements Serializable {

    @JacksonXmlProperty(localName = "TlrNo")
    private String tlrNo;

    @JacksonXmlProperty(localName = "BranchId")
    private String branchId;

}
