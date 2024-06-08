package com.devforce.backend.repos

import com.devforce.backend.models.EventModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface EventRepo: JpaRepository<EventModel, UUID> {

}