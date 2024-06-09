package com.devforce.backend.services

import com.devforce.backend.dtos.LoginDto
import com.devforce.backend.dtos.ResponseDto
import com.devforce.backend.dtos.RegisterDto
import com.devforce.backend.models.UserModel
import com.devforce.backend.repos.RoleRepo
import com.devforce.backend.repos.UserRepo
import com.devforce.backend.security.JwtGenerator
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class AuthService {

    @Autowired
    lateinit var authenticationManager: AuthenticationManager

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var passwordEncoder: PasswordEncoder

    @Autowired
    lateinit var roleRepo: RoleRepo

    @Autowired
    lateinit var jwtGenerator: JwtGenerator

    fun registerUser(userDTO: RegisterDto): ResponseEntity<ResponseDto> {
        if (userRepo.findByEmail(userDTO.email) != null) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Username is already taken"))
        }

        // Encode the password
        val encodedPassword = passwordEncoder.encode(userDTO.password)


        val generalRole = roleRepo.findByName("GENERAL")!!

        // Continue with the registration process
        val newUser = UserModel().apply {
            this.email = userDTO.email
            this.password = encodedPassword
            this.fullName = userDTO.fullName
            this.role = generalRole
        }

        userRepo.save(newUser)

        val authentication: Authentication = authenticationManager.authenticate(
            UsernamePasswordAuthenticationToken(userDTO.email, userDTO.password)
        )
        SecurityContextHolder.getContext().authentication = authentication

        val token: String = jwtGenerator.generateToken(authentication)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User registered successfully", "token" to token)
        ))

    }

    fun loginUser(userDTO: LoginDto): ResponseEntity<ResponseDto> {
        try {
            // Perform authentication
            val authentication: Authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(userDTO.email, userDTO.password)
            )

            SecurityContextHolder.getContext().authentication = authentication

            val token: String = jwtGenerator.generateToken(authentication)

            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User logged in successfully", "token" to token)))
        } catch (ex: AuthenticationException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDto("error", System.currentTimeMillis(), "Authentication failed: ${ex.message}"))
        }
    }

    fun refreshToken(token: String): ResponseEntity<ResponseDto> {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }

        val refreshedToken = jwtGenerator.refreshToken(token)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Token refreshed successfully", "token" to refreshedToken))
        )
    }

    fun logoutUser(token: String): ResponseEntity<ResponseDto> {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User logged out successfully"))
        )
    }

    fun getUser(token: String): ResponseEntity<ResponseDto> {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }

        val email = jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("user" to user))
        )
    }

    fun deleteUser(token: String): ResponseEntity<ResponseDto> {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }

        val email = jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        userRepo.delete(user)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Account deleted successfully"))
        )
    }

}
