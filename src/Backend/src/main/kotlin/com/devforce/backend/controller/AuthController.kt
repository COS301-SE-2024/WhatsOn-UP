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


}