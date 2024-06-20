package com.devforce.backend.controller

import com.devforce.backend.dto.LoginDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.RegisterDto
import com.devforce.backend.dto.ResetPasswordDto
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
    @PreAuthorize("isAuthenticated()")
    fun refreshToken(@RequestHeader("Authorization") jwtToken: String, @RequestHeader("Refresh-Token") refreshToken: String): ResponseEntity<ResponseDto> {
        val jwtTokenc = jwtToken.replace("Bearer ", "")
        return authService.refreshToken(jwtTokenc, refreshToken)
    }

    @PostMapping("/logout")
    @PreAuthorize("isAuthenticated()")
    fun logoutUser(@RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.replace("Bearer ", "")
        return authService.logoutUser(jwtToken)
    }

    @GetMapping("/get_user")
    @PreAuthorize("isAuthenticated()")
    fun getUser(@RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.replace("Bearer ", "")
        return authService.getUser(jwtToken)
    }

    @DeleteMapping("/delete_user")
    @PreAuthorize("isAuthenticated()")
    fun deleteUser(@RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.replace("Bearer ", "")
        return authService.deleteUser(jwtToken)
    }

    @PutMapping("/reset_password")
    @PreAuthorize("isAuthenticated()")
    fun resetPassword(@RequestHeader("Authorization") token: String, @RequestBody passwordBody: ResetPasswordDto): ResponseEntity<ResponseDto> {
        val jwtToken = token.replace("Bearer ", "")
        return authService.resetPassword(jwtToken, passwordBody.password)
    }

}