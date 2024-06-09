package com.devforce.backend.dtos

data class UpdateUserDto(
    val fullName: String?,
    val email: String?,
    val role: String?
)
