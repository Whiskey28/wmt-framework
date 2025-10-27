# WMT MQ Starter

基于Redis、RocketMQ、RabbitMQ、Kafka的消息队列组件，提供统一的消息发送和消费接口。

## 功能特性

- 📡 **多消息队列支持**: 支持Redis、RocketMQ、RabbitMQ、Kafka四种消息队列
- 🔄 **统一接口**: 提供统一的消息发送和消费接口
- 📝 **消息序列化**: 支持JSON序列化，自动处理消息转换
- 🎯 **消息路由**: 支持消息路由和分发
- 🔒 **消息确认**: 支持消息确认机制
- 📊 **消息监控**: 提供消息发送和消费统计
- 🔧 **配置灵活**: 支持多种配置方式和策略
- 🛡️ **容错处理**: 支持消息重试和死信队列

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-mq</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
# Redis配置（如果使用Redis作为消息队列）
spring:
  redis:
    host: localhost
    port: 6379
    password: password

# RocketMQ配置（如果使用RocketMQ）
rocketmq:
  name-server: localhost:9876
  producer:
    group: wmt-producer
  consumer:
    group: wmt-consumer

# RabbitMQ配置（如果使用RabbitMQ）
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest

# Kafka配置（如果使用Kafka）
spring:
  kafka:
    bootstrap-servers: localhost:9092
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.apache.kafka.common.serialization.StringSerializer
    consumer:
      group-id: wmt-consumer
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.apache.kafka.common.serialization.StringDeserializer
```

### 3. 使用Redis消息队列

```java
@Service
public class UserService {
    
    @Resource
    private RedisMQTemplate redisMQTemplate;
    
    /**
     * 发送用户创建消息
     */
    public void sendUserCreateMessage(Long userId) {
        UserCreateMessage message = new UserCreateMessage();
        message.setUserId(userId);
        message.setTimestamp(System.currentTimeMillis());
        
        redisMQTemplate.send("user.create", message);
    }
    
    /**
     * 发送用户更新消息
     */
    public void sendUserUpdateMessage(Long userId, UserUpdateMessage message) {
        redisMQTemplate.send("user.update", message);
    }
}
```

### 4. 使用RocketMQ

```java
@Service
public class UserService {
    
    @Resource
    private RocketMQTemplate rocketMQTemplate;
    
    /**
     * 发送用户创建消息
     */
    public void sendUserCreateMessage(Long userId) {
        UserCreateMessage message = new UserCreateMessage();
        message.setUserId(userId);
        message.setTimestamp(System.currentTimeMillis());
        
        rocketMQTemplate.convertAndSend("user-create-topic", message);
    }
}
```

### 5. 使用RabbitMQ

```java
@Service
public class UserService {
    
    @Resource
    private RabbitTemplate rabbitTemplate;
    
    /**
     * 发送用户创建消息
     */
    public void sendUserCreateMessage(Long userId) {
        UserCreateMessage message = new UserCreateMessage();
        message.setUserId(userId);
        message.setTimestamp(System.currentTimeMillis());
        
        rabbitTemplate.convertAndSend("user.create.exchange", "user.create", message);
    }
}
```

### 6. 使用Kafka

```java
@Service
public class UserService {
    
    @Resource
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    /**
     * 发送用户创建消息
     */
    public void sendUserCreateMessage(Long userId) {
        UserCreateMessage message = new UserCreateMessage();
        message.setUserId(userId);
        message.setTimestamp(System.currentTimeMillis());
        
        kafkaTemplate.send("user-create-topic", message);
    }
}
```

### 7. 创建消息监听器

```java
@Component
public class UserMessageListener {
    
    /**
     * Redis消息监听器
     */
    @RedisMQListener(topic = "user.create")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
    
    /**
     * RocketMQ消息监听器
     */
    @RocketMQMessageListener(topic = "user-create-topic", consumerGroup = "wmt-consumer")
    public class UserCreateRocketMQListener implements RocketMQListener<UserCreateMessage> {
        
        @Override
        public void onMessage(UserCreateMessage message) {
            log.info("收到用户创建消息：{}", message);
            // 处理用户创建逻辑
        }
    }
    
    /**
     * RabbitMQ消息监听器
     */
    @RabbitListener(queues = "user.create.queue")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
    
