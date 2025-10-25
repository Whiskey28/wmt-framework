package com.wmt.framework.file.core.service.impl;

import com.wmt.framework.file.core.dto.CompressResult;
import com.wmt.framework.file.core.dto.DecompressResult;
import com.wmt.framework.file.core.dto.FileCompressRequest;
import com.wmt.framework.file.core.dto.FileDecompressRequest;
import com.wmt.framework.file.core.service.FileCompressService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.compress.archivers.zip.ZipFile;
import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

/**
 * 文件压缩服务实现
 * 支持ZIP格式的压缩解压
 */
@Slf4j
@Service
public class FileCompressServiceImpl implements FileCompressService {

    @Override
    public CompressResult compress(FileCompressRequest request) {
        long startTime = System.currentTimeMillis();

        try {
            // 检查是否支持压缩格式
            if (!supportCompress(request.getFormat())) {
                return CompressResult.failure("不支持的压缩格式: " + request.getFormat());
            }

            // 执行压缩
            CompressResult result = performCompress(request);
            result.setCompressTime(System.currentTimeMillis() - startTime);

            return result;

        } catch (Exception e) {
            log.error("文件压缩失败: {}", e.getMessage(), e);
            CompressResult result = CompressResult.failure("文件压缩失败: " + e.getMessage());
            result.setCompressTime(System.currentTimeMillis() - startTime);
            return result;
        }
    }

    @Override
    public DecompressResult decompress(FileDecompressRequest request) {
        long startTime = System.currentTimeMillis();

        try {
            // 检查是否支持解压格式
            if (!supportDecompress(request.getFormat())) {
                return DecompressResult.failure("不支持的解压格式: " + request.getFormat());
            }

            // 执行解压
            DecompressResult result = performDecompress(request);
            result.setDecompressTime(System.currentTimeMillis() - startTime);

            return result;

        } catch (Exception e) {
            log.error("文件解压失败: {}", e.getMessage(), e);
            DecompressResult result = DecompressResult.failure("文件解压失败: " + e.getMessage());
            result.setDecompressTime(System.currentTimeMillis() - startTime);
            return result;
        }
    }

    @Override
    public boolean supportCompress(String format) {
        return "zip".equalsIgnoreCase(format);
    }

    @Override
    public boolean supportDecompress(String format) {
        return "zip".equalsIgnoreCase(format);
    }

    @Override
    public String[] getSupportedCompressFormats() {
        return new String[]{"zip"};
    }

    @Override
    public String[] getSupportedDecompressFormats() {
        return new String[]{"zip"};
    }

    /**
     * 执行压缩操作
     */
    private CompressResult performCompress(FileCompressRequest request) throws Exception {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        try (ZipArchiveOutputStream zipOutput = new ZipArchiveOutputStream(outputStream)) {
            zipOutput.setLevel(request.getLevel());

            // 设置密码（如果需要）
            if (request.isEncrypted() && request.getPassword() != null) {
                // 注意：commons-compress的ZipArchiveOutputStream不支持密码设置
                // 这里只是示例，实际需要其他库来支持密码保护的ZIP
                log.warn("ZIP密码保护功能需要额外的库支持");
            }

            // 添加文件到压缩包
            for (FileCompressRequest.CompressFile file : request.getFiles()) {
                ZipArchiveEntry entry = new ZipArchiveEntry(file.getPathInArchive());
                entry.setSize(file.getFileSize());
                zipOutput.putArchiveEntry(entry);

                IOUtils.copy(file.getFileStream(), zipOutput);
                zipOutput.closeArchiveEntry();
            }
        }

        byte[] compressedData = outputStream.toByteArray();
        ByteArrayInputStream resultStream = new ByteArrayInputStream(compressedData);

        String compressFileName = request.getCompressFileName();
        if (compressFileName == null) {
            compressFileName = "compressed_" + System.currentTimeMillis() + ".zip";
        }

        // 计算压缩率
        long originalSize = request.getFiles().stream().mapToLong(FileCompressRequest.CompressFile::getFileSize).sum();
        double compressRatio = originalSize > 0 ? (double) compressedData.length / originalSize : 0;

        return CompressResult.success(resultStream, compressFileName, compressedData.length, compressRatio);
    }

    /**
     * 执行解压操作
     */
    private DecompressResult performDecompress(FileDecompressRequest request) throws Exception {
        List<DecompressResult.DecompressedFile> files = new ArrayList<>();

        // 将输入流转换为字节数组，然后创建临时文件
        ByteArrayOutputStream tempOutput = new ByteArrayOutputStream();
        IOUtils.copy(request.getCompressStream(), tempOutput);
        byte[] zipData = tempOutput.toByteArray();

        // 创建临时文件
        java.io.File tempFile = java.io.File.createTempFile("zip_", ".zip");
        try {
            java.nio.file.Files.write(tempFile.toPath(), zipData);

            try (ZipFile zipFile = new ZipFile(tempFile)) {
                Enumeration<ZipArchiveEntry> entries = zipFile.getEntries();

                while (entries.hasMoreElements()) {
                    ZipArchiveEntry entry = entries.nextElement();

                    if (!entry.isDirectory()) {
                        DecompressResult.DecompressedFile file = new DecompressResult.DecompressedFile();
                        file.setFileName(entry.getName());
                        file.setFilePath(entry.getName());
                        file.setFileSize(entry.getSize());
                        file.setFileType(getFileTypeFromName(entry.getName()));

                        // 读取文件内容
                        try (InputStream entryStream = zipFile.getInputStream(entry)) {
                            byte[] content = IOUtils.toByteArray(entryStream);
                            file.setContent(content);
                        }

                        files.add(file);
                    }
                }
            }
        } finally {
            // 清理临时文件
            if (tempFile.exists()) {
                tempFile.delete();
            }
        }

        return DecompressResult.success(files);
    }

    /**
     * 根据文件名获取文件类型
     */
    private String getFileTypeFromName(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1).toLowerCase();
        }
        return "unknown";
    }
}
