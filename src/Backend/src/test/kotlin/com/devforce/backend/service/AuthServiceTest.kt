package com.devforce.backend.service

import com.devforce.backend.dto.*
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.RoleModel
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import com.devforce.backend.security.JwtGenerator
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.crypto.password.PasswordEncoder
import java.util.*

@AutoConfigureMockMvc

class AuthServiceTest {

    @Mock
    private lateinit var eventRepo: EventRepo

    @Mock
    private lateinit var userRepo: UserRepo

    @InjectMocks
    private lateinit var authServiceWithMocks: AuthService

    @Mock
    private lateinit var jwtGenerator: JwtGenerator

    @Mock
    private lateinit var passswordEncoder: PasswordEncoder

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)
        val roleg = RoleModel().apply {
            name = "GENERAL"
        }
        val user = UserModel().apply {
            userId= UUID.randomUUID()
            email = "email@gmail"
            password = "password"
            role = roleg
        }
        val roleName = "HOST"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser("email@gmail", "password", authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `!!!register user success!!!`() {
        val registerDto = RegisterDto(
            email = "email@gmail",
            password = "password",
            fullName = "John Doe"
        )

        `when`(passswordEncoder.encode(registerDto.password)).thenReturn("password")
        `when`(jwtGenerator.generateToken(registerDto.email, "GENERAL")).thenReturn(
            mapOf(
                "jwtToken" to "jwtToken",
                "refreshToken" to "refreshToken"
            ))


        val response = authServiceWithMocks.registerUser(registerDto)

        assertEquals(response.body?.status, "success")
    }

    @Test
    fun `!!!register user failure!!!`() {
        val registerDto = RegisterDto(
            email = "email@gmail",
            password = "password",
            fullName = "John Doe"
        )

        `when`(userRepo.findByEmail(registerDto.email)).thenReturn(UserModel())
        val response = authServiceWithMocks.registerUser(registerDto)

        assertEquals(response.body?.status, "error")
    }

    @Test
    fun `!!!login user success!!!`() {
        var roleg = RoleModel().apply {
            name = "GENERAL"
        }
        val loginDto = LoginDto(
            email = "email@gmail",
            password = "password"
        )

        val user = UserModel().apply {
            email = loginDto.email
            password = "password"
            role = roleg
        }

        `when`(userRepo.findByEmail(loginDto.email)).thenReturn(user)
        `when`(passswordEncoder.matches(loginDto.password, user.password)).thenReturn(true)
        `when`(jwtGenerator.generateToken(user.email, "GENERAL")).thenReturn(
            mapOf(
                "jwtToken" to "jwtToken",
                "refreshToken" to "refreshToken"
            ))

        val response = authServiceWithMocks.loginUser(loginDto)

        assertEquals(response.body?.status, "success")
    }

    @Test
    fun `!!!login user failure!!!`() {
        val loginDto = LoginDto(
            email = "email@gmail",
            password = "password"
        )

        val user = UserModel().apply {
            email = loginDto.email
            password = "password"
        }

        `when`(userRepo.findByEmail(loginDto.email)).thenReturn(user)
        `when`(passswordEncoder.matches(loginDto.password, user.password)).thenReturn(false)

        val response = authServiceWithMocks.loginUser(loginDto)

        assertEquals(response.body?.status, "error")
    }

    @Test
    fun `!!!logout user success!!!`() {
        val response = authServiceWithMocks.logoutUser()

        assertEquals(response.body?.status, "success")
    }

    @Test
    fun `!!!getUser success!!!`() {
        val response = authServiceWithMocks.getUser()

        assertEquals(response.body?.status, "success")
    }

    @Test
    fun `!!!deleteUser success!!!`() {
        val response = authServiceWithMocks.deleteUser()

        assertEquals(response.body?.status, "success")
    }

    @Test
    fun `!!!resetPassword success!!!`() {
        val password = "password"
        `when`(passswordEncoder.encode(password)).thenReturn("password")
        val user = UserModel().apply {
            email = "email@gmail"
            role = RoleModel().apply {
                name = "GENERAL"
            }
        }
        `when`(jwtGenerator.generateToken(user.email, user.role!!.name)).thenReturn(
            mapOf(
                "jwtToken" to "jwtToken",
                "refreshToken" to "refreshToken"
            ))

        val response = authServiceWithMocks.resetPassword(password)

        assertEquals(response.body?.status, "success")
    }

    @Test
    fun `!!!refreshToken success!!!`() {
        val refreshTokenDto = RefreshTokenDto("refreshToken", "jwtToken")
        val user = UserModel().apply {
            email = "email@gmail"
            role = RoleModel().apply {
                name = "GENERAL"
            }
        }
        `when`(jwtGenerator.generateToken(user.email, user.role!!.name)).thenReturn(
            mapOf(
                "jwtToken" to "jwtToken",
                "refreshToken" to "refreshToken"
            ))
        val response = authServiceWithMocks.refreshToken(refreshTokenDto)
    }

}