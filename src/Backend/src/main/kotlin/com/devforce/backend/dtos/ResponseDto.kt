package com.devforce.backend.dtos

data class ResponseDto(
    val status: String,
    val timestamp: Long,
    val body: Any
)
