package com.devforce.backend.controller

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.*
import com.devforce.backend.repo.BuildingRepo
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.VenueRepo
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import org.springframework.transaction.annotation.Transactional
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap
import java.time.LocalDateTime
import java.time.temporal.ChronoUnit
import java.util.*

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class EventControllerIntegrationTest {

    private final val baseUri = "http://localhost:8080/api/events"

    @Autowired
    private lateinit var mockMvc: MockMvc

    @Autowired
    private lateinit var objectMapper: ObjectMapper

    @Autowired
    private lateinit var eventRepository: EventRepo

    @Autowired
    private lateinit var venueRepo: VenueRepo

    @Autowired
    private lateinit var buildingRepo: BuildingRepo

    @Autowired
    private lateinit var eventRepo: EventRepo


    @Value("\${BEARER_TOKEN}")
    private val bearerToken: String? = null


    @Test
    fun `test createEvent and verify database with all fields`() {
        val initialCount = eventRepository.count()
        val randomId = UUID.randomUUID()

        val location = venueRepo.save(
            VenueModel().apply {
                venueId = randomId
                name = "Building A"
                building = buildingRepo.findById(UUID.fromString("f708e351-9f39-4cb6-afba-b55f5a4d4eb1")).orElse(null)
                boards = "Green"
                ac = false
                wifi = false
                dataProject = 0
                docCam = false
                mic = false
                windows = false
                capacity = 100
                available = true
            }
        )


        val createEventDto = CreateEventDto(
            title = "Sample Event",
            description = "This is a sample event.",
            startDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS),
            endDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS).plus(2, ChronoUnit.HOURS),
            location = randomId,
            maxParticipants = 10,
            isPrivate = true,
            hosts = setOf(UUID.fromString("ab3535b8-109b-4b82-b515-2e87f2cc1d17")),
            metadata = mapOf("category" to "Tech")
        )


        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.post("$baseUri/create")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(createEventDto))
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDto: EventDto = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDto)
            assertEquals(createEventDto.title, eventDto.title)
            assertEquals(createEventDto.description, eventDto.description)
            assertEquals(createEventDto.startDateTime, eventDto.startDateTime)
            assertEquals(createEventDto.endDateTime, eventDto.endDateTime)
            assertEquals(createEventDto.location, eventDto.location?.venueId)
            assertEquals(createEventDto.maxParticipants?:0, eventDto.maxAttendees)
            assertEquals(createEventDto.isPrivate?:false, eventDto.isPrivate)
            for (host in createEventDto.hosts ?: emptySet()) {
                assertTrue(eventDto.hosts.any { it.userId == host })
            }
            assertEquals(createEventDto.metadata?:"{}", eventDto.metadata?.let { objectMapper.readValue(it) })
        } catch (e: Exception) {
            fail("Failed to parse response data")
        }

        // Verify that the event was saved in the database
        val updatedCount = eventRepository.count()
        assertEquals(initialCount + 1, updatedCount)

    }

    @Test
    fun `test createEvent and verify database`() {
        val initialCount = eventRepository.count()
        val randomId = UUID.randomUUID()

        val location = venueRepo.save(
            VenueModel().apply {
                venueId = randomId
                name = "Building A"
                building = buildingRepo.findById(UUID.fromString("f708e351-9f39-4cb6-afba-b55f5a4d4eb1")).orElse(null)
                boards = "Green"
                ac = false
                wifi = false
                dataProject = 0
                docCam = false
                mic = false
                windows = false
                capacity = 0
                available = true
            }
        )


        val createEventDto = CreateEventDto(
            title = "Sample Event 2",
            description = "This is a sample event.",
            startDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS),
            endDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS).plus(2, ChronoUnit.HOURS),
            location = randomId,
            maxParticipants = null,
            isPrivate = null,
            hosts = null,
            metadata = null
        )

        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.post("$baseUri/create")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(createEventDto))
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDto: EventDto = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDto)
            assertEquals(createEventDto.title, eventDto.title)
            assertEquals(createEventDto.description, eventDto.description)
            assertEquals(createEventDto.startDateTime, eventDto.startDateTime)
            assertEquals(createEventDto.endDateTime, eventDto.endDateTime)
            assertEquals(createEventDto.location, eventDto.location?.venueId)
            assertEquals(createEventDto.maxParticipants?:0, eventDto.maxAttendees)
            assertEquals(createEventDto.isPrivate?:false, eventDto.isPrivate)
            for (host in createEventDto.hosts ?: emptySet()) {
                assertTrue(eventDto.hosts.any { it.userId == host })
            }
            assertEquals(createEventDto.metadata?:"{}", eventDto.metadata)
        } catch (e: Exception) {
            fail("Failed to parse response data")
        }

        // Verify that the event was saved in the database
        val updatedCount = eventRepository.count()
        assertEquals(initialCount + 1, updatedCount)

    }

    fun setup(id: UUID? = UUID.randomUUID()) {
        val location = VenueModel().apply {
            venueId = UUID.randomUUID()
            name = "Building A"
            building = buildingRepo.findById(UUID.fromString("f708e351-9f39-4cb6-afba-b55f5a4d4eb1")).orElse(null)
            boards = "Green"
            ac = false
            wifi = false
            dataProject = 0
            docCam = false
            mic = false
            windows = false
            capacity = 100
            available = true
        }
        venueRepo.save(location)
        val event = EventModel().apply {
            eventId = id
            title = "Sample Event"
            description = "This is a sample event."
            startDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS)
            endDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS).plus(2, ChronoUnit.HOURS)
            maxAttendees = 10
            isPrivate = true
            venue = location
            hosts = mutableSetOf(UserModel().apply { userId = UUID.fromString("69ae72bc-8e2b-4400-b608-29f048d4f8c7") })
            metadata = mapOf("category" to "Tech").toString()

        }

        eventRepo.save(event)

    }

    @Test
    fun `test search as host`(){
        setup()
        val params: MultiValueMap<String, String> = LinkedMultiValueMap<String, String>().apply {
            add("searchString", "Sample Event")
        }

        // Perform the POST request with query parameters
        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.get("$baseUri/search")
                .contentType(MediaType.APPLICATION_JSON)
                .params(params)
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDtos: List<EventDto> = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDtos)
            assertEquals(1, eventDtos.size)
            for (eventDto in eventDtos) {
                assertEquals("Sample Event", eventDto.title)
                assertEquals(true, eventDto.isHost)
            }

        } catch (e: Exception) {
            fail("Failed to parse response data")
        }


    }

    @Test
    fun `test search`(){
        setup()
        val params: MultiValueMap<String, String> = LinkedMultiValueMap<String, String>().apply {
            add("searchString", "Sample Event")
        }

        // Perform the POST request with query parameters
        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.get("$baseUri/search")
                .contentType(MediaType.APPLICATION_JSON)
                .params(params)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDtos: List<EventDto> = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDtos)
            assertEquals(1, eventDtos.size)
            for (eventDto in eventDtos) {
                assertEquals("Sample Event", eventDto.title)
                assertEquals(false, eventDto.isHost)
            }

        } catch (e: Exception) {
            fail("Failed to parse response data")
        }


    }

    @Test
    fun `test get all events as host`(){
        // Perform the POST request with query parameters
        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.get("$baseUri/get_all")
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDtos: List<EventDto> = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDtos)
            assertEquals(eventDtos.isNotEmpty(), true)

        } catch (e: Exception) {
            fail("Failed to parse response data")
        }

    }

    @Test
    fun `test get all events`(){
        // Perform the POST request with query parameters
        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.get("$baseUri/get_all")
                .contentType(MediaType.APPLICATION_JSON)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDtos: List<EventDto> = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDtos)
            assertEquals(eventDtos.isNotEmpty(), true)

        } catch (e: Exception) {
            fail("Failed to parse response data")
        }


    }

    @Test
    fun `test updateEvent and verify database with all fields`() {
        val randomId = UUID.randomUUID()
        setup(randomId)
        val location = venueRepo.save(
            VenueModel().apply {
                venueId = randomId
                name = "Building A"
                building = buildingRepo.findById(UUID.fromString("f708e351-9f39-4cb6-afba-b55f5a4d4eb1")).orElse(null)
                boards = "Green"
                ac = false
                wifi = false
                dataProject = 0
                docCam = false
                mic = false
                windows = false
                capacity = 100
                available = true
            }
        )


        val updateEventDto = UpdateEventDto(
            title = "Lilo Event",
            description = "Lilo is a sample event.",
            startDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS),
            endDateTime = LocalDateTime.now().plus(10, ChronoUnit.DAYS).plus(2, ChronoUnit.HOURS),
            location = randomId,
            maxParticipants = 10,
            isPrivate = true,
            hosts = setOf(UUID.fromString("ab3535b8-109b-4b82-b515-2e87f2cc1d17")),
            metadata = mapOf("category" to "Tech")
        )

        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.put("$baseUri/update/${randomId}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateEventDto))
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDto: EventDto = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDto)
            assertEquals(updateEventDto.title, eventDto.title)
            assertEquals(updateEventDto.description, eventDto.description)
            assertEquals(updateEventDto.startDateTime, eventDto.startDateTime)
            assertEquals(updateEventDto.endDateTime, eventDto.endDateTime)
            assertEquals(updateEventDto.location, eventDto.location?.venueId)
            assertEquals(updateEventDto.maxParticipants?:0, eventDto.maxAttendees)
            assertEquals(updateEventDto.isPrivate?:false, eventDto.isPrivate)
            for (host in updateEventDto.hosts ?: emptySet()) {
                assertTrue(eventDto.hosts.any { it.userId == host })
            }

