package com.wmt.framework.esb.core;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.fasterxml.jackson.dataformat.xml.ser.ToXmlGenerator;
import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import com.wmt.framework.esb.core.model.EsbEnvelope;

/**
 * ESB XML 编解码（UTF-8，根节点 {@code service}）。
 */
public class EsbXmlCodec {

    private final XmlMapper xmlMapper;

    public EsbXmlCodec() {
        this(createDefaultXmlMapper());
    }

    public EsbXmlCodec(XmlMapper xmlMapper) {
        this.xmlMapper = xmlMapper;
    }

    public String encode(EsbEnvelope<?> envelope) {
        try {
            return xmlMapper.writeValueAsString(envelope);
        } catch (Exception ex) {
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "ESB 请求报文序列化失败");
        }
    }

    public <T> EsbEnvelope<T> decode(String xml, Class<T> bodyType) {
        try {
            if (bodyType == null || Void.class.equals(bodyType)) {
                JavaType envelopeType = xmlMapper.getTypeFactory()
                        .constructParametricType(EsbEnvelope.class, Object.class);
                return xmlMapper.readValue(xml, envelopeType);
            }
            JavaType envelopeType = xmlMapper.getTypeFactory()
                    .constructParametricType(EsbEnvelope.class, bodyType);
            return xmlMapper.readValue(xml, envelopeType);
        } catch (Exception ex) {
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "ESB 响应报文解析失败");
        }
    }

    private static XmlMapper createDefaultXmlMapper() {
        XmlMapper mapper = new XmlMapper();
        mapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
        mapper.configure(ToXmlGenerator.Feature.WRITE_XML_DECLARATION, true);
        mapper.getFactory().setCharacterEscapes(new EsbXmlCharacterEscapes());
        return mapper;
    }

    /**
     * 供 Spring 容器复用同一 {@link ObjectMapper} 配置。
     */
    public XmlMapper getXmlMapper() {
        return xmlMapper;
    }

}
