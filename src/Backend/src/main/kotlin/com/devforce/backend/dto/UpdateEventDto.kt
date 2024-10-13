package com.devforce.backend.dto

import java.time.LocalDateTime
import java.util.UUID

data class UpdateEventDto(
    val title: String?,
    val description: String?,
    val startDateTime: LocalDateTime?,
    val endDateTime: LocalDateTime?,
    val location: UUID?,
    val maxParticipants: Int?,
    val metadata: Map<String, String>?,
    val isPrivate: Boolean?,
    val hosts: Set<UUID>?,
    val recurring: Boolean?
)