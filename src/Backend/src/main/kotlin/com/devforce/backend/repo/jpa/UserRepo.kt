package com.devforce.backend.repo.jpa

import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*


interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByEmail(email: String): UserModel?
    fun findByJwtTokenAndRefreshToken(jwtToken: String, refreshToken: String): UserModel?

    @Query(
        "SELECT DISTINCT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.savedEvents se " +
                "WHERE se.userId = :userId"
    )
    fun getSavedEvents(@Param("userId") userId: UUID): List<EventModel>


}
