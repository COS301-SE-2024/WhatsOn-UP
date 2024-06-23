package com.devforce.backend.controller

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.FilterByDto
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
    fun createEvent(@RequestBody event: CreateEventDto): ResponseEntity<ResponseDto> {
        return eventService.createEvent(event)
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

    @GetMapping("/search/{searchString}")
    @PreAuthorize("permitAll()")
    fun searchEvents(@PathVariable searchString: String): ResponseEntity<ResponseDto> {
        val events = eventService.searchEvents(searchString)
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
        val filteredEvents = eventService.filteringEvents(
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
    fun filterEvents(
        @RequestParam(required = false) startTime: String?,
        @RequestParam(required = false) endTime: String?,
        @RequestParam(required = false) location: String?,
        @RequestParam(required = false) isPrivate: Boolean?,
        @RequestParam(required = false) maxAttendees: Int?
    ): ResponseEntity<ResponseDto> {

        // Convert date strings to LocalDateTime
        val startTimeDateTime: LocalDateTime? = startTime?.let {
            LocalDateTime.parse(it, DateTimeFormatter.ISO_DATE_TIME)
        }

        val endTimeDateTime: LocalDateTime? = endTime?.let {
            LocalDateTime.parse(it, DateTimeFormatter.ISO_DATE_TIME)
        }


        val filterByDto = FilterByDto(startTimeDateTime, endTimeDateTime, location, isPrivate, maxAttendees)

        return eventService.filterEvents(filterByDto)
    }
}