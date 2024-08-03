package com.devforce.backend.service

import com.devforce.backend.dto.EventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.ApplicationStatusModel
import com.devforce.backend.model.HostApplicationsModel
import com.devforce.backend.repo.*
import com.devforce.backend.security.CustomUser
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.mail.MailSender
import org.springframework.mail.SimpleMailMessage
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*

@Service
class UserService {

    @Autowired
    private lateinit var roleRepo: RoleRepo

    @Autowired
    lateinit var userRepo: UserRepo
    

    @Autowired
    lateinit var eventRepo: EventRepo

    @Autowired
    lateinit var availableSlotsRepo: AvailableSlotsRepo

    @Autowired
    lateinit var hostApplicationsRepo: HostApplicationsRepo

    @Autowired
    lateinit var statusRepo: StatusRepo


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

    @Autowired
    lateinit var mailSender: MailSender

    fun applyForHost(howLong: Int, reason: String, studentEmail: String, fromWhen: String): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
        val fromWhenDate = try {
            fromWhen.let { LocalDateTime.parse(it, formatter) }
        } catch (e: Exception) {
            null
        }

        val expiryDateTime = howLong.toLong().let { fromWhenDate?.plusDays(it) }

        // Check if user is already a host
        if (user.role?.name == "HOST" || user.role?.name == "ADMIN") {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User is already a host"))
        }

        // Check if user has already applied
        val existingApplication = hostApplicationsRepo.findByUserId(user.userId)
        if (existingApplication.isNotEmpty()) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User has already applied"))
        }

        // Check if student email is valid
        if (!studentEmail.endsWith("@up.ac.za") && !studentEmail.endsWith("@tuks.co.za")) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid student email"))
        }

        if (reason.isBlank()) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Reason cannot be blank"))
        }

        val veriCode = UUID.randomUUID()

        val statusModel = statusRepo.findByName("PENDING")

        val hostApplication = HostApplicationsModel().apply {
            this.user = user
            this.expiryDateTime = expiryDateTime
            this.reason = reason
            this.verificationCode = veriCode
            this.status = statusModel
        }

        hostApplicationsRepo.save(hostApplication)

        val origin = "http://localhost:8080/api/user/verify_application?veriCode=$veriCode"

        val email = SimpleMailMessage().apply {
            setTo(studentEmail)
            setSubject("Host Application Verification")
            setText("Click the link below to verify your application: $origin")
        }

        mailSender.send(email)

        return ResponseEntity.ok(
            ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Application submitted successfully. Check your email for verification link"))
        )
    }

    fun verifyApplication(veriCode: UUID): ResponseEntity<String> {
        val application = hostApplicationsRepo.findByVerificationCode(veriCode)
            ?: return ResponseEntity.badRequest().body("Invalid verification code")

        val statusModel = statusRepo.findByName("VERIFIED")

        application.status = statusModel
        application.verificationCode = null
        hostApplicationsRepo.save(application)

        return ResponseEntity.ok("Application verified successfully")
    }

    fun acknowledgeApplication(applicationId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val application = hostApplicationsRepo.findById(applicationId)
        if (application.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not found"))
        }
        val applicationModel = application.get()
        if (applicationModel.status!!.name != "ACCEPTED") {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not accepted"))
        }

        if (applicationModel.expiryDateTime!!.isBefore(LocalDateTime.now())) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application expired"))
        }
        
        user.role = roleRepo.findByName("HOST")
        userRepo.save(user)


        applicationModel.status = statusRepo.findByName("ACKNOWLEDGED")
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
        if (applicationModel.status!!.name != "REJECTED") {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not rejected"))
        }
        applicationModel.status = statusRepo.findByName("DISPUTED")
        hostApplicationsRepo.save(applicationModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Application disputed successfully"))
        )
    }


}
