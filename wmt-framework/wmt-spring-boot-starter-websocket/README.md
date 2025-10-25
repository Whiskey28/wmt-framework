# WMT WebSocket Starter

基于Spring WebSocket的实时通信组件，支持多节点广播、消息推送、会话管理等功能。

## 功能特性

- 🔌 **WebSocket连接**: 基于Spring WebSocket的实时连接
- 📡 **多节点广播**: 支持Redis、RocketMQ、Kafka、RabbitMQ多节点消息广播
- 👥 **会话管理**: 支持用户会话管理和多端登录
- 🔐 **安全认证**: 集成用户认证，支持Token验证
- 📝 **消息监听**: 支持自定义消息监听器
- 🎯 **消息路由**: 支持消息路由和分发
- 📊 **连接统计**: 支持连接数统计和监控
- 🔄 **断线重连**: 支持客户端断线重连

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-websocket</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 配置文件

在 `application.yml` 中添加配置：

```yaml
wmt:
  websocket:
    path: /ws                    # WebSocket连接路径
    sender-type: redis          # 消息发送器类型：local、redis、rocketmq、kafka、rabbitmq

# Redis配置（如果使用Redis作为消息发送器）
spring:
  redis:
    host: localhost
    port: 6379
    password: password
```

### 3. 创建消息监听器

```java
@Component
public class UserMessageListener implements WebSocketMessageListener<UserMessage> {
    
    @Override
    public void onMessage(UserMessage message, WebSocketSession session) {
        // 处理用户消息
        log.info("收到用户消息: {}", message);
        
        // 回复消息
        UserMessage reply = new UserMessage();
        reply.setType("reply");
        reply.setContent("收到您的消息");
        WebSocketUtils.send(session, reply);
    }
    
    @Override
    public String getType() {
        return "user";
    }
}
```

### 4. 发送消息

```java
@Service
public class NotificationService {
    
    @Resource
    private WebSocketMessageSender webSocketMessageSender;
    
    /**
     * 发送消息给指定用户
     */
    public void sendToUser(Long userId, String message) {
        UserMessage userMessage = new UserMessage();
        userMessage.setType("notification");
        userMessage.setContent(message);
        userMessage.setUserId(userId);
        
        webSocketMessageSender.send(userId, userMessage);
    }
    
    /**
     * 广播消息给所有用户
     */
    public void broadcast(String message) {
        BroadcastMessage broadcastMessage = new BroadcastMessage();
        broadcastMessage.setType("broadcast");
        broadcastMessage.setContent(message);
        
        webSocketMessageSender.send(broadcastMessage);
    }
}
```

### 5. 前端连接

```javascript
// 连接WebSocket
const ws = new WebSocket('ws://localhost:8080/ws');

// 连接成功
ws.onopen = function(event) {
    console.log('WebSocket连接成功');
    
    // 发送认证消息
    ws.send(JSON.stringify({
        type: 'auth',
        token: 'your-access-token'
    }));
};

// 接收消息
ws.onmessage = function(event) {
    const message = JSON.parse(event.data);
    console.log('收到消息:', message);
    
    // 处理不同类型的消息
    switch(message.type) {
        case 'notification':
            showNotification(message.content);
            break;
        case 'broadcast':
            showBroadcast(message.content);
            break;
    }
};

// 发送消息
function sendMessage(content) {
    ws.send(JSON.stringify({
        type: 'user',
        content: content
    }));
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.websocket.path` | String | /ws | WebSocket连接路径 |
| `wmt.websocket.sender-type` | String | local | 消息发送器类型 |

### 消息发送器类型

| 类型 | 说明 | 适用场景 |
|------|------|----------|
| `local` | 本地发送器 | 单机部署 |
| `redis` | Redis发送器 | 多机部署，使用Redis |
| `rocketmq` | RocketMQ发送器 | 多机部署，使用RocketMQ |
| `kafka` | Kafka发送器 | 多机部署，使用Kafka |
| `rabbitmq` | RabbitMQ发送器 | 多机部署，使用RabbitMQ |

## 核心功能

### 消息监听器

#### WebSocketMessageListener

消息监听器接口：

```java
public interface WebSocketMessageListener<T> {
    
    /**
     * 处理消息
     */
    void onMessage(T message, WebSocketSession session);
    
    /**
     * 获取消息类型
     */
    String getType();
}
```

#### 自定义消息监听器

```java
@Component
public class ChatMessageListener implements WebSocketMessageListener<ChatMessage> {
    
    @Override
    public void onMessage(ChatMessage message, WebSocketSession session) {
        // 处理聊天消息
        log.info("收到聊天消息: {}", message);
        
        // 转发给其他用户
        forwardToOtherUsers(message);
    }
    
    @Override
    public String getType() {
        return "chat";
    }
}
```

### 消息发送器

#### WebSocketMessageSender

消息发送器接口：

```java
public interface WebSocketMessageSender {
    
    /**
     * 发送消息给指定用户
     */
    void send(Long userId, Object message);
    
    /**
     * 广播消息给所有用户
     */
    void send(Object message);
    
    /**
     * 发送消息给指定会话
     */
    void send(WebSocketSession session, Object message);
}
```

#### 使用消息发送器

