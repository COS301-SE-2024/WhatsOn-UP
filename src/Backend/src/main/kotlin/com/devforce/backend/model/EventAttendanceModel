package com.devforce.backend.model

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.util.*
import java.io.Serializable
import java.util.*

@Data
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "event_attendees")
@IdClass(EventAttendanceId::class)
class EventAttendanceModel {

    @Id
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null

    @Id
    @Column(name = "user_id", columnDefinition = "UUID")
    var userId: UUID? = null

    @Column(name = "attended")
    var attended: Boolean? = null

    @ManyToOne
    @JoinColumn(name = "event_id", insertable = false, updatable = false)
    var event: EventModel? = null

    @ManyToOne
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    var user: UserModel? = null
}



data class EventAttendanceId(
    var eventId: UUID? = null,
    var userId: UUID? = null
) : Serializable
