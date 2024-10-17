package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
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

//    @Test
//    fun `test venue not found`() {
//        val id = UUID.randomUUID()
//        `when`(venueRepo.findByVenueId(id)).thenReturn(null)
//        val response = eventService.createEvent(createEventDto)
//
//        assertEquals("error", response.body!!.status)
//        assertEquals("Venue not found", response.body!!.data["message"])
//    }

    @Test
    fun `!!!Create event success!!!`() {
        val createEventDto = CreateEventDto(
            title = "Event Title",
            description = "Event Description",
            startDateTime = LocalDateTime.now(),
            endDateTime = LocalDateTime.now().plusHours(2),
            location = UUID.randomUUID(),
            maxParticipants = 10,
            metadata = mapOf("key1" to "value1", "key2" to "value2"),
            isPrivate = false,
            null,
            recurring = null
        )

        val venueModel = VenueModel().apply {
            venueId = createEventDto.location
            available = true
            capacity = 100
        }

        `when`(venueRepo.findByVenueId(createEventDto.location)).thenReturn(venueModel)

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
            location = id,
            maxParticipants = 10,
            metadata = mapOf("key1" to "value1", "key2" to "value2"),
            isPrivate = true,
            null,
            recurring = null
        )

        val event = EventModel().apply {
            this.title = "Event Title"
            this.description = "Event Description"
            this.startDateTime = LocalDateTime.now()
            this.endDateTime = LocalDateTime.now().plusHours(2)
            this.venue = VenueModel()
            this.maxAttendees = 20
            this.metadata = mapOf("key1" to "value1", "key2" to "value2").toString()
            this.isPrivate = false
        }

        val venueModel = VenueModel().apply {
            venueId = updateEventDto.location
            available = true
            capacity = 100
        }

        // Mock necessary dependencies and interactions
        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))
        `when`(updateEventDto.location?.let { venueRepo.findByVenueId(it) }).thenReturn(venueModel)
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
            location = id,
            maxParticipants = 20,
            metadata = mapOf("key1" to "value1", "key2" to "value2"),
            isPrivate = true,
            null,
            recurring = null
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
        val userid = null

        `when`(eventRepo.searchEvents(searchString, userid)).thenReturn(listOf())

        val response = eventServiceWithMocks.searchEvents(searchString)

        assertEquals("success", response.body?.status)
    }

    @Test
    fun `!!!Filter events success!!!`() {
        val id = UUID.randomUUID()
        val filterByDto = FilterByDto(
            startDateTime = "2021-08-01 00:00:00",
            endDateTime = "2021-08-31 23:59:59",
            maxAttendees = 10,
            isPrivate = false
        )

        `when`(eventRepo.filterEvents(filterByDto, id)).thenReturn(listOf())

        val response = eventServiceWithMocks.filterEvents(filterByDto)

        assertEquals("success", response.body?.status)
    }

}