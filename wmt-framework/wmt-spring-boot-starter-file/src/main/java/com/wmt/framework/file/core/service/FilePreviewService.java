package com.wmt.framework.file.core.service;

import com.wmt.framework.file.core.dto.FilePreviewRequest;
import com.wmt.framework.file.core.dto.PreviewResult;

/**
 * 文件预览服务接口
 * 支持多种文件格式的在线预览
 */
public interface FilePreviewService {

    /**
     * 预览文件
     *
     * @param request 预览请求
     * @return 预览结果
     */
    PreviewResult preview(FilePreviewRequest request);

    /**
     * 检查是否支持指定文件类型
     *
     * @param fileType 文件类型
     * @return 是否支持
     */
    boolean support(String fileType);

    /**
     * 获取支持的文件类型列表
     *
     * @return 支持的文件类型列表
     */
    String[] getSupportedFileTypes();
}