    /**
     * Kafka消息监听器
     */
    @KafkaListener(topics = "user-create-topic")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
}
```

## 配置说明

### Redis配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `spring.redis.host` | String | localhost | Redis主机地址 |
| `spring.redis.port` | int | 6379 | Redis端口 |
| `spring.redis.password` | String | - | Redis密码 |

### RocketMQ配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `rocketmq.name-server` | String | - | NameServer地址 |
| `rocketmq.producer.group` | String | - | 生产者组名 |
| `rocketmq.consumer.group` | String | - | 消费者组名 |

### RabbitMQ配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `spring.rabbitmq.host` | String | localhost | RabbitMQ主机地址 |
| `spring.rabbitmq.port` | int | 5672 | RabbitMQ端口 |
| `spring.rabbitmq.username` | String | guest | 用户名 |
| `spring.rabbitmq.password` | String | guest | 密码 |

### Kafka配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `spring.kafka.bootstrap-servers` | String | - | Kafka服务器地址 |
| `spring.kafka.producer.key-serializer` | String | - | 键序列化器 |
| `spring.kafka.producer.value-serializer` | String | - | 值序列化器 |
| `spring.kafka.consumer.group-id` | String | - | 消费者组ID |

## 核心功能

### Redis消息队列

#### RedisMQTemplate

Redis消息队列模板：

```java
@Service
public class UserService {
    
    @Resource
    private RedisMQTemplate redisMQTemplate;
    
    /**
     * 发送消息
     */
    public void sendMessage(String topic, Object message) {
        redisMQTemplate.send(topic, message);
    }
    
    /**
     * 发送延迟消息
     */
    public void sendDelayMessage(String topic, Object message, long delay) {
        redisMQTemplate.sendDelay(topic, message, delay);
    }
}
```

#### Redis消息监听器

```java
@Component
public class UserMessageListener {
    
    @RedisMQListener(topic = "user.create")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
    
    @RedisMQListener(topic = "user.update")
    public void handleUserUpdate(UserUpdateMessage message) {
        log.info("收到用户更新消息：{}", message);
        // 处理用户更新逻辑
    }
}
```

### RocketMQ

#### RocketMQTemplate

RocketMQ消息队列模板：

```java
@Service
public class UserService {
    
    @Resource
    private RocketMQTemplate rocketMQTemplate;
    
    /**
     * 发送消息
     */
    public void sendMessage(String topic, Object message) {
        rocketMQTemplate.convertAndSend(topic, message);
    }
    
    /**
     * 发送延迟消息
     */
    public void sendDelayMessage(String topic, Object message, long delay) {
        rocketMQTemplate.convertAndSend(topic, message, delay);
    }
}
```

#### RocketMQ消息监听器

```java
@Component
@RocketMQMessageListener(topic = "user-create-topic", consumerGroup = "wmt-consumer")
public class UserCreateRocketMQListener implements RocketMQListener<UserCreateMessage> {
    
    @Override
    public void onMessage(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
}
```

### RabbitMQ

#### RabbitTemplate

RabbitMQ消息队列模板：

```java
@Service
public class UserService {
    
    @Resource
    private RabbitTemplate rabbitTemplate;
    
    /**
     * 发送消息
     */
    public void sendMessage(String exchange, String routingKey, Object message) {
        rabbitTemplate.convertAndSend(exchange, routingKey, message);
    }
    
    /**
     * 发送延迟消息
     */
    public void sendDelayMessage(String exchange, String routingKey, Object message, long delay) {
        rabbitTemplate.convertAndSend(exchange, routingKey, message, msg -> {
            msg.getMessageProperties().setDelay((int) delay);
            return msg;
        });
    }
}
```

#### RabbitMQ消息监听器

```java
@Component
public class UserMessageListener {
    
    @RabbitListener(queues = "user.create.queue")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
}
```

### Kafka

#### KafkaTemplate

Kafka消息队列模板：

```java
@Service
public class UserService {
    
    @Resource
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    /**
     * 发送消息
     */
    public void sendMessage(String topic, Object message) {
        kafkaTemplate.send(topic, message);
    }
    
    /**
     * 发送消息（带键）
     */
    public void sendMessage(String topic, String key, Object message) {
        kafkaTemplate.send(topic, key, message);
    }
}
```

#### Kafka消息监听器

```java
@Component
public class UserMessageListener {
    
    @KafkaListener(topics = "user-create-topic")
    public void handleUserCreate(UserCreateMessage message) {
        log.info("收到用户创建消息：{}", message);
        // 处理用户创建逻辑
    }
}
```

## 消息类型

### 基础消息类

```java
public class BaseMessage {
    private String messageId;
    private Long timestamp;
    private String source;
    
