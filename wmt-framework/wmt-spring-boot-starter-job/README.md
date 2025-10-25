# WMT Job Starter

基于Quartz和Spring Async的任务调度组件，提供定时任务、异步任务等功能。

## 功能特性

- ⏰ **定时任务**: 基于Quartz的定时任务调度
- 🚀 **异步任务**: 基于Spring Async的异步任务执行
- 📊 **任务管理**: 支持任务的启动、停止、暂停、恢复
- 📝 **任务日志**: 自动记录任务执行日志
- 🔄 **任务重试**: 支持任务失败重试机制
- 🎯 **任务监控**: 提供任务执行状态监控
- 🔧 **配置灵活**: 支持多种任务配置方式
- 📱 **多实例**: 支持多实例任务调度

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-job</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
spring:
  quartz:
    job-store-type: jdbc
    jdbc:
      initialize-schema: always
    properties:
      org:
        quartz:
          scheduler:
            instanceName: WmtScheduler
            instanceId: AUTO
          jobStore:
            class: org.quartz.impl.jdbcjobstore.JobStoreTX
            driverDelegateClass: org.quartz.impl.jdbcjobstore.StdJDBCDelegate
            tablePrefix: QRTZ_
            useProperties: false
            misfireThreshold: 60000
            clusterCheckinInterval: 5000
            isClustered: true
          threadPool:
            class: org.quartz.simpl.SimpleThreadPool
            threadCount: 10
            threadPriority: 5
            threadsInheritContextClassLoaderOfInitializingThread: true

# 异步任务配置
wmt:
  job:
    async:
      core-pool-size: 10
      max-pool-size: 20
      queue-capacity: 100
      thread-name-prefix: async-task-
```

### 3. 创建任务处理器

```java
@Component
public class UserSyncJobHandler implements JobHandler {
    
    @Override
    public String execute(String param) throws Exception {
        log.info("开始执行用户同步任务，参数：{}", param);
        
        try {
            // 解析参数
            UserSyncParam syncParam = JsonUtils.parseObject(param, UserSyncParam.class);
            
            // 执行同步逻辑
            int syncCount = userService.syncUsers(syncParam);
            
            log.info("用户同步任务执行完成，同步数量：{}", syncCount);
            return "同步成功，数量：" + syncCount;
        } catch (Exception e) {
            log.error("用户同步任务执行失败", e);
            throw e;
        }
    }
}
```

### 4. 使用任务调度

```java
@Service
public class JobService {
    
    @Resource
    private SchedulerManager schedulerManager;
    
    /**
     * 创建定时任务
     */
    public void createJob(Long jobId, String jobHandlerName, String cronExpression, String param) {
        JobDetail jobDetail = JobBuilder.newJob(JobHandlerInvoker.class)
                .withIdentity("job_" + jobId)
                .usingJobData(JobDataKeyEnum.JOB_ID.name(), jobId)
                .usingJobData(JobDataKeyEnum.JOB_HANDLER_NAME.name(), jobHandlerName)
                .usingJobData(JobDataKeyEnum.JOB_HANDLER_PARAM.name(), param)
                .build();
        
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("trigger_" + jobId)
                .withSchedule(CronScheduleBuilder.cronSchedule(cronExpression))
                .build();
        
        schedulerManager.scheduleJob(jobDetail, trigger);
    }
    
    /**
     * 暂停任务
     */
    public void pauseJob(Long jobId) {
        schedulerManager.pauseJob("job_" + jobId);
    }
    
    /**
     * 恢复任务
     */
    public void resumeJob(Long jobId) {
        schedulerManager.resumeJob("job_" + jobId);
    }
    
    /**
     * 删除任务
     */
    public void deleteJob(Long jobId) {
        schedulerManager.deleteJob("job_" + jobId);
    }
}
```

### 5. 使用异步任务

```java
@Service
public class UserService {
    
