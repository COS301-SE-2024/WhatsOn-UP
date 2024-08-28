package com.devforce.backend.service

import com.devforce.backend.model.AvailableSlotsModel
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.AvailableSlotsRepo
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

    @Mock
    private lateinit var availableSlotsRepo: AvailableSlotsRepo

    @InjectMocks
    private lateinit var userServiceWithMocks: UserService

    var userid = UUID.randomUUID()
    var user = UserModel().apply {
        userId= userid
    }

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)
        val roleName = "HOST"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(userid, authorities, user)
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
        val response = userServiceWithMocks.updateProfile("John Doe")

        assertEquals("success", response.body!!.status)
    }

    @Test
    fun `!!!Delete event success!!!`() {
        val id = UUID.randomUUID()
      
        val event = EventModel().apply {
            savedEvents.add(user)
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))
        `when`(eventRepo.save(event)).thenReturn(event)


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
        val id = UUID.randomUUID()
        
        val event = EventModel().apply {
            savedEvents.add(user)
            availableSlots = AvailableSlotsModel()
        }

        val option = Optional.of(user)

        `when`(userRepo.findById(id)).thenReturn(option)
        `when`(eventRepo.getSavedEvents(user.userId)).thenReturn(listOf(event))

        val response = userServiceWithMocks.getSavedEvents()

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!RSVP event success!!!`() {
        val id = UUID.randomUUID()
        
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        val response = userServiceWithMocks.rsvpEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!RSVP event failure!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.rsvpEvent(id)

        assertEquals("error", response.body?.status)
    }

    @Test
    fun `!!!Get RSVP'd events success!!!`() {
        val id = UUID.randomUUID()
        
        val event = EventModel().apply {
            attendees.add(user)
            availableSlots = AvailableSlotsModel()
        }

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(eventRepo.getRsvpdEvents(user.userId)).thenReturn(listOf(event))

        val response = userServiceWithMocks.getRsvpEvents()

        assertEquals("success", response.body?.status)
    }


    @Test
    fun `!!!Delete RSVP'd event success!!!`() {
        val id = UUID.randomUUID()

        

        val event = EventModel().apply {
            attendees.add(user)
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))
        `when`(eventRepo.save(event)).thenReturn(event)

        val response = userServiceWithMocks.deleteRsvpEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Delete RSVP'd event failure!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.deleteRsvpEvent(id)

        assertEquals("error", response.body?.status)
    }
}
