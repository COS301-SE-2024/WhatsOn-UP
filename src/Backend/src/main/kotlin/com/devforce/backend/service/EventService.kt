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
            val existing = eventRepo.findById(id)

            if (existing.isEmpty) {
                return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found")))
            }

            val existingEvent = existing.get()

            existingEvent.apply {
                updateEventDto.title?.let { title = it }
                updateEventDto.description?.let { description = it }
                updateEventDto.metadata?.let { metadata = it }
                updateEventDto.location?.let { location = it }
                updateEventDto.startDate?.let { startTime = it }
                updateEventDto.endDate?.let { endTime = it }
                updateEventDto.maxParticipants?.let { maxAttendees = it }
                updateEventDto.isPrivate?.let { isPrivate = it }
            }


            val updatedEvent = eventRepo.save(existingEvent)

            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), updatedEvent))
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
    fun filterEvents(filterBy: FilterByDto): ResponseEntity<ResponseDto>{
        val events = eventRepo.filterEvents(filterBy)
        val eventsDto = events.map { event -> AllEventsDto(event) }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

}