    @Async("taskExecutor")
    public CompletableFuture<Void> sendEmailAsync(Long userId, String content) {
        log.info("开始发送邮件给用户：{}", userId);
        
        try {
            // 模拟邮件发送
            Thread.sleep(2000);
            emailService.sendEmail(userId, content);
            
            log.info("邮件发送完成：{}", userId);
            return CompletableFuture.completedFuture(null);
        } catch (Exception e) {
            log.error("邮件发送失败：{}", userId, e);
            return CompletableFuture.failedFuture(e);
        }
    }
    
    @Async("taskExecutor")
    public CompletableFuture<String> processDataAsync(String data) {
        log.info("开始处理数据：{}", data);
        
        try {
            // 模拟数据处理
            Thread.sleep(3000);
            String result = dataProcessor.process(data);
            
            log.info("数据处理完成：{}", result);
            return CompletableFuture.completedFuture(result);
        } catch (Exception e) {
            log.error("数据处理失败：{}", data, e);
            return CompletableFuture.failedFuture(e);
        }
    }
}
```

### 6. 调用异步任务

```java
@RestController
public class UserController {
    
    @PostMapping("/users/{id}/send-email")
    public CommonResult<Void> sendEmail(@PathVariable Long id, @RequestBody EmailReqVO reqVO) {
        // 异步发送邮件
        userService.sendEmailAsync(id, reqVO.getContent());
        return CommonResult.success();
    }
    
    @PostMapping("/data/process")
    public CommonResult<String> processData(@RequestBody DataReqVO reqVO) {
        // 异步处理数据
        CompletableFuture<String> future = userService.processDataAsync(reqVO.getData());
        
        try {
            String result = future.get(5, TimeUnit.SECONDS);
            return CommonResult.success(result);
        } catch (TimeoutException e) {
            return CommonResult.error("处理超时");
        } catch (Exception e) {
            return CommonResult.error("处理失败");
        }
    }
}
```

## 配置说明

### Quartz配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `spring.quartz.job-store-type` | String | memory | 任务存储类型 |
| `spring.quartz.properties.org.quartz.scheduler.instanceName` | String | WmtScheduler | 调度器实例名 |
| `spring.quartz.properties.org.quartz.threadPool.threadCount` | int | 10 | 线程池大小 |

### 异步任务配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.job.async.core-pool-size` | int | 10 | 核心线程数 |
| `wmt.job.async.max-pool-size` | int | 20 | 最大线程数 |
| `wmt.job.async.queue-capacity` | int | 100 | 队列容量 |
| `wmt.job.async.thread-name-prefix` | String | async-task- | 线程名前缀 |

## 核心功能

### 定时任务

#### JobHandler接口

任务处理器接口：

```java
public interface JobHandler {
    
    /**
     * 执行任务
     *
     * @param param 参数
     * @return 结果
     * @throws Exception 异常
     */
    String execute(String param) throws Exception;
}
```

#### 自定义任务处理器

```java
@Component
public class DataSyncJobHandler implements JobHandler {
    
    @Override
    public String execute(String param) throws Exception {
        log.info("开始执行数据同步任务，参数：{}", param);
        
        try {
            // 解析参数
            DataSyncParam syncParam = JsonUtils.parseObject(param, DataSyncParam.class);
            
            // 执行同步逻辑
            int syncCount = dataService.syncData(syncParam);
            
            log.info("数据同步任务执行完成，同步数量：{}", syncCount);
            return "同步成功，数量：" + syncCount;
        } catch (Exception e) {
            log.error("数据同步任务执行失败", e);
            throw e;
        }
    }
}
```

#### 任务调度管理