    // getters and setters
}

public class UserCreateMessage extends BaseMessage {
    private Long userId;
    private String username;
    private String email;
    
    // getters and setters
}

public class UserUpdateMessage extends BaseMessage {
    private Long userId;
    private String username;
    private String email;
    
    // getters and setters
}
```

## 注解说明

### @RedisMQListener

Redis消息监听器注解：

```java
@RedisMQListener(
    topic = "user.create",      // 主题
    group = "user-consumer"     // 消费者组
)
public void handleUserCreate(UserCreateMessage message) {
    // 处理消息
}
```

### @RocketMQMessageListener

RocketMQ消息监听器注解：

```java
@RocketMQMessageListener(
    topic = "user-create-topic",    // 主题
    consumerGroup = "wmt-consumer"   // 消费者组
)
public class UserCreateRocketMQListener implements RocketMQListener<UserCreateMessage> {
    
    @Override
    public void onMessage(UserCreateMessage message) {
        // 处理消息
    }
}
```

### @RabbitListener

RabbitMQ消息监听器注解：

```java
@RabbitListener(
    queues = "user.create.queue",    // 队列名
    concurrency = "1-5"             // 并发数
)
public void handleUserCreate(UserCreateMessage message) {
    // 处理消息
}
```

### @KafkaListener

Kafka消息监听器注解：

```java
@KafkaListener(
    topics = "user-create-topic",   // 主题
    groupId = "wmt-consumer"        // 消费者组
)
public void handleUserCreate(UserCreateMessage message) {
    // 处理消息
}
```

## 最佳实践

### 1. 消息设计

```java
// 定义清晰的消息类型
public class UserCreateMessage extends BaseMessage {
    private Long userId;
    private String username;
    private String email;
    private String mobile;
    
    // 构造函数
    public UserCreateMessage(Long userId, String username, String email, String mobile) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.mobile = mobile;
        this.timestamp = System.currentTimeMillis();
        this.messageId = UUID.randomUUID().toString();
    }
}
```

### 2. 消息监听器设计

```java
@Component
public class UserMessageListener {
    
    @RedisMQListener(topic = "user.create")
    public void handleUserCreate(UserCreateMessage message) {
        try {
            log.info("收到用户创建消息：{}", message);
            
            // 处理业务逻辑
            processUserCreate(message);
            
        } catch (Exception e) {
            log.error("处理用户创建消息失败：{}", message, e);
            // 处理异常
            handleException(message, e);
        }
    }
}
```

### 3. 消息发送设计

```java
@Service
public class UserService {
    
    @Resource
    private RedisMQTemplate redisMQTemplate;
    
    public void createUser(UserCreateReqVO reqVO) {
        // 创建用户
        UserDO user = BeanUtils.toBean(reqVO, UserDO.class);
        userMapper.insert(user);
        
        // 发送消息
        UserCreateMessage message = new UserCreateMessage(
            user.getId(), 
            user.getUsername(), 
            user.getEmail(), 
            user.getMobile()
        );
        redisMQTemplate.send("user.create", message);
    }
}
```

### 4. 错误处理

```java
@Component
public class UserMessageListener {
    
    @RedisMQListener(topic = "user.create")
    public void handleUserCreate(UserCreateMessage message) {
        try {
            // 处理消息
            processUserCreate(message);
        } catch (Exception e) {
            log.error("处理用户创建消息失败：{}", message, e);
            
            // 发送到死信队列
            sendToDeadLetterQueue(message, e);
        }
    }
}
```

## 故障排除

### 常见问题

1. **消息发送失败**
   - 检查消息队列连接配置
   - 确认消息队列服务是否启动
   - 验证消息格式是否正确

2. **消息消费失败**
   - 检查消息监听器配置
   - 确认消费者组配置是否正确
   - 验证消息序列化是否正确

3. **消息重复消费**
   - 检查消息确认机制
   - 确认消费者组配置
   - 验证消息幂等性处理

4. **消息丢失**
   - 检查消息持久化配置
   - 确认消息确认机制
   - 验证消息队列配置

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.mq: DEBUG
    org.springframework.kafka: DEBUG
    org.springframework.amqp: DEBUG
    org.apache.rocketmq: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Redis: 6.x
- RocketMQ: 2.3.x
- RabbitMQ: 3.8.x
- Kafka: 2.8.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
