package com.wmt.framework.file.core.util;

import com.wmt.framework.file.core.dto.*;
import com.wmt.framework.file.core.service.FileCompressService;
import com.wmt.framework.file.core.service.FileConvertService;
import com.wmt.framework.file.core.service.FilePreviewService;
import com.wmt.framework.file.core.service.FileValidateService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.Arrays;
import java.util.List;

/**
 * 文件处理工具类
 * 提供便捷的文件操作方法
 */
@Slf4j
@Component
public class FileUtils {

    @Autowired
    private FileConvertService fileConvertService;

    @Autowired
    private FilePreviewService filePreviewService;

    @Autowired
    private FileCompressService fileCompressService;

    @Autowired
    private FileValidateService fileValidateService;

    /**
     * 转换文件格式
     */
    public ConvertResult convertFile(InputStream sourceStream, String sourceFormat, String targetFormat) {
        try {
            FileConvertRequest request = FileConvertRequest.create(sourceStream, null, targetFormat);
            request.setSourceFormat(sourceFormat);
            return fileConvertService.convert(request);
        } catch (Exception e) {
            log.error("文件转换失败: {}", e.getMessage(), e);
            return ConvertResult.failure("文件转换失败: " + e.getMessage());
        }
    }

    /**
     * 预览文件
     */
    public PreviewResult previewFile(InputStream fileStream, String fileName, String fileType) {
        try {
            FilePreviewRequest request = FilePreviewRequest.create(fileStream, fileName, fileType);
            return filePreviewService.preview(request);
        } catch (Exception e) {
            log.error("文件预览失败: {}", e.getMessage(), e);
            return PreviewResult.failure("文件预览失败: " + e.getMessage());
        }
    }

    /**
     * 压缩文件
     */
    public CompressResult compressFiles(List<FileCompressRequest.CompressFile> files, String format) {
        try {
            FileCompressRequest request = new FileCompressRequest();
            request.setFiles(files);
            request.setFormat(format);
            return fileCompressService.compress(request);
        } catch (Exception e) {
            log.error("文件压缩失败: {}", e.getMessage(), e);
            return CompressResult.failure("文件压缩失败: " + e.getMessage());
        }
    }

    /**
     * 解压文件
     */
    public DecompressResult decompressFile(InputStream compressStream, String fileName, String format) {
        try {
            FileDecompressRequest request = FileDecompressRequest.create(compressStream, fileName, format);
            return fileCompressService.decompress(request);
        } catch (Exception e) {
            log.error("文件解压失败: {}", e.getMessage(), e);
            return DecompressResult.failure("文件解压失败: " + e.getMessage());
        }
    }

    /**
     * 校验文件
     */
    public ValidateResult validateFile(InputStream fileStream, String fileName, long fileSize) {
        try {
            FileValidateRequest request = FileValidateRequest.create(fileStream, fileName, fileSize);
            return fileValidateService.validate(request);
        } catch (Exception e) {
            log.error("文件校验失败: {}", e.getMessage(), e);
            return ValidateResult.invalid(Arrays.asList("文件校验失败: " + e.getMessage()));
        }
    }

    /**
     * 校验文件（带限制）
     */
    public ValidateResult validateFile(InputStream fileStream, String fileName, long fileSize,
                                     List<String> allowedTypes, Long maxSize) {
        try {
            FileValidateRequest request = FileValidateRequest.create(fileStream, fileName, fileSize);
            request.setAllowedTypes(allowedTypes);
            request.setMaxSize(maxSize);
            return fileValidateService.validate(request);
        } catch (Exception e) {
            log.error("文件校验失败: {}", e.getMessage(), e);
            return ValidateResult.invalid(Arrays.asList("文件校验失败: " + e.getMessage()));
        }
    }

    /**
     * 从MultipartFile校验文件
     */
    public ValidateResult validateMultipartFile(MultipartFile file) {
        try {
            return validateFile(file.getInputStream(), file.getOriginalFilename(), file.getSize());
        } catch (Exception e) {
            log.error("MultipartFile校验失败: {}", e.getMessage(), e);
            return ValidateResult.invalid(Arrays.asList("文件校验失败: " + e.getMessage()));
        }
    }

    /**
     * 计算文件MD5
     */
    public String calculateFileMD5(InputStream fileStream) {
        try {
            return fileValidateService.calculateMD5(fileStream);
        } catch (Exception e) {
            log.error("计算文件MD5失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 计算文件SHA1
     */
    public String calculateFileSHA1(InputStream fileStream) {
        try {
            return fileValidateService.calculateSHA1(fileStream);
        } catch (Exception e) {
            log.error("计算文件SHA1失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 检查是否支持文件转换
     */
    public boolean isConvertSupported(String sourceFormat, String targetFormat) {
        return fileConvertService.support(sourceFormat, targetFormat);
    }

    /**
     * 检查是否支持文件预览
     */
    public boolean isPreviewSupported(String fileType) {
        return filePreviewService.support(fileType);
    }

    /**
     * 检查是否支持文件压缩
     */
    public boolean isCompressSupported(String format) {
        return fileCompressService.supportCompress(format);
    }

    /**
     * 检查是否支持文件解压
     */
    public boolean isDecompressSupported(String format) {
        return fileCompressService.supportDecompress(format);
    }
}
