package com.devforce.backend.repo

import com.devforce.backend.model.AvailableSlotsModel
import com.sun.java.accessibility.util.EventID
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*


interface AvailableSlotsRepo : JpaRepository<AvailableSlotsModel, UUID> {
    fun findByEventId(eventID: UUID): AvailableSlotsModel?
}
