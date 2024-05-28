// generate a controller with a single endpoint

package com.devforce.backend.controllers

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class GreetingController {
    @GetMapping("/")
    fun greeting(): String {
        return "Hello, World!"
    }
}