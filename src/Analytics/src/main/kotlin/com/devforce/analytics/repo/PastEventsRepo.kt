package com.devforce.analytics.repo


//import com.devforce.analytics.model.EventModelAll
import com.devforce.analytics.model.PastEventModel

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*
//FUTURE - filterEvents

interface PastEventsRepo: JpaRepository<PastEventModel, UUID> {
    @Query(
        "SELECT DISTINCT e FROM PastEventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.savedEvents s " +
                "LEFT JOIN FETCH s.role sr " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "LEFT JOIN Fetch e.feedback f " +
                "LEFT JOIN FETCH f.user fu " +
                "LEFT JOIN FETCH fu.role fur " +
                "WHERE (:userId IS NULL OR h.userId = :userId)"

    )
    fun findPastEvents(@Param("userId") userId: UUID?): List<PastEventModel>


}
//
//interface EventRepoAll: JpaRepository<EventModelAll, UUID>{
//}
