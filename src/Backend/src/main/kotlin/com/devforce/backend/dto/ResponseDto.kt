package com.devforce.backend.dto

data class ResponseDto(
    val status: String,
    val timestamp: Long,
    val data: Any?
)
