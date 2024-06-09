package com.devforce.backend.controller

import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.UserRepo
import com.fasterxml.jackson.databind.ObjectMapper
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import java.util.*


@SpringBootTest
@AutoConfigureMockMvc
class EventControllerTest {

    @Autowired
    lateinit var mockMvc: MockMvc

    @Autowired
    lateinit var objectMapper: ObjectMapper

    @MockBean
    lateinit var userRepo: UserRepo

    @MockBean
    lateinit var userController: UserController

    @MockBean
    lateinit var eventController: EventController

    @MockBean
    lateinit var eventRepo: EventRepo

//
//    @Test
//    fun addEventSuccess() {
//        println("Testing add_event - success case")
//        val eventData = mapOf(
//            "name" to "Test Event",
//            "description" to "Description of test event",
//            "startTime" to "2024-06-30T10:00:00",
//            "endTime" to "2024-06-30T12:00:00",
//            "metadata" to "Some metadata",
//            "eventMedia" to listOf("image1.jpg", "image2.jpg"),
//            "hosts" to "Host1, Host2",
//            "location" to "Some location",
//            "maxAttendees" to "100",
//            "isPrivate" to "false"
//        )
//
//        mockMvc.perform(
//            post("/add_event")
//                .contentType(MediaType.APPLICATION_JSON)
//                .content(objectMapper.writeValueAsString(eventData))
//        )
//            .andExpect(status().isOk)
//    }

    @Test
    fun getEventsSuccess() {
        println("Testing get_events - success case")
        mockMvc.perform(get("/get_events"))
            .andExpect(status().isOk)
    }

    @Test
    fun deleteEventSuccess() {
        println("Testing delete_event - success case")
        val eventId = UUID.randomUUID().toString() // Random UUID

        mockMvc.perform(
            post("/delete_event")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(mapOf("eventId" to eventId)))
        )
            .andExpect(status().isOk)
    }
//
//    @Test
//    fun updateEventSuccess() {
//        println("Testing update_event - success case")
//        val eventId = UUID.randomUUID().toString() // Random UUID
//        val eventData = mapOf(
//            "eventId" to eventId,
//            "name" to "Updated Event Name",
//            "description" to "Updated description",
//            "startTime" to "2024-06-30T10:00:00",
//            "endTime" to "2024-06-30T12:00:00",
//            "metadata" to "Updated metadata",
//            "eventMedia" to listOf("updated_image1.jpg", "updated_image2.jpg"),
//            "hosts" to "Updated Host1, Host2",
//            "location" to "Updated location",
//            "maxAttendees" to "150",
//            "isPrivate" to "true"
//        )
//
//        mockMvc.perform(
//            post("/update_event")
//                .contentType(MediaType.APPLICATION_JSON)
//                .content(objectMapper.writeValueAsString(eventData))
//        ).andExpect(status().isOk)
//    }
}
