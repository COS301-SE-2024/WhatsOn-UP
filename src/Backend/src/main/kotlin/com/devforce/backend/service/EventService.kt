package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.EventModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.elasticSearch.EventElasticsearchRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.*

@Service
class EventService @Autowired constructor(
    private val eventRepo: EventRepo,
    private val eventElasticsearchRepo: EventElasticsearchRepo
) {

    // To do: Implement function to create a new event
    fun createEvent(event: CreateEventDto): ResponseEntity<ResponseDto> {
        val eventModel = EventModel().apply {
            name = event.name
            description = event.description
            metadata = event.metadata
            hosts = event.hosts
            location = event.location
            startTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(event.startDate), ZoneId.systemDefault())
            endTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(event.endDate), ZoneId.systemDefault())
            maxAttendees = event.maxParticipants
            isPrivate = event.isPrivate
        }
        val savedEvent = eventRepo.save(eventModel)
        eventElasticsearchRepo.save(savedEvent)
        return ResponseEntity.ok().body(ResponseDto("Event created successfully", System.currentTimeMillis(), savedEvent))
    }

    // To do: Implement function to retrieve all events
    fun getAllEvents(): ResponseEntity<ResponseDto> {
        val events = eventRepo.findAll()
        return ResponseEntity.ok(ResponseDto("All events fetched", System.currentTimeMillis(), events))
    }

    // To do: Implement function to update an existing event
    fun updateEvent(id: UUID, updateEventDto: UpdateEventDto): ResponseEntity<ResponseDto> {
        val existingEvent = eventRepo.findById(id).orElseThrow { Exception("Event not found") }
        existingEvent.apply {
            updateEventDto.name?.let { name = it }
            updateEventDto.description?.let { description = it }
            updateEventDto.metadata?.let { metadata = it }
            updateEventDto.hosts?.let { hosts = it }
            updateEventDto.location?.let { location = it }
            updateEventDto.startDate?.let { startTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(it), ZoneId.systemDefault()) }
            updateEventDto.endDate?.let { endTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(it), ZoneId.systemDefault()) }
            updateEventDto.maxParticipants?.let { maxAttendees = it }
            updateEventDto.isPrivate?.let { isPrivate = it }
        }
        val updatedEvent = eventRepo.save(existingEvent)
        eventElasticsearchRepo.save(updatedEvent)
        return ResponseEntity.ok(ResponseDto("Event updated successfully", System.currentTimeMillis(), updatedEvent))
    }

    // To do: Implement function to delete an event
    fun deleteEvent(id: UUID): ResponseEntity<ResponseDto> {
        if (eventRepo.existsById(id)) {
            eventRepo.deleteById(id)
            eventElasticsearchRepo.deleteById(id.toString())
            return ResponseEntity.ok(ResponseDto("Event deleted successfully", System.currentTimeMillis(), emptyMap<String, Any>()))
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseDto("Event not found", System.currentTimeMillis(), mapOf("id" to id.toString())))
        }
    }

    fun getEvent(id: UUID): ResponseEntity<ResponseDto> {
        val event = eventRepo.findById(id)
        return if (event.isPresent) {
            ResponseEntity.ok(ResponseDto("Event fetched successfully", System.currentTimeMillis(), event.get()))
        } else {
            ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseDto("Event not found", System.currentTimeMillis(), mapOf("id" to id.toString())))
        }
    }

    // To do: Implement function to search events based on criteria
    fun searchEvents(
        title: String?,
        description: String?,
        startDate: Long?,
        endDate: Long?
    ): ResponseEntity<ResponseDto> {
        val results = mutableListOf<EventModel>()

        if (!title.isNullOrBlank()) {
            results.addAll(eventElasticsearchRepo.findByName(title))
        }
        if (!description.isNullOrBlank()) {
            results.addAll(eventElasticsearchRepo.findByDescription(description))
        }
        // Implement search by date range logic if needed

        return ResponseEntity.ok(ResponseDto("Events searched successfully", System.currentTimeMillis(), results))
    }
}