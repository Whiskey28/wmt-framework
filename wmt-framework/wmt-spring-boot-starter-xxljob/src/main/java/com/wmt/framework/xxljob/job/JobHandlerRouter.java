package com.wmt.framework.xxljob.job;

import com.wmt.framework.quartz.core.handler.JobHandler;
import com.xxl.job.core.context.XxlJobHelper;
import com.xxl.job.core.handler.annotation.XxlJob;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * 兼容现有 JobHandler 的 XXL-Job 路由器
 * 使用：在 xxl-job-admin 上配置 JobHandler 为 "jobHandlerRouter"，参数为 Spring Bean 名称或 JSON，包含 handlerName/param
 */
@Component
public class JobHandlerRouter {

    @Resource
    private ApplicationContext applicationContext;

    @XxlJob("jobHandlerRouter")
    public void execute() throws Exception {
        String param = XxlJobHelper.getJobParam();
        // param 允许直接传 beanName 或者 "beanName#payload" 格式
        String beanName = param;
        String payload = "";
        if (param != null && param.contains("#")) {
            int idx = param.indexOf('#');
            beanName = param.substring(0, idx).trim();
            payload = param.substring(idx + 1);
        }
        JobHandler handler = applicationContext.getBean(beanName, JobHandler.class);
        String result = handler.execute(payload);
        XxlJobHelper.log("result: {}", result);
    }
}


