package com.wmt.framework.esb.core.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;
import lombok.Data;

import java.io.Serializable;

/**
 * ESB 标准 XML 根节点 {@code <service>}。
 *
 * @param <T> Body 业务报文类型
 */
@Data
@JacksonXmlRootElement(localName = "service")
public class EsbEnvelope<T> implements Serializable {

    @JacksonXmlProperty(localName = "SysHead")
    private EsbSysHead sysHead;

    @JacksonXmlProperty(localName = "AppHead")
    private EsbAppHead appHead;

    @JacksonXmlProperty(localName = "Body")
    private T body;

}
