package com.devforce.analytics.service

import com.devforce.analytics.dto.EventDto
import com.devforce.analytics.dto.MonthlyEventSummary
import com.devforce.analytics.dto.OverallEventSummary
import com.devforce.analytics.repo.PastEventsRepo
import com.devforce.analytics.security.CustomUser
import com.devforce.backend.dto.ResponseDto
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

    fun getAggregateData(): ResponseEntity<ResponseDto> {
        val user = SecurityContextHolder.getContext().authentication.principal
        val userModel = (user as CustomUser).userModel
        val events = pastEventsRepo.findPastEvents(userModel.userId)

        val eventsDto = events
            .map { event -> EventDto(event) }
            .groupBy { eventDto -> eventDto.startDateTime.month }

        val (monthlySummaries, overallSummary) = summarizeEvents(eventsDto)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf(
            "monthlySummaries" to monthlySummaries,
            "overallSummary" to overallSummary
        )))
    }

    fun summarizeEvents(eventsDto: Map<Month, List<EventDto>>): Pair<List<MonthlyEventSummary>, OverallEventSummary> {
        val monthlySummaries = eventsDto.map { (month, eventDtos) ->
            MonthlyEventSummary(
                month = month,
                duration = eventDtos.sumOf { it.duration },
                averageRating = eventDtos.map { it.averageRating }.average(),
                medianRating = calculateMedian(eventDtos.map { it.medianRating }),
                highestRating = eventDtos.maxOf { it.highestRating },
                lowestRating = eventDtos.minOf { it.lowestRating },
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
            highestRating = monthlySummaries.maxOf { it.highestRating },
            lowestRating = monthlySummaries.minOf { it.lowestRating },
            mode = calculateMode(monthlySummaries.map { it.mode }),
            skewness = calculateSkewness(monthlySummaries.map { it.skewness }),
            outliers = monthlySummaries.flatMap { it.outliers ?: emptySet() }.toSet(),
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
}