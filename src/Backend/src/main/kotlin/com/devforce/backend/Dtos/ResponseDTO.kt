package com.devforce.backend.Dtos

data class ResponseDTO(
    val status: String,
    val timestamp: Long,
    val body: Any
)
