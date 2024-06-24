package com.devforce.backend.dto


data class RegisterDto(
    val email: String,
    val password: String,
    val fullName: String
)
