package com.devforce.backend.service

import com.devforce.backend.dto.*
import com.devforce.backend.model.EventModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.security.CustomUser
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import java.time.*
import java.util.*
import java.util.stream.Collectors
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException

@Service
class EventService {

    @Autowired
    lateinit var eventRepo: EventRepo

    fun createEvent(createEventDto: CreateEventDto): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val event = EventModel().apply {
            this.title = createEventDto.title
            this.description = createEventDto.description
            this.startTime = createEventDto.startDate
            this.endTime = createEventDto.endDate
            this.location = createEventDto.location
            this.maxAttendees = createEventDto.maxParticipants ?: 10
            this.metadata = createEventDto.metadata ?: ""
            this.isPrivate = createEventDto.isPrivate ?: false
            this.hosts = setOf(user)
            this.eventMedia = createEventDto.media ?: this.eventMedia
        }

        eventRepo.save(event)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event added successfully"))
        )
    }

    // To do: Implement function to retrieve all events
    fun getAllEvents(): ResponseEntity<ResponseDto> {
        // Implementation goes here
        val events = eventRepo.findAll()
        val eventsDto = events.map { event -> AllEventsDto(event) }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

    // To do: Implement function to update an existing event
    fun updateEvent(id: UUID, updateEventDto: UpdateEventDto): ResponseEntity<ResponseDto> {
        try {
            val existingEvent = eventRepo.findById(id)
                .orElseThrow { NoSuchElementException("Event with id $id not found") }

            existingEvent.apply {
                updateEventDto.title?.let { title = it }
                updateEventDto.description?.let { description = it }
                updateEventDto.metadata?.let { metadata = it }
                updateEventDto.location?.let { location = it }
                updateEventDto.startDate?.let { startTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(it), ZoneId.systemDefault()) }
                updateEventDto.endDate?.let { endTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(it), ZoneId.systemDefault()) }
                updateEventDto.maxParticipants?.let { maxAttendees = it }
                updateEventDto.isPrivate?.let { isPrivate = it }
            }

            val updatedEvent = eventRepo.save(existingEvent)

            return ResponseEntity.ok(ResponseDto("Event updated successfully", System.currentTimeMillis(), updatedEvent))
        } catch (e: NoSuchElementException) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found")))
        } catch (e: Exception) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Failed to update event:")))


    }}


    // To do: Implement function to delete an event
    fun deleteEvent(id: UUID): ResponseEntity<ResponseDto> {

        val event = eventRepo.findById(id)
        if (event.isEmpty) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found"))
            )
        }

        eventRepo.delete(event.get())

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event deleted successfully"))
        )
    }


//     To do: Implement function to search events based on criteria
    fun searchEvents(
        searchString: String
    ): ResponseEntity<ResponseDto> {

        val events = eventRepo.searchEvents(searchString)
        val eventsDto = events.map { event -> AllEventsDto(event) }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )

}
    fun filteringEvents(startDate: String?, endDate: String?, minCapacity: Int, maxCapacity: Int, isPrivate: Boolean): ResponseEntity<ResponseDto> {
        try {
            println("Before anything: $startDate")

            val parsedStartDate = parseToLocalDateTime(startDate)
            val parsedEndDate = parseToLocalDateTime(endDate)

            println("Parsed Start Date: $parsedStartDate")
            println("Parsed End Date: $parsedEndDate")
    if(parsedStartDate != null || parsedEndDate != null) {

        val filteredEvents = eventRepo.filterEvents(null, null, minCapacity, maxCapacity, isPrivate)
        println("Filtered Events: $filteredEvents")
        return ResponseEntity.ok(ResponseDto("Events filtered successfully", System.currentTimeMillis(), filteredEvents))
    }
            else {

        val formattedStartDate = parsedStartDate?.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
        val formattedEndDate = parsedEndDate?.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))

        println("Formatted Start Date: $formattedStartDate")
        println("Formatted End Date: $formattedEndDate")

        val filteredEvents =
            eventRepo.filterEvents(formattedStartDate, formattedEndDate, minCapacity, maxCapacity, isPrivate)
        println("Filtered Events: $filteredEvents")
        return ResponseEntity.ok(ResponseDto("Events filtered successfully", System.currentTimeMillis(), filteredEvents))
    }

        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
            return ResponseEntity.badRequest()
                .body(ResponseDto("Error filtering events: ${e.message}", System.currentTimeMillis(), null))
        } catch (e: Exception) {
            e.printStackTrace()
            return ResponseEntity.internalServerError()
                .body(ResponseDto("Error filtering events", System.currentTimeMillis(), null))
        }
    }

    fun parseToLocalDateTime(timestamp: String?): LocalDateTime? {
        return if (timestamp.isNullOrBlank()) {
            null
        } else {
            timestamp.toLongOrNull()?.let { epochMillis ->
                LocalDateTime.ofInstant(Instant.ofEpochMilli(epochMillis), ZoneOffset.UTC)
            }
        }
    }


    fun filterEventsByKeyword(keywordFilter: String): List<EventModel> {
        return eventRepo.filterEventsByKeyword(keywordFilter)
    }
    fun filterEvents(filterBy: FilterByDto): ResponseEntity<ResponseDto>{
        val events = eventRepo.filterEvents(filterBy)
        val eventsDto = events.map { event -> AllEventsDto(event) }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

}