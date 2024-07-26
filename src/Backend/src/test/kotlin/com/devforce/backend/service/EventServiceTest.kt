package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.FilterByDto
import com.devforce.backend.dto.UpdateEventDto
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
import java.time.LocalDateTime
import java.util.*

@AutoConfigureMockMvc
class EventServiceTest {

    @Mock
    private lateinit var eventRepo: EventRepo

    @Mock
    private lateinit var userRepo: UserRepo

    @InjectMocks
    private lateinit var eventServiceWithMocks: EventService

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)

        val id = UUID.randomUUID()
        val user = UserModel().apply {
            userId= id
        }
        val roleName = "HOST"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(id, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `!!!Save event success!!!`() {
        val createEventDto = CreateEventDto(
            title = "Event Title",
            description = "Event Description",
            startDate = LocalDateTime.now(),
            endDate = LocalDateTime.now().plusHours(2),
            location = "Event Location",
            maxParticipants = 10,
            metadata = "Event Metadata",
            isPrivate = false,
            media = List(1) { "Event Media" }
        )

        val response = eventServiceWithMocks.createEvent(createEventDto)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Get all events success!!!`() {
        val response = eventServiceWithMocks.getAllEvents()

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Update event success!!!`() {
        val id = UUID.randomUUID()
        val updateEventDto = UpdateEventDto(
            title = "Updated Event Title",
            description = "Updated Event Description",
            startDateTime = LocalDateTime.now(),
            endDateTime = LocalDateTime.now().plusHours(2),
            location = "Updated Event Location",
            maxParticipants = 10,
            metadata = "Updated Event Metadata",
            isPrivate = true
        )

        val event = EventModel().apply {
            this.title = "Event Title"
            this.description = "Event Description"
            this.startDateTime = LocalDateTime.now()
            this.endDateTime = LocalDateTime.now().plusHours(2)
            this.location = "Event Location"
            this.maxAttendees = 20
            this.metadata = "Event Metadata"
            this.isPrivate = false
        }

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))
        `when`(eventRepo.save(event)).thenReturn(event)

        val response = eventServiceWithMocks.updateEvent(id, updateEventDto)
        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Update event failure!!!`() {
        val id = UUID.randomUUID()
        val updateEventDto = UpdateEventDto(
            title = "Updated Event Title",
            description = "Updated Event Description",
            startDateTime = LocalDateTime.now(),
            endDateTime = LocalDateTime.now().plusHours(2),
            location = "Updated Event Location",
            maxParticipants = 20,
            metadata = "Updated Event Metadata",
            isPrivate = true
        )

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
    }

    @Test
    fun `!!!Delete event success!!!`() {
        val id = UUID.randomUUID()
        val event = EventModel()

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        val response = eventServiceWithMocks.deleteEvent(id)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Delete event failure!!!`() {
        val id = UUID.randomUUID()

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        val response = eventServiceWithMocks.deleteEvent(id)

        assertEquals("error", response.body?.status)
    }

    @Test
    fun `!!!Search events success!!!`() {
        val searchString = "searchString"

        `when`(eventRepo.searchEvents(searchString)).thenReturn(listOf())

        val response = eventServiceWithMocks.searchEvents(searchString)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Filter events success!!!`() {
        val filterByDto = FilterByDto(
            startDateTime = "2021-08-01 00:00:00",
            endDateTime = "2021-08-31 23:59:59",
            maxAttendees = 10,
            isPrivate = false,
            location = "Location"
        )

        `when`(eventRepo.filterEvents(filterByDto)).thenReturn(listOf())

        val response = eventServiceWithMocks.filterEvents(filterByDto)

        assertEquals("success", response.body?.status)
    }

}