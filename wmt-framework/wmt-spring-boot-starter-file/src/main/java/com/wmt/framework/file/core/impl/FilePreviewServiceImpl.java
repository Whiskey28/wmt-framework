package com.wmt.framework.file.core.impl;

import com.wmt.framework.file.core.FilePreviewRequest;
import com.wmt.framework.file.core.FilePreviewService;
import com.wmt.framework.file.core.PreviewResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.util.Arrays;

/**
 * 文件预览服务实现
 * 支持图片、PDF、Office文档等格式的预览
 */
@Slf4j
@Service
public class FilePreviewServiceImpl implements FilePreviewService {

    @Override
    public PreviewResult preview(FilePreviewRequest request) {
        long startTime = System.currentTimeMillis();

        try {
            // 检查是否支持预览
            if (!support(request.getFileType())) {
                return PreviewResult.failure("不支持的文件类型: " + request.getFileType());
            }

            // 根据文件类型进行预览
            PreviewResult result = performPreview(request);
            result.setPreviewTime(System.currentTimeMillis() - startTime);

            return result;

        } catch (Exception e) {
            log.error("文件预览失败: {}", e.getMessage(), e);
            PreviewResult result = PreviewResult.failure("文件预览失败: " + e.getMessage());
            result.setPreviewTime(System.currentTimeMillis() - startTime);
            return result;
        }
    }

    @Override
    public boolean support(String fileType) {
        String[] supportedTypes = getSupportedFileTypes();
        return Arrays.asList(supportedTypes).contains(fileType.toLowerCase());
    }

    @Override
    public String[] getSupportedFileTypes() {
        return new String[]{
            "jpg", "jpeg", "png", "gif", "bmp", "webp",  // 图片格式
            "pdf",                                        // PDF
            "docx", "doc", "xlsx", "xls", "pptx", "ppt", // Office文档
            "txt", "html", "css", "js", "json", "xml"    // 文本格式
        };
    }

    /**
     * 执行具体的预览操作
     */
    private PreviewResult performPreview(FilePreviewRequest request) throws Exception {
        String fileType = request.getFileType().toLowerCase();

        switch (fileType) {
            case "jpg":
            case "jpeg":
            case "png":
            case "gif":
            case "bmp":
            case "webp":
                return previewImage(request);
            case "pdf":
                return previewPdf(request);
            case "docx":
            case "doc":
            case "xlsx":
            case "xls":
            case "pptx":
            case "ppt":
                return previewOffice(request);
            case "txt":
            case "html":
            case "css":
            case "js":
            case "json":
            case "xml":
                return previewText(request);
            default:
                throw new UnsupportedOperationException("不支持的文件类型: " + fileType);
        }
    }

    /**
     * 预览图片
     */
    private PreviewResult previewImage(FilePreviewRequest request) throws Exception {
        // 对于图片，直接返回原文件流
        // 如果需要生成缩略图，可以使用Thumbnailator库

        String previewFileName = generatePreviewFileName(request.getFileName(), "preview");

        return PreviewResult.success(
            request.getFileStream(),
            previewFileName,
            request.getFileType(),
            request.getFileSize()
        );
    }

    /**
     * 预览PDF
     */
    private PreviewResult previewPdf(FilePreviewRequest request) throws Exception {
        // 这里应该使用PDF处理库将PDF转换为图片进行预览
        // 为了简化，这里返回一个占位实现

        String resultContent = "PDF预览功能需要集成PDF处理库";
        ByteArrayInputStream resultStream = new ByteArrayInputStream(resultContent.getBytes("UTF-8"));

        String previewFileName = generatePreviewFileName(request.getFileName(), "preview.txt");

        return PreviewResult.success(resultStream, previewFileName, "txt", resultContent.getBytes("UTF-8").length);
    }

    /**
     * 预览Office文档
     */
    private PreviewResult previewOffice(FilePreviewRequest request) throws Exception {
        // 这里应该使用Office处理库将文档转换为HTML或图片进行预览
        // 为了简化，这里返回一个占位实现

        String resultContent = "Office文档预览功能需要集成Office处理库";
        ByteArrayInputStream resultStream = new ByteArrayInputStream(resultContent.getBytes("UTF-8"));

        String previewFileName = generatePreviewFileName(request.getFileName(), "preview.txt");

        return PreviewResult.success(resultStream, previewFileName, "txt", resultContent.getBytes("UTF-8").length);
    }

    /**
     * 预览文本文件
     */
    private PreviewResult previewText(FilePreviewRequest request) throws Exception {
        // 对于文本文件，直接返回原文件流
        String previewFileName = generatePreviewFileName(request.getFileName(), "preview");

        return PreviewResult.success(
            request.getFileStream(),
            previewFileName,
            request.getFileType(),
            request.getFileSize()
        );
    }

    /**
     * 生成预览文件名
     */
    private String generatePreviewFileName(String originalFileName, String suffix) {
        if (originalFileName == null) {
            return "preview_" + System.currentTimeMillis();
        }

        int lastDotIndex = originalFileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            return originalFileName.substring(0, lastDotIndex) + "_" + suffix + originalFileName.substring(lastDotIndex);
        } else {
            return originalFileName + "_" + suffix;
        }
    }
}
