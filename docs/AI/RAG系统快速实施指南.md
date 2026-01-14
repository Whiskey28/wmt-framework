# RAG系统快速实施指南

> **目标**：快速搭建RAG系统，实现基于文档的智能问答  
> **适用场景**：技术文档问答、业务知识问答、代码库问答

---

## 📚 什么是RAG？（再解释一遍）

### 简单理解

**RAG = 检索 + 生成**

1. **检索（Retrieval）**：从你的文档库中找到相关文档
2. **增强（Augmented）**：把找到的文档作为上下文
3. **生成（Generation）**：AI基于这些文档生成答案

### 工作流程

```
用户问题："如何使用WMT框架的Redis组件？"
         ↓
[步骤1] 将问题转换为向量（一串数字）
         ↓
[步骤2] 在向量数据库中搜索相似的文档片段
        （你已配置：Redis/Qdrant/Milvus）
         ↓
[步骤3] 找到最相关的3-5个文档片段
         ↓
[步骤4] 把文档片段 + 用户问题一起发给AI
         ↓
[步骤5] AI基于这些具体文档内容生成答案
```

---

## 🛠️ 技术栈

### 你已经有的
- ✅ Spring Boot 2.7.x
- ✅ Redis（向量存储）
- ✅ Qdrant（向量存储，可选）
- ✅ Milvus（向量存储，可选）
- ✅ 多个AI模型配置（DeepSeek、GPT等）

### 需要添加的
- 📦 Spring AI（Spring官方AI框架）
- 📦 Embedding模型（文本转向量）

---

## 🚀 快速开始（3步搭建）

### 步骤1：添加依赖

在你的`pom.xml`中添加：

```xml
<dependencies>
    <!-- Spring AI -->
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-openai-spring-boot-starter</artifactId>
        <version>0.8.1</version>
    </dependency>
    
    <!-- Redis向量存储 -->
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-redis-store-spring-boot-starter</artifactId>
        <version>0.8.1</version>
    </dependency>
    
    <!-- 或者使用Qdrant -->
    <!--
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-qdrant-store-spring-boot-starter</artifactId>
        <version>0.8.1</version>
    </dependency>
    -->
</dependencies>
```

### 步骤2：配置Embedding模型

在`application.yaml`中添加：

```yaml
spring:
  ai:
    # Embedding模型（文本转向量）
    openai:
      api-key: ${OPENAI_API_KEY}
      embedding:
        options:
          model: text-embedding-3-small  # 或使用通义千问的embedding
    
    # 向量存储配置（你已有）
    vectorstore:
      redis:
        initialize-schema: true
        index-name: knowledge_index
        prefix: "knowledge_segment:"
```

### 步骤3：创建RAG服务

```java
package com.wmt.framework.ai.service;

import org.springframework.ai.document.Document;
import org.springframework.ai.embedding.EmbeddingClient;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class RAGService {
    
    @Autowired
    private VectorStore vectorStore; // Redis向量存储
    
    @Autowired
    private EmbeddingClient embeddingClient; // 文本转向量
    
    @Autowired
    private ChatClient chatClient; // AI对话（你已配置的DeepSeek等）
    
    /**
     * RAG问答：基于文档回答问题
     */
    public String answer(String question) {
        // 1. 在向量数据库中搜索相似文档
        List<Document> relevantDocs = vectorStore.similaritySearch(
            SearchRequest.query(question)
                .withTopK(5) // 返回最相关的5个文档片段
                .withSimilarityThreshold(0.7) // 相似度阈值（0-1）
        );
        
        if (relevantDocs.isEmpty()) {
            return "抱歉，没有找到相关文档。";
        }
        
        // 2. 构建上下文（把找到的文档拼接起来）
        String context = relevantDocs.stream()
            .map(Document::getContent)
            .collect(Collectors.joining("\n\n---\n\n"));
        
        // 3. 构建Prompt（把上下文和问题一起发给AI）
        String prompt = String.format(
            "基于以下文档内容回答问题，如果文档中没有相关信息，请说'文档中没有相关信息'。\n\n" +
            "文档内容：\n%s\n\n" +
            "问题：%s\n\n" +
            "回答：",
            context,
            question
        );
        
        // 4. 调用AI生成答案
        return chatClient.call(prompt);
    }
    
    /**
     * 文档入库：将文档转换为向量并存储
     */
    public void addDocument(String content, Map<String, Object> metadata) {
        // 1. 将文档分块（每块500-1000字，避免太长）
        List<String> chunks = splitDocument(content, 800);
        
        // 2. 将每块转换为Document对象
        List<Document> documents = chunks.stream()
            .map(chunk -> new Document(chunk, metadata))
            .collect(Collectors.toList());
        
        // 3. 存储到向量数据库（自动转换为向量）
        vectorStore.add(documents);
    }
    
    /**
     * 文档分块（简单实现）
     */
    private List<String> chunks = new ArrayList<>();
    private List<String> splitDocument(String content, int chunkSize) {
        List<String> chunks = new ArrayList<>();
        String[] sentences = content.split("[。！？\n]");
        
        StringBuilder currentChunk = new StringBuilder();
        for (String sentence : sentences) {
            if (currentChunk.length() + sentence.length() > chunkSize) {
                if (currentChunk.length() > 0) {
                    chunks.add(currentChunk.toString());
                    currentChunk = new StringBuilder();
                }
            }
            currentChunk.append(sentence).append("。");
        }
        
        if (currentChunk.length() > 0) {
            chunks.add(currentChunk.toString());
        }
        
        return chunks;
    }
    
    /**
     * 批量文档入库
     */
    public void batchAddDocuments(List<String> contents, Map<String, Object> metadata) {
        for (String content : contents) {
            addDocument(content, metadata);
        }
    }
}
```

