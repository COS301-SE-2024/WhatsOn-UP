package com.devforce.backend.repo

import com.devforce.backend.model.BroadcastModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface BroadcastRepo: JpaRepository<BroadcastModel, UUID> {

}