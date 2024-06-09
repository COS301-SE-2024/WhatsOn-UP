package com.devforce.backend.controllers

import com.devforce.backend.dtos.LoginDto
import com.devforce.backend.dtos.ResponseDto
import com.devforce.backend.dtos.RegisterDto
import com.devforce.backend.services.AuthService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/auth")
class AuthController {

    @Autowired
    lateinit var authService: AuthService

    @PostMapping("/register")
    @PreAuthorize("permitAll()")
    fun registerUser(@RequestBody userDTO: RegisterDto): ResponseEntity<ResponseDto> {
        return authService.registerUser(userDTO)
    }

    @PostMapping("/login")
    @PreAuthorize("permitAll()")
    fun loginUser(@RequestBody userDTO: LoginDto): ResponseEntity<ResponseDto> {
        return authService.loginUser(userDTO)
    }

    @PostMapping("/refresh_token")
    @PreAuthorize("isAuthenticated()")
    fun refreshToken(@RequestBody token: String): ResponseEntity<ResponseDto> {
        return authService.refreshToken(token)
    }

    @PostMapping("/logout")
    @PreAuthorize("isAuthenticated()")
    fun logoutUser(@RequestBody token: String): ResponseEntity<ResponseDto> {
        return authService.logoutUser(token)
    }


    @PostMapping("/get_user")
    @PreAuthorize("isAuthenticated()")
    fun getUser(@RequestBody token: String): ResponseEntity<ResponseDto> {
        return authService.getUser(token)
    }

    @DeleteMapping("/delete_user")
    @PreAuthorize("isAuthenticated()")
    fun deleteUser(@RequestBody token: String): ResponseEntity<ResponseDto> {
        return authService.deleteUser(token)
    }
}