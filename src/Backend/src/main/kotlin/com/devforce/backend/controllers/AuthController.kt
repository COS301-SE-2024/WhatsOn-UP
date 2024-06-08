package com.devforce.backend.controllers

import com.devforce.backend.Dtos.LoginDto
import com.devforce.backend.Dtos.ResponseDTO
import com.devforce.backend.Dtos.RegisterDto
import com.devforce.backend.services.AuthService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/auth")
class AuthController {

    @Autowired
    lateinit var authService: AuthService

    @PostMapping("/register")
    fun registerUser(@RequestBody userDTO: RegisterDto): ResponseEntity<ResponseDTO> {
        return authService.registerUser(userDTO)
    }

    @PostMapping("/login")
    fun loginUser(@RequestBody userDTO: LoginDto): ResponseEntity<ResponseDTO> {
        return authService.loginUser(userDTO)
    }

    @PostMapping("/refresh_token")
    fun refreshToken(@RequestBody token: String): ResponseEntity<ResponseDTO> {
        return authService.refreshToken(token)
    }

    @PostMapping("/logout")
    fun logoutUser(@RequestBody token: String): ResponseEntity<ResponseDTO> {
        return authService.logoutUser(token)
    }


    @PostMapping("/get_user")
    fun getUser(@RequestBody token: String): ResponseEntity<ResponseDTO> {
        return authService.getUser(token)
    }

}