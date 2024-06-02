package com.devforce.backend.controllers

import com.devforce.backend.repos.EventRepo
import com.devforce.backend.repos.UserRepo
import com.fasterxml.jackson.databind.ObjectMapper
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status


@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {

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


    @Test
    fun registerUser200() {
        println("Testing register user 200")
        val requestObject = mapOf("email" to "test1@example.com", "password" to "password", "name" to "test1")
        mockMvc.perform(
            post("/register")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 200

    }

    @Test
    fun registerUser400() {
        println("Testing register user 400")
        var requestObject = mapOf("password" to "password", "name" to "test1")
        mockMvc.perform(
            post("/register")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400

        requestObject = mapOf("password" to "password", "email" to "test1@example.com")
        mockMvc.perform(
            post("/register")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400

        requestObject = mapOf("name" to "test1", "email" to "test1@example.com")
        mockMvc.perform(
            post("/register")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400

    }

    @Test
    fun loginUser200() {
        println("Testing login user 200")
        val requestObject = mapOf("email" to "test1@example.com", "password" to "password")

        mockMvc.perform(
            post("/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 200
    }

    @Test
    fun loginUser400() {
        println("Testing login user 400")
        var requestObject = mapOf("password" to "password")

        mockMvc.perform(
            post("/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400


        requestObject = mapOf("email" to "test1@example.com")

        mockMvc.perform(
            post("/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400


        requestObject = mapOf("email" to "test2@example.com", "password" to "pass")

        mockMvc.perform(
            post("/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400

        requestObject = mapOf("email" to "test1@example.com", "password" to "pass")

        mockMvc.perform(
            post("/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestObject))
        )
            .andExpect(status().isOk) // Assert that the response status is 400
    }



}