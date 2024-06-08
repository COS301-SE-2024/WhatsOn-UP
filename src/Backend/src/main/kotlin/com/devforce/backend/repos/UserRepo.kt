package com.devforce.backend.repos

import com.devforce.backend.models.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByUsernameAndPassword(email: String, password: String): UserModel?
    fun findByUsername(email: String): UserModel?
}
