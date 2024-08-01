package com.devforce.backend.repo


import com.devforce.backend.model.PassedEventModel

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*
//FUTURE - filterEvents

interface PassedEventsRepo: JpaRepository<PassedEventModel, UUID> {
    @Query(
        "SELECT DISTINCT e FROM PassedEventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "WHERE h.userId = :userId "
    )
    fun findPassedEvents(@Param("userId") userId: UUID): List<PassedEventModel>
}