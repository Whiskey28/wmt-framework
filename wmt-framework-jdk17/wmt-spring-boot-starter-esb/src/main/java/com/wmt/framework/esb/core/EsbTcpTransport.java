package com.wmt.framework.esb.core;

import com.wmt.framework.common.exception.ServiceException;
import com.wmt.framework.common.exception.enums.GlobalErrorCodeConstants;
import com.wmt.framework.esb.config.EsbProperties;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.charset.Charset;

/**
 * ESB TCP 短连接传输：{@code 长度头 + XML} 同步请求/响应。
 */
@Slf4j
public class EsbTcpTransport {

    private final EsbProperties properties;

    public EsbTcpTransport(EsbProperties properties) {
        this.properties = properties;
    }

    /**
     * 发送 XML 报文并读取响应 XML（不含长度头）。
     */
    public String sendAndReceive(String xmlPayload) {
        validateEndpoint();
        Charset charset = properties.getCharset();
        byte[] requestBytes = xmlPayload.getBytes(charset);
        if (requestBytes.length > properties.getMaxBodyBytes()) {
            throw new ServiceException(GlobalErrorCodeConstants.BAD_REQUEST.getCode(),
                    "ESB 请求报文超过最大限制 " + properties.getMaxBodyBytes() + " 字节");
        }

        String lengthHeader = formatLengthHeader(requestBytes.length);
        log.debug("[esb] tcp send host={}:{} length={}", properties.getHost(), properties.getPort(),
                requestBytes.length);

        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(properties.getHost(), properties.getPort()),
                    properties.getConnectTimeoutMs());
            socket.setSoTimeout(properties.getReadTimeoutMs());

            OutputStream outputStream = socket.getOutputStream();
            outputStream.write(lengthHeader.getBytes(charset));
            outputStream.write(requestBytes);
            outputStream.flush();

            InputStream inputStream = socket.getInputStream();
            String responseLengthHeader = readFixedHeader(inputStream, properties.getLengthHeaderSize(), charset);
            int responseLength = parseLengthHeader(responseLengthHeader);
            if (responseLength > properties.getMaxBodyBytes()) {
                throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                        "ESB 响应报文超过最大限制 " + properties.getMaxBodyBytes() + " 字节");
            }
            byte[] responseBytes = readFully(inputStream, responseLength);
            String responseXml = new String(responseBytes, charset);
            log.debug("[esb] tcp response length={}", responseLength);
            return responseXml;
        } catch (IOException ex) {
            log.error("[esb] tcp invoke error host={}:{}", properties.getHost(), properties.getPort(), ex);
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "调用 ESB 失败：" + ex.getMessage());
        }
    }

    private void validateEndpoint() {
        if (!org.springframework.util.StringUtils.hasText(properties.getHost()) || properties.getPort() == null) {
            throw new ServiceException(GlobalErrorCodeConstants.ERROR_CONFIGURATION.getCode(),
                    "ESB 接入地址未配置（wmt.esb.host / wmt.esb.port）");
        }
    }

    String formatLengthHeader(int bodyLength) {
        int headerSize = properties.getLengthHeaderSize();
        String pattern = "%0" + headerSize + "d";
        String header = String.format(pattern, bodyLength);
        if (header.length() != headerSize) {
            throw new ServiceException(GlobalErrorCodeConstants.BAD_REQUEST.getCode(),
                    "ESB 报文长度超出长度头可表示范围，length=" + bodyLength);
        }
        return header;
    }

    static String readFixedHeader(InputStream inputStream, int headerSize, Charset charset) throws IOException {
        byte[] headerBytes = readFully(inputStream, headerSize);
        return new String(headerBytes, charset);
    }

    static int parseLengthHeader(String lengthHeader) {
        try {
            return Integer.parseInt(lengthHeader.trim());
        } catch (NumberFormatException ex) {
            throw new ServiceException(GlobalErrorCodeConstants.INTERNAL_SERVER_ERROR.getCode(),
                    "ESB 响应长度头非法：" + lengthHeader);
        }
    }

    static byte[] readFully(InputStream inputStream, int length) throws IOException {
        byte[] buffer = new byte[length];
        int offset = 0;
        while (offset < length) {
            int read = inputStream.read(buffer, offset, length - offset);
            if (read < 0) {
                throw new IOException("ESB 响应不完整，期望 " + length + " 字节，实际 " + offset + " 字节");
            }
            offset += read;
        }
        return buffer;
    }

}
