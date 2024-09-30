package com.devforce.analytics.dto

import java.util.Date
import java.util.UUID

data class RecommendedVenueDto(
    val venueId: UUID? = null,
    val venueName: String? = null
)


data class RecommendedDateDto(
    val startDateTime: Date? = null,
    val endDateTime: Date? = null,
    val day: String? = null
)