package com.devforce.backend.dto


import java.time.LocalDateTime

data class FilterByDto(
    val startTime: LocalDateTime?,
    val endTime: LocalDateTime?,
    val location: String?,
    val isPrivate: Boolean?,  // Assuming `isPrivate` is a boolean flag
    val maxAttendees: Int?
)