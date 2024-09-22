package com.devforce.analytics.model

import DurationConverter
import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.time.Duration
import java.util.*


@Data
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "analytics")
class AnalyticsModel {
    @Id
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null

    @Convert(converter = DurationConverter::class)
    @Column(name = "duration")
    var duration: Duration = Duration.ZERO

    @Column(name = "average_rating")
    var averageRating: Double = 0.0

    @Column(name = "median_rating")
    var medianRating: Double = 0.0

    @Column(name = "max_rating")
    var highestRating: Int = 0

    @Column(name = "min_rating")
    var lowestRating: Int = 0

    @Column(name = "mode_rating")
    var modeRating: Int = 0

    @Column(name = "skewness")
    var skewness: Double = 0.0

    @Column(name = "rsvp_ratio")
    var rsvpRatio: Double = 0.0

    @Column(name = "capacity_ratio")
    var capacityRatio: Double = 0.0

    @Column(name = "attendance_ratio")
    var attendanceRatio: Double = 0.0

    @Column(name = "feedback_ratio")
    var feedbackRatio: Double = 0.0

    @OneToMany
    @JoinColumn(name = "event_id")
    var outliers: Set<OutlierModel> = HashSet()
}