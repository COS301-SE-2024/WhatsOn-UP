package com.devforce.backend.controller

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.*
import com.devforce.backend.repo.*
import com.devforce.backend.security.CustomUser
import com.devforce.backend.service.UserService
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import io.github.cdimascio.dotenv.Dotenv
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.fail
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
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
class UserControllerIntegrationTest {

    @Autowired
    private lateinit var statusRepo: StatusRepo

    @Autowired
    private lateinit var hostApplicationsRepo: HostApplicationsRepo

    @Autowired
    private lateinit var userService: UserService
    private final val baseUri = "http://localhost:8080/api/user"

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
            availableSlots = 10
            isPrivate = true
            venue = location
            hosts = mutableSetOf(UserModel().apply { userId = UUID.fromString("1a927c22-ef44-40d6-b8fd-a6ed695d22b8") })
            metadata = mapOf("category" to "Tech").toString()

        }

        eventRepo.save(event)

    }

    @Test
    fun `Test saving events functions`(){
        val eventId = UUID.randomUUID()
        setup(eventId)
        var response = mockMvc.perform(put("$baseUri/save_event/$eventId")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val event = eventRepository.findById(eventId).orElse(null)

        assertNotNull(event)

        response = mockMvc.perform(get("$baseUri/get_saved_events")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val content = response.andReturn().response.contentAsString

        val responseDto = objectMapper.readValue<ResponseDto>(content)
        assertEquals("success", responseDto.status)
        assertNotNull(responseDto.data)
        val events = responseDto.data as List<EventDto>
        assert(events.isNotEmpty())

        response = mockMvc.perform(
            delete("$baseUri/delete_saved_event/$eventId")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val event2 = eventRepository.findById(eventId).orElse(null)

        assertNotNull(event2)

    }

    @Test
    fun `Test rsvp events functions`(){
        val eventId = UUID.randomUUID()
        setup(eventId)
        var response = mockMvc.perform(put("$baseUri/rsvp_event/$eventId")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val event = eventRepository.findById(eventId).orElse(null)

        assertNotNull(event)

        response = mockMvc.perform(get("$baseUri/get_rsvp_events")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val content = response.andReturn().response.contentAsString

        val responseDto = objectMapper.readValue<ResponseDto>(content)
        assertEquals("success", responseDto.status)
        assertNotNull(responseDto.data)
        val events = responseDto.data as List<EventDto>
        assert(events.isNotEmpty())

        response = mockMvc.perform(
            delete("$baseUri/delete_rsvp_event/$eventId")
                .header(HttpHeaders.AUTHORIZATION, bearerToken)
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val event2 = eventRepository.findById(eventId).orElse(null)

        assertNotNull(event2)

    }

    @Test
    fun `Test update profile`(){
        var response = mockMvc.perform(put("$baseUri/update_profile")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .param("fullName", "John Doe")
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)
        val content = response.andReturn().response.contentAsString

        var responseDto = objectMapper.readValue<ResponseDto>(content)
        assertEquals("success", responseDto.status)
        assertNotNull(responseDto.data)
        var data = responseDto.data as Map<String, String>
        var user = data["user"] as Map<String, String>
        assertEquals("John Doe", user["fullName"])

        response = mockMvc.perform(get("$baseUri/get_user")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)

        val content2 = response.andReturn().response.contentAsString

        responseDto = objectMapper.readValue<ResponseDto>(content2)

        assertEquals("success", responseDto.status)

        assertNotNull(responseDto.data)

        data = responseDto.data as Map<String, String>

        user = data["user"] as Map<String, String>
        assertEquals("John Doe", user["fullName"])


    }

    fun setUp(roleName: String) {
        MockitoAnnotations.openMocks(this)

        val userid = UUID.randomUUID()
        val user = UserModel().apply {
            userId= userid
            role = RoleModel().apply { name = roleName }
        }
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(userid, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `apply for host`() {
        setUp("GENERAL")

        // Apply for host and check response
        val response = userService.applyForHost(10, "I am a student", "u2345667@tuks.co.za", "2024-09-22T09:00:00")

        // Assert the applyForHost response
        assertEquals("success", response.body?.status)
        assertNotNull(response.body?.data)

        val data = response.body?.data as Map<String, String>
        assertEquals("Application submitted successfully. Check your email for verification link", data["message"])

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
