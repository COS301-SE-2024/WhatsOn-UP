package com.devforce.analytics.service

import com.devforce.analytics.dto.EventDto
import com.devforce.analytics.dto.MonthlyEventSummary
import com.devforce.analytics.dto.OverallEventSummary
import com.devforce.analytics.repo.*
import com.devforce.analytics.security.CustomUser
import com.devforce.analytics.dto.ResponseDto
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import java.time.Month
import kotlin.math.pow
import kotlin.math.sqrt

@Service
class HostService {
    @Autowired
    private lateinit var pastEventsRepo: PastEventsRepo

    @Autowired
    private lateinit var recommendedDateRepo: RecommendedDateRepoImpl

    @Autowired
    private lateinit var recommendedVenueRepo: RecommendedVenueRepoImpl

    fun getPastEvents(): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel
        val events = pastEventsRepo.findPastEvents(userModel.userId)

        val eventsDto = events
            .map { event -> EventDto(event) }
            .groupBy { eventDto -> eventDto.startDateTime.month }
            .mapValues { (_, eventDtos) -> eventDtos.sortedBy { it.startDateTime } }


        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }


    fun get(): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel
        val events = pastEventsRepo.findPastEvents(userModel.userId)

        val eventsDto = events
            .map { event -> EventDto(event) }
            .groupBy { eventDto -> eventDto.startDateTime.month }
            .mapValues { (_, eventDtos) -> eventDtos.sortedBy { it.startDateTime } }

        val (monthlySummaries, overallSummary) = summarizeEvents(eventsDto)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf(
            "overallSummary" to overallSummary,
            "monthlySummaries" to monthlySummaries,
            "ActualData" to eventsDto
        )))


    }

    fun getAggregateData(): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel
        val events = pastEventsRepo.findPastEvents(userModel.userId)

        val eventsDto = events
            .map { event -> EventDto(event) }
            .groupBy { eventDto -> eventDto.startDateTime.month }

        val (monthlySummaries, overallSummary) = summarizeEvents(eventsDto)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf(
            "overallSummary" to overallSummary,
            "monthlySummaries" to monthlySummaries
        )))
    }

    fun summarizeEvents(eventsDto: Map<Month, List<EventDto>>): Pair<List<MonthlyEventSummary>, OverallEventSummary> {
        val monthlySummaries = eventsDto.map { (month, eventDtos) ->
            MonthlyEventSummary(
                month = month,
                duration = eventDtos.sumOf { it.duration},
                averageRating = eventDtos.map { it.averageRating }.average(),
                medianRating = calculateMedian(eventDtos.map { it.medianRating }),
                highestRating = eventDtos.maxOfOrNull { it.highestRating } ?: 0,
                lowestRating = eventDtos.minOfOrNull { it.lowestRating } ?: 0,
                mode = calculateMode(eventDtos.map { it.mode }),
                skewness = calculateSkewness(eventDtos.map { it.skewness }),
                outliers = eventDtos.flatMap { it.outliers ?: emptySet() }.toSet(),
                rsvpRatio = eventDtos.map { it.rsvpRatio }.average(),
                capacityRatio = eventDtos.map { it.capacityRatio }.average(),
                attendanceRatio = eventDtos.map { it.attendanceRatio }.average(),
                feedbackRatio = eventDtos.map { it.feedbackRatio }.average()
            )
        }

        val overallSummary = OverallEventSummary(
            totalDuration = monthlySummaries.sumOf { it.duration },
            averageRating = monthlySummaries.map { it.averageRating }.average(),
            medianRating = calculateMedian(monthlySummaries.map { it.medianRating }),
            highestRating = monthlySummaries.maxOfOrNull { it.highestRating } ?: 0,
            lowestRating = monthlySummaries.minOfOrNull { it.lowestRating } ?: 0,
            mode = calculateMode(monthlySummaries.map { it.mode }),
            skewness = calculateSkewness(monthlySummaries.map { it.skewness }),
            outliers = monthlySummaries.flatMap { it.outliers}.toSet(),
            rsvpRatio = monthlySummaries.map { it.rsvpRatio }.average(),
            capacityRatio = monthlySummaries.map { it.capacityRatio }.average(),
            attendanceRatio = monthlySummaries.map { it.attendanceRatio }.average(),
            feedbackRatio = monthlySummaries.map { it.feedbackRatio }.average()
        )

        return Pair(monthlySummaries, overallSummary)
    }


    fun calculateMedian(values: List<Double>): Double {
        if (values.isEmpty()) return 0.0

        val sortedValues = values.sorted()
        val middle = sortedValues.size / 2

        return if (sortedValues.size % 2 == 0) {
            (sortedValues[middle - 1] + sortedValues[middle]) / 2.0
        } else {
            sortedValues[middle]
        }
    }
    
    fun calculateMode(values: List<Int>): Int {
        if (values.isEmpty()) return 0

        val frequencyMap = values.groupingBy { it }.eachCount()
        return frequencyMap.maxByOrNull { it.value }?.key ?: 0
    }

    fun calculateSkewness(values: List<Double>): Double {
        if (values.isEmpty()) return 0.0

        val mean = values.average()
        val n = values.size.toDouble()
        val stdDev = sqrt(values.sumOf { (it - mean).pow(2) } / n)

        return if (stdDev == 0.0) {
            0.0
        } else {
            (n / ((n - 1) * (n - 2))) * values.sumOf { ((it - mean) / stdDev).pow(3) }
        }
    }

    fun getPopularEvents(): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel
        val events = pastEventsRepo.findPastEvents(userModel.userId)

        val popularEvents = events
            .map { event -> EventDto(event) }
            .sortedByDescending { it.attendanceRatio }
            .take(5)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), popularEvents)
        )
    }

    fun getRecommendations(category: String, title: String): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel

        val venues = recommendedVenueRepo.getPossibleVenues(userModel.userId, title, category)
        val dates = recommendedDateRepo.getPossibleDates(userModel.userId, title, category)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf(
            "venues" to venues,
            "dates" to dates
        )))
    }
}