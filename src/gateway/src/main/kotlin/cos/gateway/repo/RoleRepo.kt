package cos.gateway.repo

import cos.gateway.model.RoleModel
import org.springframework.data.jpa.repository.JpaRepository

interface RoleRepo: JpaRepository<RoleModel, Long> {
    fun findByName(name: String): RoleModel?
}