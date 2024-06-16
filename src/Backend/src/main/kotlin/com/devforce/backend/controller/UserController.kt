package com.devforce.backend.controller

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateUserDto
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
    fun saveEvent(@PathVariable id: UUID, @RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.saveEvent(id, jwtToken)
    }

    @DeleteMapping("/delete_saved_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteSavedEvent(@PathVariable id: UUID, @RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.deleteSavedEvent(id, jwtToken)
    }

    @GetMapping("/get_saved_events")
    @PreAuthorize("isAuthenticated()")
    fun getSavedEvents(@RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.getSavedEvents(jwtToken)
    }


    @PutMapping("rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rspvEvent(@PathVariable id: UUID,@RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.rspvEvent(id, jwtToken)
    }

    @GetMapping("/get_rspv_events")
    @PreAuthorize("isAuthenticated()")
    fun getRspvEvents(@RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.getRspvEvents(jwtToken)
    }

    @DeleteMapping("/delete_rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteRspvEvent(@PathVariable id: UUID, @RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.deleteRspvEvent(id, jwtToken)
    }

    @PutMapping("/update_profile")
    @PreAuthorize("isAuthenticated()")
    fun updateProfile(@RequestBody userDto: UpdateUserDto, @RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return userService.updateProfile(userDto, jwtToken)
    }

}