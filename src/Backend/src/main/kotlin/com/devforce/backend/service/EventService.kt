package com.devforce.backend.service

import com.devforce.backend.dto.*
import com.devforce.backend.model.BroadcastModel
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.VenueModel
import com.devforce.backend.repo.BroadcastRepo
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.VenueRepo
import com.devforce.backend.security.CustomUser
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import java.time.*
import java.util.*
import java.time.Instant
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

//FUTURE
//fun filterEvents(
@Service
class EventService {

    @Autowired
    private lateinit var objectMapper: ObjectMapper

    @Autowired
    lateinit var eventRepo: EventRepo

    @Autowired
    lateinit var venueRepo: VenueRepo

    @Autowired
    lateinit var broadcastRepo: BroadcastRepo

    fun createEvent(createEventDto: CreateEventDto): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val venue = venueRepo.findByVenueId(createEventDto.location)
            ?: return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Venue not found")))

        if (!venue.available) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Venue not available")))
        }

        if (createEventDto.maxParticipants != null && createEventDto.maxParticipants < 1) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Max participants must be greater than 0")))
        }

        if (createEventDto.maxParticipants != null && createEventDto.maxParticipants > venue.capacity) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Max participants must be less than venue capacity")))
        }

        venue.available = false

        val event = EventModel().apply {
            this.eventId = UUID.randomUUID()
            this.title = createEventDto.title
            this.description = createEventDto.description
            this.startDateTime = createEventDto.startDateTime
            this.endDateTime = createEventDto.endDateTime
            this.venue = venue
            this.maxAttendees = createEventDto.maxParticipants ?: 1
            this.metadata = createEventDto.metadata?.let {
                // Assuming metadata is passed as a Map<String, Any> in DTO
                ObjectMapper().writeValueAsString(it)
            } ?: "{}"
            this.isPrivate = createEventDto.isPrivate ?: false
            this.hosts = setOf(user)
        }

        eventRepo.save(event)

        val eventDto = EventDto(event,false, createEventDto.maxParticipants)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventDto)
        )
    }

    // To do: Implement function to retrieve all events
    fun getAllEvents(): ResponseEntity<ResponseDto> {
        // Implementation goes here
        val user = SecurityContextHolder.getContext().authentication.principal
        var eventsDto: List<EventDto>? = null
         if (user == "anonymousUser") {
            val events = eventRepo.findAllByUser(null)
            eventsDto = events.map { event -> EventDto(event, false, null) }
        }
        else {
            val userModel = (user as CustomUser).userModel
            val events = eventRepo.findAllByUser(userModel.userId)
            eventsDto = events.map {
                event -> EventDto(event, userModel.userId in event.hosts.map { host -> host.userId }, null)
            }
        }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

    // To do: Implement function to update an existing event
    fun updateEvent(id: UUID, updateEventDto: UpdateEventDto): ResponseEntity<ResponseDto> {
        try {
            val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

            if (user.role!!.name != "ADMIN" && eventRepo.findById(id).get().hosts.none { host -> host.userId == user.userId }) {
                return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "You are not authorized to update this event")))
            }


            val existing = eventRepo.findById(id)

            if (existing.isEmpty) {
                return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found")))
            }

            val existingEvent = existing.get()

            var v: VenueModel? = null

            if (updateEventDto.location != null) {
                v = venueRepo.findByVenueId(updateEventDto.location)
                if (v == null) return ResponseEntity.ok(
                        ResponseDto(
                            "error",
                            System.currentTimeMillis(),
                            mapOf("message" to "Venue not found")
                        )
                    )

                if (!v.available) {
                    return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Venue not available")))
                }

                if (updateEventDto.maxParticipants != null && updateEventDto.maxParticipants < 1) {
                    return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Max participants must be greater than 0")))
                }

                if (updateEventDto.maxParticipants != null && updateEventDto.maxParticipants > v.capacity) {
                    return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Max participants must be less than venue capacity")))
                }

                v.available = false
            }



            existingEvent.apply {
                updateEventDto.title?.let { title = it }
                updateEventDto.description?.let { description = it }
                updateEventDto.metadata?.let { metadata = it.toString() }
                updateEventDto.location?.let { venue = v}
                updateEventDto.startDateTime?.let { startDateTime = it }
                updateEventDto.endDateTime?.let { endDateTime = it }
                updateEventDto.maxParticipants?.let { maxAttendees = it }
                updateEventDto.isPrivate?.let { isPrivate = it }
            }


            val updatedEvent = eventRepo.save(existingEvent)

            return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), updatedEvent))
        } catch (e: NoSuchElementException) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found")))
        } catch (e: Exception) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Failed to update event")))


    }}


    // To do: Implement function to delete an event
    fun deleteEvent(id: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val event = eventRepo.findById(id)
        if (event.isEmpty) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found"))
            )
        }

        if (user.role!!.name != "ADMIN" && event.get().hosts.none { host -> host.userId == user.userId }) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "You are not authorized to delete this event"))
            )
        }

        eventRepo.deleteEvent(id)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Event deleted successfully"))
        )
    }


//     To do: Implement function to search events based on criteria
    fun searchEvents(
        searchString: String
    ): ResponseEntity<ResponseDto> {

        val user = SecurityContextHolder.getContext().authentication.principal
        var eventsDto: List<EventDto>? = null
        if (user == "anonymousUser") {
            val events = eventRepo.searchEvents(searchString, null)
            eventsDto = events.map { event -> EventDto(event, false, null) }
        }
        else {
            val userModel = (user as CustomUser).userModel
            val events = eventRepo.searchEvents(searchString, userModel.userId)
            eventsDto = events.map {
                    event -> EventDto(event, userModel.userId in event.hosts.map { host -> host.userId }, null)
            }
        }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
    )

}


    fun getUniqueCategories(): List<String> {
        return eventRepo.findUniqueCategories()
    }
    private fun extractCategory(metadata: String): String? {
        val json = ObjectMapper().readTree(metadata)
        return json.get("category")?.asText()
    }

    fun broadcastMessage(message: String, eventId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val event = eventRepo.findById(eventId)
        if (event.isEmpty) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found"))
            )
        }

        if (user.role!!.name != "ADMIN" && event.get().hosts.none { host -> host.userId == user.userId }) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "You are not authorized to broadcast to this event"))
            )
        }

        val broadcast = BroadcastModel().apply {
            this.messageId = UUID.randomUUID()
            this.message = message
            this.sentAt = Date.from(Instant.now())
            this.fromId = user.userId
            this.eventId = eventId
        }

        broadcastRepo.save(broadcast)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Broadcast sent successfully"))
        )

    }

    fun filterEvents(filterBy: FilterByDto): ResponseEntity<ResponseDto>{

        val user = SecurityContextHolder.getContext().authentication.principal
        var eventsDto: List<EventDto>? = null
        if (user == "anonymousUser") {
            val events = eventRepo.filterEvents(filterBy, null)
            eventsDto = events.map { event -> EventDto(event, false, null) }
        }
        else {
           val userModel = (user as CustomUser).userModel
           val events = eventRepo.filterEvents(filterBy, userModel.userId)
            eventsDto = events.map {
                   event -> EventDto(event, userModel.userId in event.hosts.map { host -> host.userId }, null)
           }
       }
       return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto))
    }

    fun getLocations(): ResponseEntity<ResponseDto> {
        val locations = venueRepo.findAll()
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), locations))
    }

}