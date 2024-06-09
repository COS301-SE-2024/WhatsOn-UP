package com.devforce.backend.controllers

import com.devforce.backend.dtos.ResponseDto
import com.devforce.backend.dtos.UpdateUserDto
import com.devforce.backend.services.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/user")
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
    fun deleteSavedEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return userService.deleteSavedEvent(id)
    }

    @GetMapping("/get_saved_events")
    @PreAuthorize("isAuthenticated()")
    fun getSavedEvents(): ResponseEntity<ResponseDto> {
        return userService.getSavedEvents()
    }


    @PutMapping("rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rspvEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return userService.rspvEvent(id)
    }

    @GetMapping("/get_rspv_events")
    @PreAuthorize("isAuthenticated()")
    fun getRspvEvents(): ResponseEntity<ResponseDto> {
        return userService.getRspvEvents()
    }

    @DeleteMapping("/delete_rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteRspvEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return userService.deleteRspvEvent(id)
    }

    @PutMapping("/update_profile")
    @PreAuthorize("isAuthenticated()")
    fun updateProfile(@RequestBody user: UpdateUserDto): ResponseEntity<ResponseDto> {
        return userService.updateProfile(user)
    }
}