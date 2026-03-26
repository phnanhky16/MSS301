package com.kidfavor.productservice.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.ElasticsearchTransport;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;
import org.springframework.boot.autoconfigure.elasticsearch.RestClientBuilderCustomizer;
import jakarta.annotation.PostConstruct;

@Configuration
@EnableElasticsearchRepositories(basePackages = "com.kidfavor.productservice.repository")
public class ElasticSearchConfig {

    @Value("${spring.elasticsearch.uris:http://localhost:9200}")
    private String elasticsearchUrl;

    // when security is enabled we need credentials to talk to the cluster
    @Value("${spring.elasticsearch.username:elastic}")
    private String elasticsearchUsername;

    @Value("${spring.elasticsearch.password:changeme}")
    private String elasticsearchPassword;

    // log the resolved values right after the bean is constructed (for debugging)
    @PostConstruct
    public void logProperties() {
        System.out.println("ES URL=" + elasticsearchUrl +
                " user=" + elasticsearchUsername +
                " pass=" + (elasticsearchPassword != null ? "****" : "<null>"));
    }

        // supply a customizer to the auto‑configured RestClientBuilder so that
        // Basic auth credentials are always attached.  Spring Boot's default
        // builder does not preemptively send an Authorization header, which was
        // causing repository initialization to fail with 401s.
        @Bean
        public RestClientBuilderCustomizer authCustomizer() {
            return builder -> {
                System.out.println("Applying ES auth customizer: user=" + elasticsearchUsername);
            if (elasticsearchUsername != null && !elasticsearchUsername.isEmpty()) {
            org.apache.http.impl.client.BasicCredentialsProvider creds =
                new org.apache.http.impl.client.BasicCredentialsProvider();
            creds.setCredentials(org.apache.http.auth.AuthScope.ANY,
                new org.apache.http.auth.UsernamePasswordCredentials(elasticsearchUsername, elasticsearchPassword));
            builder.setHttpClientConfigCallback(httpClientBuilder ->
                httpClientBuilder.setDefaultCredentialsProvider(creds));
            // also add preemptive header
            String token = java.util.Base64.getEncoder()
                .encodeToString((elasticsearchUsername + ":" + elasticsearchPassword)
                    .getBytes(java.nio.charset.StandardCharsets.UTF_8));
            org.apache.http.Header authHeader =
                new org.apache.http.message.BasicHeader("Authorization", "Basic " + token);
            builder.setDefaultHeaders(new org.apache.http.Header[]{authHeader});
            }
        };
        }

            // create a primary ElasticsearchClient bean ourselves. by marking it
            // @Primary we ensure that Spring Data repositories will use this
            // instance rather than any client produced by auto-configuration.
            @Bean
            @org.springframework.context.annotation.Primary
            public ElasticsearchClient primaryElasticsearchClient() {
            // build RestClient with credentials/header (same logic as before)
            org.elasticsearch.client.RestClientBuilder builder =
                RestClient.builder(HttpHost.create(elasticsearchUrl));
            if (elasticsearchUsername != null && !elasticsearchUsername.isEmpty()) {
                org.apache.http.impl.client.BasicCredentialsProvider creds =
                    new org.apache.http.impl.client.BasicCredentialsProvider();
                creds.setCredentials(org.apache.http.auth.AuthScope.ANY,
                    new org.apache.http.auth.UsernamePasswordCredentials(elasticsearchUsername, elasticsearchPassword));
                builder = builder.setHttpClientConfigCallback(httpClientBuilder ->
                    httpClientBuilder.setDefaultCredentialsProvider(creds));
                String token = java.util.Base64.getEncoder()
                    .encodeToString((elasticsearchUsername + ":" + elasticsearchPassword)
                        .getBytes(java.nio.charset.StandardCharsets.UTF_8));
                org.apache.http.Header authHeader =
                    new org.apache.http.message.BasicHeader("Authorization", "Basic " + token);
                builder.setDefaultHeaders(new org.apache.http.Header[]{authHeader});
            }
            org.elasticsearch.client.RestClient restClient = builder.build();
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper()
                .registerModule(new com.fasterxml.jackson.datatype.jsr310.JavaTimeModule())
                .configure(com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            ElasticsearchTransport transport = new RestClientTransport(restClient, new JacksonJsonpMapper(mapper));
            return new ElasticsearchClient(transport);
            }
}
