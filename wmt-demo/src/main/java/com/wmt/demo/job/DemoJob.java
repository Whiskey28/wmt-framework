package com.wmt.demo.job;

import com.xxl.job.core.handler.annotation.XxlJob;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 演示定时任务
 *
 * @author WMT
 */
@Slf4j
@Component
public class DemoJob {

    /**
     * 简单的定时任务示例
     */
    @XxlJob("demoJob")
    public void execute() {
        log.info("===== 执行演示定时任务 =====");
        log.info("当前时间: {}", System.currentTimeMillis());
        // 这里可以编写具体的业务逻辑
        log.info("===== 定时任务执行完成 =====");
    }

}

