package com.wmt.framework.storage.core.enums;

/**
 * 存储类型枚举
 */
public enum StorageType {

    /**
     * 本地存储
     */
    LOCAL("local"),

    /**
     * MinIO对象存储
     */
    MINIO("minio"),

    /**
     * 阿里云OSS
     */
    OSS("oss"),

    /**
     * 腾讯云COS
     */
    COS("cos"),

    /**
     * AWS S3
     */
    S3("s3");

    private final String value;

    StorageType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static StorageType fromValue(String value) {
        for (StorageType type : values()) {
            if (type.value.equals(value)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown storage type: " + value);
    }
}
