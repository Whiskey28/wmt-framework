package com.wmt.framework.compression;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 压缩服务接口
 * 支持多种压缩算法的自动选择
 */
public interface CompressionService {

    /**
     * 根据请求的Accept-Encoding头自动选择最佳压缩算法
     * 
     * @param request HTTP请求
     * @param response HTTP响应
     * @param data 要压缩的数据
     * @return 是否成功压缩
     * @throws IOException IO异常
     */
    boolean compressIfNeeded(HttpServletRequest request, HttpServletResponse response, byte[] data) throws IOException;

    /**
     * 检查是否支持压缩
     * 
     * @param request HTTP请求
     * @param dataSize 数据大小
     * @return 是否支持压缩
     */
    boolean shouldCompress(HttpServletRequest request, int dataSize);

    /**
     * 检查是否支持压缩（支持自定义最小压缩大小）
     * 
     * @param request HTTP请求
     * @param dataSize 数据大小
     * @param minSize 最小压缩大小
     * @return 是否支持压缩
     */
    boolean shouldCompress(HttpServletRequest request, int dataSize, int minSize);

    /**
     * 获取支持的压缩算法列表
     * 
     * @param acceptEncoding Accept-Encoding头值
     * @return 支持的压缩算法列表，按优先级排序
     */
    String[] getSupportedEncodings(String acceptEncoding);
}
