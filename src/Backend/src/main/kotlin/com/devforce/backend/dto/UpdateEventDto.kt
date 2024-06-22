package com.devforce.backend.dto

data class UpdateEventDto(
    val title: String?,
    val description: String?,
    val startDate: Long?,
    val endDate: Long?,
    val location: String?,
    val maxParticipants: Int?,
    val metadata: String?,
    val isPrivate: Boolean?,
    val hosts: String?
)