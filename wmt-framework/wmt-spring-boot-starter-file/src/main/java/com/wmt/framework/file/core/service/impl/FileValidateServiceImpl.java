package com.wmt.framework.file.core.service.impl;

import com.wmt.framework.file.core.dto.FileValidateRequest;
import com.wmt.framework.file.core.dto.ValidateResult;
import com.wmt.framework.file.core.service.FileValidateService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

/**
 * 文件校验服务实现
 * 支持文件类型、大小、内容校验
 */
@Slf4j
@Service
public class FileValidateServiceImpl implements FileValidateService {

    // 文件类型魔数
    private static final byte[][] FILE_SIGNATURES = {
        {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF}, // JPEG
        {(byte) 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A}, // PNG
        {0x47, 0x49, 0x46, 0x38, 0x37, 0x61}, // GIF87a
        {0x47, 0x49, 0x46, 0x38, 0x39, 0x61}, // GIF89a
        {0x42, 0x4D}, // BMP
        {0x25, 0x50, 0x44, 0x46}, // PDF
        {0x50, 0x4B, 0x03, 0x04}, // ZIP/DOCX/XLSX/PPTX
        {0x50, 0x4B, 0x05, 0x06}, // ZIP (empty)
        {0x50, 0x4B, 0x07, 0x08}, // ZIP (spanned)
    };

    private static final String[] FILE_TYPES = {
        "jpg", "png", "gif", "gif", "bmp", "pdf", "zip", "zip", "zip"
    };

    @Override
    public ValidateResult validate(FileValidateRequest request) {
        long startTime = System.currentTimeMillis();
        List<String> errors = new ArrayList<>();
        List<String> warnings = new ArrayList<>();

        try {
            // 校验文件大小
            if (request.getMaxSize() != null && request.getFileSize() > request.getMaxSize()) {
                errors.add("文件大小超过限制: " + request.getFileSize() + " > " + request.getMaxSize());
            }
            if (request.getMinSize() != null && request.getFileSize() < request.getMinSize()) {
                errors.add("文件大小小于限制: " + request.getFileSize() + " < " + request.getMinSize());
            }

            // 校验文件类型
            String detectedType = validateFileType(request.getFileStream(), request.getFileName());
            if (request.getAllowedTypes() != null && !request.getAllowedTypes().isEmpty()) {
                if (!request.getAllowedTypes().contains(detectedType)) {
                    errors.add("文件类型不在允许列表中: " + detectedType);
                }
            }

            // 校验文件内容
            if (request.isValidateContent()) {
                ValidateResult contentResult = validateFileContent(request.getFileStream(), request.getFileName());
                if (!contentResult.isValid()) {
                    errors.addAll(contentResult.getErrors());
                }
            }

            // 计算哈希值
            String md5 = null;
            String sha1 = null;
            if (request.isCalculateHash()) {
                // 重置流位置
                request.getFileStream().reset();
                md5 = calculateMD5(request.getFileStream());
                request.getFileStream().reset();
                sha1 = calculateSHA1(request.getFileStream());
            }

            boolean valid = errors.isEmpty();
            ValidateResult result = valid ?
                ValidateResult.valid(detectedType, request.getFileSize(), md5, sha1) :
                ValidateResult.invalid(errors);

            result.setValidateTime(System.currentTimeMillis() - startTime);
            return result;

        } catch (Exception e) {
            log.error("文件校验失败: {}", e.getMessage(), e);
            errors.add("文件校验失败: " + e.getMessage());
            ValidateResult result = ValidateResult.invalid(errors);
            result.setValidateTime(System.currentTimeMillis() - startTime);
            return result;
        }
    }

    @Override
    public String validateFileType(InputStream fileStream, String fileName) {
        try {
            // 读取文件头
            byte[] header = new byte[8];
            int bytesRead = fileStream.read(header);

            if (bytesRead < 2) {
                return getFileTypeFromExtension(fileName);
            }

            // 检查魔数
            for (int i = 0; i < FILE_SIGNATURES.length; i++) {
                byte[] signature = FILE_SIGNATURES[i];
                if (bytesRead >= signature.length) {
                    boolean matches = true;
                    for (int j = 0; j < signature.length; j++) {
                        if (header[j] != signature[j]) {
                            matches = false;
                            break;
                        }
                    }
                    if (matches) {
                        return FILE_TYPES[i];
                    }
                }
            }

            // 如果魔数不匹配，尝试从文件扩展名判断
            return getFileTypeFromExtension(fileName);

        } catch (IOException e) {
            log.warn("读取文件头失败: {}", e.getMessage());
            return getFileTypeFromExtension(fileName);
        }
    }

    @Override
    public boolean validateFileSize(long fileSize, long maxSize) {
        return fileSize <= maxSize;
    }

    @Override
    public ValidateResult validateFileContent(InputStream fileStream, String fileName) {
        List<String> errors = new ArrayList<>();

        try {
            // 这里可以添加更复杂的内容校验逻辑
            // 比如检查文件是否损坏、是否包含恶意内容等

            // 简单的内容校验：检查文件是否为空
            byte[] buffer = new byte[1024];
            int bytesRead = fileStream.read(buffer);
            if (bytesRead == 0) {
                errors.add("文件内容为空");
            }

            return errors.isEmpty() ?
                ValidateResult.valid("unknown", 0, null, null) :
                ValidateResult.invalid(errors);

        } catch (IOException e) {
            errors.add("读取文件内容失败: " + e.getMessage());
            return ValidateResult.invalid(errors);
        }
    }

    @Override
    public String calculateMD5(InputStream fileStream) {
        try {
            return DigestUtils.md5DigestAsHex(fileStream);
        } catch (IOException e) {
            log.error("计算MD5失败: {}", e.getMessage(), e);
            return null;
        }
    }

    @Override
    public String calculateSHA1(InputStream fileStream) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-1");
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fileStream.read(buffer)) != -1) {
                digest.update(buffer, 0, bytesRead);
            }

            byte[] hash = digest.digest();
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException | IOException e) {
            log.error("计算SHA1失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 从文件扩展名获取文件类型
     */
    private String getFileTypeFromExtension(String fileName) {
        if (fileName == null) {
            return "unknown";
        }

        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1).toLowerCase();
        }

        return "unknown";
    }
}
