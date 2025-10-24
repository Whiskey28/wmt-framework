package com.wmt.framework.file.config;

import com.wmt.framework.file.core.*;
import com.wmt.framework.file.core.impl.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 文件处理服务自动配置
 */
@Slf4j
@Configuration
public class FileAutoConfiguration {

    /**
     * 文件转换服务
     */
    @Bean
    public FileConvertServiceImpl fileConvertService() {
        log.info("初始化文件转换服务");
        return new FileConvertServiceImpl();
    }

    /**
     * 文件预览服务
     */
    @Bean
    public FilePreviewServiceImpl filePreviewService() {
        log.info("初始化文件预览服务");
        return new FilePreviewServiceImpl();
    }

    /**
     * 文件压缩服务
     */
    @Bean
    public FileCompressService fileCompressService() {
        log.info("初始化文件压缩服务");
        return new FileCompressServiceImpl();
    }

    /**
     * 文件校验服务
     */
    @Bean
    public FileValidateServiceImpl fileValidateService() {
        log.info("初始化文件校验服务");
        return new FileValidateServiceImpl();
    }
}
