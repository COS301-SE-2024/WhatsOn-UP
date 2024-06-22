package com.devforce.backend.dto

data class RefreshTokenDto(
    val refreshToken: String,
    val jwtToken: String
)
