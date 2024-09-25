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
    lateinit var hostApplicationsRepo: HostApplicationsRepo

    @Mock
    lateinit var broadcastRepo: BroadcastRepo

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
            role = RoleModel().apply { name = "HOST" }
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

    @Test
    fun `Test promote user`(){
        var userId = userid
        `when`(userRepo.findById(userId)).thenReturn(Optional.empty())

        var response = adminServiceMockMock.promoteUser(userId)

        assertEquals("error", response.body?.status)
        assertEquals("User not found", response.body?.data)

        `when`(userRepo.findById(userId)).thenReturn(Optional.of(user))

        response = adminServiceMockMock.promoteUser(userId)

        assertEquals("error", response.body?.status)
        assertEquals("User is already a host", response.body?.data)

        setUp("ADMIN")
        userId = userid

        `when`(userRepo.findById(userId)).thenReturn(Optional.of(user))

        response = adminServiceMockMock.promoteUser(userId)

        assertEquals("error", response.body?.status)
        assertEquals("User is an admin", response.body?.data)

        setUp("GENERAL")
        userId = userid

        `when`(userRepo.findById(userId)).thenReturn(Optional.of(user))

        response = adminServiceMockMock.promoteUser(userId)

        assertEquals("success", response.body?.status)
        val result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("User promoted to host successfully", result["message"])

    }

    @Test
    fun `Test demote user`(){
        var userId = userid
        `when`(userRepo.findById(userId)).thenReturn(Optional.empty())

        var response = adminServiceMockMock.demoteUser(userId)

        assertEquals("error", response.body?.status)
        assertEquals("User not found", response.body?.data)

        setUp("ADMIN")

        userId = userid

        `when`(userRepo.findById(userId)).thenReturn(Optional.of(user))

        response = adminServiceMockMock.demoteUser(userId)

        assertEquals("error", response.body?.status)
        assertEquals("User is an admin", response.body?.data)

        setUp("HOST")

        userId = userid

        `when`(userRepo.findById(userId)).thenReturn(Optional.of(user))
        `when`(hostApplicationsRepo.findByUserId(userId)).thenReturn(listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "VERIFIED" }
        }))

        response = adminServiceMockMock.demoteUser(userId)

        assertEquals("success", response.body?.status)
        val result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("User demoted to general successfully", result["message"])

    }

    @Test
    fun `Test accept application`(){
        var applicationId = UUID.randomUUID()
        `when`(hostApplicationsRepo.findById(applicationId)).thenReturn(Optional.empty())

        var response = adminServiceMockMock.acceptApplication(applicationId)

        assertEquals("error", response.body?.status)
        assertEquals("Application not found", response.body?.data)

        `when`(hostApplicationsRepo.findById(applicationId)).thenReturn(Optional.of(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
            verificationCode = UUID.randomUUID()
        }))

        response = adminServiceMockMock.acceptApplication(applicationId)

        assertEquals("error", response.body?.status)
        assertEquals("Application not verified", response.body?.data)

        `when`(hostApplicationsRepo.findById(applicationId)).thenReturn(Optional.of(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
            proofUrl = null
        }))

        response = adminServiceMockMock.acceptApplication(applicationId)

        assertEquals("error", response.body?.status)
        assertEquals("Application not verified", response.body?.data)

        `when`(hostApplicationsRepo.findById(applicationId)).thenReturn(Optional.of(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "ACCEPTED" }
        }))

        val applicationModel = HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
            verificationCode = UUID.randomUUID()
        }

        `when`(hostApplicationsRepo.save(applicationModel)).thenReturn(applicationModel)

        response = adminServiceMockMock.acceptApplication(applicationId)

        assertEquals("success", response.body?.status)
        val result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Application accepted successfully", result["message"])

    }

    @Test
    fun `Test reject application`(){
        var applicationId = UUID.randomUUID()
        `when`(hostApplicationsRepo.findById(applicationId)).thenReturn(Optional.empty())

        var response = adminServiceMockMock.rejectApplication(applicationId)

        assertEquals("error", response.body?.status)
        assertEquals("Application not found", response.body?.data)

        `when`(hostApplicationsRepo.findById(applicationId)).thenReturn(Optional.of(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
        }))

        val applicationModel = HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
        }

        `when`(hostApplicationsRepo.save(applicationModel)).thenReturn(applicationModel)

        response = adminServiceMockMock.rejectApplication(applicationId)

        assertEquals("success", response.body?.status)
        val result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Application rejected successfully", result["message"])

    }

    @Test
    fun `Test get all applications`(){
        `when`(hostApplicationsRepo.findByStatus(null)).thenReturn(listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
        }))

        var response = adminServiceMockMock.getAllApplications(null)

        assertEquals("success", response.body?.status)
        assertEquals(1, (response.body?.data as List<HostApplicationsModel>).size)

        `when`(hostApplicationsRepo.findByStatus("PENDING")).thenReturn(listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply { name = "PENDING" }
        }))

        response = adminServiceMockMock.getAllApplications("PENDING")

        assertEquals("success", response.body?.status)
        assertEquals(1, (response.body?.data as List<HostApplicationsModel>).size)

    }

    @Test
    fun `Test broadcast message`(){
        val hello = "Hello"
        val user = UserModel().apply {
            userId = UUID.randomUUID()
        }

        val broadcast = BroadcastModel().apply {
            messageId = UUID.randomUUID()
            eventId = null
            message = hello
            fromId = user.userId
            sentAt = Date()
        }

        `when`(broadcastRepo.save(broadcast)).thenReturn(broadcast)

        var response = adminServiceMockMock.broadcastMessage(hello)

        assertEquals("success", response.body?.status)
        val result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Message broadcasted successfully", result["message"])

    }



}
