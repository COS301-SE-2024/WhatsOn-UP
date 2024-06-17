package com.devforce.backend.repo.jpa

import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface EventRepo: JpaRepository<EventModel, UUID> {
    fun findByAttendeesIs(user: UserModel): List<EventModel>
}
