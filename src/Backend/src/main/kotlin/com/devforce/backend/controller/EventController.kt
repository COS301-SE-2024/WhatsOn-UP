package com.devforce.backend.controller

import com.devforce.backend.dto.*
import com.devforce.backend.security.CustomUser
import com.devforce.backend.service.EventService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.bind.annotation.*
import java.util.UUID

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

    @DeleteMapping("/remove/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun deleteEvent(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return eventService.deleteEvent(id)
    }
    @GetMapping("/categories")
    @PreAuthorize("permitAll()")
    fun getUniqueCategories(): ResponseEntity<ResponseDto> {
        val categories = eventService.getUniqueCategories()
        return ResponseEntity.ok(ResponseDto("Categories fetched successfully", System.currentTimeMillis(), categories))

    }


    @GetMapping("/search")
    @PreAuthorize("permitAll()")
    fun searchEvents(
        @RequestParam(required = true) searchString: String)
    : ResponseEntity<ResponseDto>? {
        val events = searchString.let { eventService.searchEvents(it) }
        return events
    }

    /*@GetMapping("/filterEvents")
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
*/
        //FUTURE
   @GetMapping("/filter")
    @PreAuthorize("permitAll()")
    fun filterEvents(
        @RequestParam(required = false) startDateTime: String?,
       @RequestParam(required = false) endDateTime: String?,
       @RequestParam(required = false) isPrivate: Boolean?,
       @RequestParam(required = false) maxAttendees: Int?
    ): ResponseEntity<ResponseDto> {
        val filterByDto = FilterByDto(startDateTime, endDateTime, isPrivate, maxAttendees)

        return eventService.filterEvents(filterByDto)
    }


    @GetMapping("/get_locations")
    @PreAuthorize("permitAll()")
    fun getLocations(): ResponseEntity<ResponseDto> {
        return eventService.getLocations()
    }

    @PutMapping("/broadcast")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun broadcastMessage(@RequestParam eventId: UUID, @RequestParam message: String): ResponseEntity<ResponseDto> {
        return eventService.broadcastMessage(message, eventId)
    }


    @GetMapping("/{eventId}/attendance")
    fun getAllAttendanceByEventId(@PathVariable eventId: UUID): ResponseEntity<ResponseDto> {
        return eventService.getAllAttendanceByEventId(eventId)

    }

    @PutMapping("/update-attendance")
    @PreAuthorize("hasRole('ADMIN')")
    fun updateAttendanceStatus(@RequestBody request: AttendanceUpdateDto): ResponseEntity<ResponseDto> {
        println("Received request body: $request")
        val eventUUID = UUID.fromString(request.eventId)
        val userUUID = UUID.fromString(request.userId)

        return eventService.updateAttendanceStatus(
            eventUUID,
            userUUID,
                request.attended
            )

    }

    @GetMapping("/generate_code/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun generateCode(@PathVariable id: UUID): ResponseEntity<ResponseDto> {
        return eventService.generateCode(id)
    }


}