package com.devforce.backend.repo.jpa

import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByEmail(email: String): UserModel?
    fun findByEmailAndJwtTokenAndRefreshToken(email: String, jwtToken: String, refreshToken: String): UserModel?

    fun findByEmailAndJwtToken(email: String, jwtToken: String): UserModel?

}
