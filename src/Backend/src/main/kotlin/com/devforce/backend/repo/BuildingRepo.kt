package com.devforce.backend.repo

import com.devforce.backend.model.BuildingModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface BuildingRepo: JpaRepository<BuildingModel, UUID> {


}