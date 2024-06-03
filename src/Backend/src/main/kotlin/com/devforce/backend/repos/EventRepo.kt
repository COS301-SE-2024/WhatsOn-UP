package com.devforce.backend.repos

import com.devforce.backend.event.EventModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface EventRepo: JpaRepository<EventModel, UUID> {

}