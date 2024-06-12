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

@Data
@Builder
@Entity
@Table(name = "event")
@NoArgsConstructor
@AllArgsConstructor
@Document(indexName = "events")
class EventModel {
    @jakarta.persistence.Id
    @ESId
    @GeneratedValue
    @Column(columnDefinition = "UUID")
    var id: UUID = UUID.randomUUID()

    var name: String = ""
    var description: String = ""
    var metadata: String = ""

    @ElementCollection
    @CollectionTable(name = "event_media", joinColumns = [JoinColumn(name = "event_id")])
    @Column(name = "media_link")
    var eventMedia: List<String> = ArrayList()

    private var createdAt: LocalDateTime = LocalDateTime.now()
    private var updatedAt: LocalDateTime = LocalDateTime.now()

    var hosts: String = ""
    var location: String = ""
    var startTime: LocalDateTime = LocalDateTime.now()
    var endTime: LocalDateTime = LocalDateTime.now()

    var maxAttendees: Int = 0
    var isPrivate: Boolean = false

    @ManyToMany
    @JoinTable(
        name = "event_attendees",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var attendees: Set<UserModel> = HashSet()

    @ManyToMany
    @JoinTable(
        name = "event_invitees",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var invitees: Set<UserModel> = HashSet()

    @PrePersist
    fun prePersist() {
        createdAt = LocalDateTime.now()
        updatedAt = LocalDateTime.now()
    }

    @PreUpdate
    fun preUpdate() {
        updatedAt = LocalDateTime.now()
    }

    fun getEsId(): String {
        return id.toString()
    }

    fun setEsId(esId: String) {
        id = UUID.fromString(esId)
    }
}