//package com.devforce.analytics.dto
//
//import com.devforce.analytics.model.PastEventModel
//import com.devforce.analytics.model.UserModel
//import com.devforce.analytics.model.VenueModel
//import java.time.Duration
//import java.time.LocalDateTime
//import java.time.Month
//import kotlin.math.abs
//import kotlin.math.pow
//import kotlin.math.sqrt
//
//data class EventDto(
//    val id: String,
//    val title: String,
//    val description: String,
//    val metadata: String?,
//    val eventMedia: List<String>,
//    val location: VenueModel?,
//    val startDateTime: LocalDateTime,
//    val endDateTime: LocalDateTime,
//    val maxAttendees: Int,
//    val isPrivate: Boolean,
//    val hosts: Set<UserModel>,
//    val attendees: Set<UserModel>,
//    val invitees: Set<UserModel>,
//    val savedEvents: Set<UserModel>,
//    val status: String,
//    val feedback: List<FeedbackDTO>,
//
//    val duration: Int,
//    val averageRating: Double,
//    val medianRating: Double,
//    val highestRating: Int,
//    val lowestRating: Int,
//    val mode: Int,
//    val skewness: Double,
//    val outliers: Set<FeedbackDTO>?,
//    val rsvpRatio: Double,
//    val capacityRatio: Double,
//    val attendanceRatio: Double,
//    val feedbackRatio: Double,
//
//    ) {
//    constructor(event: PastEventModel) : this(
//        id = event.eventId.toString(),
//        title = event.title,
//        description = event.description,
//        metadata = event.metadata,
//        eventMedia = event.eventMedia,
//        location = event.venue,
//        startDateTime = event.startDateTime,
//        endDateTime = event.endDateTime,
//        maxAttendees = event.maxAttendees,
//        savedEvents = event.savedEvents,
//        isPrivate = event.isPrivate,
//        hosts = event.hosts,
//        attendees = event.attendees,
//        invitees = event.invitees,
//        duration = Duration.between(event.startDateTime, event.endDateTime).toHours().toInt(),
//        feedback = event.feedback.map {
//            FeedbackDTO(it.feedbackId, it.user, it.rating, it.comment)
//        },
//        averageRating = event.feedback
//            .map { it.rating!! }
//            .average()
//            .takeIf { it.isFinite() }
//            ?: 0.0,
//        medianRating = event.feedback
//            .map { it.rating!! }
//            .takeIf { it.isNotEmpty() } // Ensure the list is not empty
//            ?.sorted()
//            ?.let {
//                val size = it.size
//                if (size % 2 == 0) {
//                    // If even number of elements, average the two middle values
//                    (it[size / 2 - 1] + it[size / 2]) / 2.0
//                } else {
//                    // If odd number of elements, take the middle value
//                    it[size / 2].toDouble()
//                }
//            } ?: 0.0,
//
//
//        highestRating = event.feedback.maxOfOrNull { it.rating!! } ?: 0,
//
//        lowestRating = event.feedback.minOfOrNull { it.rating!! } ?: 0,
//
//        mode = event.feedback
//            .map { it.rating!! }
//            .groupingBy { it }
//            .eachCount()
//            .maxByOrNull { it.value }
//            ?.key ?: 0,
//
//        skewness = event.feedback
//            .map { it.rating!! }
//            .let { ratings ->
//                val mean = ratings.average()
//                val size = ratings.size
//                val sumSquaredDeviations = ratings.sumOf { (it - mean) * (it - mean) }
//                val variance = sumSquaredDeviations / size
//                val stdDev = sqrt(variance)
//
//                // Calculate the sum of cubed deviations
//                val sumCubedDeviations = ratings.sumOf { (it - mean).pow(3.0) }
//
//                // Calculate skewness
//                val skewness = sumCubedDeviations / (size * stdDev.pow(3.0))
//                skewness
//            }.takeIf { it.isFinite() }
//            ?: 0.0,
//
//
//        outliers = event.feedback.let { feedbacks ->
//            val ratings = feedbacks.map { it.rating!! }
//            val mean = ratings.average()
//            val size = ratings.size
//            val sum = ratings.sumOf { (it - mean) * (it - mean) }
//            val variance = sum / size
//            val stdDev = sqrt(variance)
//
//            feedbacks.map { FeedbackDTO(it.feedbackId, it.user, it.rating, it.comment) }
//                .filter { feedback -> abs(feedback.rating!! - mean) > 2 * stdDev }
//                .toSet()
//        },
//
//
//        status = event.status,
//            // Calculate the ratio of combined saved events and invitees to the number of actual attendees
//        rsvpRatio = (event.savedEvents.size + event.invitees.size).toDouble() / event.attendees.size.toDouble() * 100,
//
//        // Calculate the ratio of the number of attendees to the maximum allowed attendees
//        capacityRatio = event.attendees.size.toDouble() / event.maxAttendees.toDouble() * 100,
//
//        // Calculate the ratio of the number of attendees to the maximum allowed attendees (same as capacityRatio)
//        attendanceRatio = event.attendees.size.toDouble() / event.maxAttendees.toDouble() * 100,
//
//        // Calculate the ratio of the number of attendees to the number of feedback responses received
//        feedbackRatio = event.feedback.size.toDouble() / event.attendees.size.toDouble() * 100,
//
//    )
//}
//
//data class MonthlyEventSummary(
//    val month: Month,
//    val duration: Int,
//    val averageRating: Double,
//    val medianRating: Double,
//    val highestRating: Int,
//    val lowestRating: Int,
//    val mode: Int,
//    val skewness: Double,
//    val outliers: Set<FeedbackDTO>,
//    val rsvpRatio: Double,
//    val capacityRatio: Double,
//    val attendanceRatio: Double,
//    val feedbackRatio: Double
//)
//
//data class OverallEventSummary(
//    val totalDuration: Int,
//    val averageRating: Double,
//    val medianRating: Double,
//    val highestRating: Int,
//    val lowestRating: Int,
//    val mode: Int,
//    val skewness: Double,
//    val outliers: Set<FeedbackDTO>,
//    val rsvpRatio: Double,
//    val capacityRatio: Double,
//    val attendanceRatio: Double,
//    val feedbackRatio: Double
//)