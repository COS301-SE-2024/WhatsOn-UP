package com.devforce.backend.repo.jpa

import com.devforce.backend.model.EventMediaModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface EventMediaRepo : JpaRepository<EventMediaModel, UUID> {
    fun findByEventId(eventId: UUID): List<EventMediaModel>
}