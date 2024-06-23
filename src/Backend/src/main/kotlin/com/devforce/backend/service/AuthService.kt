package com.devforce.backend.service

import com.devforce.backend.dto.LoginDto
import com.devforce.backend.dto.RefreshTokenDto
import com.devforce.backend.dto.RegisterDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.RoleRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import com.devforce.backend.security.JwtGenerator
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
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
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Email is already taken"))
        }

        // Encode the password
        val encodedPassword = passwordEncoder.encode(userDTO.password)

        val tokenDto = jwtGenerator.generateToken(userDTO.email, "GENERAL")

        val newUser = UserModel().apply {
            this.email = userDTO.email
            this.password = encodedPassword
            this.fullName = userDTO.fullName
            this.password = encodedPassword
            this.jwtToken = tokenDto["jwtToken"]!!
            this.refreshToken = tokenDto["refreshToken"]!!
        }

        userRepo.save(newUser)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), tokenDto))

    }

    fun loginUser(userDTO: LoginDto): ResponseEntity<ResponseDto> {
        try {
            val user = userRepo.findByEmail(userDTO.email)!!

            if (!passwordEncoder.matches(userDTO.password, user.password)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ResponseDto("error", System.currentTimeMillis(), "Invalid email or password"))
            }

            val tokenDto = jwtGenerator.generateToken(userDTO.email, user.role!!.name)
            user.jwtToken = tokenDto["jwtToken"]!!
            user.refreshToken = tokenDto["refreshToken"]!!

            userRepo.save(user)

            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), tokenDto))
        } catch (ex: AuthenticationException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDto("error", System.currentTimeMillis(), "Authentication failed: ${ex.message}"))
        }
    }

    fun refreshToken(refreshTokenDto: RefreshTokenDto): ResponseEntity<ResponseDto> {

        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDto("error", System.currentTimeMillis(), "Invalid refresh token"))

        val refreshed = jwtGenerator.generateToken(user.email, user.role!!.name)
        user.jwtToken = refreshed["jwtToken"]!!
        user.refreshToken = refreshed["refreshToken"]!!
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), refreshed))
    }

    fun logoutUser(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel


        user.jwtToken = ""
        user.refreshToken = ""
        userRepo.save(user)

        return ResponseEntity.ok(
            ResponseDto(
                "success",
                System.currentTimeMillis(),
                "User logged out successfully"
            )
        )
    }


    fun getUser(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

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

    fun deleteUser(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel
        userRepo.delete(user)

        return ResponseEntity.ok(
            ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Account deleted successfully"))
        )
    }

    fun resetPassword(newPassword: String): ResponseEntity<ResponseDto> {
        try {
            val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel


            val tokenDto = jwtGenerator.generateToken(user.email, user.role!!.name)

            user.password = passwordEncoder.encode(newPassword)
            user.jwtToken = tokenDto["jwtToken"]!!
            user.refreshToken = tokenDto["refreshToken"]!!

            userRepo.save(user)

            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), tokenDto))
        } catch (ex: AuthenticationException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ResponseDto("error", System.currentTimeMillis(), "Authentication failed: ${ex.message}"))
        }
    }

}
