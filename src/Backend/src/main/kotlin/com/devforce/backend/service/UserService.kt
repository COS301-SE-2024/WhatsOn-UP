package com.devforce.backend.service

import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateUserDto
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.RoleRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import java.util.*

@Service
class UserService {

    @Autowired
    lateinit var userRepo: UserRepo
    

    @Autowired
    lateinit var eventRepo: EventRepo


    // To do: Implement function to save an event for the current user
    fun saveEvent(id: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val event = optionalEvent.get()
        if (event.savedEvents.any { it.userId == user.userId }) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event already saved"))
        }

        event.savedEvents.add(user)
        eventRepo.save(event)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event saved successfully")))

    }

    // To do: Implement function to delete a saved event for the current user
    fun deleteSavedEvent(id: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }


        val event = optionalEvent.get()
        val u = event.savedEvents.find { it.userId == user.userId }
        if (event.savedEvents.remove(u)){
            eventRepo.save(event)
            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event deleted successfully"))
            )
        }
        else {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }



    }

    // To do: Implement function to get all saved events for the current user
    fun getSavedEvents(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val events = eventRepo.getSavedEvents(user.userId)
        val eventsDto = events.map { event -> EventDto(event, false) }

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }
    

    // To do: Implement function to RSVP to an event for the current user
    fun rspvEvent(id: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val event = optionalEvent.get()

        if (event.attendees.any { it.userId == user.userId } || event.hosts.any { it.userId == user.userId }) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event already RSVP'd"))
        }


        event.attendees.add(user)
        eventRepo.save(event)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event RSVP'd successfully")))
    }

    // To do: Implement function to get all RSVP'd events for the current user
    fun getRspvEvents(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val events = eventRepo.getRspvdEvents(user.userId)
        val eventsDto = events.map { event -> EventDto(event, false) }

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

    // To do: Implement function to delete an RSVP'd event for the current user
    fun deleteRspvEvent(id: UUID
    ): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel
        val optionalEvent = eventRepo.findById(id)

        if (optionalEvent.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val event = optionalEvent.get()
        val u = event.attendees.find { it.userId == user.userId }
        if (event.attendees.remove(u)){
            eventRepo.save(event)
            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event deleted successfully"))
            )
        }
        else {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }
    }

    // To do: Implement function to update user profile
    fun updateProfile(updateUserDto: UpdateUserDto): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        user.fullName = updateUserDto.fullName ?: user.fullName
        user.profileImage = updateUserDto.profileImage ?: user.profileImage

        userRepo.save(user)

        val userDetails = mapOf(
            "role" to user.role?.name,
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

    fun getUser(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val userCreds = mapOf(
            "role" to user.role?.name,
            "fullName" to user.fullName,
            "profileImage" to user.profileImage
        )

        return ResponseEntity.ok(
            ResponseDto(
                "success",
                System.currentTimeMillis(),
                mapOf("user" to userCreds)
            )
        )
    }

    fun deleteUser(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel
        userRepo.delete(user)

        return ResponseEntity.ok(
            ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Account deleted successfully"))
        )
    }


}
