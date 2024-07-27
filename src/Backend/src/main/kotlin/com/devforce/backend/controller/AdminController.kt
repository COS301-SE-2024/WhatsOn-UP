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

    @DeleteMapping("/delete_user")
    fun deleteUser(@RequestParam userId: UUID): ResponseEntity<ResponseDto> {
        return adminService.deleteUser(userId)
    }


}