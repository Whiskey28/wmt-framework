package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import org.junit.jupiter.api.Test;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class EsbSequenceServiceTest {

    @Test
    void nextCnsmSysSeqNo_shouldFollow19DigitRule() {
        EsbProperties properties = new EsbProperties();
        properties.setCnsmSysId("DMPF001");
        EsbSequenceService service = new EsbSequenceService(properties);

        String seqNo = service.nextCnsmSysSeqNo();

        assertEquals(19, seqNo.length());
        assertTrue(seqNo.startsWith("DMPF00100"));
        assertEquals('9', seqNo.charAt(12));
        assertEquals("DMPF001000019000001", seqNo);
    }

    @Test
    void nextCnsmSysSeqNo_withRedis_shouldUseIncrMapping() {
        EsbProperties properties = new EsbProperties();
        properties.setCnsmSysId("DMPF001");
        StringRedisTemplate redis = mock(StringRedisTemplate.class);
        @SuppressWarnings("unchecked")
        ValueOperations<String, String> ops = mock(ValueOperations.class);
        when(redis.opsForValue()).thenReturn(ops);
        when(ops.increment(eq(EsbSequenceService.REDIS_KEY_PREFIX + "DMPF001"))).thenReturn(100L);

        EsbSequenceService service = new EsbSequenceService(properties, redis);
        assertEquals("DMPF001000009000100", service.nextCnsmSysSeqNo());
    }

    @Test
    void nextCnsmSysSeqNo_withRedisNull_shouldFailLoudly() {
        EsbProperties properties = new EsbProperties();
        properties.setCnsmSysId("DMPF001");
        StringRedisTemplate redis = mock(StringRedisTemplate.class);
        @SuppressWarnings("unchecked")
        ValueOperations<String, String> ops = mock(ValueOperations.class);
        when(redis.opsForValue()).thenReturn(ops);
        when(ops.increment(eq(EsbSequenceService.REDIS_KEY_PREFIX + "DMPF001"))).thenReturn(null);

        EsbSequenceService service = new EsbSequenceService(properties, redis);
        assertThrows(Exception.class, service::nextCnsmSysSeqNo);
    }

    @Test
    void normalizeSystemId_shouldRejectInvalidLength() {
        assertThrows(Exception.class, () -> EsbSequenceService.normalizeSystemId("ABC"));
    }

}
