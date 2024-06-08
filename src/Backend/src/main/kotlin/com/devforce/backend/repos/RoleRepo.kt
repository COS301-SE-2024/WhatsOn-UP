package com.devforce.backend.repos

import com.devforce.backend.models.RoleModel
import org.springframework.data.jpa.repository.JpaRepository

interface RoleRepo: JpaRepository<RoleModel, Long> {
    fun findByName(name: String): RoleModel?
}