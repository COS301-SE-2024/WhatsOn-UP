package com.devforce.backend.service

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.jpa.UserRepo
import com.devforce.backend.security.JwtGenerator
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service

@Service
class CheckJwt {
    @Autowired
    lateinit var jwtGenerator: JwtGenerator

    fun check(token: String): ResponseEntity<ResponseDto>? {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }
        return null
    }

}
