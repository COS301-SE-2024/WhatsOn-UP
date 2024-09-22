package com.devforce.backend.dto

import java.util.*

data class AttendanceUpdateDto(
    val eventId: String,
    val userId: String,
    val attended: Boolean?
)
