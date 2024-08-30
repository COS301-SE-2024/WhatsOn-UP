package com.devforce.backend.repo

import com.devforce.backend.model.FeedbackModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*


interface FeedbackRepo : JpaRepository<FeedbackModel, UUID> {

}
