package com.devforce.backend.controllers

import com.devforce.backend.dtos.CreateEventDto
import com.devforce.backend.dtos.ResponseDto
import com.devforce.backend.dtos.UpdateEventDto
import com.devforce.backend.services.EventService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.time.LocalDateTime
import java.util.UUID

@RestController
@RequestMapping("/events")
class EventController {

    @Autowired
    lateinit var eventService: EventService

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('ADMIN', 'HOST')")
    fun createEvent(@RequestBody event: CreateEventDto): ResponseEntity<ResponseDto> {
        return eventService.createEvent(event)
    }

    @GetMapping("/get_all")
    fun getAllEvents(): ResponseEntity<ResponseDto>{
        return eventService.getAllEvents()
    }

    @PutMapping("/update/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'HOST')")
    fun updateEvent(@PathVariable id: UUID, @RequestBody event: UpdateEventDto): ResponseEntity<ResponseDto> {
        return eventService.updateEvent(id, event)
    }

    @DeleteMapping("/delete/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'HOST')")
    fun deleteEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return eventService.deleteEvent(id)
    }

    @GetMapping("/get/{id}")
    fun getEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return  eventService.getEvent(id)
    }

    @GetMapping("/search")
    fun searchEvents(
        @RequestParam(required = false) title: String?,
        @RequestParam(required = false) description: String?,
        @RequestParam(required = false) startDate: LocalDateTime?,
        @RequestParam(required = false) endDate: LocalDateTime?
    ): ResponseEntity<ResponseDto> {
        return eventService.searchEvents(title, description, startDate, endDate)
    }
}
