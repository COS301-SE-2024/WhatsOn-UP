package com.devforce.backend.service

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.repo.*
import com.devforce.backend.security.CustomUser
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import java.util.*

@Service
class AdminService {

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var roleRepo: RoleRepo

    @Autowired
    lateinit var hostApplicationsRepo: HostApplicationsRepo

    @Autowired
    lateinit var statusRepo: StatusRepo

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

        val application = hostApplicationsRepo.findByUserId(userId)
        if (application.isNotEmpty()) {
            application[0]?.status = statusRepo.findByName("VERIFIED")
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

    fun acceptApplication(applicationId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val application = hostApplicationsRepo.findById(applicationId)
        if (application.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not found"))
        }

        if (application.get().status!!.name == "PENDING" && (application.get().verificationCode != null || application.get().proofUrl == null)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not verified"))
        }

        val applicationModel = application.get()
        applicationModel.status = statusRepo.findByName("ACCEPTED")
        applicationModel.acceptedRejectedBy = user
        hostApplicationsRepo.save(applicationModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Application accepted successfully")))
    }

    fun rejectApplication(applicationId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val application = hostApplicationsRepo.findById(applicationId)
        if (application.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Application not found"))
        }
        val applicationModel = application.get()
        applicationModel.status = statusRepo.findByName("REJECTED")
        applicationModel.acceptedRejectedBy = user
        hostApplicationsRepo.save(applicationModel)
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Application rejected successfully")))
    }

    fun getAllApplications(status: String?): ResponseEntity<ResponseDto> {

        val applications = if (status == null) {
            hostApplicationsRepo.findByStatus(null)
        } else {
            hostApplicationsRepo.findByStatus(status)
        }

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), applications))
    }
}