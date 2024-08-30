package com.devforce.analytics.dto

import com.devforce.analytics.model.UserModel
import java.util.UUID

data class FeedbackDTO(
    val feedbackId: UUID? = null,
    val userId: UserModel? = null,
    val rating: Int? = null,
    val comment: String? = null
)
