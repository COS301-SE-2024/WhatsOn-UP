package com.devforce.backend.dtos


data class RegisterDto(
    val email: String,
    val password: String,
    val fullName: String
)
