package com.wmt.framework.storage.config;

import com.wmt.framework.storage.core.factory.StorageServiceFactory;
import com.wmt.framework.storage.core.impl.LocalStorageServiceImpl;
import com.wmt.framework.storage.core.impl.MinioStorageServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 存储服务自动配置
 */
@Slf4j
@Configuration
@EnableConfigurationProperties(StorageProperties.class)
public class StorageAutoConfiguration {

    /**
     * 本地存储服务
     */
    @Bean
    @ConditionalOnProperty(prefix = "wmt.storage", name = "type", havingValue = "local", matchIfMissing = true)
    public LocalStorageServiceImpl localStorageService() {
        log.info("初始化本地存储服务");
        return new LocalStorageServiceImpl();
    }

    /**
     * MinIO存储服务
     */
    @Bean
    @ConditionalOnProperty(prefix = "wmt.storage", name = "type", havingValue = "minio")
    public MinioStorageServiceImpl minioStorageService() {
        log.info("初始化MinIO存储服务");
        return new MinioStorageServiceImpl();
    }

    /**
     * 存储服务工厂
     */
    @Bean
    public StorageServiceFactory storageServiceFactory() {
        return new StorageServiceFactory();
    }
}
