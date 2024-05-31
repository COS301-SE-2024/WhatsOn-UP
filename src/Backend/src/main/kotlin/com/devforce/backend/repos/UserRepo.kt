package com.devforce.backend.repos

import com.devforce.backend.models.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByEmailAndPassword(email: String, password: String): UserModel
}
