package com.devforce.backend.service

import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.RoleRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import java.util.*

@Service
class UsersService {

    @Autowired
    lateinit var userRepo: UserRepo


    fun getAllUsers(): ResponseEntity<ResponseDto> {
        val users = userRepo.findAll()
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("users" to users)))
    }
}
