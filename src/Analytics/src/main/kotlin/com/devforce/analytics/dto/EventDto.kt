package com.devforce.analytics.dto

import com.devforce.analytics.model.PastEventModel
import com.devforce.analytics.model.UserModel
import com.devforce.analytics.model.VenueModel
import java.time.Duration
import java.time.LocalDateTime
import java.time.Month
import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.sqrt

data class EventDto(
    val id: String,
    val title: String,
    val description: String,
    val metadata: String?,
    val eventMedia: List<String>,
    val location: VenueModel?,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val maxAttendees: Int,
    val isPrivate: Boolean,
    val hosts: Set<UserModel>,
    val attendees: Set<UserModel>,
    val invitees: Set<UserModel>,
    val savedEvents: Set<UserModel>,
    val status: String,
    val feedback: List<FeedbackDTO>,

    val duration: Int,
    val averageRating: Double,
    val medianRating: Double,
    val highestRating: Int,
    val lowestRating: Int,
    val mode: Int,
    val skewness: Double,
    val outliers: Set<FeedbackDTO>?,
    val rsvpRatio: Double,
    val capacityRatio: Double,
    val attendanceRatio: Double,
    val feedbackRatio: Double,

    ) {
    constructor(event: PastEventModel) : this(
        id = event.eventId.toString(),
        title = event.title,
        description = event.description,
        metadata = event.metadata,
        eventMedia = event.eventMedia,
        location = event.venue,
        startDateTime = event.startDateTime,
        endDateTime = event.endDateTime,
        maxAttendees = event.maxAttendees,
        savedEvents = event.savedEvents,
        isPrivate = event.isPrivate,
        hosts = event.hosts,
        attendees = event.attendees,
        invitees = event.invitees,
        duration = Duration.between(event.startDateTime, event.endDateTime).toHours().toInt(),
        feedback = event.feedback.map {
            FeedbackDTO(it.feedbackId, it.user, it.rating, it.comment)
        },
        averageRating = event.analytics!!.averageRating,
        medianRating = event.analytics!!.medianRating,


        highestRating = event.analytics!!.highestRating,

        lowestRating = event.analytics!!.lowestRating,

        mode = event.analytics!!.modeRating,

        skewness = event.analytics!!.skewness,

        outliers = event.analytics!!.outliers.map {
            FeedbackDTO(it.feedbackId, it.feedback!!.user, it.feedback!!.rating, it.feedback!!.comment)
        }.toSet(),


        status = event.status,

        rsvpRatio = event.analytics!!.rsvpRatio,
        capacityRatio = event.analytics!!.capacityRatio,
        attendanceRatio = event.analytics!!.attendanceRatio,
        feedbackRatio = event.analytics!!.feedbackRatio
    )
}

data class MonthlyEventSummary(
    val month: Month,
    val duration: Int,
    val averageRating: Double,
    val medianRating: Double,
    val highestRating: Int,
    val lowestRating: Int,
    val mode: Int,
    val skewness: Double,
    val outliers: Set<FeedbackDTO>,
    val rsvpRatio: Double,
    val capacityRatio: Double,
    val attendanceRatio: Double,
    val feedbackRatio: Double
)

data class OverallEventSummary(
    val totalDuration: Int,
    val averageRating: Double,
    val medianRating: Double,
    val highestRating: Int,
    val lowestRating: Int,
    val mode: Int,
    val skewness: Double,
    val outliers: Set<FeedbackDTO>,
    val rsvpRatio: Double,
    val capacityRatio: Double,
    val attendanceRatio: Double,
    val feedbackRatio: Double
)