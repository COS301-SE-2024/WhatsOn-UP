package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.FilterByDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.RoleModel
import com.devforce.backend.model.UserModel
import com.devforce.backend.model.VenueModel
import com.devforce.backend.repo.BroadcastRepo
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

    @Mock
    private lateinit var broadcastRepo: BroadcastRepo

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

    fun setUp(role: String) {
        MockitoAnnotations.openMocks(this)

        val id = UUID.randomUUID()
        val user = UserModel().apply {
            userId= id
            this.role = RoleModel().apply { name = role }
        }
        val roleName = role
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

        val existingEvent = EventModel().apply {
            eventId = id
            title = "Event"
            description = "Description"
            this.venue = venue
            this.maxAttendees = 5


        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(existingEvent))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(venue)
        `when`(eventRepo.save(existingEvent)).thenReturn(existingEvent)

        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("success", response.body?.status)
        assertEquals(updateEventDto.title, (response.body?.data as EventDto).title)
        assertEquals(updateEventDto.description, (response.body?.data as EventDto).description)


        setUp("HOST")
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(existingEvent))
        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("You are not authorized to update this event", result["message"])

        `when`(eventRepo.findById(id)).then{ throw Exception() }
        response = eventServiceWithMocks.updateEvent(id, updateEventDto)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Failed to update event", result["message"])


    }

    @Test
    fun `Test delete event`(){
        val id = UUID.randomUUID()
        val eventModel = EventModel().apply {
            eventId = id
            title = "Event"
            description = "Description"
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        var response = eventServiceWithMocks.deleteEvent(id)

        assertEquals("error", response.body?.status)
        var result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Event not found", result["message"])

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(eventRepo.deleteEvent(id)).then{}

        response = eventServiceWithMocks.deleteEvent(id)

        assertEquals("success", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Event deleted successfully", result["message"])


        setUp("HOST")
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))
        `when`(eventRepo.deleteEvent(id)).then{}

        response = eventServiceWithMocks.deleteEvent(id)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("You are not authorized to delete this event", result["message"])
    }


    @Test
    fun `Test search events`(){
        val userModel = UserModel().apply {
            userId = UUID.randomUUID()
        }
        `when`(eventRepo.searchEvents("string", userModel.userId)).thenReturn(listOf())

        val response = eventServiceWithMocks.searchEvents("string")

        assertEquals("success", response.body?.status)
        assertEquals(0, (response.body?.data as List<EventDto>).size)
    }

    @Test
    fun `Test getUnique Categories`(){
        `when`(eventRepo.findUniqueCategories()).thenReturn(listOf("category1", "category2"))

        val response = eventServiceWithMocks.getUniqueCategories()
        assertEquals(2, response.size)
    }

    @Test
    fun `Test broadcast`(){
        val id = UUID.randomUUID()
        val eventModel = EventModel().apply {
            eventId = id
            title = "Event"
            description = "Description"
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))

        var response = eventServiceWithMocks.broadcastMessage("Alert", id)

        assertEquals("success", response.body?.status)
        var result: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Broadcast sent successfully", result["message"])

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        response = eventServiceWithMocks.broadcastMessage("Alert", id)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("Event not found", result["message"])


        setUp("HOST")
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(eventModel))

        response = eventServiceWithMocks.broadcastMessage("Alert", id)

        assertEquals("error", response.body?.status)
        result = response.body?.data as Map<String, String>
        assertEquals("You are not authorized to broadcast to this event", result["message"])

    }

    @Test
    fun `Test filter`(){
        val filterByDto = FilterByDto(
            "category",
            "location",
            true,
            10
        )

        val userModel = UserModel().apply {
            userId = UUID.randomUUID()
        }
        `when`(eventRepo.filterEvents(filterByDto, userModel.userId)).thenReturn(listOf())

        val response = eventServiceWithMocks.filterEvents(filterByDto)

        assertEquals("success", response.body?.status)
        assertEquals(0, (response.body?.data as List<EventDto>).size)
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

    @Test
    fun `Test get attendance`(){
        val eventId = UUID.randomUUID()
        val userId = UUID.randomUUID()
        val attended = true;
        `when`(eventRepo.findAttendanceByEventId(eventId)).thenReturn(listOf(mapOf("user_id" to userId, "attended" to attended)))

        var response = eventServiceWithMocks.getAllAttendanceByEventId(eventId)

        assertEquals("success", response.body?.status)
        assertEquals(1, (response.body?.data as List<Map<String, Any>>).size)

        `when`(eventRepo.findAttendanceByEventId(eventId)).thenReturn(listOf())

        // Act: Test for error case when exception occurs
        response = eventServiceWithMocks.getAllAttendanceByEventId(eventId)

        // Assert: Check if the response status is "error"
        assertEquals("error", response.body?.status)
        val result = response.body?.data as Map<String, String>
        assertEquals("No attendance records found for the event", result["message"])

    }

    @Test
    fun `Test get locations`(){
        `when`(venueRepo.findAll()).thenReturn(listOf(VenueModel(), VenueModel()))

        val response = eventServiceWithMocks.getLocations()

        val result = response.body?.data as List<VenueModel>

        assertEquals("success", response.body?.status)
        assertEquals(2, result.size)
    }


}