
package com.devforce.backend.repo.jpa

import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.time.LocalDateTime
import java.util.*

interface EventRepo: JpaRepository<EventModel, UUID> {
    fun findByAttendeesIs(user: UserModel): List<EventModel>

    @Query("SELECT e FROM EventModel e WHERE " +
            "(?1 IS NULL OR e.title LIKE %?1%) AND " +
            "(?2 IS NULL OR e.description LIKE %?2%) AND " +
            "(?3 IS NULL OR e.startTime >= ?3) AND " +
            "(?4 IS NULL OR e.endTime <= ?4)")
    fun searchEvents(title: String?, description: String?, startDate: LocalDateTime?, endDate: LocalDateTime?): List<EventModel>
}

