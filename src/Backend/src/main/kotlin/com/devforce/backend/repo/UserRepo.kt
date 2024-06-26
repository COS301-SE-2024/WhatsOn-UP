package com.devforce.backend.repo

import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*


interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByEmail(email: String): UserModel?

}
