package cos.gateway.config

import org.springframework.context.annotation.Configuration
import org.springframework.data.jpa.repository.config.EnableJpaRepositories

@Configuration
@EnableJpaRepositories(basePackages = ["cos.gateway.repo"]) // Exclude "elasticSearch" package
class JpaConfig {
    // Additional JPA configuration if needed
}
