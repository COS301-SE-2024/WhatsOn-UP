package com.devforce.backend.controllers

import com.devforce.backend.models.EventModel
import com.devforce.backend.repos.EventRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.time.LocalDateTime
import java.util.UUID

@RestController
class EventController {
    @Autowired
    lateinit var eventRepository: EventRepo

    @GetMapping("/get_events")
    fun getEvents(): ResponseEntity<Any> {
        return try {
            val events = eventRepository.findAll()
            ResponseEntity.ok(ApiResponse("success", System.currentTimeMillis(), events))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ApiResponse("error", System.currentTimeMillis(), "An error occurred while retrieving events"))
        }
    }


    @PostMapping("/add_event")
    fun addEvent(@RequestBody eventData: Map<String, String>): ResponseEntity<Any> {
        val name = eventData["name"]
        val description = eventData["description"]
        val startTime = eventData["startTime"]
        val endTime = eventData["endTime"]

        // Validate required fields
        if (name.isNullOrEmpty() || description.isNullOrEmpty() || startTime.isNullOrEmpty() || endTime.isNullOrEmpty()) {
            return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), "Name, description, start time, and end time are required"))
        }

        return try {
            val event = EventModel().apply {
                this.name = name
                this.description = description
                metadata = eventData["metadata"] ?: ""
                eventMedia = eventData["eventMedia"]?.split(",") ?: emptyList()
                hosts = eventData["hosts"] ?: ""
                location = eventData["location"] ?: ""
                this.startTime = LocalDateTime.parse(startTime)
                this.endTime = LocalDateTime.parse(endTime)
                maxAttendees = eventData["maxAttendees"]?.toInt() ?: 0
                isPrivate = eventData["isPrivate"]?.toBoolean() ?: false
            }
            val savedEvent = eventRepository.save(event)
            ResponseEntity.ok(ApiResponse("success", System.currentTimeMillis(), mapOf("event" to savedEvent)))
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), "Invalid date format"))
        }
    }


    @PostMapping("/delete_event")
    fun deleteEvent(@RequestBody eventData: Map<String, String>): ResponseEntity<ApiResponse> {
        val eventId = eventData["eventId"]
        if (eventId.isNullOrEmpty()) {
            return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(),  "Event ID is required"))
        }

        return try {
            val uuid = UUID.fromString(eventId)
            if (eventRepository.existsById(uuid)) {
                eventRepository.deleteById(uuid)
                ResponseEntity.ok(ApiResponse("success", System.currentTimeMillis(), "Event deleted successfully"))
            } else {
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse("error", System.currentTimeMillis(), "Event not found"))
            }
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), "Invalid Event ID format"))
        }
    }


    @PostMapping("/update_event")
    fun updateEvent(@RequestBody eventData: Map<String, String>): ResponseEntity<Any> {
        val eventId = eventData["eventId"]
        if (eventId.isNullOrEmpty()) {
            return ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), "Event ID is required"))
        }

        return try {
            val uuid = UUID.fromString(eventId)
            val event = eventRepository.findById(uuid).orElse(null)
            if (event == null) {
                ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse("error", System.currentTimeMillis(), "Event not found"))
            } else {
                event.name = eventData["name"] ?: event.name
                event.description = eventData["description"] ?: event.description
                event.metadata = eventData["metadata"] ?: event.metadata
                event.eventMedia = eventData["eventMedia"]?.split(",") ?: event.eventMedia
                event.hosts = eventData["hosts"] ?: event.hosts
                event.location = eventData["location"] ?: event.location
                event.startTime = LocalDateTime.parse(eventData["startTime"] ?: event.startTime.toString())
                event.endTime = LocalDateTime.parse(eventData["endTime"] ?: event.endTime.toString())
                event.maxAttendees = eventData["maxAttendees"]?.toInt() ?: event.maxAttendees
                event.isPrivate = eventData["isPrivate"]?.toBoolean() ?: event.isPrivate
                val updatedEvent = eventRepository.save(event)
                ResponseEntity.ok(updatedEvent)
            }
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(ApiResponse("error", System.currentTimeMillis(), "Invalid Event ID format"))
        }
    }

}