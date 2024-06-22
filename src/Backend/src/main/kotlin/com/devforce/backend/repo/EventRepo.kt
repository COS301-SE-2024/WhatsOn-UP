package com.devforce.backend.repo

import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*

interface EventRepo: JpaRepository<EventModel, UUID> {
    fun findByAttendeesIs(user: UserModel): List<EventModel>
    @Query("SELECT DISTINCT e FROM EventModel e " +
            "LEFT JOIN FETCH e.attendees a " +
            "LEFT JOIN FETCH a.role ar " +
            "LEFT JOIN FETCH e.hosts h " +
            "LEFT JOIN FETCH h.role hr " +
            "LEFT JOIN FETCH e.invitees i " +
            "LEFT JOIN FETCH i.role ir " +
            "LEFT JOIN FETCH e.eventMedia em")
    override fun findAll(): List<EventModel>
}