---

## 📝 使用示例

### 1. 文档入库

```java
@RestController
@RequestMapping("/api/ai/rag")
public class RAGController {
    
    @Autowired
    private RAGService ragService;
    
    /**
     * 将WMT框架文档入库
     */
    @PostMapping("/index")
    public CommonResult<String> indexDocuments() {
        // 读取文档
        List<String> docs = readMarkdownFiles("docs/wmt/**/*.md");
        
        // 入库
        for (String doc : docs) {
            ragService.addDocument(
                doc,
                Map.of(
                    "source", "wmt-framework",
                    "type", "技术文档",
                    "timestamp", System.currentTimeMillis()
                )
            );
        }
        
        return CommonResult.success("文档入库成功");
    }
    
    /**
     * 问答接口
     */
    @PostMapping("/ask")
    public CommonResult<String> ask(@RequestBody Map<String, String> request) {
        String question = request.get("question");
        String answer = ragService.answer(question);
        return CommonResult.success(answer);
    }
}
```

### 2. 前端调用

```javascript
// 前端调用示例
async function askQuestion(question) {
    const response = await fetch('/api/ai/rag/ask', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ question })
    });
    
    const result = await response.json();
    return result.data; // AI生成的答案
}

// 使用
const answer = await askQuestion("如何使用WMT框架的Redis组件？");
console.log(answer);
```

---

## 🎯 实际应用场景

### 场景1：WMT框架技术文档问答

```java
// 1. 文档入库（一次性）
@PostConstruct
public void init() {
    // 读取WMT框架所有README文档
    List<String> docs = readFiles("wmt-framework/**/README.md");
    
    for (String doc : docs) {
        ragService.addDocument(doc, Map.of("source", "wmt-framework"));
    }
}

// 2. 用户提问
String answer = ragService.answer("如何使用数据权限组件？");
// AI会基于README文档内容回答
```

### 场景2：论文辅导业务知识问答

```java
// 1. 业务文档入库
ragService.addDocument(
    readFile("docs/论文辅导业务知识.md"),
    Map.of("source", "业务知识", "type", "FAQ")
);

// 2. 用户提问
String answer = ragService.answer("论文辅导的收费标准是什么？");
// AI会基于业务文档回答
```

### 场景3：代码库问答

```java
// 1. 代码注释入库（提取代码中的注释）
List<String> codeComments = extractCodeComments("wmt-framework/**/*.java");

for (String comment : codeComments) {
    ragService.addDocument(comment, Map.of("source", "代码注释"));
}

// 2. 用户提问
String answer = ragService.answer("Redis组件是如何实现分布式锁的？");
// AI会基于代码注释回答
```

---

## 🔧 优化建议

### 1. 文档分块优化

