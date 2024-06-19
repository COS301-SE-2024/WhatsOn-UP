package com.devforce.backend.model

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import org.springframework.data.annotation.Id as ESId
import org.springframework.data.elasticsearch.annotations.Document
import java.time.LocalDateTime
import java.util.*

@Entity
@Table(name = "event_media")
data class EventMediaModel(
    @Id
    @Column(name = "event_id")
    var eventId: UUID = UUID.randomUUID(),

    @Column(name = "media_link")
    var mediaLink: String = ""
)