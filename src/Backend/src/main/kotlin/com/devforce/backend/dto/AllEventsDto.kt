package com.devforce.backend.dto

import com.devforce.backend.model.EventModel
import java.time.LocalDateTime

data class AllEventsDto(
    val id: String,
    val title: String,
    val description: String,
    val metadata: String?,
    val eventMedia: List<String>,
    val location: String,
    val startTime: LocalDateTime,
    val endTime: LocalDateTime,
    val maxAttendees: Int,
    val isPrivate: Boolean,
    val hosts: List<PartialUser>,
    val attendees: List<PartialUser>,
    val invitees: List<PartialUser>
) {
    constructor(event: EventModel) : this(
        id = event.eventId.toString(),
        title = event.title,
        description = event.description,
        metadata = event.metadata,
        eventMedia = event.eventMedia,
        location = event.location,
        startTime = event.startTime,
        endTime = event.endTime,
        maxAttendees = event.maxAttendees,
        isPrivate = event.isPrivate,
        hosts = event.hosts.map { host ->
            PartialUser(
                fullName = host.fullName
            )
        },
        attendees = event.attendees.map { attendee ->
            PartialUser(
                fullName = attendee.fullName
            )
        },
        invitees = event.invitees.map { invitee ->
            PartialUser(
                fullName = invitee.fullName
            )
        }
    )
}
