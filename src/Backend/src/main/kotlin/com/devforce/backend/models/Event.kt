package com.devforce.backend.event

import com.devforce.backend.models.User
import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.time.LocalDateTime
import java.util.*

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "event")
class Event {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID")
    var id: UUID = UUID.randomUUID()

    var name: String = ""
    var description: String = ""
    var metadata: String = "" // You can store metadata/tags as a JSON string or any other appropriate format

    @ElementCollection
    @CollectionTable(name = "event_media", joinColumns = [JoinColumn(name = "event_id")])
    @Column(name = "media_link")
    var eventMedia: List<String> = ArrayList()

    var createdAt: LocalDateTime = LocalDateTime.now()
    var updatedAt: LocalDateTime = LocalDateTime.now()

    @ManyToOne
    @JoinColumn(name = "host_id")
    var host: User? = null

    var location: String = ""
    var startTime: LocalDateTime = LocalDateTime.now()
    var endTime: LocalDateTime = LocalDateTime.now()

    var maxAttendees: Int = 0
    var isPrivate: Boolean = false

    @ManyToOne
    @JoinColumn(name = "creator_id")
    var creator: User? = null

    @ManyToMany
    @JoinTable(
        name = "event_attendees",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var attendees: Set<User> = HashSet()

    @ManyToMany
    @JoinTable(
        name = "event_invitees",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var invitees: Set<User> = HashSet()

    @PrePersist
    fun prePersist() {
        createdAt = LocalDateTime.now()
        updatedAt = LocalDateTime.now()
    }

    @PreUpdate
    fun preUpdate() {
        updatedAt = LocalDateTime.now()
    }
}
