package com.devforce.backend.repo

import com.devforce.backend.model.InviteeModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface InviteeRepo: JpaRepository<InviteeModel, UUID> {
}