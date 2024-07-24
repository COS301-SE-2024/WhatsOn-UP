package com.devforce.backend.repo

import com.devforce.backend.model.InviteeModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.UUID

interface InviteeRepo: JpaRepository<InviteeModel, UUID> {
    @Query(
        "SELECT i FROM InviteeModel i " +
                "WHERE i.user.userId = :userId " +
                "AND i.event.eventId = :eventId"
    )
    fun findByUserAndEvent(userId: UUID, eventId: UUID): InviteeModel?
}