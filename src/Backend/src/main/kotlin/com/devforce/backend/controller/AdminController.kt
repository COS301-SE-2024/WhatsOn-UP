package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.service.AdminService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasAnyRole('ADMIN')")
class AdminController {
    @Autowired
    lateinit var adminService: AdminService


    @PostMapping("/promote")
    fun inviteUser(@RequestParam userId: UUID): ResponseEntity<ResponseDto> {
        return adminService.promoteUser(userId)
    }

    @PostMapping("/demote")
    fun acceptInvite(@RequestParam userId: UUID): ResponseEntity<ResponseDto> {
        return adminService.demoteUser(userId)
    }


    @PostMapping("/accept_application")
    fun acceptApplication(@RequestParam applicationId: UUID): ResponseEntity<ResponseDto> {
        return adminService.acceptApplication(applicationId)
    }

    @PostMapping("/reject_application")
    fun rejectApplication(@RequestParam applicationId: UUID): ResponseEntity<ResponseDto> {
        return adminService.rejectApplication(applicationId)
    }

    @GetMapping("/all_applications")
    fun allApplications(): ResponseEntity<ResponseDto> {
        return adminService.getAllApplications(null)
    }

    @GetMapping("/all_applications/{status}")
    fun allApplications(@PathVariable status: String): ResponseEntity<ResponseDto> {
        // convert status to Status enum
        val validStatuses = listOf("PENDING", "ACCEPTED", "REJECTED", "ACKNOWLEDGED", "DISPUTED", "VERIFIED")

        if (!validStatuses.contains(status)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid status"))
        }

        return adminService.getAllApplications(status)
    }

    @PutMapping("/broadcast")
    fun broadcastMessage(@RequestParam message: String): ResponseEntity<ResponseDto> {
        return adminService.broadcastMessage(message)
    }



}