package com.devforce.backend.dto

import com.devforce.backend.model.EventModel
import com.devforce.backend.model.UserModel
import com.devforce.backend.model.VenueModel
import java.time.LocalDateTime

data class EventDto(
    val id: String,
    val title: String,
    val description: String,
    val metadata: String?,
    val eventMedia: List<String>,
    val location: VenueModel?,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val maxAttendees: Int,
    val isPrivate: Boolean,
    val hosts: Set<UserModel>,
    val attendees: Set<UserModel>,
    val invitees: Set<UserModel>,
    val isHost: Boolean,
    val saved: Boolean = false,
    val availableSlots: Int,
    val recurring: Int?,
    val code: String?
) {
    constructor(event: EventModel, isHost: Boolean, saved: Boolean) : this(
        id = event.eventId.toString(),
        title = event.title,
        description = event.description,
        metadata = event.metadata,
        eventMedia = event.eventMedia,
        location = event.venue,
        startDateTime = event.startDateTime,
        endDateTime = event.endDateTime,
        maxAttendees = event.maxAttendees,
        isPrivate = event.isPrivate,
        hosts = event.hosts,
        attendees = event.attendees,
        invitees = event.invitees,
        isHost = isHost,
        saved = saved,
        availableSlots = event.availableSlots ?: 0,
        recurring = event.recurring,
        code = if (isHost) event.code else null
    )
}
