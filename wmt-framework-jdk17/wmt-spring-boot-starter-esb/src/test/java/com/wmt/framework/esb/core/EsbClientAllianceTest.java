package com.wmt.framework.esb.core;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.esb.config.EsbProperties;
import lombok.Data;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * 联盟 KeyInd 自动注入测试。
 */
class EsbClientAllianceTest {

    private ServerSocket serverSocket;

    private ExecutorService executor;

    private int port;

    private final AtomicReference<String> capturedRequestXml = new AtomicReference<>();

    @BeforeEach
    void setUp() throws IOException {
        serverSocket = new ServerSocket(0);
        port = serverSocket.getLocalPort();
        executor = Executors.newSingleThreadExecutor();
        executor.submit(this::acceptAndRespond);
    }

    @AfterEach
    void tearDown() throws Exception {
        if (serverSocket != null && !serverSocket.isClosed()) {
            serverSocket.close();
        }
        if (executor != null) {
            executor.shutdownNow();
            executor.awaitTermination(2, TimeUnit.SECONDS);
        }
    }

    @Test
    void invoke_shouldInjectKeyIndWhenAllianceTrue() {
        EsbClient client = newClient("DMPF.861BY8610001.zak", "4190001");

        AllianceReq req = new AllianceReq();
        req.setBizNo("B001");

        client.invokeForBody(
                EsbInvokeOptions.builder()
                        .svcCd("11003000003")
                        .svcScn("01")
                        .alliance(true)
                        .build(),
                req,
                AllianceResp.class
        );

        assertEquals("DMPF.861BY8610001.zak", req.getKeyInd());
        String xml = capturedRequestXml.get();
        assertTrue(xml != null && xml.contains("<KeyInd>DMPF.861BY8610001.zak</KeyInd>"),
                "request xml should contain KeyInd: " + xml);
        assertTrue(xml.contains("<BranchId>4190001</BranchId>"), xml);
        assertTrue(xml.contains("<ChnlTp>09</ChnlTp>"), xml);
        assertTrue(xml.contains("<CnsmSysId>8610716</CnsmSysId>"), xml);
        assertTrue(xml.contains("<SrcSysId>8610716</SrcSysId>"), xml);
        assertTrue(xml.contains("<CnsmSysSeqNo>8610716"), "seq should use alliance sys id: " + xml);
    }

    @Test
    void invoke_shouldNotOverrideExistingKeyInd() {
        EsbClient client = newClient("DMPF.861BY8610001.zak", "4190001");

        AllianceReq req = new AllianceReq();
        req.setBizNo("B001");
        req.setKeyInd("CUSTOM.KEY.zak");

        client.invokeForBody(
                EsbInvokeOptions.of("11003000003", "01", true),
                req,
                AllianceResp.class
        );

        assertEquals("CUSTOM.KEY.zak", req.getKeyInd());
        assertTrue(capturedRequestXml.get().contains("<KeyInd>CUSTOM.KEY.zak</KeyInd>"));
    }

    @Test
    void invoke_shouldFailWhenAllianceButBodyNotImplement() {
        EsbClient client = newClient("DMPF.861BY8610001.zak", "4190001");
        PlainReq req = new PlainReq();
        req.setBizNo("B001");

        assertThrows(ServiceException.class, () -> client.invokeForBody(
                EsbInvokeOptions.of("11003000003", "01", true),
                req,
                AllianceResp.class
        ));
    }

    @Test
    void invoke_shouldFailWhenAllianceButKeyIndNotConfigured() {
        EsbClient client = newClient(null, "4190001");
        AllianceReq req = new AllianceReq();
        req.setBizNo("B001");

        assertThrows(ServiceException.class, () -> client.invokeForBody(
                EsbInvokeOptions.of("11003000003", "01", true),
                req,
                AllianceResp.class
        ));
    }

    @Test
    void invoke_shouldFailWhenAllianceButBranchIdNotConfigured() {
        EsbClient client = newClient("DMPF.861BY8610001.zak", null);
        AllianceReq req = new AllianceReq();
        req.setBizNo("B001");

        assertThrows(ServiceException.class, () -> client.invokeForBody(
                EsbInvokeOptions.of("11003000003", "01", true),
                req,
                AllianceResp.class
        ));
    }

    private EsbClient newClient(String keyInd, String branchId) {
        EsbProperties properties = new EsbProperties();
        properties.setHost("127.0.0.1");
        properties.setPort(port);
        properties.setCnsmSysId("DMPF001");
        properties.setSrcSysId("DMPF001");
        properties.setChnlTp("O3");
        properties.setConnectTimeoutMs(3_000);
        properties.setReadTimeoutMs(3_000);
        properties.getAlliance().setKeyInd(keyInd);
        properties.getAlliance().setBranchId(branchId);
        return new EsbClient(
                properties,
                new EsbTcpTransport(properties),
                new EsbXmlCodec(),
                new EsbSequenceService(properties),
                new EsbResponseHandler()
        );
    }

    private void acceptAndRespond() {
        try (Socket socket = serverSocket.accept();
             InputStream inputStream = socket.getInputStream();
             OutputStream outputStream = socket.getOutputStream()) {
            String requestLengthHeader = EsbTcpTransport.readFixedHeader(inputStream, 8, StandardCharsets.UTF_8);
            int requestLength = EsbTcpTransport.parseLengthHeader(requestLengthHeader);
            byte[] requestBytes = EsbTcpTransport.readFully(inputStream, requestLength);
            capturedRequestXml.set(new String(requestBytes, StandardCharsets.UTF_8));

            String responseXml = """
                    <?xml version="1.0" encoding="UTF-8"?>
                    <service>
                      <SysHead>
                        <SvcCd>11003000003</SvcCd>
                        <SvcScn>01</SvcScn>
                        <TranRetSt>S</TranRetSt>
                        <RetMsgArray>
                          <RetCd>000000</RetCd>
                          <RetMsg>交易成功</RetMsg>
                        </RetMsgArray>
                      </SysHead>
                      <AppHead/>
                      <Body>
                        <BizNo>B001</BizNo>
                      </Body>
                    </service>
                    """;
            byte[] responseBytes = responseXml.getBytes(StandardCharsets.UTF_8);
            outputStream.write(String.format("%08d", responseBytes.length).getBytes(StandardCharsets.UTF_8));
            outputStream.write(responseBytes);
            outputStream.flush();
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    static class AllianceReq implements EsbAllianceBody {
        @JacksonXmlProperty(localName = "BizNo")
        private String bizNo;

        @JacksonXmlProperty(localName = "KeyInd")
        private String keyInd;

        public String getBizNo() { return bizNo; }
        public void setBizNo(String bizNo) { this.bizNo = bizNo; }

        @Override
        public String getKeyInd() { return keyInd; }

        @Override
        public void setKeyInd(String keyInd) { this.keyInd = keyInd; }
    }

    @Data
    static class PlainReq {
        @JacksonXmlProperty(localName = "BizNo")
        private String bizNo;
    }

    @Data
    static class AllianceResp {
        @JacksonXmlProperty(localName = "BizNo")
        private String bizNo;
    }

}
