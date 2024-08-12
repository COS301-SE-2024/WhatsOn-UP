package com.devforce.backend.dto



data class FilterByDto(
    val startDateTime: String?,
    val endDateTime: String?,
    val isPrivate: Boolean?,  // Assuming `isPrivate` is a boolean flag
    val maxAttendees: Int?
)