package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.FilterByDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.RoleModel
import com.devforce.backend.model.UserModel
import com.devforce.backend.model.VenueModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.repo.VenueRepo
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
import javax.swing.text.html.Option

@AutoConfigureMockMvc
class EventServiceTest {

    @Mock
    private lateinit var eventRepo: EventRepo

    @Mock
    private lateinit var userRepo: UserRepo

    @Mock
    private lateinit var venueRepo: VenueRepo

    @InjectMocks
    private lateinit var eventServiceWithMocks: EventService

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)

        val id = UUID.randomUUID()
        val user = UserModel().apply {
            userId= id
            role = RoleModel().apply { name = "ADMIN" }
        }
        val roleName = "ADMIN"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(id, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `Test create event`(){
        val createEventDto = CreateEventDto(
            "Event",
            "Description",
            LocalDateTime.now(),
            LocalDateTime.now().plusHours(2),
            UUID.randomUUID(),
            0,
            null,
            null,
            null,
        )

        val venue = VenueModel().apply {
            venueId = UUID.randomUUID()
            capacity = 5
            available = false
        }

        `when`(venueRepo.findByVenueId(createEventDto.location)).thenReturn(null)

        var response = eventServiceWithMocks.createEvent(createEventDto)

        assertEquals("error", response.body?.status)
        var result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Venue not found", result["message"])

        `when`(venueRepo.findByVenueId(createEventDto.location)).thenReturn(venue)

        response = eventServiceWithMocks.createEvent(createEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Venue not available", result["message"])

        venue.available = true

        `when`(venueRepo.findByVenueId(createEventDto.location)).thenReturn(venue)

        response = eventServiceWithMocks.createEvent(createEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Max participants must be greater than 0", result["message"])



        createEventDto.maxParticipants = 10

        `when`(venueRepo.findByVenueId(createEventDto.location)).thenReturn(venue)

        response = eventServiceWithMocks.createEvent(createEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Max participants must be less than venue capacity", result["message"])

        venue.capacity = 20

        `when`(venueRepo.findByVenueId(createEventDto.location)).thenReturn(venue)


        val event = EventModel()

        `when`(eventRepo.save(event)).thenReturn(event)

        response = eventServiceWithMocks.createEvent(createEventDto)

        assertEquals("success", response.body?.status)
        assertEquals(createEventDto.title, (response.body?.data as EventDto).title)
        assertEquals(createEventDto.description, (response.body?.data as EventDto).description)
    }

    @Test
    fun `Test update event`(){
        val updateEventDto = UpdateEventDto(
            "Event 2",
            "Description 2",
            LocalDateTime.now(),
            LocalDateTime.now().plusHours(2),
            UUID.randomUUID(),
            10,
            null,
            null,
            null,
        )

        val venue = VenueModel().apply {
            venueId = UUID.randomUUID()
            capacity = 5
            available = false
        }

        val eventModel = EventModel().apply {
            title = "Event"
            description = "Description"
            this.venue = venue
        }

        val id = UUID.randomUUID()
        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        var response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        var result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Event not found", result["message"])


        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(null)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Venue not found", result["message"])

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(venue)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Venue not available", result["message"])

        venue.available = true
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(venue)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Max participants must be less than venue capacity", result["message"])

        updateEventDto.location = null

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(venue.venueId?.let { venueRepo.findByVenueId(it) }).thenReturn(venue)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Max participants must be less than venue capacity", result["message"])

        venue.capacity = 10
        updateEventDto.location = UUID.randomUUID()
        updateEventDto.maxParticipants = 0


        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(venue)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Max participants must be greater than 0", result["message"])

        updateEventDto.maxParticipants = 10
        venue.available = true

        val existingEvent = EventModel()

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(venue)
        `when`(eventRepo.save(existingEvent)).thenReturn(existingEvent)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("success", response.body?.status)
        assertEquals(updateEventDto.title, (response.body?.data as EventDto).title)
        assertEquals(updateEventDto.description, (response.body?.data as EventDto).description)


        `when`(eventRepo.findById(id)).thenThrow(NoSuchElementException::class.java)
        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Failed to update event", result["message"])


        `when`(eventRepo.findById(id)).thenThrow(RuntimeException::class.java)
        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Event not found", result["message"])


















    }



    @Test
    fun `Test update attendance`(){
        val eventId = UUID.randomUUID()
        val userId = UUID.randomUUID()
        val attended = true;
        `when`(eventRepo.updateAttendanceStatus(eventId, userId, attended)).thenReturn(0)

        var response = eventServiceWithMocks.updateAttendanceStatus(eventId, userId, attended)

        assertEquals("error", response.body?.status)

        `when`(eventRepo.updateAttendanceStatus(eventId, userId, attended)).thenReturn(2)

        response = eventServiceWithMocks.updateAttendanceStatus(eventId, userId, attended)

        assertEquals("success", response.body?.status)

        `when`(eventRepo.updateAttendanceStatus(eventId, userId, attended)).thenThrow(RuntimeException::class.java)

        // Act: Test for error case when exception occurs
        response = eventServiceWithMocks.updateAttendanceStatus(eventId, userId, attended)

        // Assert: Check if the response status is "error"
        assertEquals("error", response.body?.status)

    }

}