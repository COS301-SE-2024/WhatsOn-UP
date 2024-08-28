package com.devforce.backend.model

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor


@Data
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "events")
class EventModel: AllEventModel() {

    @Column(name = "available_slots", nullable = false)
    var availableSlots: Int = 0
}