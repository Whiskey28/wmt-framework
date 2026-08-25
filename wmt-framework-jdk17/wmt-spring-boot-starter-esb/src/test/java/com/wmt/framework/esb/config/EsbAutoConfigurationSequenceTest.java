package com.wmt.framework.esb.config;

import com.wmt.framework.esb.core.EsbSequenceService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.autoconfigure.AutoConfigurations;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * 回归：有 {@link StringRedisTemplate} 时必须走 Redis 流水号，不能被内存回退抢先注册。
 */
class EsbAutoConfigurationSequenceTest {

    private final ApplicationContextRunner contextRunner = new ApplicationContextRunner()
            .withConfiguration(AutoConfigurations.of(EsbAutoConfiguration.class))
            .withPropertyValues(
                    "wmt.esb.enabled=true",
                    "wmt.esb.host=127.0.0.1",
                    "wmt.esb.port=10001",
                    "wmt.esb.cnsm-sys-id=DMPF001",
                    "wmt.esb.cnsm-sys-svr-id=1270000001"
            );

    @Test
    void withStringRedisTemplate_shouldUseRedisIncr() {
        StringRedisTemplate redis = mock(StringRedisTemplate.class);
        @SuppressWarnings("unchecked")
        ValueOperations<String, String> ops = mock(ValueOperations.class);
        when(redis.opsForValue()).thenReturn(ops);
        when(ops.increment(eq("esb:seq:DMPF001"))).thenReturn(100L);

        contextRunner
                .withBean(StringRedisTemplate.class, () -> redis)
                .run(context -> {
                    assertThat(context).hasSingleBean(EsbSequenceService.class);
                    EsbSequenceService sequenceService = context.getBean(EsbSequenceService.class);
                    assertThat(sequenceService.nextCnsmSysSeqNo()).isEqualTo("DMPF001000009000100");
                    verify(ops).increment("esb:seq:DMPF001");
                });
    }

    @Test
    void withoutStringRedisTemplate_shouldFallbackToMemory() {
        contextRunner.run(context -> {
            assertThat(context).hasSingleBean(EsbSequenceService.class);
            EsbSequenceService sequenceService = context.getBean(EsbSequenceService.class);
            assertThat(sequenceService.nextCnsmSysSeqNo()).isEqualTo("DMPF001000019000001");
        });
    }

}
