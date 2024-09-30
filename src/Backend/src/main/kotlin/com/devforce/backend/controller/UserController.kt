package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/user")
class UserController {
    @Autowired
    lateinit var userService: UserService

    @PutMapping("/save_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun saveEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return userService.saveEvent(id)
    }

    @DeleteMapping("/delete_saved_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteSavedEvent(@PathVariable id: UUID, ): ResponseEntity<ResponseDto> {
        
        return userService.deleteSavedEvent(id)
    }

    @GetMapping("/get_saved_events")
    @PreAuthorize("isAuthenticated()")
    fun getSavedEvents(): ResponseEntity<ResponseDto> {
        
        return userService.getSavedEvents()
    }


    @PutMapping("rsvp_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rsvpEvent(@PathVariable id: UUID,): ResponseEntity<ResponseDto> {
        
        return userService.rsvpEvent(id)
    }

    @GetMapping("/get_rsvp_events")
    @PreAuthorize("isAuthenticated()")
    fun getRsvpEvents(): ResponseEntity<ResponseDto> {
        
        return userService.getRsvpEvents()
    }

    @DeleteMapping("/delete_rsvp_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteRsvpEvent(@PathVariable id: UUID, ): ResponseEntity<ResponseDto> {
        
        return userService.deleteRsvpEvent(id)
    }

    @PutMapping("/update_profile")
    @PreAuthorize("isAuthenticated()")
    fun updateProfile(@RequestParam fullName: String): ResponseEntity<ResponseDto> {
        
        return userService.updateProfile(fullName)
    }

    @GetMapping("/get_user")
    @PreAuthorize("isAuthenticated()")
    fun getUser(): ResponseEntity<ResponseDto> {
        return userService.getUser()
    }

    @PutMapping("/apply_for_host")
    @PreAuthorize("isAuthenticated()")
    fun applyHost(
        @RequestParam howLong: Int,
        @RequestParam reason: String,
        @RequestParam studentEmail: String?,
        @RequestParam fromWhen: String,
    ): ResponseEntity<ResponseDto> {
        return userService.applyForHost(howLong, reason, studentEmail, fromWhen)
    }

    @PostMapping("/acknowledge_application")
    @PreAuthorize("isAuthenticated()")
    fun acknowledgeApplication(): ResponseEntity<ResponseDto> {
        return userService.acknowledgeApplication()
    }

//    @PostMapping("/dispute_application")
//    @PreAuthorize("isAuthenticated()")
//    fun disputeApplication(): ResponseEntity<ResponseDto> {
//        return userService.disputeApplication()
//    }

    @GetMapping("/verify_application")
    @PreAuthorize("permitAll()")
    fun verifyApplication(@RequestParam veriCode: UUID): ResponseEntity<String> {
        return userService.verifyApplication(veriCode)
    }

    @PutMapping("/rate_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rateEvent(@PathVariable id: UUID, @RequestParam rating: Int, @RequestParam comment: String?): ResponseEntity<ResponseDto> {
        return userService.rateEvent(id, rating, comment)
    }

}