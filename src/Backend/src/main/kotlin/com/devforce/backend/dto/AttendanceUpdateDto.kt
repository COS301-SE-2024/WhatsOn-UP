package com.devforce.backend.dto

import java.util.*

data class AttendanceUpdateDto(
    val eventId: UUID,
    val userId: UUID,
    val attended: Boolean?
)
