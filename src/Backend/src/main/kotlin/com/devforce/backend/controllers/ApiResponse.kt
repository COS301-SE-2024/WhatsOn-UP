package com.devforce.backend.controllers

data class ApiResponse(
    val status: String,
    val timestamp: Long,
    val body: Any
)
