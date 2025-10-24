package com.wmt.framework.file.core;

import java.io.InputStream;
import java.io.OutputStream;

/**
 * 文件转换服务接口
 * 支持多种文件格式转换
 */
public interface FileConvertService {

    /**
     * 转换文件
     * 
     * @param request 转换请求
     * @return 转换结果
     */
    ConvertResult convert(FileConvertRequest request);

    /**
     * 检查是否支持指定的转换
     * 
     * @param sourceFormat 源格式
     * @param targetFormat 目标格式
     * @return 是否支持
     */
    boolean support(String sourceFormat, String targetFormat);

    /**
     * 获取支持的源格式列表
     * 
     * @return 支持的源格式列表
     */
    String[] getSupportedSourceFormats();

    /**
     * 获取支持的目标格式列表
     * 
     * @param sourceFormat 源格式
     * @return 支持的目标格式列表
     */
    String[] getSupportedTargetFormats(String sourceFormat);
}
