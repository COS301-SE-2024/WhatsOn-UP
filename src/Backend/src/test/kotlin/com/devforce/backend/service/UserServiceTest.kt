package com.devforce.backend.service

import com.devforce.backend.dto.UpdateUserDto
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import java.util.*

@AutoConfigureMockMvc
class UserServiceTest {

    @Mock
    private lateinit var eventRepo: EventRepo

    @Mock
    private lateinit var userRepo: UserRepo

    @InjectMocks
    private lateinit var userServiceWithMocks: UserService

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)
        val user = UserModel().apply {
            userId= UUID.randomUUID()
            email = "email@gmail"
            password = "password"
        }
        val roleName = "HOST"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser("email@gmail", "password", authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `!!!Save event success!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        val response = userServiceWithMocks.saveEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Save event failure!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.saveEvent(id)

        assertEquals("error", response.body?.status)
    }

    @Test
    fun `!!!Update user profile success!!!`() {
        val updateUserDto = UpdateUserDto("email@gmail", "password", "newPassword")
        val response = userServiceWithMocks.updateProfile(updateUserDto)

        assertEquals("success", response.body!!.status)
    }

    @Test
    fun `!!!Delete event success!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        val response = userServiceWithMocks.deleteSavedEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Delete event failure!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.deleteSavedEvent(id)

        assertEquals("error", response.body?.status)
    }

    @Test
    fun `!!!Get saved events success!!!`() {
        val user = UserModel().apply {
            userId = UUID.randomUUID()
            email = "email@gmail"
            password = "password"
        }
        val event = EventModel().apply {
            attendees.add(user)
        }

        `when`(userRepo.findByEmail("email@gmail")).thenReturn(user)
        `when`(eventRepo.getSavedEvents(user.userId)).thenReturn(listOf(event))

        val response = userServiceWithMocks.getSavedEvents()

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!RSVP event success!!!`() {
        val id = UUID.randomUUID()
        val user = UserModel().apply {
            userId = UUID.randomUUID()
            email = "email@gmail"
            password = "password"
        }
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        val response = userServiceWithMocks.rspvEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!RSVP event failure!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.rspvEvent(id)

        assertEquals("error", response.body?.status)
    }

    @Test
    fun `!!!Get RSVP'd events success!!!`() {
        val user = UserModel().apply {
            userId = UUID.randomUUID()
            email = "email@gmail"
            password = "password"
        }
        val event = EventModel().apply {
            attendees.add(user)
        }

        `when`(userRepo.findByEmail("email@gmail")).thenReturn(user)
        `when`(eventRepo.getRspvdEvents(user.userId)).thenReturn(listOf(event))

        val response = userServiceWithMocks.getRspvEvents()

        assertEquals("success", response.body?.status)
    }


    @Test
    fun `!!!Delete RSVP'd event success!!!`() {
        val id = UUID.randomUUID()
        val user = UserModel().apply {
            userId = UUID.randomUUID()
            email = "email@gmail"
            password = "password"
        }
        val event = EventModel().apply {
            attendees.add(user)
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        val response = userServiceWithMocks.deleteRspvEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Delete RSVP'd event failure!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.deleteRspvEvent(id)

        assertEquals("error", response.body?.status)
    }
}
