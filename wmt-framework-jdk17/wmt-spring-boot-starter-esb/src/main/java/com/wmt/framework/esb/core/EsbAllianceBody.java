package com.wmt.framework.esb.core;

/**
 * 联盟 ESB 请求 Body 标记：需要 MAC 时自动注入 {@code KeyInd}。
 *
 * <p>实现类应在 Jackson XML 字段上声明 {@code @JacksonXmlProperty(localName = "KeyInd")}。</p>
 */
public interface EsbAllianceBody {

    String getKeyInd();

    void setKeyInd(String keyInd);

}
