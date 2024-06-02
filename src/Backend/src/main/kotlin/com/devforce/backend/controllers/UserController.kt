package com.devforce.backend.controllers

import com.devforce.backend.models.UserModel
import com.devforce.backend.repos.UserRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController
class UserController {
    @Autowired
    lateinit var userRepository: UserRepo

    @PostMapping("/register")
    fun registerUser(@RequestBody userData: Map<String, String>): ResponseEntity<Any> {
        val email = userData["email"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "Email is required")))
        val password = userData["password"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "Password is required")))
        val name = userData["name"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "Name is required")))

        return try {
            val user = UserModel().apply {
                this.email = email
                this.password = password
                this.name = name
            }
            val savedUser = userRepository.save(user)
            ResponseEntity.ok(ApiResponse("success", System.currentTimeMillis(), mapOf("id" to savedUser.id, "name" to savedUser.name, "email" to savedUser.email, "role" to savedUser.role)))
        } catch (e: Exception) {
            ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "An error occurred while registering user")))
        }
    }

    @PostMapping("/login")
    fun loginUser(@RequestBody userData: Map<String, String>): ResponseEntity<Any> {
        val email = userData["email"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "Email is required")))
        val password = userData["password"] ?: return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "Password is required")))

        return try {
            val user = userRepository.findByEmailAndPassword(email, password)
            if (user != null) {
                val userDetails = mapOf("id" to user.id, "name" to user.name, "email" to user.email, "role" to user.role)
                ResponseEntity.ok(ApiResponse("success", System.currentTimeMillis(), userDetails))
            } else {
                ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to "Invalid email or password")))
            }
        } catch (e: Exception) {
            ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), mapOf("message" to (e.message ?: "An error occurred while logging in user"))))
        }
    }


}