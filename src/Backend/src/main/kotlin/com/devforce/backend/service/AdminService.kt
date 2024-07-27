package com.devforce.backend.service

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.repo.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import java.util.*

@Service
class AdminService {

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var roleRepo: RoleRepo


    fun promoteUser(userId: UUID): ResponseEntity<ResponseDto> {
        val user = userRepo.findById(userId)
        if (user.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User not found"))
        }
        val userModel = user.get()
        if (userModel.role!!.name == "ADMIN") {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User is an admin"))
        }

        userModel.role = roleRepo.findByName("HOST")

        userRepo.save(userModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User promoted to host successfully")))
    }

    fun demoteUser(userId: UUID): ResponseEntity<ResponseDto> {
        val user = userRepo.findById(userId)
        if (user.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User not found"))
        }
        val userModel = user.get()
        if (userModel.role!!.name == "ADMIN") {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User is an admin"))
        }

        userModel.role = roleRepo.findByName("GENERAL")

        userRepo.save(userModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User demoted to general successfully")))
    }

    fun deleteUser(userId: UUID): ResponseEntity<ResponseDto> {
        val user = userRepo.findById(userId)
        if (user.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User not found"))
        }
        userRepo.delete(user.get())
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User deleted successfully")))
    }






}