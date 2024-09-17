package com.devforce.analytics.controller

import com.devforce.analytics.service.AdminService
import com.devforce.analytics.service.HostService
import com.devforce.backend.dto.ResponseDto
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/analytics/admin")
@PreAuthorize("hasAnyRole('ADMIN')")
class AdminController {
    @Autowired
    private lateinit var adminService: AdminService

    @GetMapping("/get_past_events_by_host/{userId}")
    fun dashboard(@PathVariable userId: UUID): ResponseEntity<ResponseDto> {
        val response = adminService.getPastEvents(userId)
        return response
    }


    @GetMapping("/get_aggregate_data_by_host/{userId}")
    fun getAggregateData(@PathVariable userId: UUID): ResponseEntity<ResponseDto> {
        return adminService.getAggregateData(userId)
    }

    @GetMapping("/get_by_host/{userId}")
    fun get(@PathVariable userId: UUID): ResponseEntity<ResponseDto> {
        return adminService.get(userId)
    }

    @GetMapping("/get_for_all_hosts")
    fun getAllHosts(): ResponseEntity<ResponseDto> {
        return adminService.getForAllHosts()
    }

    @GetMapping("/get_all_events")
    fun getAllEvents(): ResponseEntity<ResponseDto> {
        return adminService.getAllEvents()
    }

    @GetMapping("/get_all_aggregate_data")
    fun getAllAggregateData(): ResponseEntity<ResponseDto> {
        return adminService.getAllAggregateData()
    }

    @GetMapping("/get_popular_events")
    fun getPopularEvents(): ResponseEntity<ResponseDto> {
        return adminService.getPopularEvents()
    }

}