package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.*
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.PassedEventsRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.repo.VenueRepo
import com.devforce.backend.security.CustomUser
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.MockitoAnnotations
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.context.SecurityContextImpl
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

    @Mock
    private lateinit var passedEventsRepo: PassedEventsRepo


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

    fun setUp(type: String) {
        MockitoAnnotations.openMocks(this)

        val id = UUID.randomUUID()
        val user = UserModel().apply {
            userId= id
            role = RoleModel().apply { name = type }
        }
        val roleName = type
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(id, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `Create event test cases`() {
        // Test case 1: Successful event creation
        val createEventDtoSuccess = CreateEventDto(
            title = "Event Title",
            description = "Event Description",
            startDateTime = LocalDateTime.now(),
            endDateTime = LocalDateTime.now().plusHours(2),
            location = UUID.randomUUID(),
            maxParticipants = 10,
            metadata = "Event Metadata",
            isPrivate = false
        )

        val venueModelSuccess = VenueModel().apply {
            venueId = createEventDtoSuccess.location
            available = true
            capacity = 100
        }

        `when`(venueRepo.findByVenueId(createEventDtoSuccess.location)).thenReturn(venueModelSuccess)

        val responseSuccess = eventServiceWithMocks.createEvent(createEventDtoSuccess)

        assertEquals("success", responseSuccess.body?.status)

        // Test case 2: Venue not found
        val createEventDtoVenueNotFound = createEventDtoSuccess.copy(location = UUID.randomUUID())

        `when`(venueRepo.findByVenueId(createEventDtoVenueNotFound.location)).thenReturn(null)

        val responseVenueNotFound = eventServiceWithMocks.createEvent(createEventDtoVenueNotFound)

        assertEquals("error", responseVenueNotFound.body?.status)
        val dataVenueNotFound = responseVenueNotFound.body?.data as? Map<*, *>
        assertEquals("Venue not found", dataVenueNotFound?.get("message"))

        // Test case 3: Venue not available
        val createEventDtoVenueNotAvailable = createEventDtoSuccess.copy(location = UUID.randomUUID())

        val venueModelNotAvailable = VenueModel().apply {
            venueId = createEventDtoVenueNotAvailable.location
            available = false
            capacity = 100
        }

        `when`(venueRepo.findByVenueId(createEventDtoVenueNotAvailable.location)).thenReturn(venueModelNotAvailable)

        val responseVenueNotAvailable = eventServiceWithMocks.createEvent(createEventDtoVenueNotAvailable)

        assertEquals("error", responseVenueNotAvailable.body?.status)
        val dataVenueNotAvailable = responseVenueNotAvailable.body?.data as? Map<*, *>
        assertEquals("Venue not available", dataVenueNotAvailable?.get("message"))

        // Test case 4: Max participants less than 1
        val createEventDtoMaxParticipantsLessThanOne = createEventDtoSuccess.copy(maxParticipants = 0)

        val venueModelLessThanOne = VenueModel().apply {
            venueId = createEventDtoMaxParticipantsLessThanOne.location
            available = true
            capacity = 100
        }

        `when`(venueRepo.findByVenueId(createEventDtoMaxParticipantsLessThanOne.location)).thenReturn(venueModelLessThanOne)

        val responseMaxParticipantsLessThanOne = eventServiceWithMocks.createEvent(createEventDtoMaxParticipantsLessThanOne)

        assertEquals("error", responseMaxParticipantsLessThanOne.body?.status)
        val dataMaxParticipantsLessThanOne = responseMaxParticipantsLessThanOne.body?.data as? Map<*, *>
        assertEquals("Max participants must be greater than 0", dataMaxParticipantsLessThanOne?.get("message"))

        // Test case 5: Max participants greater than venue capacity
        val createEventDtoMaxParticipantsGreaterThanCapacity = createEventDtoSuccess.copy(maxParticipants = 200)

        val venueModelGreaterThanCapacity = VenueModel().apply {
            venueId = createEventDtoMaxParticipantsGreaterThanCapacity.location
            available = true
            capacity = 100
        }

        `when`(venueRepo.findByVenueId(createEventDtoMaxParticipantsGreaterThanCapacity.location)).thenReturn(venueModelGreaterThanCapacity)

        val responseMaxParticipantsGreaterThanCapacity = eventServiceWithMocks.createEvent(createEventDtoMaxParticipantsGreaterThanCapacity)

        assertEquals("error", responseMaxParticipantsGreaterThanCapacity.body?.status)
        val dataMaxParticipantsGreaterThanCapacity = responseMaxParticipantsGreaterThanCapacity.body?.data as? Map<*, *>
        assertEquals("Max participants must be less than venue capacity", dataMaxParticipantsGreaterThanCapacity?.get("message"))
    }


    @Test
    fun `Test getAllEvents and getPassedEvents`() {
        // Test case 1: Get all events for anonymous user
        SecurityContextHolder.setContext(SecurityContextImpl().apply {
            authentication = UsernamePasswordAuthenticationToken("anonymousUser", null, emptyList())
        })

        val availableSlotsModel = AvailableSlotsModel().apply {
            eventId = UUID.randomUUID()
            availableSlots = 10
        }



        val anonymousEvents = listOf(
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 1"
                description = "Description 1"
                metadata = "Metadata 1"
                eventMedia = listOf("media1.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(UserModel())
                attendees = setOf(UserModel()) as MutableSet<UserModel>
                invitees = setOf(UserModel()) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            },
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 2"
                description = "Description 2"
                metadata = "Metadata 2"
                eventMedia = listOf("media2.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(UserModel())
                attendees = setOf(UserModel()) as MutableSet<UserModel>
                invitees = setOf(UserModel()) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            }
        )
        `when`(eventRepo.findAllByUser(null)).thenReturn(anonymousEvents)

        val anonymousResponse = eventServiceWithMocks.getAllEvents()

        assertEquals("success", anonymousResponse.body?.status)
        assertEquals(2, (anonymousResponse.body?.data as? List<EventDto>)?.size)

        // Test case 2: Get all events for authenticated user
        setUp()
        val customUser = SecurityContextHolder.getContext().authentication.principal as CustomUser
        val userModel = customUser.userModel
        val userEvents = listOf(
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 1"
                description = "Description 1"
                metadata = "Metadata 1"
                eventMedia = listOf("media1.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(userModel)
                attendees = setOf(userModel) as MutableSet<UserModel>
                invitees = setOf(userModel) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            },
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 2"
                description = "Description 2"
                metadata = "Metadata 2"
                eventMedia = listOf("media2.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(UserModel())
                attendees = setOf(UserModel()) as MutableSet<UserModel>
                invitees = setOf(UserModel()) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            }
        )

        `when`(eventRepo.findAllByUser(userModel.userId)).thenReturn(userEvents)

        val userResponse = eventServiceWithMocks.getAllEvents()

        assertEquals("success", userResponse.body?.status)
        val eventsDto = userResponse.body?.data as? List<EventDto>
        assertEquals(2, eventsDto?.size)
        assertEquals(true, eventsDto?.get(0)?.isHost)
        assertEquals(false, eventsDto?.get(1)?.isHost)

        // Test case 3: Get passed events for authenticated user
        val passedEvents = listOf(
            PassedEventModel().apply {
                eventId = UUID.randomUUID()
                title = "Passed Event 1"
                description = "Description 1"
                metadata = "Metadata 1"
                eventMedia = listOf("media1.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(userModel)
                attendees = setOf(userModel) as MutableSet<UserModel>
                invitees = setOf(userModel) as MutableSet<UserModel>
            },
            PassedEventModel().apply {
                eventId = UUID.randomUUID()
                title = "Passed Event 2"
                description = "Description 2"
                metadata = "Metadata 2"
                eventMedia = listOf("media2.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(userModel)
                attendees = setOf(userModel) as MutableSet<UserModel>
                invitees = setOf(userModel) as MutableSet<UserModel>
            }
        )

        `when`(passedEventsRepo.findPassedEvents(userModel.userId)).thenReturn(passedEvents)

        val passedEventsResponse = eventServiceWithMocks.getPassedEvents()

        assertEquals("success", passedEventsResponse.body?.status)
        assertEquals(2, (passedEventsResponse.body?.data as? List<EventModel>)?.size)
    }

    @Test
    fun `Test updateEvent`() {
        val eventId = UUID.randomUUID()

        // Test case 1: User not authorized to update event
        setUp("GENERAL")
        `when`(eventRepo.findById(eventId)).thenReturn(Optional.of(EventModel().apply { hosts = setOf() }))
        val unauthorizedResponse = eventServiceWithMocks.updateEvent(eventId, UpdateEventDto("New Title", "New Description", null, null, null, null, null, null))
        assertEquals("error", unauthorizedResponse.body?.status)
        assertEquals("You are not authorized to update this event", (unauthorizedResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 2: Event not found
        setUp()
        val customUser = SecurityContextHolder.getContext().authentication.principal as CustomUser
        val userModel = customUser.userModel

        `when`(eventRepo.findById(eventId)).thenReturn(Optional.empty())
        val eventNotFoundResponse = eventServiceWithMocks.updateEvent(eventId, UpdateEventDto())
        assertEquals("error", eventNotFoundResponse.body?.status)
        assertEquals("Event not found", (eventNotFoundResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 3: Venue not found
        `when`(eventRepo.findById(eventId)).thenReturn(Optional.of(EventModel().apply { hosts = setOf(userModel) }))
        `when`(venueRepo.findByVenueId(UUID.randomUUID())).thenReturn(null)
        val venueNotFoundResponse = eventServiceWithMocks.updateEvent(eventId, UpdateEventDto(location = UUID.randomUUID()))
        assertEquals("error", venueNotFoundResponse.body?.status)
        assertEquals("Venue not found", (venueNotFoundResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 4: Venue not available
        var randomUUID = UUID.randomUUID()
        var updateEventDto = UpdateEventDto(location = randomUUID)

        `when`(venueRepo.findByVenueId(updateEventDto.location)).thenReturn(VenueModel().apply { available = false })
        val venueNotAvailableResponse = eventServiceWithMocks.updateEvent(eventId, updateEventDto)
        assertEquals("error", venueNotAvailableResponse.body?.status)
        assertEquals("Venue not available", (venueNotAvailableResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 5: Max participants less than 1
        updateEventDto = UpdateEventDto(location = randomUUID, maxParticipants = 0)

        `when`(venueRepo.findByVenueId(updateEventDto.location)).thenReturn(VenueModel().apply { this.available = true})
        val maxParticipantsLessThanOneResponse = eventServiceWithMocks.updateEvent(eventId, updateEventDto)
        assertEquals("error", maxParticipantsLessThanOneResponse.body?.status)
        assertEquals("Max participants must be greater than 0", (maxParticipantsLessThanOneResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 6: Max participants greater than venue capacity
        updateEventDto = UpdateEventDto(location = randomUUID, maxParticipants = 200)
        `when`(venueRepo.findByVenueId(updateEventDto.location)).thenReturn(VenueModel().apply { available = true; capacity = 100 })
        val maxParticipantsGreaterThanCapacityResponse = eventServiceWithMocks.updateEvent(eventId, updateEventDto)
        assertEquals("error", maxParticipantsGreaterThanCapacityResponse.body?.status)
        assertEquals("Max participants must be less than venue capacity", (maxParticipantsGreaterThanCapacityResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 7: Successful event update
        val existingEvent = EventModel().apply {
            this.eventId = eventId
            title = "Old Title"
            description = "Old Description"
            hosts = setOf(userModel)
            venue = VenueModel()
        }
        `when`(eventRepo.findById(eventId)).thenReturn(Optional.of(existingEvent))
        `when`(eventRepo.save(existingEvent)).thenReturn(existingEvent)

        updateEventDto = UpdateEventDto(
            title = "New Title",
            description = "New Description",
            location = UUID.randomUUID(),
            maxParticipants = 50
        )
        `when`(venueRepo.findByVenueId(updateEventDto.location!!)).thenReturn(VenueModel().apply { available = true; capacity = 100 })

        val successfulUpdateResponse = eventServiceWithMocks.updateEvent(eventId, updateEventDto)
        assertEquals("success", successfulUpdateResponse.body?.status)
        val updatedEvent = successfulUpdateResponse.body?.data as? EventModel
        assertEquals("New Title", updatedEvent?.title)
        assertEquals("New Description", updatedEvent?.description)
        assertEquals(50, updatedEvent?.maxAttendees)
    }

    @Test
    fun `Test deleteEvent`() {
        val eventId = UUID.randomUUID()

        // Test case 1: Event not found
        `when`(eventRepo.findById(eventId)).thenReturn(Optional.empty())
        val eventNotFoundResponse = eventServiceWithMocks.deleteEvent(eventId)
        assertEquals("error", eventNotFoundResponse.body?.status)
        assertEquals("Event not found", (eventNotFoundResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 2: User not authorized to delete event
        setUp("GENERAL")
        val customUser = SecurityContextHolder.getContext().authentication.principal as CustomUser
        val userModel = customUser.userModel

        `when`(eventRepo.findById(eventId)).thenReturn(Optional.of(EventModel().apply { hosts = setOf() }))
        val unauthorizedResponse = eventServiceWithMocks.deleteEvent(eventId)
        assertEquals("error", unauthorizedResponse.body?.status)
        assertEquals("You are not authorized to delete this event", (unauthorizedResponse.body?.data as? Map<String, String>)?.get("message"))

        // Test case 3: Successful event deletion by host
        val existingEvent = EventModel().apply {
            this.eventId = eventId
            this.hosts = setOf(userModel)
        }
        `when`(eventRepo.findById(eventId)).thenReturn(Optional.of(existingEvent))

        val successfulDeletionResponse = eventServiceWithMocks.deleteEvent(eventId)
        assertEquals("success", successfulDeletionResponse.body?.status)
        assertEquals("Event deleted successfully", (successfulDeletionResponse.body?.data as? Map<String, String>)?.get("message"))
        verify(eventRepo, times(1)).deleteEvent(eventId)

        // Test case 4: Successful event deletion by admin
        setUp()
        `when`(eventRepo.findById(eventId)).thenReturn(Optional.of(existingEvent))
        val adminDeletionResponse = eventServiceWithMocks.deleteEvent(eventId)
        assertEquals("success", adminDeletionResponse.body?.status)
        assertEquals("Event deleted successfully", (adminDeletionResponse.body?.data as? Map<String, String>)?.get("message"))
        verify(eventRepo, times(1)).deleteEvent(eventId) // Total calls to deleteEvent should be 2 now
    }

    @Test
    fun `Test searchEvents`() {
        val searchString = "Event"

        // Test case 1: Search events for anonymous user
        SecurityContextHolder.setContext(SecurityContextImpl().apply {
            authentication = UsernamePasswordAuthenticationToken("anonymousUser", null, emptyList())
        })

        val availableSlotsModel = AvailableSlotsModel().apply {
            eventId = UUID.randomUUID()
            availableSlots = 10
        }

        val anonymousEvents = listOf(
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 1"
                description = "Description 1"
                metadata = "Metadata 1"
                eventMedia = listOf("media1.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(UserModel())
                attendees = setOf(UserModel()) as MutableSet<UserModel>
                invitees = setOf(UserModel()) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            },
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 2"
                description = "Description 2"
                metadata = "Metadata 2"
                eventMedia = listOf("media2.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(UserModel())
                attendees = setOf(UserModel()) as MutableSet<UserModel>
                invitees = setOf(UserModel()) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            }
        )
        `when`(eventRepo.searchEvents(searchString, null)).thenReturn(anonymousEvents)

        val anonymousResponse = eventServiceWithMocks.searchEvents(searchString)

        assertEquals("success", anonymousResponse.body?.status)
        assertEquals(2, (anonymousResponse.body?.data as? List<EventDto>)?.size)

        // Test case 2: Search events for authenticated user
        setUp()
        val customUser = SecurityContextHolder.getContext().authentication.principal as CustomUser
        val userModel = customUser.userModel
        val userEvents = listOf(
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 1"
                description = "Description 1"
                metadata = "Metadata 1"
                eventMedia = listOf("media1.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(userModel)
                attendees = setOf(userModel) as MutableSet<UserModel>
                invitees = setOf(userModel) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            },
            EventModel().apply {
                eventId = UUID.randomUUID()
                title = "Event 2"
                description = "Description 2"
                metadata = "Metadata 2"
                eventMedia = listOf("media2.jpg")
                venue = VenueModel()
                startDateTime = LocalDateTime.now()
                endDateTime = LocalDateTime.now().plusHours(2)
                maxAttendees = 100
                isPrivate = false
                hosts = setOf(UserModel())
                attendees = setOf(UserModel()) as MutableSet<UserModel>
                invitees = setOf(UserModel()) as MutableSet<UserModel>
                availableSlots = availableSlotsModel
            }
        )

        `when`(eventRepo.searchEvents(searchString, userModel.userId)).thenReturn(userEvents)

        val userResponse = eventServiceWithMocks.searchEvents(searchString)

        assertEquals("success", userResponse.body?.status)
        val eventsDto = userResponse.body?.data as? List<EventDto>
        assertEquals(2, eventsDto?.size)
        assertEquals(true, eventsDto?.get(0)?.isHost)
        assertEquals(false, eventsDto?.get(1)?.isHost)
    }

    @Test
    fun `Test getLocations with no locations`() {
        // Test case: No locations found
        val locations = emptyList<VenueModel>()

        `when`(venueRepo.findAll()).thenReturn(locations)

        val response = eventServiceWithMocks.getLocations()

        assertEquals("success", response.body?.status)
        val responseData = response.body?.data as? List<VenueModel>
        assertEquals(0, responseData?.size)
    }


}


