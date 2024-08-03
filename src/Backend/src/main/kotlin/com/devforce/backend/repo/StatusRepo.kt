package com.devforce.backend.repo

import com.devforce.backend.model.ApplicationStatusModel
import com.devforce.backend.model.RoleModel
import org.springframework.data.jpa.repository.JpaRepository

interface StatusRepo: JpaRepository<ApplicationStatusModel, Long> {
    fun findByName(name: String): ApplicationStatusModel?
}