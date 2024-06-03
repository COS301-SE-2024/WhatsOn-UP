package com.devforce.backend

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.web.bind.annotation.CrossOrigin

@SpringBootApplication
@CrossOrigin
class BackendApplication

fun main(args: Array<String>) {
	runApplication<BackendApplication>(*args)
}
