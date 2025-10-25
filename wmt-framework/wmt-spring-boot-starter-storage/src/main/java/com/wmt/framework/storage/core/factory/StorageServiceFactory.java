package com.wmt.framework.storage.core.factory;

import com.wmt.framework.storage.config.StorageProperties;
import com.wmt.framework.storage.core.enums.StorageType;
import com.wmt.framework.storage.core.impl.LocalStorageServiceImpl;
import com.wmt.framework.storage.core.impl.MinioStorageServiceImpl;
import com.wmt.framework.storage.core.service.StorageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 存储服务工厂
 * 根据配置选择具体的存储实现
 */
@Slf4j
@Component
public class StorageServiceFactory {

    @Autowired
    private StorageProperties storageProperties;

    @Autowired
    private LocalStorageServiceImpl localStorageService;

    @Autowired
    private MinioStorageServiceImpl minioStorageService;

    /**
     * 获取存储服务实例
     */
    public StorageService getStorageService() {
        StorageType type = storageProperties.getType();

        switch (type) {
            case LOCAL:
                return localStorageService;
            case MINIO:
                return minioStorageService;
            case OSS:
            case COS:
            case S3:
                throw new UnsupportedOperationException("暂不支持存储类型: " + type);
            default:
                log.warn("未知的存储类型: {}，使用默认本地存储", type);
                return localStorageService;
        }
    }

    /**
     * 根据类型获取存储服务实例
     */
    public StorageService getStorageService(StorageType type) {
        switch (type) {
            case LOCAL:
                return localStorageService;
            case MINIO:
                return minioStorageService;
            case OSS:
            case COS:
            case S3:
                throw new UnsupportedOperationException("暂不支持存储类型: " + type);
            default:
                log.warn("未知的存储类型: {}，使用默认本地存储", type);
                return localStorageService;
        }
    }
}
