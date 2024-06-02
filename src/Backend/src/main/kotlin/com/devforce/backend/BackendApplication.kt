package com.devforce.backend

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.domain.EntityScan
import org.springframework.boot.runApplication
import org.springframework.context.annotation.ComponentScan
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.web.bind.annotation.CrossOrigin

@SpringBootApplication
@CrossOrigin
@EntityScan("com.devforce.backend.models")
@EnableJpaRepositories("com.devforce.backend.repos")
@ComponentScan("com.devforce.backend.controllers")
class BackendApplication

fun main(args: Array<String>) {
	runApplication<BackendApplication>(*args)
}
