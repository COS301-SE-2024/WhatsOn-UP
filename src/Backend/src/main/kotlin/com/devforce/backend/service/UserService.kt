package com.devforce.backend.service

import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.HostApplicationsModel
import com.devforce.backend.model.Status
import com.devforce.backend.repo.*
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

    @Autowired
    lateinit var availableSlotsRepo: AvailableSlotsRepo

    @Autowired
    lateinit var hostApplicationsRepo: HostApplicationsRepo


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
        val eventsDto = events.map { event -> EventDto(event, false, null) }

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

        val availableSlots = availableSlotsRepo.findByEventId(id)

        if (availableSlots != null) {
            if (availableSlots.availableSlots <= 0) {
                return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event is full"))
            }
        }

        event.attendees.add(user)
        eventRepo.save(event)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event RSVP'd successfully")))
    }

    // To do: Implement function to get all RSVP'd events for the current user
    fun getRspvEvents(): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val events = eventRepo.getRspvdEvents(user.userId)
        val eventsDto = events.map { event -> EventDto(event, false, null) }

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
    fun updateProfile(fullName: String): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        user.fullName = fullName

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
            "profileImage" to user.profileImage,
            "userId" to user.userId
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

    fun applyForHost(howLong: Int?, proof: String): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val hostApplication = HostApplicationsModel().apply {
            this.user = user
            this.status = Status.PENDING
            if (howLong != null) {
                this.howLong = howLong
            }
            this.proof = proof
        }

        hostApplicationsRepo.save(hostApplication)

        return ResponseEntity.ok(
            ResponseDto("success", System.currentTimeMillis(), hostApplication)
        )
    }

    fun acknowledgeApplication(applicationId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val application = hostApplicationsRepo.findById(applicationId)
        if (application.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not found"))
        }
        val applicationModel = application.get()
        applicationModel.status = Status.ACKNOWLEDGED
        applicationModel.expiryDateTime = Date(System.currentTimeMillis() + applicationModel.howLong * 24 * 60 * 60 * 1000)
        hostApplicationsRepo.save(applicationModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Application acknowledged successfully"))
        )
    }

    fun disputeApplication(applicationId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val application = hostApplicationsRepo.findById(applicationId)
        if (application.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not found"))
        }
        val applicationModel = application.get()
        applicationModel.status = Status.DISPUTED
        hostApplicationsRepo.save(applicationModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Application disputed successfully"))
        )
    }


}
