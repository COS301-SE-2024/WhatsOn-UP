package com.devforce.backend.service

import com.devforce.backend.dto.AllEventsDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateUserDto
import com.devforce.backend.repo.jpa.EventRepo
import com.devforce.backend.repo.jpa.RoleRepo
import com.devforce.backend.repo.jpa.UserRepo
import com.devforce.backend.security.JwtGenerator
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import java.util.*

@Service
class UserService {

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var roleRepo: RoleRepo

    @Autowired
    lateinit var jwtGenerator: JwtGenerator

    @Autowired
    lateinit var passwordEncoder: PasswordEncoder

    @Autowired
    lateinit var checkJwt: CheckJwt

    @Autowired
    lateinit var eventRepo: EventRepo


    // To do: Implement function to save an event for the current user
    fun saveEvent(id: UUID, token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val event = optionalEvent.get()
        user.savedEvents.add(event)
        userRepo.save(user)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event saved successfully")))

    }

    // To do: Implement function to delete a saved event for the current user
    fun deleteSavedEvent(id: UUID, token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        user.savedEvents.remove(optionalEvent.get())
        userRepo.save(user)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event deleted successfully"))
        )
    }

    // To do: Implement function to get all saved events for the current user
    fun getSavedEvents(token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val events = user.savedEvents
        val eventsDto = events.map { event -> AllEventsDto(event) }

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

    // To do: Implement function to RSVP to an event for the current user
    fun rspvEvent(id: UUID, token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val event = optionalEvent.get()
        event.attendees.add(user)
        eventRepo.save(event)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event RSVP'd successfully")))
    }

    // To do: Implement function to get all RSVP'd events for the current user
    fun getRspvEvents(token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val events = eventRepo.findByAttendeesIs(user)
        val eventsDto = events.map { event -> AllEventsDto(event) }

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

    // To do: Implement function to delete an RSVP'd event for the current user
    fun deleteRspvEvent(id: UUID, token: String
    ): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val event = optionalEvent.get()
        event.attendees.remove(user)
        userRepo.save(user)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event deleted successfully"))
        )
    }

    // To do: Implement function to update user profile
    fun updateProfile(updateUserDto: UpdateUserDto, token: String): ResponseEntity<ResponseDto> {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }

        val email = jwtGenerator.getUsernameFromToken(token)

        val user = userRepo.findByEmail(email)!!

        user.fullName = updateUserDto.fullName ?: user.fullName
        user.email = updateUserDto.email ?: user.email
        user.profileImage = updateUserDto.profileImage ?: user.profileImage

        userRepo.save(user)

        val userDetails = mapOf(
            "email" to user.email,
            "role" to user.role?.name,
            "id" to user.userId,
            "fullName" to user.fullName,
            "profileImage" to user.profileImage
        )

        // Return a success response
        return ResponseEntity.ok(
            ResponseDto(
                "success",
                System.currentTimeMillis(),
                mapOf("user" to userDetails)
            )
        )
    }

}
