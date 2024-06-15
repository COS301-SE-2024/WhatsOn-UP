package com.devforce.backend.repo

import com.devforce.backend.model.EventModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface EventRepo: JpaRepository<EventModel, UUID> {

}


