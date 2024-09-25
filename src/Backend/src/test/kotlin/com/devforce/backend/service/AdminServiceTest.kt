package com.devforce.backend.service

import com.devforce.backend.model.*
import com.devforce.backend.repo.*
import com.devforce.backend.security.CustomUser
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.mail.MailSender
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import java.time.LocalDateTime
import java.time.temporal.ChronoUnit
import java.util.*

@AutoConfigureMockMvc
class AdminServiceTest {


    @InjectMocks
    private lateinit var adminServiceMockMock: AdminService

    @Mock
    private lateinit var statusRepo: StatusRepo

    @Mock
    lateinit var roleRepo: RoleRepo

    @Mock
    lateinit var userRepo: UserRepo

    var userid = UUID.randomUUID()

    var user = UserModel().apply {
        userId= userid
    }

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)

        userid = UUID.randomUUID()
        user = UserModel().apply {
            userId= userid
            role = RoleModel().apply { name = "ADMIN" }
        }
        val roleName = "HOST"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(userid, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }


    fun setUp(roleName: String) {
        MockitoAnnotations.openMocks(this)

        userid = UUID.randomUUID()
        user = UserModel().apply {
            userId= userid
            role = RoleModel().apply { name = roleName }
        }
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(userid, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }





}
