package cos.gateway.dto

import java.time.LocalDateTime
import java.util.UUID

data class UpdateEventDto(
    val title: String? = null,
    val description: String? = null,
    val startDateTime: LocalDateTime? = null,
    val endDateTime: LocalDateTime? = null,
    val location: UUID? = null,
    val maxParticipants: Int? = null,
    val metadata: String? = null,
    val isPrivate: Boolean? = null,
)