```java
@Service
public class NotificationService {
    
    @Resource
    private WebSocketMessageSender webSocketMessageSender;
    
    public void sendNotification(Long userId, String content) {
        NotificationMessage message = new NotificationMessage();
        message.setType("notification");
        message.setContent(content);
        message.setUserId(userId);
        
        webSocketMessageSender.send(userId, message);
    }
    
    public void broadcastAnnouncement(String content) {
        AnnouncementMessage message = new AnnouncementMessage();
        message.setType("announcement");
        message.setContent(content);
        
        webSocketMessageSender.send(message);
    }
}
```

### 会话管理

#### WebSocketSessionManager

会话管理器：

```java
@Service
public class UserService {
    
    @Resource
    private WebSocketSessionManager sessionManager;
    
    /**
     * 获取用户的所有会话
     */
    public List<WebSocketSession> getUserSessions(Long userId) {
        return sessionManager.getSessions(userId);
    }
    
    /**
     * 检查用户是否在线
     */
    public boolean isUserOnline(Long userId) {
        return sessionManager.hasSession(userId);
    }
    
    /**
     * 强制用户下线
     */
    public void forceLogout(Long userId) {
        sessionManager.closeSessions(userId);
    }
}
```

### 消息类型

#### 基础消息类

```java
public class WebSocketMessage {
    private String type;
    private Object data;
    private Long timestamp;
    
    // getters and setters
}

public class UserMessage extends WebSocketMessage {
    private Long userId;
    private String content;
    
    // getters and setters
}

public class BroadcastMessage extends WebSocketMessage {
    private String content;
    private List<Long> targetUsers;  // 目标用户列表，为空表示广播给所有用户
    
    // getters and setters
}
```

## 注解说明

### @WebSocketMessageListener

消息监听器注解：

```java
@Component
@WebSocketMessageListener(type = "chat")
public class ChatMessageListener implements WebSocketMessageListener<ChatMessage> {
    
    @Override
    public void onMessage(ChatMessage message, WebSocketSession session) {
        // 处理聊天消息
    }
}
```

## 工具类

### WebSocketUtils

WebSocket工具类：

```java
// 发送消息给会话
WebSocketUtils.send(session, message);

// 发送消息给用户
WebSocketUtils.sendToUser(userId, message);

// 广播消息
WebSocketUtils.broadcast(message);

// 检查用户是否在线
boolean isOnline = WebSocketUtils.isOnline(userId);

// 获取在线用户数
int onlineCount = WebSocketUtils.getOnlineCount();
```

## 最佳实践

### 1. 消息类型设计

```java
// 定义清晰的消息类型
public enum MessageType {
    AUTH("auth", "认证消息"),
    CHAT("chat", "聊天消息"),
    NOTIFICATION("notification", "通知消息"),
    BROADCAST("broadcast", "广播消息"),
    HEARTBEAT("heartbeat", "心跳消息");
    
    private final String type;
    private final String description;
}
```

### 2. 消息监听器设计

```java
@Component
public class ChatMessageListener implements WebSocketMessageListener<ChatMessage> {
    
    @Override
    public void onMessage(ChatMessage message, WebSocketSession session) {
        try {
            // 验证消息格式
            validateMessage(message);
            
            // 处理业务逻辑
            processChatMessage(message);
            
            // 转发给其他用户
            forwardToOtherUsers(message);
            
        } catch (Exception e) {
            log.error("处理聊天消息失败", e);
            sendErrorResponse(session, "消息处理失败");
        }
    }
    
    @Override
    public String getType() {
        return MessageType.CHAT.getType();
    }
}
```

### 3. 错误处理

```java
@Component
public class ErrorMessageListener implements WebSocketMessageListener<ErrorMessage> {
    
    @Override
    public void onMessage(ErrorMessage message, WebSocketSession session) {
        log.error("WebSocket错误: {}", message);
        
        // 发送错误响应
        ErrorResponse response = new ErrorResponse();
        response.setCode(message.getCode());
        response.setMessage(message.getMessage());
        
        WebSocketUtils.send(session, response);
    }
    
    @Override
    public String getType() {
        return "error";
    }
}
```

### 4. 心跳检测

```java
@Component
public class HeartbeatMessageListener implements WebSocketMessageListener<HeartbeatMessage> {
    
    @Override
    public void onMessage(HeartbeatMessage message, WebSocketSession session) {
        // 更新最后心跳时间
        sessionManager.updateLastHeartbeat(session);
        
        // 回复心跳
        HeartbeatResponse response = new HeartbeatResponse();
        response.setTimestamp(System.currentTimeMillis());
        
        WebSocketUtils.send(session, response);
    }
    
    @Override
    public String getType() {
        return MessageType.HEARTBEAT.getType();
    }
}
```

## 故障排除

### 常见问题

1. **WebSocket连接失败**
   - 检查WebSocket路径配置
   - 确认服务器端口是否正确
   - 验证网络连接是否正常

2. **消息发送失败**
   - 检查消息发送器配置
   - 确认消息格式是否正确
   - 验证用户是否在线

3. **多节点消息不同步**
   - 检查消息发送器类型配置
   - 确认中间件连接是否正常
   - 验证消息序列化是否正确

4. **会话管理异常**
   - 检查会话管理器配置
   - 确认用户认证是否正常
   - 验证会话超时设置

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.websocket: DEBUG
    org.springframework.web.socket: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- Spring WebSocket: 5.3.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
