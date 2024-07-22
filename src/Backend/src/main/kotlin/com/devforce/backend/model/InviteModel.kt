package com.devforce.backend.model


import jakarta.persistence.*
import lombok.Builder
import lombok.Data
import java.time.LocalDateTime
import java.util.*

@Data
@Builder
@Entity
@Table(name = "event_invitees")

class InviteesModel {
    @Id
    @GeneratedValue
    @Column(name = "invite_id", columnDefinition = "UUID")
    var inviteId: UUID = UUID.randomUUID()

    var opened: Boolean = false

    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID = UUID.randomUUID()

    @Column(name = "user_id", columnDefinition = "UUID")
    var userId: UUID = UUID.randomUUID()

    @Column(name = "sent_at", nullable = false, updatable = false)
    private var sentAt: LocalDateTime = LocalDateTime.now()

    @Column(name = "from_id", columnDefinition = "UUID")
    var fromId: UUID = UUID.randomUUID()

    @Column(name = "opened_at", nullable = false, updatable = false)
    private var openedAt: LocalDateTime = LocalDateTime.now()

}