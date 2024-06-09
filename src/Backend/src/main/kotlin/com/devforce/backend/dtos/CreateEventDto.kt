package com.devforce.backend.dtos

data class CreateEventDto(
    val name: String,
    val description: String,
    val startDate: Long,
    val endDate: Long,
    val location: String,
    val maxParticipants: Int,
    val metadata: String,
    val isPrivate: Boolean,
    val hosts: String
)