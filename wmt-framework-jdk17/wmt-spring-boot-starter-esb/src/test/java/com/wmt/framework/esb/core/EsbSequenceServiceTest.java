package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

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
    }

    @Test
    void normalizeSystemId_shouldRejectInvalidLength() {
        assertThrows(Exception.class, () -> EsbSequenceService.normalizeSystemId("ABC"));
    }

}
