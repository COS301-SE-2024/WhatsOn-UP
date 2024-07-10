package com.devforce.backend.controller

import com.devforce.backend.dto.*
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

//FUTURE
//  fun filterEvents(
@RestController
@RequestMapping("/api/events")
class EventController {
    @Autowired
    lateinit var eventService: EventService

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun createEvent(@RequestBody event: CreateEventDto): ResponseEntity<ResponseDto> {
        return eventService.createEvent(event)
    }

    @GetMapping("/get_all")
    @PreAuthorize("permitAll()")
    fun getAllEvents(): ResponseEntity<ResponseDto>{
        return eventService.getAllEvents()
    }

    @PutMapping("/update/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun updateEvent(@PathVariable id: UUID, @RequestBody event: UpdateEventDto): ResponseEntity<ResponseDto> {
        return eventService.updateEvent(id, event)
    }

    @DeleteMapping("/delete/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun deleteEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return eventService.deleteEvent(id)
    }
    @GetMapping("/categories")
    fun getUniqueCategories(): ResponseEntity<ResponseDto> {
        val categories = eventService.getUniqueCategories()
        return ResponseEntity.ok(ResponseDto("Categories fetched successfully", System.currentTimeMillis(), categories))

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

        //FUTURE
    @GetMapping("/filter")
    @PreAuthorize("permitAll()")
    fun filterEvents(
        @RequestParam(required = false) startTime: String?,
        @RequestParam(required = false) endTime: String?,
        @RequestParam(required = false) location: String?,
        @RequestParam(required = false) isPrivate: Boolean?,
        @RequestParam(required = false) maxAttendees: Int?
    ): ResponseEntity<ResponseDto> {
        val filterByDto = FilterByDto(startTime, endTime, location, isPrivate, maxAttendees)

        return eventService.filterEvents(filterByDto)
    }
}