//            assertEquals(updateEventDto.metadata?:"{}", eventDto.metadata?.let { objectMapper.readValue(it) })


        } catch (e: Exception) {
            fail("Failed to parse response data")
        }

        val event = eventRepo.findById(randomId).orElse(null)
        assertNotNull(event)

        assertEquals(updateEventDto.title, event.title)
        assertEquals(updateEventDto.description, event.description)
        assertEquals(updateEventDto.startDateTime, event.startDateTime)
        assertEquals(updateEventDto.endDateTime, event.endDateTime)
        assertEquals(updateEventDto.location, event.venue?.venueId)
        assertEquals(updateEventDto.maxParticipants?:0, event.maxAttendees)
        assertEquals(updateEventDto.isPrivate?:false, event.isPrivate)
        for (host in updateEventDto.hosts ?: emptySet()) {
            assertTrue(event.hosts.any { it.userId == host })
        }
//        assertEquals(updateEventDto.metadata?:"{}", event.metadata)




    }

    @Test
    fun `test upadateEvent and verify database`() {
        val randomId = UUID.randomUUID()
        setup(randomId)

        val event = eventRepo.findById(randomId).orElse(null)
        assertNotNull(event)


        val updateEventDto = UpdateEventDto(
            title = null,
            description = null,
            startDateTime = null,
            endDateTime = null,
            location = null,
            maxParticipants = null,
            isPrivate = null,
            hosts = null,
            metadata = null
        )


        val resultActions = mockMvc.perform(
            MockMvcRequestBuilders.put("$baseUri/update/${randomId}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateEventDto))
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)

        // Extract the response content and perform custom assertions
        val responseString = resultActions.andReturn().response.contentAsString
        val responseDto: ResponseDto = objectMapper.readValue(responseString)

        // Perform your custom assertions
        assertEquals("success", responseDto.status)
        try {
            val eventDto: EventDto = objectMapper.readValue(objectMapper.writeValueAsString(responseDto.data))
            assertNotNull(eventDto)
            assertEquals(event.title, eventDto.title)
            assertEquals(event.description, eventDto.description)
            assertEquals(event.startDateTime, eventDto.startDateTime)
            assertEquals(event.endDateTime, eventDto.endDateTime)
            assertEquals(event.venue?.venueId, eventDto.location?.venueId)
            assertEquals(event.maxAttendees, eventDto.maxAttendees)
            assertEquals(event.isPrivate, eventDto.isPrivate)
            for (host in event.hosts ?: emptySet()) {
                assertTrue(eventDto.hosts.any { it.userId == host.userId })
            }
            assertEquals(event.metadata, eventDto.metadata)

//            assertEquals(event.metadata?:"{}", eventDto.metadata?.let { objectMapper.readValue(it) })

        } catch (e: Exception) {
            fail("Failed to parse response data")
        }

        val event2 = eventRepo.findById(randomId).orElse(null)
        assertNotNull(event2)

        assertEquals(event.title, event2.title)
        assertEquals(event.description, event2.description)
        assertEquals(event.startDateTime, event2.startDateTime)
        assertEquals(event.endDateTime, event2.endDateTime)
        assertEquals(event.venue?.venueId, event2.venue?.venueId)
        assertEquals(event.maxAttendees, event2.maxAttendees)
        assertEquals(event.isPrivate, event2.isPrivate)
        for (host in event.hosts ?: emptySet()) {
            assertTrue(event2.hosts.any { it.userId == host.userId })
        }
        assertEquals(event.metadata, event2.metadata)

    }

    companion object {
        @JvmStatic
        @BeforeAll
        fun setUp(): Unit {
            val dotenv: Dotenv = Dotenv.load()

            System.setProperty("DB_USERNAME", dotenv.get("DB_USERNAME"))
            System.setProperty("MAIL_PASSWORD", dotenv.get("MAIL_PASSWORD"))
            System.setProperty("MAIL_USERNAME", dotenv.get("MAIL_USERNAME"))
            System.setProperty("SECRET", dotenv.get("SECRET"))

            System.setProperty("CORS_ORIGINS", dotenv.get("CORS_ORIGINS"))
            System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"))
            System.setProperty("DB_URL", dotenv.get("DB_URL"))
            System.setProperty("BEARER_TOKEN", dotenv.get("BEARER_TOKEN"))
        }
    }

}
