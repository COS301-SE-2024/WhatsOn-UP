package com.devforce.backend.dto

import java.time.LocalDateTime

data class CreateEventDto(
    val title: String,
    val description: String,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val location: String,
    val maxParticipants: Int?,
    val metadata: String?,
    val isPrivate: Boolean?,
)