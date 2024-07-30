package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.service.UserService
import com.devforce.backend.service.UsersService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.repository.query.Param
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/users")
class UsersController {
    @Autowired
    lateinit var usersService: UsersService

    @GetMapping("/get_all")
    @PreAuthorize("isAuthenticated()")
    fun getAllUsers(): ResponseEntity<ResponseDto> {
        return usersService.getAllUsers()
    }

}