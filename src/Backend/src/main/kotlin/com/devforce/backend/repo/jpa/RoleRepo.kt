package com.devforce.backend.repo.jpa

import com.devforce.backend.model.RoleModel
import org.springframework.data.jpa.repository.JpaRepository

interface RoleRepo: JpaRepository<RoleModel, Long> {
    fun findByName(name: String): RoleModel?
}