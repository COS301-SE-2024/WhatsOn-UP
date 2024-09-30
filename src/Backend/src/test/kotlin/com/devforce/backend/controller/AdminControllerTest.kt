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
class AdminControllerIntegrationTest {

    @Autowired
    private lateinit var statusRepo: StatusRepo

    @Autowired
    private lateinit var hostApplicationsRepo: HostApplicationsRepo

    @Autowired
    private lateinit var userService: UserService
    private final val baseUri = "http://localhost:8080/api/admin"

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
            isPrivate = true
            venue = location
            hosts = mutableSetOf(UserModel().apply { userId = UUID.fromString("1a927c22-ef44-40d6-b8fd-a6ed695d22b8") })
            metadata = mapOf("category" to "Tech").toString()

        }

        eventRepo.save(event)

    }

    @Test
    fun `test accept or reject application`(){
        var response = mockMvc.perform(post("$baseUri/accept_application")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .param("applicationId", "eca82eaf-fe48-4016-bc87-c24587be7081")
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isBadRequest)

        var responseDto: ResponseDto = objectMapper.readValue(response.andReturn().response.contentAsString)

        assertEquals("error", responseDto.status)

        response = mockMvc.perform(post("$baseUri/reject_application")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .param("applicationId", "eca82eaf-fe48-4016-bc87-c24587be7081")
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))


        response.andExpect(MockMvcResultMatchers.status().isBadRequest)

        responseDto = objectMapper.readValue(response.andReturn().response.contentAsString)

        assertEquals("error", responseDto.status)
    }

    @Test
    fun `test get applications`(){
        var response = mockMvc.perform(get("$baseUri/all_applications")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))
        
        response.andExpect(MockMvcResultMatchers.status().isOk)

        var responseDto: ResponseDto = objectMapper.readValue(response.andReturn().response.contentAsString)

        assertEquals("success", responseDto.status)

        val status = "PENDING"

        response = mockMvc.perform(get("$baseUri/all_applications/$status")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)

        responseDto = objectMapper.readValue(response.andReturn().response.contentAsString)

        assertEquals("success", responseDto.status)



    }

    @Test
    fun `test broadcast message`(){
        val message = "Hello World"
        val response = mockMvc.perform(put("$baseUri/broadcast")
            .header(HttpHeaders.AUTHORIZATION, bearerToken)
            .param("message", message)
            .contentType(MediaType.APPLICATION_JSON)
            .accept(MediaType.APPLICATION_JSON))

        response.andExpect(MockMvcResultMatchers.status().isOk)

        val responseDto: ResponseDto = objectMapper.readValue(response.andReturn().response.contentAsString)

        assertEquals("success", responseDto.status)
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