```java
/**
 * 更好的文档分块策略
 */
private List<String> splitDocumentAdvanced(String content, int chunkSize) {
    List<String> chunks = new ArrayList<>();
    
    // 按段落分割
    String[] paragraphs = content.split("\n\n");
    
    StringBuilder currentChunk = new StringBuilder();
    for (String paragraph : paragraphs) {
        if (currentChunk.length() + paragraph.length() > chunkSize) {
            if (currentChunk.length() > 0) {
                chunks.add(currentChunk.toString());
                currentChunk = new StringBuilder();
            }
        }
        currentChunk.append(paragraph).append("\n\n");
    }
    
    if (currentChunk.length() > 0) {
        chunks.add(currentChunk.toString());
    }
    
    return chunks;
}
```

### 2. 相似度阈值调整

```java
// 根据场景调整相似度阈值
public String answer(String question, double threshold) {
    List<Document> relevantDocs = vectorStore.similaritySearch(
        SearchRequest.query(question)
            .withTopK(5)
            .withSimilarityThreshold(threshold) // 0.7-0.9之间
    );
    // ...
}
```

### 3. 结果排序（Rerank）

```java
// 使用通义千问的Rerank模型（你已配置）
@Autowired
private RerankClient rerankClient; // 如果配置了

public String answerWithRerank(String question) {
    // 1. 先检索（返回更多结果）
    List<Document> docs = vectorStore.similaritySearch(
        SearchRequest.query(question).withTopK(20)
    );
    
    // 2. 使用Rerank重新排序（返回最相关的5个）
    List<Document> rerankedDocs = rerankClient.rerank(
        question,
        docs,
        5
    );
    
    // 3. 基于排序后的文档生成答案
    // ...
}
```

---

## 📊 效果评估

### 测试问题示例

```java
@Test
public void testRAG() {
    RAGService ragService = new RAGService();
    
    // 测试问题
    String[] questions = {
        "如何使用WMT框架的Redis组件？",
        "数据权限组件的工作原理是什么？",
        "如何配置多租户？"
    };
    
    for (String question : questions) {
        String answer = ragService.answer(question);
        System.out.println("问题：" + question);
        System.out.println("回答：" + answer);
        System.out.println("---");
    }
}
```

### 评估指标

1. **准确率**：答案是否基于文档内容
2. **相关性**：答案是否回答了问题
3. **完整性**：答案是否完整
4. **响应时间**：检索+生成的总时间

---

## 🚨 常见问题

### Q1: 向量数据库选择哪个？

**A**: 
- **Redis**：简单、你已有，适合小规模（<10万文档）
- **Qdrant**：专业、性能好，适合中大规模
- **Milvus**：企业级、功能强，适合大规模

**建议**：先用Redis，规模大了再迁移到Qdrant。

### Q2: Embedding模型选择哪个？

**A**:
- **OpenAI text-embedding-3-small**：质量好、价格中等
- **通义千问embedding**：中文好、价格便宜
- **DeepSeek embedding**：便宜（如果有）

**建议**：中文文档用通义千问，英文文档用OpenAI。

### Q3: 文档分块大小？

**A**: 
- **500-800字**：适合技术文档
- **1000-1500字**：适合长文章
- **200-500字**：适合FAQ

**建议**：从800字开始，根据效果调整。

### Q4: 相似度阈值设置？

**A**:
- **0.7-0.8**：严格匹配，只返回高度相关文档
- **0.6-0.7**：中等匹配，平衡相关性和召回率
- **0.5-0.6**：宽松匹配，返回更多文档

**建议**：从0.7开始，根据效果调整。

---

## 📈 下一步

1. **立即开始**：搭建基础RAG系统（1周内）
2. **文档入库**：将WMT框架文档入库（1-2天）
3. **测试优化**：测试问答效果，调整参数（1周）
4. **扩展应用**：应用到业务知识问答、代码库问答

---

## 💡 总结

RAG系统的核心是：
1. **文档入库**：将文档转换为向量并存储
2. **检索**：根据问题检索相关文档
3. **生成**：基于文档内容生成答案

**优势**：
- ✅ 答案基于真实文档，更准确
- ✅ 可以补充AI的知识盲区
- ✅ 可以处理专业领域问题

**适用场景**：
- ✅ 技术文档问答
- ✅ 业务知识问答
- ✅ 代码库问答
- ✅ FAQ自动回答

---

**开始搭建吧！** 🚀
