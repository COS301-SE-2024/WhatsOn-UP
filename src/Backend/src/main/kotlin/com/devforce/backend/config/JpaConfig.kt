package com.devforce.backend.config

import org.springframework.context.annotation.Configuration
import org.springframework.data.jpa.repository.config.EnableJpaRepositories

@Configuration
@EnableJpaRepositories(basePackages = ["com.devforce.backend.repo"]) // Exclude "elasticSearch" package
class JpaConfig {
    // Additional JPA configuration if needed
}
