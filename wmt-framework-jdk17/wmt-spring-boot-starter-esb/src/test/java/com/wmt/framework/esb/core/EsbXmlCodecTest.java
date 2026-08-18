package com.wmt.framework.esb.core;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.esb.core.model.EsbEnvelope;
import lombok.Data;
import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.util.Objects;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

class EsbXmlCodecTest {

    private final EsbXmlCodec codec = new EsbXmlCodec();
    private final EsbResponseHandler handler = new EsbResponseHandler();

    @Test
    void decode_shouldIgnoreUnknownSysHeadNacAndPassSuccessCodes() throws Exception {
        EsbEnvelope<DemoBody> env = codec.decode(readClasspath("/esb/lrms0058-syshead-nac-resp.xml"), DemoBody.class);

        assertEquals("S", env.getSysHead().getTranRetSt());
        assertEquals("000000", env.getSysHead().resolveRetCd());
        assertEquals("CST-001", env.getBody().getInfoNo());
        handler.checkSuccessOrThrow(env.getSysHead());
    }

    @Test
    void decode_shouldAcceptEmptyMacAndPassSuccessCodes() throws Exception {
        EsbEnvelope<DemoBody> env = codec.decode(readClasspath("/esb/lrms0059-syshead-mac-resp.xml"), DemoBody.class);

        assertEquals("S", env.getSysHead().getTranRetSt());
        assertEquals("000000", env.getSysHead().resolveRetCd());
        assertEquals("CST-001", env.getBody().getInfoNo());
        handler.checkSuccessOrThrow(env.getSysHead());
    }

    @Test
    void decode_shouldPreserveCauseOnMalformedXml() {
        ServiceException ex = assertThrows(ServiceException.class, () -> codec.decode("<not-xml", DemoBody.class));
        assertEquals("ESB 响应报文解析失败", ex.getMessage());
        assertNotNull(ex.getCause());
    }

    private static String readClasspath(String path) throws Exception {
        try (var in = Objects.requireNonNull(EsbXmlCodecTest.class.getResourceAsStream(path), path)) {
            return new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
    }

    @Data
    static class DemoBody {
        @JacksonXmlProperty(localName = "InfoNo")
        private String infoNo;
    }

}
