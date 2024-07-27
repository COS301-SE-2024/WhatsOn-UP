package com.devforce.backend.repo

import com.devforce.backend.model.VenueModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*


interface VenueRepo : JpaRepository<VenueModel, UUID> {
    fun findByVenueId(userId: UUID): VenueModel?

}