```java
@Service
public class JobService {
    
    @Resource
    private SchedulerManager schedulerManager;
    
    /**
     * 创建定时任务
     */
    public void createJob(Long jobId, String jobHandlerName, String cronExpression, String param) {
        JobDetail jobDetail = JobBuilder.newJob(JobHandlerInvoker.class)
                .withIdentity("job_" + jobId)
                .usingJobData(JobDataKeyEnum.JOB_ID.name(), jobId)
                .usingJobData(JobDataKeyEnum.JOB_HANDLER_NAME.name(), jobHandlerName)
                .usingJobData(JobDataKeyEnum.JOB_HANDLER_PARAM.name(), param)
                .build();
        
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("trigger_" + jobId)
                .withSchedule(CronScheduleBuilder.cronSchedule(cronExpression))
                .build();
        
        schedulerManager.scheduleJob(jobDetail, trigger);
    }
    
    /**
     * 立即执行任务
     */
    public void triggerJob(Long jobId) {
        schedulerManager.triggerJob("job_" + jobId);
    }
    
    /**
     * 暂停任务
     */
    public void pauseJob(Long jobId) {
        schedulerManager.pauseJob("job_" + jobId);
    }
    
    /**
     * 恢复任务
     */
    public void resumeJob(Long jobId) {
        schedulerManager.resumeJob("job_" + jobId);
    }
    
    /**
     * 删除任务
     */
    public void deleteJob(Long jobId) {
        schedulerManager.deleteJob("job_" + jobId);
    }
}
```

### 异步任务

#### @Async注解

异步任务注解：

```java
@Service
public class UserService {
    
    @Async("taskExecutor")
    public CompletableFuture<Void> sendEmailAsync(Long userId, String content) {
        // 异步发送邮件
        emailService.sendEmail(userId, content);
        return CompletableFuture.completedFuture(null);
    }
    
    @Async("taskExecutor")
    public CompletableFuture<String> processDataAsync(String data) {
        // 异步处理数据
        String result = dataProcessor.process(data);
        return CompletableFuture.completedFuture(result);
    }
}
```

#### 异步任务配置

```java
@Configuration
@EnableAsync
public class AsyncConfig {
    
    @Bean("taskExecutor")
    public ThreadPoolTaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-task-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.initialize();
        return executor;
    }
}
```

### 任务日志

#### 自动记录任务日志

```java
@Component
public class JobLogFrameworkService {
    
    /**
     * 创建任务日志
     */
    public Long createJobLog(Long jobId, LocalDateTime startTime, String jobHandlerName, String jobHandlerParam, int refireCount) {
        JobLogDO jobLog = new JobLogDO();
        jobLog.setJobId(jobId);
        jobLog.setStartTime(startTime);
        jobLog.setJobHandlerName(jobHandlerName);
        jobLog.setJobHandlerParam(jobHandlerParam);
        jobLog.setRefireCount(refireCount);
        jobLog.setStatus(JobLogStatusEnum.RUNNING.getStatus());
        
        jobLogMapper.insert(jobLog);
        return jobLog.getId();
    }
    
    /**
     * 更新任务日志结果
     */
    public void updateJobLogResult(Long jobLogId, LocalDateTime startTime, String data, Throwable exception) {
        JobLogDO jobLog = new JobLogDO();
        jobLog.setId(jobLogId);
        jobLog.setEndTime(LocalDateTime.now());
        jobLog.setDuration((int) ChronoUnit.MILLIS.between(startTime, jobLog.getEndTime()));
        
        if (exception != null) {
            jobLog.setStatus(JobLogStatusEnum.FAILURE.getStatus());
            jobLog.setResult(ExceptionUtils.getStackTrace(exception));
        } else {
            jobLog.setStatus(JobLogStatusEnum.SUCCESS.getStatus());
            jobLog.setResult(data);
        }
        
        jobLogMapper.updateById(jobLog);
    }
}
```

## 工具类

### CronUtils

Cron表达式工具类：

```java
// 验证Cron表达式
boolean isValid = CronUtils.isValid("0 0 12 * * ?");

// 获取下次执行时间
Date nextTime = CronUtils.getNextExecution("0 0 12 * * ?");

// 获取执行时间列表
List<Date> executionTimes = CronUtils.getExecutionTimes("0 0 12 * * ?", 10);
```

