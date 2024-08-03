package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.Status
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

    @DeleteMapping("/delete_user")
    fun deleteUser(@RequestParam userId: UUID): ResponseEntity<ResponseDto> {
        return adminService.deleteUser(userId)
    }

    @GetMapping("/get_applications")
    fun getApplications(): ResponseEntity<ResponseDto> {
        return adminService.getApplications()
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
    fun allApplications(@PathVariable status: Status): ResponseEntity<ResponseDto> {
        return adminService.getAllApplications(status)
    }


}