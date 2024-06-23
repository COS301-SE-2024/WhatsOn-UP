package com.devforce.backend.controller

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.EventModel
import com.devforce.backend.service.EventService
import jakarta.annotation.security.RolesAllowed
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.bind.annotation.*
import java.util.UUID
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException


@RestController
@RequestMapping("/api/events")
class EventController {

    @Autowired
    lateinit var eventService: EventService

    @PostMapping("/create")
    @RolesAllowed("HOST", "ADMIN")
    fun createEvent(@RequestBody event: CreateEventDto, @RequestHeader("Authorization") token: String): ResponseEntity<ResponseDto> {
        val jwtToken = token.substring(7)
        return eventService.createEvent(event, jwtToken)
    }

    @GetMapping("/get_all")
    @PreAuthorize("permitAll()")
    fun getAllEvents(): ResponseEntity<ResponseDto>{
        return eventService.getAllEvents()
    }

    @PutMapping("/update/{id}")
    @RolesAllowed("HOST", "ADMIN")
    fun updateEvent(@PathVariable id: UUID, @RequestBody event: UpdateEventDto): ResponseEntity<ResponseDto> {
        return eventService.updateEvent(id, event)
    }

    @DeleteMapping("/delete/{id}")
    @RolesAllowed("HOST", "ADMIN")
    fun deleteEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return eventService.deleteEvent(id)
    }

    @GetMapping("/get/{id}")
    @PreAuthorize("permitAll()")
    fun getEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return  eventService.getEvent(id)
    }

    @GetMapping("/{eventId}/media")
    @PreAuthorize("permitAll()")
    fun getEventMedia(@PathVariable eventId: UUID): ResponseEntity<ResponseDto> {
        return eventService.getEventMedia(eventId)
    }

    @GetMapping("/search")
    @PreAuthorize("permitAll()")
    fun searchEvents(
        @RequestParam(required = false) title: String?,
        @RequestParam(required = false) description: String?,
        @RequestParam(required = false) location: String?
    ): ResponseEntity<ResponseDto> {
        val events = eventService.searchEvents(title, description, location)
        return events
    }

    @GetMapping("/filterEvents")
    @PreAuthorize("permitAll()")
    fun filterEvents(
        @RequestParam(required = false) startDate: String?,
        @RequestParam(required = false) endDate: String?,
        @RequestParam(required = false) minCapacity: Int?,
        @RequestParam(required = false) maxCapacity: Int?,
        @RequestParam(required = false) isPrivate: Boolean?
    ): ResponseEntity<ResponseDto> {
        val filteredEvents = eventService.filterEvents(
            startDate,
            endDate,
            minCapacity ?: 0,
            maxCapacity ?: Int.MAX_VALUE,
            isPrivate ?: false
        )
        return filteredEvents
    }

        //this filter is the one for search page  - fliter by keyword
    @GetMapping("/filter")
    @PreAuthorize("permitAll()")
    fun filterEventsByKeyword(@RequestParam keywordFilter: String): ResponseEntity<ResponseDto> {
        val events = eventService.filterEventsByKeyword(keywordFilter)
        return ResponseEntity.ok(ResponseDto("Events filtered successfully", System.currentTimeMillis(), events))
    }
}