package com.wmt.framework.search.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wmt.framework.search.core.SearchService;
import com.wmt.framework.search.core.impl.ElasticsearchSearchService;
import com.wmt.framework.search.properties.SearchProperties;
import lombok.RequiredArgsConstructor;
import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.ElasticsearchTransport;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

import java.util.List;

/**
 * 搜索自动配置
 *
 * @author wmt
 */
@Configuration
@EnableConfigurationProperties(SearchProperties.class)
@ConditionalOnProperty(prefix = "wmt.search", name = "enabled", havingValue = "true", matchIfMissing = true)
@ConditionalOnClass(ElasticsearchClient.class)
@EnableAspectJAutoProxy
@RequiredArgsConstructor
public class SearchAutoConfiguration {
    
    private final SearchProperties searchProperties;
    
    /**
     * 配置Elasticsearch REST客户端
     */
    @Bean
    @ConditionalOnMissingBean
    public RestClient restClient() {
        SearchProperties.Elasticsearch esConfig = searchProperties.getElasticsearch();
        
        if (esConfig.getHosts().isEmpty()) {
            esConfig.getHosts().add("localhost:9200");
        }
        
        HttpHost[] hosts = esConfig.getHosts().stream()
                .map(host -> {
                    String[] parts = host.split(":");
                    return new HttpHost(parts[0], Integer.parseInt(parts[1]), "http");
                })
                .toArray(HttpHost[]::new);
        
        RestClientBuilder builder = RestClient.builder(hosts)
                .setRequestConfigCallback(requestConfigBuilder -> {
                    requestConfigBuilder.setConnectTimeout(esConfig.getConnectTimeout());
                    requestConfigBuilder.setSocketTimeout(esConfig.getReadTimeout());
                    return requestConfigBuilder;
                })
                .setHttpClientConfigCallback(httpClientBuilder -> {
                    httpClientBuilder.setMaxConnTotal(esConfig.getMaxConnections());
                    httpClientBuilder.setMaxConnPerRoute(esConfig.getMaxConnectionsPerRoute());
                    
                    // 配置认证
                    if (esConfig.getUsername() != null && esConfig.getPassword() != null) {
                        CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
                        credentialsProvider.setCredentials(AuthScope.ANY,
                                new UsernamePasswordCredentials(esConfig.getUsername(), esConfig.getPassword()));
                        httpClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
                    }
                    
                    return httpClientBuilder;
                });
        
        return builder.build();
    }
    
    /**
     * 配置ObjectMapper
     */
    @Bean
    @ConditionalOnMissingBean
    public ObjectMapper objectMapper() {
        return new ObjectMapper();
    }
    
    /**
     * 配置Elasticsearch传输层
     */
    @Bean
    @ConditionalOnMissingBean
    public ElasticsearchTransport elasticsearchTransport(RestClient restClient, ObjectMapper objectMapper) {
        return new RestClientTransport(restClient, new JacksonJsonpMapper(objectMapper));
    }
    
    /**
     * 配置Elasticsearch客户端
     */
    @Bean
    @ConditionalOnMissingBean
    public ElasticsearchClient elasticsearchClient(ElasticsearchTransport transport) {
        return new ElasticsearchClient(transport);
    }
    
    /**
     * 配置搜索服务
     */
    @Bean
    @ConditionalOnMissingBean
    public SearchService searchService(ElasticsearchClient elasticsearchClient, ObjectMapper objectMapper) {
        return new ElasticsearchSearchService(elasticsearchClient, objectMapper);
    }
}
