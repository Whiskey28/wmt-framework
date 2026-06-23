package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertEquals;

class EsbTcpTransportTest {

    @Test
    void formatLengthHeader_shouldPadToEightDigits() {
        EsbProperties properties = new EsbProperties();
        properties.setLengthHeaderSize(8);
        EsbTcpTransport transport = new EsbTcpTransport(properties);

        assertEquals("00001423", transport.formatLengthHeader(1423));
    }

    @Test
    void parseLengthHeader_shouldParseNumericHeader() {
        assertEquals(1423, EsbTcpTransport.parseLengthHeader("00001423"));
    }

    @Test
    void readFixedHeader_shouldReadExactBytes() throws Exception {
        byte[] payload = "00000010".getBytes(StandardCharsets.UTF_8);
        java.io.ByteArrayInputStream inputStream = new java.io.ByteArrayInputStream(payload);
        String header = EsbTcpTransport.readFixedHeader(inputStream, 8, StandardCharsets.UTF_8);
        assertEquals("00000010", header);
    }

}
