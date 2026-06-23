package com.wmt.framework.esb.core;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.wmt.framework.esb.config.EsbProperties;
import com.wmt.framework.esb.core.model.EsbAppHead;
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

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class EsbClientTest {

    private ServerSocket serverSocket;

    private ExecutorService executor;

    private int port;

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
    void invokeForBody_shouldSendLengthPrefixedXmlAndParseResponse() {
        EsbProperties properties = new EsbProperties();
        properties.setHost("127.0.0.1");
        properties.setPort(port);
        properties.setCnsmSysId("DMPF001");
        properties.setSrcSysId("DMPF001");
        properties.setConnectTimeoutMs(3_000);
        properties.setReadTimeoutMs(3_000);

        EsbClient client = new EsbClient(
                properties,
                new EsbTcpTransport(properties),
                new EsbXmlCodec(),
                new EsbSequenceService(properties),
                new EsbResponseHandler()
        );

        DemoReq req = new DemoReq();
        req.setInfoNo("WMA2004");

        DemoResp resp = client.invokeForBody(
                EsbInvokeOptions.builder()
                        .svcCd("11003000003")
                        .svcScn("01")
                        .appHead(appHead("00012545", "86100099"))
                        .build(),
                req,
                DemoResp.class
        );

        assertNotNull(resp);
        assertEquals("WMA2004", resp.getInfoNo());
    }

    private EsbAppHead appHead(String tlrNo, String branchId) {
        EsbAppHead appHead = new EsbAppHead();
        appHead.setTlrNo(tlrNo);
        appHead.setBranchId(branchId);
        return appHead;
    }

    private void acceptAndRespond() {
        try (Socket socket = serverSocket.accept();
             InputStream inputStream = socket.getInputStream();
             OutputStream outputStream = socket.getOutputStream()) {
            String requestLengthHeader = EsbTcpTransport.readFixedHeader(inputStream, 8, StandardCharsets.UTF_8);
            int requestLength = EsbTcpTransport.parseLengthHeader(requestLengthHeader);
            EsbTcpTransport.readFully(inputStream, requestLength);

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
                        <InfoNo>WMA2004</InfoNo>
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

    @Data
    static class DemoReq {
        @JacksonXmlProperty(localName = "InfoNo")
        private String infoNo;
    }

    @Data
    static class DemoResp {
        @JacksonXmlProperty(localName = "InfoNo")
        private String infoNo;
    }

}
