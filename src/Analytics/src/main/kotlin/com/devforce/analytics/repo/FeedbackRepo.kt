package com.devforce.analytics.repo

import com.devforce.analytics.model.FeedbackModel
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*


interface FeedbackRepo : JpaRepository<FeedbackModel, UUID> {

}
