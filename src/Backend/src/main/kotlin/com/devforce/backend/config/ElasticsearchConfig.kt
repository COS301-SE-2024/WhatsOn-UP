package com.devforce.backend.config


import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.elasticsearch.core.ElasticsearchOperations
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories

@Configuration
@EnableElasticsearchRepositories(basePackages = ["com.devforce.backend.repo.elasticSearch"])
class ElasticsearchConfig {
    // Additional Elasticsearch-specific configuration can be added here if needed
}
