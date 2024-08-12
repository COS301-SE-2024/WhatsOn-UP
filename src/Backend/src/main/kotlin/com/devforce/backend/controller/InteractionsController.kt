package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.service.InteractionsService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/interactions")
class InteractionsController {

    @Autowired
    lateinit var interactionsService: InteractionsService


    @GetMapping("/get_all_users")
    @PreAuthorize("isAuthenticated()")
    fun getAllUsers(): ResponseEntity<ResponseDto> {
        return interactionsService.getAllUsers()
    }

    @PutMapping("/send_invite")
    @PreAuthorize("isAuthenticated()")
    fun inviteUser(@RequestParam eventId: UUID, @RequestParam userId: UUID): ResponseEntity<ResponseDto> {
        return interactionsService.inviteUser(eventId, userId)
    }

    @PostMapping("/accept_invite/{id}")
    @PreAuthorize("isAuthenticated()")
    fun acceptInvite(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return interactionsService.acceptInvite(id)
    }

    @PostMapping("/reject_invite/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rejectInvite(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return interactionsService.rejectInvite(id)
    }

}