package com.wmt.framework.crypto.config;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class CryptoPlatformAutoConfigurationTest {

    @TempDir
    Path tempDir;

    @Test
    void unionCssp_shouldFailWhenConfigMissingAndFailOnError() {
        CryptoPlatformProperties properties = new CryptoPlatformProperties();
        properties.setEnabled(true);
        properties.setFailOnConfigError(true);

        CryptoPlatformAutoConfiguration configuration = new CryptoPlatformAutoConfiguration();
        assertThrows(IllegalStateException.class, () -> configuration.unionCssp(properties));
    }

    @Test
    void unionCssp_shouldSetSystemPropertyWhenConfigExists() throws Exception {
        Path conf = tempDir.resolve("serverList.conf");
        Files.writeString(conf, "[CSSP]\t[TE]\t[TE]\t[2]\t[1000]\t[60]\t[0]\t[1]\n{CSSP}\n[127.0.0.1]\t[22601]\n");

        CryptoPlatformProperties properties = new CryptoPlatformProperties();
        properties.setConfigFile(conf.toString());
        properties.setFailOnConfigError(true);

        CryptoPlatformAutoConfiguration configuration = new CryptoPlatformAutoConfiguration();
        assertDoesNotThrow(() -> configuration.unionCssp(properties));
        assertEquals(conf.toAbsolutePath().normalize().toString(),
                System.getProperty(CryptoPlatformAutoConfiguration.CONFIG_FILE_SYSTEM_PROPERTY));
        System.clearProperty(CryptoPlatformAutoConfiguration.CONFIG_FILE_SYSTEM_PROPERTY);
    }

}
