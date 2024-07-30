package com.devforce.backend.model

import jakarta.persistence.*
import lombok.*
import java.util.*

@Data
@Builder
@Entity
@Table(name = "event_attendance_summary")
@NoArgsConstructor
@AllArgsConstructor
class AvailableSlotsModel {
    @Id
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null

    @Column(name = "available_slots")
    var availableSlots: Int = 0
}
