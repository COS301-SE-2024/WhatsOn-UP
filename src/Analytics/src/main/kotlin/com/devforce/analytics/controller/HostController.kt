package com.devforce.analytics.controller

import com.devforce.analytics.service.HostService
import com.devforce.backend.dto.ResponseDto
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/analytics/host")
@PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
class HostController {
    @Autowired
    private lateinit var hostService: HostService

    @RequestMapping("/get_past_events")
    fun dashboard(): ResponseEntity<ResponseDto> {
        return hostService.getPastEvents()
    }

    @RequestMapping("/get_aggregate_data")
    fun getAggregateData(): ResponseEntity<ResponseDto> {
        return hostService.getAggregateData()
    }

    @RequestMapping("/get")
    fun get(): ResponseEntity<ResponseDto> {
        return hostService.get()
    }

}