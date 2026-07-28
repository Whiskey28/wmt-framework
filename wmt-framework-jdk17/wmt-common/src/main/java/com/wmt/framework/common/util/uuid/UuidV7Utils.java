package com.wmt.framework.common.util.uuid;

import java.security.SecureRandom;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicLong;

/**
 * RFC 9562 UUID v7 生成工具（时间有序，适用于数据库聚簇主键）。
 *
 * @author wmt
 */
public final class UuidV7Utils {

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final AtomicLong LAST_TIMESTAMP = new AtomicLong();
    private static final AtomicLong SEQUENCE = new AtomicLong();

    private UuidV7Utils() {
    }

    /**
     * 生成标准格式 UUID v7（36 字符，含连字符）。
     */
    public static String generate() {
        long timestamp = System.currentTimeMillis();
        long last = LAST_TIMESTAMP.get();
        if (timestamp > last) {
            LAST_TIMESTAMP.compareAndSet(last, timestamp);
            SEQUENCE.set(RANDOM.nextInt(1 << 12));
        } else {
            timestamp = LAST_TIMESTAMP.get();
            SEQUENCE.incrementAndGet();
        }

        long seq = SEQUENCE.get() & 0xFFF;
        long msb = (timestamp << 16) | (0x7L << 12) | seq;

        long rand = RANDOM.nextLong();
        long lsb = (rand & 0x3FFFFFFFFFFFFFFFL) | 0x8000000000000000L;

        return new UUID(msb, lsb).toString();
    }

    /**
     * 判断是否为 UUID v7（接受 32/36 字符格式）。
     */
    public static boolean isUuidV7(String uuid) {
        if (uuid == null) {
            return false;
        }
        String compact = uuid.replace("-", "");
        if (compact.length() != 32) {
            return false;
        }
        try {
            // version nibble is at character index 12 in compact form
            int version = Character.digit(compact.charAt(12), 16);
            return version == 7;
        } catch (Exception ex) {
            return false;
        }
    }

    /**
     * 将 32 位无横杠 UUID 转为标准 36 位格式；已是标准格式则原样返回。
     */
    public static String normalizeToStandard(String uuid) {
        if (uuid == null) {
            return null;
        }
        String trimmed = uuid.trim();
        if (trimmed.length() == 36) {
            return trimmed;
        }
        if (trimmed.length() != 32) {
            throw new IllegalArgumentException("Invalid UUID length: " + trimmed.length());
        }
        return trimmed.substring(0, 8) + "-"
                + trimmed.substring(8, 12) + "-"
                + trimmed.substring(12, 16) + "-"
                + trimmed.substring(16, 20) + "-"
                + trimmed.substring(20, 32);
    }

}
