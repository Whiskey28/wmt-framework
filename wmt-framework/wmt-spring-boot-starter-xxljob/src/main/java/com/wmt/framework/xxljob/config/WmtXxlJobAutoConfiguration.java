package com.wmt.framework.xxljob.config;

import com.wmt.framework.xxljob.job.JobHandlerRouter;
import com.xxl.job.core.executor.impl.XxlJobSpringExecutor;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;

@AutoConfiguration
@EnableConfigurationProperties(WmtXxlJobAutoConfiguration.XxlJobProps.class)
@ConditionalOnProperty(prefix = "xxl.job", name = "enabled", havingValue = "true")
@Import({JobHandlerRouter.class})
public class WmtXxlJobAutoConfiguration {

    @Bean
    public XxlJobSpringExecutor xxlJobExecutor(XxlJobProps props) {
        XxlJobSpringExecutor exec = new XxlJobSpringExecutor();
        exec.setAdminAddresses(props.getAdmin().getAddresses());
        exec.setAppname(props.getExecutor().getAppname());
        exec.setAddress(props.getExecutor().getAddress());
        exec.setIp(props.getExecutor().getIp());
        exec.setPort(props.getExecutor().getPort());
        exec.setAccessToken(props.getAccessToken());
        exec.setLogPath(props.getExecutor().getLogpath());
        exec.setLogRetentionDays(props.getExecutor().getLogretentiondays());
        return exec;
    }

    @ConfigurationProperties(prefix = "xxl.job")
    public static class XxlJobProps {
        private boolean enabled = false;
        private String accessToken;
        private Admin admin = new Admin();
        private Executor executor = new Executor();

        public boolean isEnabled() { return enabled; }
        public void setEnabled(boolean enabled) { this.enabled = enabled; }
        public String getAccessToken() { return accessToken; }
        public void setAccessToken(String accessToken) { this.accessToken = accessToken; }
        public Admin getAdmin() { return admin; }
        public void setAdmin(Admin admin) { this.admin = admin; }
        public Executor getExecutor() { return executor; }
        public void setExecutor(Executor executor) { this.executor = executor; }

        public static class Admin {
            private String addresses;
            public String getAddresses() { return addresses; }
            public void setAddresses(String addresses) { this.addresses = addresses; }
        }
        public static class Executor {
            private String appname;
            private String address;
            private String ip;
            private int port = 9999;
            private String logpath = "./logs/xxl-job";
            private int logretentiondays = 30;
            public String getAppname() { return appname; }
            public void setAppname(String appname) { this.appname = appname; }
            public String getAddress() { return address; }
            public void setAddress(String address) { this.address = address; }
            public String getIp() { return ip; }
            public void setIp(String ip) { this.ip = ip; }
            public int getPort() { return port; }
            public void setPort(int port) { this.port = port; }
            public String getLogpath() { return logpath; }
            public void setLogpath(String logpath) { this.logpath = logpath; }
            public int getLogretentiondays() { return logretentiondays; }
            public void setLogretentiondays(int logretentiondays) { this.logretentiondays = logretentiondays; }
        }
    }
}