### SchedulerManager

调度器管理工具类：

```java
// 调度任务
schedulerManager.scheduleJob(jobDetail, trigger);

// 立即执行任务
schedulerManager.triggerJob("job_1");

// 暂停任务
schedulerManager.pauseJob("job_1");

// 恢复任务
schedulerManager.resumeJob("job_1");

// 删除任务
schedulerManager.deleteJob("job_1");
```

## 最佳实践

### 1. 任务处理器设计

```java
@Component
public class UserSyncJobHandler implements JobHandler {
    
    @Override
    public String execute(String param) throws Exception {
        log.info("开始执行用户同步任务，参数：{}", param);
        
        try {
            // 解析参数
            UserSyncParam syncParam = JsonUtils.parseObject(param, UserSyncParam.class);
            
            // 执行同步逻辑
            int syncCount = userService.syncUsers(syncParam);
            
            log.info("用户同步任务执行完成，同步数量：{}", syncCount);
            return "同步成功，数量：" + syncCount;
        } catch (Exception e) {
            log.error("用户同步任务执行失败", e);
            throw e;
        }
    }
}
```

### 2. 异步任务设计

```java
@Service
public class UserService {
    
    @Async("taskExecutor")
    public CompletableFuture<Void> sendEmailAsync(Long userId, String content) {
        log.info("开始发送邮件给用户：{}", userId);
        
        try {
            emailService.sendEmail(userId, content);
            log.info("邮件发送完成：{}", userId);
            return CompletableFuture.completedFuture(null);
        } catch (Exception e) {
            log.error("邮件发送失败：{}", userId, e);
            return CompletableFuture.failedFuture(e);
        }
    }
}
```

### 3. 任务管理设计

```java
@Service
public class JobService {
    
    @Resource
    private SchedulerManager schedulerManager;
    
    public void createJob(Long jobId, String jobHandlerName, String cronExpression, String param) {
        // 创建任务详情
        JobDetail jobDetail = JobBuilder.newJob(JobHandlerInvoker.class)
                .withIdentity("job_" + jobId)
                .usingJobData(JobDataKeyEnum.JOB_ID.name(), jobId)
                .usingJobData(JobDataKeyEnum.JOB_HANDLER_NAME.name(), jobHandlerName)
                .usingJobData(JobDataKeyEnum.JOB_HANDLER_PARAM.name(), param)
                .build();
        
        // 创建触发器
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("trigger_" + jobId)
                .withSchedule(CronScheduleBuilder.cronSchedule(cronExpression))
                .build();
        
        // 调度任务
        schedulerManager.scheduleJob(jobDetail, trigger);
    }
}
```

### 4. 错误处理

```java
@Component
public class DataSyncJobHandler implements JobHandler {
    
    @Override
    public String execute(String param) throws Exception {
        try {
            // 执行任务逻辑
            return processData(param);
        } catch (Exception e) {
            log.error("任务执行失败，参数：{}", param, e);
            throw e;
        }
    }
}
```

## 故障排除

### 常见问题

1. **任务不执行**
   - 检查Cron表达式是否正确
   - 确认任务处理器是否注册为Spring Bean
   - 验证调度器是否正常启动

2. **异步任务不生效**
   - 确认使用了`@Async`注解
   - 检查异步配置是否正确
   - 验证线程池配置

3. **任务重复执行**
   - 检查集群配置是否正确
   - 确认任务是否设置了`@DisallowConcurrentExecution`
   - 验证数据库连接配置

4. **任务日志不记录**
   - 检查任务日志配置是否正确
   - 确认数据库连接是否正常
   - 验证日志表结构

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.quartz: DEBUG
    org.quartz: DEBUG
    org.springframework.scheduling: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Quartz: 2.3.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
