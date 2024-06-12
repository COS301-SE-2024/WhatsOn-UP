package com.devforce.backend.service

import com.devforce.backend.dto.CreateEventDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.dto.UpdateEventDto
import com.devforce.backend.model.EventModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.EventSearchRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.*

@Service
class EventService @Autowired constructor(
    private val eventRepo: EventRepo,
    private val eventSearchRepo: EventSearchRepo
) {

    // To do: Implement function to create a new event
    fun createEvent(event: CreateEventDto): ResponseEntity<ResponseDto> {
        // Implementation goes here
      //  return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented"))
      //  )
        val eventModel = EventModel().apply {
            name = event.name ?: ""
            description = event.description ?: ""
            metadata = event.metadata ?: ""
            hosts = event.hosts ?: ""
            location = event.location ?: ""
            startTime = event.startDate?.let { LocalDateTime.ofInstant(Instant.ofEpochMilli(it), ZoneId.systemDefault()) }
                ?: LocalDateTime.now()
            endTime = event.endDate?.let { LocalDateTime.ofInstant(Instant.ofEpochMilli(it), ZoneId.systemDefault()) }
                ?: LocalDateTime.now()
            maxAttendees = event.maxParticipants ?: 0
            isPrivate = event.isPrivate ?: false
            // assuming eventMedia and other properties are set accordingly
        }
        val savedEvent = eventRepo.save(eventModel)
        eventSearchRepo.save(savedEvent)
        return ResponseEntity.ok(ResponseDto("Event created successfully", savedEvent))
    }

    // To do: Implement function to retrieve all events
    fun getAllEvents(): ResponseEntity<ResponseDto> {
        val events = eventRepo.findAll()
        return ResponseEntity.ok(ResponseDto("All events fetched successfully", events))
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
            // assuming eventMedia and other properties are updated accordingly
        }
        val updatedEvent = eventRepo.save(existingEvent)
        eventSearchRepo.save(updatedEvent)
        return ResponseEntity.ok(ResponseDto("Event updated successfully", updatedEvent))
    }


    // To do: Implement function to delete an event
    fun deleteEvent(id: UUID): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented"))
        )
    }

    // To do: Implement function to retrieve a specific event by ID
    fun getEvent(id: UUID): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented"))
        )
    }

    // To do: Implement function to search events based on criteria
    fun searchEvents(
        title: String?,
        description: String?,
        startDate: LocalDateTime?,
        endDate: LocalDateTime?
    ): ResponseEntity<ResponseDto> {
        // Implementation goes here
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Method needs to be implemented"))
        )
    }
}