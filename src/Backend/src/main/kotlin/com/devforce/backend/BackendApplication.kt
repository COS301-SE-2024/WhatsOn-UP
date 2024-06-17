package com.devforce.backend

//import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.domain.EntityScan
import org.springframework.boot.runApplication
import org.springframework.context.annotation.ComponentScan
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories

import org.springframework.boot.autoconfigure.SpringBootApplication
//import org.springframework.boot.runApplication


@SpringBootApplication
@EntityScan("com.devforce.backend.model")
@EnableJpaRepositories(
	basePackages = ["com.devforce.backend.repo.jpa"]
)
@EnableElasticsearchRepositories(
	basePackages = ["com.devforce.backend.repo.elasticSearch"]
)
@ComponentScan("com.devforce.backend.controller", "com.devforce.backend.config", "com.devforce.backend.service" , "com.devforce.backend.security")
class BackendApplication
fun main(args: Array<String>) {
	runApplication<BackendApplication>(*args)
}
