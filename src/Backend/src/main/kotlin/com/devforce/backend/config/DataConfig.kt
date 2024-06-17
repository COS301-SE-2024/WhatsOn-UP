package com.devforce.backend.config

import org.springframework.context.annotation.Configuration
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories
import org.springframework.data.jpa.repository.config.EnableJpaRepositories

@Configuration
@EnableJpaRepositories(basePackages = ["com.devforce.backend.repo"])
@EnableElasticsearchRepositories(basePackages = ["com.devforce.backend.repo.elasticSearch"])
class DataConfig {
}