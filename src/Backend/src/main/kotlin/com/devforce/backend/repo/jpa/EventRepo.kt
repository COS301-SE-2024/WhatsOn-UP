
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


    @Query(value = """
        SELECT * FROM event e
        WHERE (:startDate IS NULL OR e.start_time >= CAST(:startDate AS TIMESTAMP))
        AND (:endDate IS NULL OR e.end_time <= CAST(:endDate AS TIMESTAMP))
        AND e.max_attendees >= :minCapacity
        AND e.max_attendees <= :maxCapacity
        AND e.is_private = :isPrivate
    """, nativeQuery = true)
    fun filterEvents(
        @Param("startDate") startDate: String?,
        @Param("endDate") endDate: String?,
        @Param("minCapacity") minCapacity: Int,
        @Param("maxCapacity") maxCapacity: Int,
        @Param("isPrivate") isPrivate: Boolean
    ): List<EventModel>
}
    /*fun searchEvents(
        @Param("title") title: String?,
        @Param("description") description: String?,
        @Param("startDate") startDate: LocalDateTime?,
        @Param("endDate") endDate: LocalDateTime?
    ): List<EventModel>*/
