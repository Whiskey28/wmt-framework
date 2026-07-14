package com.wmt.framework.crypto.core;

import com.union.api.UnionCSSP;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * 不依赖 Mockito：使用匿名子类桩，避免 starter-test 传递依赖差异。
 */
class CryptoPlatformKeyServiceTest {

    @Test
    void importSymmetricKeyByLmk_shouldMapSuccessRecv() {
        UnionCSSP cssp = new UnionCSSP() {
            @Override
            public Recv servE112(String keyName, String keyValue, String checkValue,
                                 String protectFlag, String protectKey, String activeDate) {
                assertEquals("DMPF.861BY8610001.zak", keyName);
                assertEquals("5C9C41B3438132AC", keyValue);
                assertEquals("3", protectFlag);
                Recv recv = new Recv();
                recv.setResponseCode(0);
                recv.setResponseRemark("ok");
                recv.setKeyName(keyName);
                recv.setCheckValue("AABBCCDD");
                return recv;
            }
        };

        CryptoPlatformKeyService service = new CryptoPlatformKeyService(cssp);
        CryptoPlatformKeyResult result = service.importSymmetricKeyByLmk(
                "DMPF.861BY8610001.zak", "5C9C41B3438132AC");

        assertTrue(result.isSuccess());
        assertEquals(0, result.getResponseCode());
        assertEquals("DMPF.861BY8610001.zak", result.getKeyName());
        assertEquals("AABBCCDD", result.getCheckValue());
    }

    @Test
    void importSymmetricKey_shouldMapFailureRecv() {
        UnionCSSP cssp = new UnionCSSP() {
            @Override
            public Recv servE112(String keyName, String keyValue, String checkValue,
                                 String protectFlag, String protectKey, String activeDate) {
                Recv recv = new Recv();
                recv.setResponseCode(-2004);
                recv.setResponseRemark("Connect timed out");
                return recv;
            }
        };

        CryptoPlatformKeyService service = new CryptoPlatformKeyService(cssp);
        CryptoPlatformKeyResult result = service.importSymmetricKey(
                "DMPF.TEST.zak", "AABB", "", "3", "", "");

        assertFalse(result.isSuccess());
        assertEquals(-2004, result.getResponseCode());
    }

    @Test
    void importSymmetricKeyByLmkOrThrow_shouldThrowOnFailure() {
        UnionCSSP cssp = new UnionCSSP() {
            @Override
            public Recv servE112(String keyName, String keyValue, String checkValue,
                                 String protectFlag, String protectKey, String activeDate) {
                Recv recv = new Recv();
                recv.setResponseCode(-2004);
                recv.setResponseRemark("Connect timed out");
                return recv;
            }
        };
        CryptoPlatformKeyService service = new CryptoPlatformKeyService(cssp);
        assertThrows(Exception.class,
                () -> service.importSymmetricKeyByLmkOrThrow("DMPF.TEST.zak", "AABB"));
    }

    @Test
    void importSymmetricKey_shouldRejectBlankKeyName() {
        CryptoPlatformKeyService service = new CryptoPlatformKeyService(new UnionCSSP());
        assertThrows(Exception.class, () -> service.importSymmetricKeyByLmk(" ", "AABB"));
    }

}
