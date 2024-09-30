package com.devforce.analytics.controller

import com.devforce.analytics.service.HostService
import com.devforce.analytics.service.LanguageModelService
import com.devforce.analytics.dto.ResponseDto
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.repository.query.Param
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController


@RestController
@RequestMapping("/analytics/host")
@PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
class HostController {
    @Autowired
    private lateinit var hostService: HostService

    @Autowired
    private lateinit var languageModelService: LanguageModelService

    @GetMapping("/get_past_events")
    fun dashboard(): ResponseEntity<ResponseDto> {
        return hostService.getPastEvents()
    }

    @GetMapping("/get_aggregate_data")
    fun getAggregateData(): ResponseEntity<ResponseDto> {
        return hostService.getAggregateData()
    }

    @GetMapping("/get")
    fun get(): ResponseEntity<ResponseDto> {
        return hostService.get()
    }

    @GetMapping("/get_popular_events")
    fun getPopularEvents(): ResponseEntity<ResponseDto> {
        return hostService.getPopularEvents()
    }

    @GetMapping("/get_recommendations")
    fun getRecommendations(
        @Param("category") category: String,
        @Param("title") title: String
    ): ResponseEntity<ResponseDto> {
        return hostService.getRecommendations(category, title)
    }

    @GetMapping("/generate_autofill")
    fun generateDescription(
        @Param("description") description: String,
        @Param("title") title: String
    ): ResponseEntity<ResponseDto> {
        val formattedResponse: MutableMap<String, String> = HashMap()
        formattedResponse["description"] = description
        formattedResponse["title"] = title

        val responseString = formattedResponse.toString()
        val response = languageModelService.generateEventDescription(responseString, title)
        return response;
    }



}