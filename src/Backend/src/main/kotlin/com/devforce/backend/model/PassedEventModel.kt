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
@Table(name = "passed_events")
@NoArgsConstructor
@AllArgsConstructor

class PassedEventModel {
    @Id
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null

    var title: String = ""
    var description: String = ""

    var metadata: String = "" //changed from  var metadata: String = ""

    var status: String = ""

    @ElementCollection
    @CollectionTable(name = "event_media", joinColumns = [JoinColumn(name = "event_id")])
    @Column(name = "media_link" , columnDefinition = "TEXT")
    var eventMedia: List<String> = ArrayList()

    @Column(name = "created_at", nullable = false, updatable = false)
    private var createdAt: LocalDateTime = LocalDateTime.now()


    @OneToOne
    @JoinColumn(name = "venue_id")
    var venue: VenueModel? = null


    @Column(name = "start_date_time", nullable = false)
    var startDateTime: LocalDateTime = LocalDateTime.now()

    @Column(name = "end_date_time", nullable = false)
    var endDateTime: LocalDateTime = LocalDateTime.now()

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

    @ManyToMany
    @JoinTable(
        name = "saved_events",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var savedEvents: MutableSet<UserModel> = HashSet()

    @PrePersist
    fun prePersist() {
        createdAt = LocalDateTime.now()
    }




}
