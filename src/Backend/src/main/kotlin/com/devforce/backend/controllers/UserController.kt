package com.devforce.backend.controllers

import com.devforce.backend.models.UserModel
import com.devforce.backend.repos.EventRepo
import com.devforce.backend.repos.UserRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController
class UserController {
    @Autowired
    lateinit var userRepository: UserRepo

    @PostMapping("/register")
    fun registerUser(@RequestBody userData: Map<String, String>): ResponseEntity<Any> {
        val email = userData["email"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", "Email is required"))
        val password = userData["password"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", "Password is required"))

        return try {
            val user = UserModel().apply {
                this.email = email
                this.password = password
            }
            val savedUser = userRepository.save(user)
            ResponseEntity.ok(savedUser)
        } catch (e: Exception) {
            ResponseEntity.badRequest().body(ApiResponse("error", e.message ?: "An error occurred while registering user"))
        }
    }

    @PostMapping("/login")
    fun loginUser(@RequestBody userData: Map<String, String>): ResponseEntity<Any> {
        val email = userData["email"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", "Email is required"))
        val password = userData["password"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", "Password is required"))

        return try {
            val user = userRepository.findByEmailAndPassword(email, password)
            if (user != null) {
                ResponseEntity.ok(user)
            } else {
                ResponseEntity.badRequest().body(ApiResponse("error", "Invalid email or password"))
            }
        } catch (e: Exception) {
            ResponseEntity.badRequest().body(ApiResponse("error", e.message ?: "An error occurred while logging in user"))
        }
    }

}