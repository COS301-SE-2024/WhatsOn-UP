package com.devforce.backend.service

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateUserDto
import com.devforce.backend.repo.RoleRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.JwtGenerator
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import java.util.*

@Service
class UserService {

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var roleRepo: RoleRepo

    @Autowired
    lateinit var jwtGenerator: JwtGenerator

    @Autowired
    lateinit var passwordEncoder: PasswordEncoder

    // To do: Implement function to save an event for the current user
    fun saveEvent(id: UUID): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented")))
    }

    // To do: Implement function to delete a saved event for the current user
    fun deleteSavedEvent(id: UUID): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented")))
    }

    // To do: Implement function to get all saved events for the current user
    fun getSavedEvents(): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented")))
    }

    // To do: Implement function to RSVP to an event for the current user
    fun rspvEvent(id: UUID): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented")))
    }

    // To do: Implement function to get all RSVP'd events for the current user
    fun getRspvEvents(): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented")))
    }

    // To do: Implement function to delete an RSVP'd event for the current user
    fun deleteRspvEvent(id: UUID): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented")))
    }

    // To do: Implement function to update user profile
    fun updateProfile(updateUserDto: UpdateUserDto, token: String): ResponseEntity<ResponseDto> {
        if (!jwtGenerator.validateToken(token)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid token"))
        }

        val email = jwtGenerator.getUsernameFromToken(token)

        val user = userRepo.findByEmail(email)!!

        user.fullName = updateUserDto.fullName ?: user.fullName
        user.email = updateUserDto.email ?: user.email
        user.password = updateUserDto.password?.let { passwordEncoder.encode(it) } ?: user.password
        user.profileImage = updateUserDto.profileImage ?: user.profileImage

        userRepo.save(user)

        // Return a success response
        return ResponseEntity.ok(
            ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Account updated successfully"))
        )
    }

}
