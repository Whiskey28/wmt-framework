package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import com.wmt.framework.esb.core.model.EsbEnvelope;
import com.wmt.framework.esb.core.model.EsbSysHead;
import lombok.Data;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * 提供方 Router：业务失败仍 TranRetSt=S；未知服务 TranRetSt=F。
 */
class EsbProviderRouterTest {

    private static final String SVC_CD = "900010001";

    private final EsbXmlCodec codec = new EsbXmlCodec();
    private EsbProviderRouter router;

    @BeforeEach
    void setUp() {
        EsbProperties properties = new EsbProperties();
        properties.setCnsmSysId("DMPF001");
        EsbProviderResponseFactory responseFactory =
                new EsbProviderResponseFactory(properties, new EsbSequenceService(properties));
        EsbProviderHandler<DemoReq, DemoResp> handler = new EsbProviderHandler<>() {
            @Override
            public String svcCd() {
                return SVC_CD;
            }

            @Override
            public Class<DemoReq> requestType() {
                return DemoReq.class;
            }

            @Override
            public DemoResp handle(EsbSysHead requestSysHead, DemoReq request) {
                DemoResp resp = new DemoResp();
                if (request == null || request.getIdentNo() == null || request.getIdentNo().isBlank()) {
                    resp.setBusinessRetCode("1001");
                    resp.setBusinessRetReason("参数错误");
                    resp.setAmount(0D);
                    return resp;
                }
                resp.setBusinessRetCode("0000");
                resp.setBusinessRetReason("成功");
                resp.setAmount(12345.67D);
                return resp;
            }
        };
        router = new EsbProviderRouter(codec, responseFactory, "DMPF001", List.of(handler));
        assertEquals(1, router.registeredRouteCount());
    }

    @Test
    void dispatch_success_shouldKeepTranRetStSAndBody() throws Exception {
        String xml = requestXml(SVC_CD, "91150100MA0XXXXX1A");
        EsbEnvelope<DemoResp> env = codec.decode(router.dispatch(xml), DemoResp.class);
        assertEquals(EsbProviderConstants.TRAN_RET_SUCCESS, env.getSysHead().getTranRetSt());
        assertEquals(EsbProviderConstants.RET_CD_SUCCESS, env.getSysHead().getRetMsgArray().getRetCd());
        assertEquals("0000", env.getBody().getBusinessRetCode());
        assertEquals(12345.67D, env.getBody().getAmount());
        assertTrue(router.dispatch(xml).contains("<Amt>"));
    }

    @Test
    void dispatch_businessFail_shouldStillTranRetStS() throws Exception {
        String xml = requestXml(SVC_CD, "  ");
        EsbEnvelope<DemoResp> env = codec.decode(router.dispatch(xml), DemoResp.class);
        assertEquals(EsbProviderConstants.TRAN_RET_SUCCESS, env.getSysHead().getTranRetSt());
        assertEquals("1001", env.getBody().getBusinessRetCode());
    }

    @Test
    void dispatch_unknownSvc_shouldTranRetStF() throws Exception {
        String xml = requestXml("999999999", "x");
        EsbEnvelope<Object> env = codec.decode(router.dispatch(xml), Object.class);
        assertEquals(EsbProviderConstants.TRAN_RET_FAILURE, env.getSysHead().getTranRetSt());
    }

    @Test
    void blankSvcCd_shouldSkipRegistration() {
        EsbProperties properties = new EsbProperties();
        properties.setCnsmSysId("DMPF001");
        EsbProviderResponseFactory responseFactory =
                new EsbProviderResponseFactory(properties, new EsbSequenceService(properties));
        EsbProviderHandler<DemoReq, DemoResp> blank = new EsbProviderHandler<>() {
            @Override
            public String svcCd() {
                return "";
            }

            @Override
            public Class<DemoReq> requestType() {
                return DemoReq.class;
            }

            @Override
            public DemoResp handle(EsbSysHead requestSysHead, DemoReq request) {
                return new DemoResp();
            }
        };
        EsbProviderRouter emptyRouter =
                new EsbProviderRouter(codec, responseFactory, "DMPF001", List.of(blank));
        assertEquals(0, emptyRouter.registeredRouteCount());
    }

    private static String requestXml(String svcCd, String identNo) {
        return """
                <?xml version="1.0" encoding="UTF-8"?>
                <service>
                  <SysHead>
                    <SvcCd>%s</SvcCd>
                    <SvcScn>01</SvcScn>
                    <CnsmSysId>LRMS001</CnsmSysId>
                  </SysHead>
                  <Body>
                    <IdentNo>%s</IdentNo>
                  </Body>
                </service>
                """.formatted(svcCd, identNo);
    }

    @Data
    static class DemoReq {
        @com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty(localName = "IdentNo")
        private String identNo;
    }

    @Data
    static class DemoResp {
        @com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty(localName = "BsnRetCd")
        private String businessRetCode;
        @com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty(localName = "BsnRetRsn")
        private String businessRetReason;
        @com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty(localName = "Amt")
        private Double amount;
    }

}
