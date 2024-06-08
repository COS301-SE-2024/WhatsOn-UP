package com.devforce.backend.services

import com.devforce.backend.Dtos.LoginDto
import com.devforce.backend.Dtos.ResponseDTO
import com.devforce.backend.Dtos.RegisterDto
import com.devforce.backend.models.UserModel
import com.devforce.backend.repos.RoleRepo
import com.devforce.backend.repos.UserRepo
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

    fun registerUser(userDTO: RegisterDto): ResponseEntity<ResponseDTO> {
        if (userRepo.findByUsername(userDTO.username) != null) {
            return ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(), "Username is already taken"))
        }

        // Encode the password
        val encodedPassword = passwordEncoder.encode(userDTO.password)


        val generalRole = roleRepo.findByName("GENERAL")!!

        // Continue with the registration process
        val newUser = UserModel().apply {
            this.username = userDTO.username
            this.password = encodedPassword
            this.fullName = userDTO.fullName
            this.roles = setOf(generalRole)
        }

        userRepo.save(newUser)

        return ResponseEntity.ok(ResponseDTO("success", System.currentTimeMillis(), "User registered successfully"))

    }

    fun loginUser(userDTO: LoginDto): ResponseEntity<ResponseDTO> {
        try {
            // Perform authentication
            val authentication: Authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(userDTO.username, userDTO.password)
            )

            // Set the authentication object to the security context
            SecurityContextHolder.getContext().authentication = authentication

            return ResponseEntity.ok(ResponseDTO("success", System.currentTimeMillis(), "User logged in successfully"))
        } catch (ex: AuthenticationException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDTO("error", System.currentTimeMillis(), "Authentication failed: ${ex.message}"))
        }
    }
}
