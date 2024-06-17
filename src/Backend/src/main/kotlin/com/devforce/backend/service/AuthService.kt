package com.devforce.backend.service

import com.devforce.backend.dto.LoginDto
import com.devforce.backend.dto.RegisterDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.RoleRepo
import com.devforce.backend.repo.UserRepo
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

    @Autowired
    lateinit var checkJwt: CheckJwt

    fun registerUser(userDTO: RegisterDto): ResponseEntity<ResponseDto> {
        if (userRepo.findByEmail(userDTO.email) != null) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Email is already taken"))
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

        val tokenDto = jwtGenerator.generateToken(authentication)

        return ResponseEntity.ok(tokenDto)

    }

    fun loginUser(userDTO: LoginDto): ResponseEntity<ResponseDto> {
        try {
            // Perform authentication
            val authentication: Authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(userDTO.email, userDTO.password)
            )

            SecurityContextHolder.getContext().authentication = authentication

            val tokenDto = jwtGenerator.generateToken(authentication)

            return ResponseEntity.ok(tokenDto)
        } catch (ex: AuthenticationException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDto("error", System.currentTimeMillis(), "Authentication failed: ${ex.message}"))
        }
    }

    fun refreshToken(jwtToken: String, refreshToken: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(jwtToken)
        if (response != null) {
            return response
        }

        val expiry = jwtGenerator.checkExpiry(jwtToken)

        if (!expiry) {
            val refreshedDto = jwtGenerator.refreshToken(jwtToken, refreshToken)
            return ResponseEntity.ok(refreshedDto)
        }

        return ResponseEntity.ok(
            ResponseDto(
                "success",
                System.currentTimeMillis(),
                "Token is still valid"
            )
        )
    }

    fun logoutUser(token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)

        user?.let {
            it.jwtToken = ""
            it.refreshToken = ""
            userRepo.save(it)
        }

        return ResponseEntity.ok(
            ResponseDto(
                "success",
                System.currentTimeMillis(),
                "User logged out successfully"
            )
        )
    }


    fun getUser(token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val userCreds = mapOf(
            "email" to user.email,
            "role" to user.role?.name,
            "id" to user.userId,
            "fullName" to user.fullName,
            "profileImage" to user.profileImage
        )

        return ResponseEntity.ok(
            ResponseDto(
                "success",
                System.currentTimeMillis(),
                mapOf("user" to userCreds)
            )
        )
    }

    fun deleteUser(token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!
        userRepo.delete(user)

        return ResponseEntity.ok(
            ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Account deleted successfully"))
        )
    }

    fun resetPassword(token: String, newPassword: String): ResponseEntity<ResponseDto> {
        try {
            val response = checkJwt.check(token)
            if (response != null) {
                return response
            }

            val email = jwtGenerator.getUsernameFromToken(token)
            val user = userRepo.findByEmail(email)!!

            user.password = passwordEncoder.encode(newPassword)
            userRepo.save(user)

            val authentication: Authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(email, newPassword)
            )

            SecurityContextHolder.getContext().authentication = authentication

            val tokenDto = jwtGenerator.generateToken(authentication)

            return ResponseEntity.ok(tokenDto)
        } catch (ex: AuthenticationException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDto("error", System.currentTimeMillis(), "Authentication failed: ${ex.message}"))
        }
    }

}
