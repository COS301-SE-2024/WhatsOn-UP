package com.devforce.backend.model

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.time.LocalDateTime
import java.util.*

@Data
@Builder
@Entity
@Table(name = "event")
@NoArgsConstructor
@AllArgsConstructor

class EventModel {
    @Id
    @GeneratedValue
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID = UUID.randomUUID()

    var title: String = ""
    var description: String = ""
    var metadata: String = ""

    @ElementCollection
    @CollectionTable(name = "event_media", joinColumns = [JoinColumn(name = "event_id")])
    @Column(name = "media_link")
    var eventMedia: List<String> = ArrayList()

    @Column(name = "created_at", nullable = false, updatable = false)
    private var createdAt: LocalDateTime = LocalDateTime.now()

    @Column(name = "updated_at", nullable = false)
    private var updatedAt: LocalDateTime = LocalDateTime.now()

    var location: String = ""

    @Column(name = "start_time", nullable = false)
    var startTime: LocalDateTime = LocalDateTime.now()

    @Column(name = "end_time", nullable = false)
    var endTime: LocalDateTime = LocalDateTime.now()

    @Column(name = "max_attendees", nullable = false)
    var maxAttendees: Int = 0

    @Column(name = "is_private", nullable = false)
    var isPrivate: Boolean = false

    @ManyToMany
    @JoinTable(
        name = "event_hosts",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var hosts: Set<UserModel> = HashSet()

    @ManyToMany
    @JoinTable(
        name = "event_attendees",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var attendees: MutableSet<UserModel> = HashSet()

    @ManyToMany
    @JoinTable(
        name = "event_invitees",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var invitees: MutableSet<UserModel> = HashSet()

    @PrePersist
    fun prePersist() {
        createdAt = LocalDateTime.now()
        updatedAt = LocalDateTime.now()
    }

    @PreUpdate
    fun preUpdate() {
        updatedAt = LocalDateTime.now()
    }



  /*  fun getEsId(): String {
        return eventId.toString()
    }

    fun setEsId(esId: String) {
        eventId = UUID.fromString(esId)
    }*/
}
