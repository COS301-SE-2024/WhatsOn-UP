package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.repository.query.Param
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


    @PutMapping("rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rspvEvent(@PathVariable id: UUID,): ResponseEntity<ResponseDto> {
        
        return userService.rspvEvent(id)
    }

    @GetMapping("/get_rspv_events")
    @PreAuthorize("isAuthenticated()")
    fun getRspvEvents(): ResponseEntity<ResponseDto> {
        
        return userService.getRspvEvents()
    }

    @DeleteMapping("/delete_rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteRspvEvent(@PathVariable id: UUID, ): ResponseEntity<ResponseDto> {
        
        return userService.deleteRspvEvent(id)
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

    @DeleteMapping("/delete_user")
    @PreAuthorize("isAuthenticated()")
    fun deleteUser(): ResponseEntity<ResponseDto> {
        return userService.deleteUser()
    }

}