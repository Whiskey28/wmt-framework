package com.wmt.framework.compression;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.GZIPOutputStream;

/**
 * 压缩服务实现
 * 支持Brotli和Gzip压缩的自动选择
 */
@Slf4j
@Service
public class CompressionServiceImpl implements CompressionService {

    private static final int MIN_COMPRESS_SIZE = 2048 * 1024; // 2MB
    private static final String BROTLI_ENCODING = "br";
    private static final String GZIP_ENCODING = "gzip";
    private static final String ACCEPT_ENCODING_HEADER = "Accept-Encoding";

    @Override
    public boolean compressIfNeeded(HttpServletRequest request, HttpServletResponse response, byte[] data) throws IOException {
        if (!shouldCompress(request, data.length)) {
            return false;
        }

        String acceptEncoding = request.getHeader(ACCEPT_ENCODING_HEADER);
        String[] supportedEncodings = getSupportedEncodings(acceptEncoding);

        for (String encoding : supportedEncodings) {
            if (BROTLI_ENCODING.equals(encoding)) {
                if (compressWithBrotli(response, data)) {
                    return true;
                }
            } else if (GZIP_ENCODING.equals(encoding)) {
                if (compressWithGzip(response, data)) {
                    return true;
                }
            }
        }

        return false;
    }

    @Override
    public boolean shouldCompress(HttpServletRequest request, int dataSize) {
        return shouldCompress(request, dataSize, MIN_COMPRESS_SIZE);
    }

    /**
     * 检查是否支持压缩（支持自定义最小压缩大小）
     */
    public boolean shouldCompress(HttpServletRequest request, int dataSize, int minSize) {
        // 检查数据大小是否达到压缩阈值
        if (dataSize < minSize) {
            return false;
        }

        // 检查客户端是否支持压缩
        String acceptEncoding = request.getHeader(ACCEPT_ENCODING_HEADER);
        return acceptEncoding != null && !acceptEncoding.trim().isEmpty();
    }

    @Override
    public String[] getSupportedEncodings(String acceptEncoding) {
        if (acceptEncoding == null || acceptEncoding.trim().isEmpty()) {
            return new String[0];
        }

        // 解析Accept-Encoding头，按优先级排序
        String[] encodings = acceptEncoding.toLowerCase().split(",");
        boolean supportsBrotli = false;
        boolean supportsGzip = false;

        for (String encoding : encodings) {
            String trimmed = encoding.trim();
            if (trimmed.contains(BROTLI_ENCODING)) {
                supportsBrotli = true;
            }
            if (trimmed.contains(GZIP_ENCODING)) {
                supportsGzip = true;
            }
        }

        // 优先选择Brotli，其次Gzip
        if (supportsBrotli && supportsGzip) {
            return new String[]{BROTLI_ENCODING, GZIP_ENCODING};
        } else if (supportsBrotli) {
            return new String[]{BROTLI_ENCODING};
        } else if (supportsGzip) {
            return new String[]{GZIP_ENCODING};
        }

        return new String[0];
    }

    /**
     * 使用Brotli压缩
     */
    private boolean compressWithBrotli(HttpServletResponse response, byte[] data) {
        try {
            // 初始化Brotli库
            com.aayushatharva.brotli4j.Brotli4jLoader.ensureAvailability();
            
            // 使用Brotli压缩
            byte[] compressedData = com.aayushatharva.brotli4j.encoder.Encoder.compress(data);
            
            // 设置响应头
            response.setHeader("Content-Encoding", BROTLI_ENCODING);
            response.setHeader("Vary", "Accept-Encoding");
            response.setContentLength(compressedData.length);
            
            // 写入压缩数据
            response.getOutputStream().write(compressedData);
            response.getOutputStream().flush();
            
            log.debug("Successfully compressed data with Brotli, original size: {}, compressed size: {}", 
                     data.length, compressedData.length);
            return true;
        } catch (Exception e) {
            log.warn("Failed to compress with Brotli: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 使用Gzip压缩
     */
    private boolean compressWithGzip(HttpServletResponse response, byte[] data) {
        try {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            GZIPOutputStream gzipOutputStream = new GZIPOutputStream(byteArrayOutputStream);
            gzipOutputStream.write(data);
            gzipOutputStream.close();
            
            byte[] compressedData = byteArrayOutputStream.toByteArray();
            
            // 设置响应头
            response.setHeader("Content-Encoding", GZIP_ENCODING);
            response.setHeader("Vary", "Accept-Encoding");
            response.setContentLength(compressedData.length);
            
            // 写入压缩数据
            response.getOutputStream().write(compressedData);
            response.getOutputStream().flush();
            
            log.debug("Successfully compressed data with Gzip, original size: {}, compressed size: {}", 
                     data.length, compressedData.length);
            return true;
        } catch (Exception e) {
            log.warn("Failed to compress with Gzip: {}", e.getMessage());
            return false;
        }
    }
}
