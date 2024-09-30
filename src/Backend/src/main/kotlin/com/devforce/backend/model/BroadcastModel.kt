package com.devforce.backend.model

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.util.*

@Data
@Builder
@Entity
@Table(name = "broadcast_messages")
@NoArgsConstructor
@AllArgsConstructor
class BroadcastModel {

    @Id
    @Column(name = "message_id", columnDefinition = "UUID")
    var messageId: UUID? = null

    @Column(name = "message", columnDefinition = "TEXT")
    var message: String = ""

    @Column(name = "sent_at")
    var sentAt: Date = Date()

    @Column(name = "from_id", columnDefinition = "UUID")
    var fromId: UUID? = null

    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null
}
