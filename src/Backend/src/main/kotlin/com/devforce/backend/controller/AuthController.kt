package com.devforce.backend.controller

import com.devforce.backend.dto.*
import com.devforce.backend.service.AuthService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*

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
    @PreAuthorize("permitAll()")
    fun refreshToken(@RequestBody refreshTokenDto: RefreshTokenDto): ResponseEntity<ResponseDto> {
        return authService.refreshToken(refreshTokenDto)
    }

    @PostMapping("/logout")
    @PreAuthorize("isAuthenticated()")
    fun logoutUser(): ResponseEntity<ResponseDto> {
        return authService.logoutUser()
    }

    @GetMapping("/get_user")
    @PreAuthorize("isAuthenticated()")
    fun getUser(): ResponseEntity<ResponseDto> {
        return authService.getUser()
    }

    @DeleteMapping("/delete_user")
    @PreAuthorize("isAuthenticated()")
    fun deleteUser(): ResponseEntity<ResponseDto> {
        return authService.deleteUser()
    }

    @PutMapping("/reset_password")
    @PreAuthorize("isAuthenticated()")
    fun resetPassword(@RequestBody passwordBody: ResetPasswordDto): ResponseEntity<ResponseDto> {
        return authService.resetPassword(passwordBody.password)
    }

}