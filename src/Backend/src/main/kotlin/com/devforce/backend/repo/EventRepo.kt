package com.devforce.backend.repo

import com.devforce.backend.model.EventModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface EventRepo: JpaRepository<EventModel, UUID> {

}