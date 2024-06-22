
package com.devforce.backend.repo.jpa

import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.time.LocalDateTime
import java.util.*
import org.springframework.data.repository.query.Param;

interface EventRepo: JpaRepository<EventModel, UUID> {
    fun findByAttendeesIs(user: UserModel): List<EventModel>

    @Query("SELECT e FROM EventModel e WHERE (:title IS NULL OR e.title LIKE %:title%) " +
            "AND (:description IS NULL OR e.description LIKE %:description%) " +
            "AND (:location IS NULL OR e.location LIKE %:location%)")
    fun searchEvents(title: String?, description: String?, location: String?): List<EventModel>

    @Query("SELECT e FROM EventModel e WHERE e.title LIKE %:keywordFilter%")
    fun filterEventsByKeyword(@Param("keywordFilter") keywordFilter: String): List<EventModel>

    @Query("SELECT e FROM EventModel e " +
            "WHERE (:date IS NULL OR e.startTime >= :date) " +
            "AND (:maxAttendees IS NULL OR e.maxAttendees <= :maxAttendees) " +
            "AND (:type IS NULL OR e.isPrivate = :type)")
    fun filterEvents(
        @Param("date") date: LocalDateTime?,
        @Param("maxAttendees") maxAttendees: Int?,
        @Param("type") type: Boolean?
    ): List<EventModel>
}
    /*fun searchEvents(
        @Param("title") title: String?,
        @Param("description") description: String?,
        @Param("startDate") startDate: LocalDateTime?,
        @Param("endDate") endDate: LocalDateTime?
    ): List<EventModel>*/
