package com.devforce.backend.repo

import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*

interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByEmail(email: String): UserModel?
    fun findByEmailAndJwtTokenAndRefreshToken(email: String, jwtToken: String, refreshToken: String): UserModel?

    fun findByEmailAndJwtToken(email: String, jwtToken: String): UserModel?


    @Query(value = "SELECT manage_user(:email, :fullName, :password)", nativeQuery = true)
    fun executeManageUserFunction(
        @Param("email") email: String?,
        @Param("fullName") fullName: String?,
        @Param("password") password: String?
    ): String?

}
