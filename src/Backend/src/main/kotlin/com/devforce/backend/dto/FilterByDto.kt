package com.devforce.backend.dto



data class FilterByDto(
    val startTime: String?,
    val endTime: String?,
    val location: String?,
    val isPrivate: Boolean?,  // Assuming `isPrivate` is a boolean flag
    val maxAttendees: Int?
)