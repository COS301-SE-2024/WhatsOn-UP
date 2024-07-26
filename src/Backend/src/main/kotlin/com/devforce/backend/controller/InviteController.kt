package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.service.InviteService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/invite")
class InviteController {
    @Autowired
    lateinit var inviteService: InviteService

    @PutMapping("/send")
    @PreAuthorize("isAuthenticated()")
    fun inviteUser(@RequestParam eventId: UUID, @RequestParam userId: UUID): ResponseEntity<ResponseDto> {
        return inviteService.inviteUser(eventId, userId)
    }

    @PostMapping("/accept/{id}")
    @PreAuthorize("isAuthenticated()")
    fun acceptInvite(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return inviteService.acceptInvite(id)
    }
}