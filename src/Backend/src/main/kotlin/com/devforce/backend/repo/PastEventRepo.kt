package com.devforce.backend.repo

import com.devforce.backend.model.PastEventModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface PastEventRepo: JpaRepository<PastEventModel, UUID> {

}