package com.devforce.backend.service

import com.devforce.backend.dto.*
import com.devforce.backend.model.EventModel
import com.devforce.backend.repo.jpa.EventRepo
import com.devforce.backend.repo.jpa.UserRepo
import org.springframework.beans.factory.annotation.Autowired
import com.devforce.backend.repo.jpa.EventMediaRepo
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import java.time.*
import java.util.*
import java.util.stream.Collectors

@Service
class EventService @Autowired constructor(
    private val eventRepo: EventRepo,
    private val eventMediaRepo: EventMediaRepo
)  {
    @Autowired
    lateinit var checkJwt: CheckJwt

    @Autowired
    lateinit var userRepo: UserRepo


    // To do: Implement function to create a new event
    fun createEvent(createEventDto: CreateEventDto, token: String): ResponseEntity<ResponseDto> {
        val response = checkJwt.check(token)
        if (response != null) {
            return response
        }

        val email = checkJwt.jwtGenerator.getUsernameFromToken(token)
        val user = userRepo.findByEmail(email)!!

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
            this.eventMedia = createEventDto.media ?: emptyList()
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

        fun getEvent(id: UUID): ResponseEntity<ResponseDto> {
            val event = eventRepo.findById(id)
            return if (event.isPresent) {
                ResponseEntity.ok(ResponseDto("Event fetched successfully", System.currentTimeMillis(), event.get()))
            } else {
                ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ResponseDto("Event not found", System.currentTimeMillis(), mapOf("id" to id.toString())))
            }
        }

        // To do: Implement function to search events based on criteria
        fun searchEvents(
            title: String?,
            description: String?,
            startDate: LocalDateTime?,
            endDate: LocalDateTime?
        ): ResponseEntity<ResponseDto> {
            println("Searching events with parameters: title=$title, description=$description, startDate=$startDate, endDate=$endDate")

            val results = eventRepo.searchEvents(title, description, startDate, endDate)
            println("Found ${results.size} events");
            return ResponseEntity.ok(ResponseDto("Events searched successfully", System.currentTimeMillis(), results))


            // Implement search by date range logic
          /*  if (startDate != null && endDate != null) {
                val dateRangeResults = eventElasticsearchRepo.findByStartTimeBetween(startDate, endDate)
                println("Results for date range search: ${dateRangeResults.size}")
                results.addAll(dateRangeResults)
            }*/

        }


    fun getAllEventsWithMedia(): List<EventModel> {
            val events = eventRepo.findAll()
            events.forEach { event ->
                val mediaLinks = eventMediaRepo.findByEventId(event.eventId)
                    .map { it.mediaLink }
                event.eventMedia = mediaLinks
            }
            return events
        }

        fun getEventMedia(eventId: UUID): ResponseEntity<ResponseDto> {
            val eventMedia = eventMediaRepo.findByEventId(eventId)

            return if (eventMedia.isNotEmpty()) {
                ResponseEntity.ok()
                    .body(ResponseDto("Event media fetched successfully", System.currentTimeMillis(), eventMedia))
            } else {
                ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ResponseDto("Event media not found", System.currentTimeMillis(), emptyMap<String, Any>()))
            }

        }
    }