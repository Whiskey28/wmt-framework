package com.wmt.framework.file.core;

import java.io.InputStream;
import java.util.List;

/**
 * 文件压缩服务接口
 * 支持ZIP、RAR、7Z等格式的压缩解压
 */
public interface FileCompressService {

    /**
     * 压缩文件
     * 
     * @param request 压缩请求
     * @return 压缩结果
     */
    CompressResult compress(FileCompressRequest request);

    /**
     * 解压文件
     * 
     * @param request 解压请求
     * @return 解压结果
     */
    DecompressResult decompress(FileDecompressRequest request);

    /**
     * 检查是否支持指定的压缩格式
     * 
     * @param format 压缩格式
     * @return 是否支持
     */
    boolean supportCompress(String format);

    /**
     * 检查是否支持指定的解压格式
     * 
     * @param format 解压格式
     * @return 是否支持
     */
    boolean supportDecompress(String format);

    /**
     * 获取支持的压缩格式列表
     * 
     * @return 支持的压缩格式列表
     */
    String[] getSupportedCompressFormats();

    /**
     * 获取支持的解压格式列表
     * 
     * @return 支持的解压格式列表
     */
    String[] getSupportedDecompressFormats();
}
