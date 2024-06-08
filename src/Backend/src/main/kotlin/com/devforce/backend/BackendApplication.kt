package com.devforce.backend

//import org.springframework.boot.autoconfigure.SpringBootApplication
//import org.springframework.boot.autoconfigure.domain.EntityScan
//import org.springframework.boot.runApplication
//import org.springframework.context.annotation.ComponentScan
//import org.springframework.data.jpa.repository.config.EnableJpaRepositories

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication


@SpringBootApplication
//@EntityScan("com.devforce.backend.models")
//@EnableJpaRepositories("com.devforce.backend.repos")
//@ComponentScan("com.devforce.backend.controllers", "com.devforce.backend.config")
class BackendApplication
fun main(args: Array<String>) {
	runApplication<BackendApplication>(*args)
}
