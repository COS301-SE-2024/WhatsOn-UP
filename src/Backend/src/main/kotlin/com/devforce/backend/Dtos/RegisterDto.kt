package com.devforce.backend.Dtos


data class RegisterDto(
    val username: String,
    val password: String,
    val fullName: String
)
