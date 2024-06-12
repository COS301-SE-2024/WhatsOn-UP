package com.devforce.backend

object ApplicationConstants {
    const val EXPIRY: Long = 86400000
    val SECRET: String = System.getenv("SECRET") ?: "defaultSecret"
}
