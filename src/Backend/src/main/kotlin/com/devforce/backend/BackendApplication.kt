package com.devforce.backend

//import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.domain.EntityScan
import org.springframework.boot.runApplication
import org.springframework.context.annotation.ComponentScan
import org.springframework.data.jpa.repository.config.EnableJpaRepositories

import org.springframework.boot.autoconfigure.SpringBootApplication
//import org.springframework.boot.runApplication


@SpringBootApplication
@EntityScan("com.devforce.backend.model")
@EnableJpaRepositories("com.devforce.backend.repo")
@ComponentScan("com.devforce.backend.controller", "com.devforce.backend.config", "com.devforce.backend.service")
class BackendApplication
fun main(args: Array<String>) {
	runApplication<BackendApplication>(*args)
}
