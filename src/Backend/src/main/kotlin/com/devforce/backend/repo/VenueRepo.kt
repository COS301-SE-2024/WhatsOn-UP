package com.devforce.backend.repo

import com.devforce.backend.model.VenueModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*


interface VenueRepo : JpaRepository<VenueModel, UUID> {
    fun findByVenueId(userId: UUID): VenueModel?

    @Query(
        "SELECT DISTINCT e FROM VenueModel e " +
                "LEFT JOIN FETCH e.building b " +
                "LEFT JOIN FETCH b.campus c"
    )
    override fun findAll(): List<VenueModel>

}
