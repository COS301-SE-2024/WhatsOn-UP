package com.devforce.backend.repo

import com.devforce.backend.model.RoleModel
import org.springframework.data.jpa.repository.JpaRepository

interface RoleRepo: JpaRepository<RoleModel, Long> {
    fun findByName(name: String): RoleModel?
}