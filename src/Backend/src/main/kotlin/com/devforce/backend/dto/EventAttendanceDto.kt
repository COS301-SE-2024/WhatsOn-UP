package com.devforce.backend.dto

import java.util.UUID

data class EventAttendanceDto(
    val eventId: UUID,
    val userId: UUID,
    val attended: Boolean?
)
