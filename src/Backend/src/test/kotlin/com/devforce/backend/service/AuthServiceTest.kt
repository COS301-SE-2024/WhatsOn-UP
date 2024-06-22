package com.devforce.backend.service

import com.devforce.backend.dto.LoginDto
import com.devforce.backend.dto.RegisterDto
import jakarta.transaction.Transactional
import org.junit.jupiter.api.Test

import org.junit.jupiter.api.Assertions.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import org.springframework.web.client.HttpClientErrorException

@SpringBootTest
@Transactional
class AuthServiceTest {

    @Autowired
    lateinit var authService: AuthService


    @Test
    fun registerUser() {
        val userDTO = RegisterDto("test@example.com", "password", "Test User")

        try {
            val response = authService.registerUser(userDTO)

            assertEquals(HttpStatus.OK, response.statusCode)

            assertNotNull(response.body)

        } catch (ex: HttpClientErrorException) {
            if (ex.statusCode == HttpStatus.CONFLICT) {
                // Handle conflict scenario if needed
            } else {
                throw ex
            }
        }
    }

    @Test
    fun loginUser() {
        val userDTO = LoginDto("test@example.com", "password")

        try {
            val response = authService.loginUser(userDTO)

            assertEquals(HttpStatus.OK, response.statusCode)

            assertNotNull(response.body)

        } catch (ex: HttpClientErrorException) {
            if (ex.statusCode == HttpStatus.UNAUTHORIZED) {
                // Handle unauthorized scenario if needed
            } else {
                throw ex
            }
        }
    }

    @Test
    fun refreshToken() {
    }

    @Test
    fun logoutUser() {
    }

    @Test
    fun getUser() {
    }

    @Test
    fun deleteUser() {
    }

    @Test
    fun resetPassword() {
    }
}