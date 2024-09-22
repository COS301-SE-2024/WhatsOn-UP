package com.devforce.backend.repo

import com.devforce.backend.model.BroadcastModel
import com.devforce.backend.model.VenueModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*

interface BroadcastRepo: JpaRepository<BroadcastModel, UUID> {


}
