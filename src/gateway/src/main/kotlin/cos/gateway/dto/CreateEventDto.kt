package cos.gateway.dto

import java.time.LocalDateTime
import java.util.UUID

data class CreateEventDto(
    val title: String,
    val description: String,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val location: UUID,
    val maxParticipants: Int?,
    val metadata: String?,
    val isPrivate: Boolean?,
)