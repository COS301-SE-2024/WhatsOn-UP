package com.devforce.backend.dto

import java.time.LocalDateTime

data class UpdateEventDto(
    val title: String?,
    val description: String?,
    val startDateTime: LocalDateTime?,
    val endDateTime: LocalDateTime?,
    val location: String?,
    val maxParticipants: Int?,
    val metadata: String?,
    val isPrivate: Boolean?,
)