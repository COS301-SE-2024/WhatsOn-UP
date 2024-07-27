package com.devforce.backend.service

import com.devforce.backend.dto.*
import com.devforce.backend.model.EventModel
import com.devforce.backend.model.VenueModel
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
    lateinit var eventRepo: EventRepo

    @Autowired
    lateinit var venueRepo: VenueRepo

    fun createEvent(createEventDto: CreateEventDto): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val venue = venueRepo.findByVenueId(createEventDto.location)
            ?: return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Venue not found")))

        if (!venue.available) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Venue not available")))
        }

        venue.available = false

        val event = EventModel().apply {
            this.eventId = UUID.randomUUID()
            this.title = createEventDto.title
            this.description = createEventDto.description
            this.startDateTime = createEventDto.startDateTime
            this.endDateTime = createEventDto.endDateTime
            this.venue = venue
            this.maxAttendees = createEventDto.maxParticipants ?: 10
            this.metadata = createEventDto.metadata ?: ""
            this.isPrivate = createEventDto.isPrivate ?: false
            this.hosts = setOf(user)
        }

        eventRepo.save(event)

        val eventDto = EventDto(event,false)

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
            eventsDto = events.map { event -> EventDto(event, false) }
        }
        else {
            val userModel = (user as CustomUser).userModel
            val events = eventRepo.findAllByUser(userModel.userId)
            eventsDto = events.map {
                event -> EventDto(event, userModel.userId in event.hosts.map { host -> host.userId })
            }
        }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
        )
    }

    fun getPassedEvents(): ResponseEntity<ResponseDto> {
        // Implementation goes here
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val events = eventRepo.findPassedEvents(user.userId)

        val eventsDto = events.map { event -> EventDto(event, user.userId in event.hosts.map { host -> host.userId }) }

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

            var v: VenueModel? = null

            if (updateEventDto.location != null) {
                v = venueRepo.findByVenueId(updateEventDto.location)
                    ?: return ResponseEntity.ok(
                        ResponseDto(
                            "error",
                            System.currentTimeMillis(),
                            mapOf("message" to "Venue not found")
                        )
                    )

                if (!v.available) {
                    return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Venue not available")))
                }

                v.available = false
            }

            existingEvent.apply {
                updateEventDto.title?.let { title = it }
                updateEventDto.description?.let { description = it }
                updateEventDto.metadata?.let { metadata = it }
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
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Failed to update event:")))


    }}


    // To do: Implement function to delete an event
    fun deleteEvent(id: UUID): ResponseEntity<ResponseDto> {

        val event = eventRepo.findById(id)
        if (event.isEmpty) {
            return ResponseEntity.ok(ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Event not found"))
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
            eventsDto = events.map { event -> EventDto(event, false) }
        }
        else {
            val userModel = (user as CustomUser).userModel
            val events = eventRepo.searchEvents(searchString, userModel.userId)
            eventsDto = events.map {
                    event -> EventDto(event, userModel.userId in event.hosts.map { host -> host.userId })
            }
        }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto)
    )

}
    //the filter for filtering screen
    fun filteringEvents(startDate: String?, endDate: String?, minCapacity: Int?, maxCapacity: Int?, isPrivate: Boolean?): ResponseEntity<ResponseDto> {
        try {
            println("Before anything: $startDate")
            println("Before anything: $endDate")
            println("Before anything bool check: $isPrivate")

            val trimmedStartDate = startDate?.trim()
            val trimmedEndDate = endDate?.trim()
            println("Before anything2: $trimmedStartDate")
            println("Before anything2: $trimmedEndDate")
            var formattedStartDate: String? = null
            var formattedEndDate: String? = null
            var emptyMax: Int? = null
            var emptyMin: Int? = null
//its currently parsing sanme date for start and end so && will work until i fix that
            if (trimmedStartDate != null) {
                if (trimmedEndDate != null) {
                    if (trimmedStartDate.isNotEmpty() && !trimmedEndDate.isNotEmpty()) {
                        val parsedStartDate = parseToLocalDateTime(trimmedStartDate)
                        val parsedEndDate = parseToLocalDateTime(trimmedEndDate)

                        println("Parsed Start Date: $parsedStartDate")
                        println("Parsed End Date: $parsedEndDate")
                        println("Parsed Bool: $isPrivate")
                        println("Min Capacity: $minCapacity")
                        println("Max Capacity: $maxCapacity")

                        formattedStartDate = parsedStartDate?.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                        formattedEndDate = parsedEndDate?.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))

                        println("Formatted Start Date: $formattedStartDate")
                        println("Formatted End Date: $formattedEndDate")
                    }
                }
            }
            println("Sending start..: $formattedStartDate")
            println("Sending end..: $formattedEndDate")
            println("Sending bool..: $isPrivate")
            println("Sending max..: $maxCapacity")
            println("Sending min..: $minCapacity")
            val filteredEvents = if (minCapacity != null && maxCapacity != null) {
                eventRepo.filteringEvents(
                    formattedStartDate,
                    formattedEndDate,
                    minCapacity,
                    maxCapacity,
                    isPrivate
                )
            } else {
                eventRepo.filteringEvents(
                    formattedStartDate,
                    formattedEndDate,
                    null,  // pass null explicitly
                    null,  // pass null explicitly
                    isPrivate
                )
            }

            println("Filtered Events: $filteredEvents")
            return ResponseEntity.ok(ResponseDto("Events filtered successfully", System.currentTimeMillis(), filteredEvents))
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

    fun getUniqueCategories(): List<String> {
        return eventRepo.findUniqueCategories()
    }
    private fun extractCategory(metadata: String): String? {
        val json = ObjectMapper().readTree(metadata)
        return json.get("category")?.asText()
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


    //FUTURE
    fun filterEvents(filterBy: FilterByDto): ResponseEntity<ResponseDto>{

        val user = SecurityContextHolder.getContext().authentication.principal
        var eventsDto: List<EventDto>? = null
        if (user == "anonymousUser") {
            val events = eventRepo.filterEvents(filterBy, null)
            eventsDto = events.map { event -> EventDto(event, false) }
        }
        else {
            val userModel = (user as CustomUser).userModel
            val events = eventRepo.filterEvents(filterBy, userModel.userId)
            eventsDto = events.map {
                    event -> EventDto(event, userModel.userId in event.hosts.map { host -> host.userId })
            }
        }
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), eventsDto))
    }

}