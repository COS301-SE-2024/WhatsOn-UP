package com.devforce.analytics.model

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
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "past_events")
class PastEventModel{
    @Id
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null

    var title: String = ""
    var description: String = ""

    @Column(name = "metadata", columnDefinition = "TEXT")
    var metadata: String = ""

    @ElementCollection
    @CollectionTable(name = "event_media", joinColumns = [JoinColumn(name = "event_id")])
    @Column(name = "media_link" , columnDefinition = "TEXT")
    var eventMedia: Set<String> = HashSet()

    @Column(name = "deleted_at", nullable = false, updatable = false)
    private var deletedAt: LocalDateTime = LocalDateTime.now()

    @OneToOne
    @JoinColumn(name = "venue_id")
    var venue: VenueModel? = null

    @OneToOne
    @JoinColumn(name = "event_id")
    var analytics: AnalyticsModel? = null


    @Column(name = "start_date_time", nullable = false)
    var startDateTime: LocalDateTime = LocalDateTime.now()

    @Column(name = "end_date_time", nullable = false)
    var endDateTime: LocalDateTime = LocalDateTime.now()

    @Column(name = "max_attendees", nullable = false)
    var maxAttendees: Int = 0

    @Column(name = "is_private", nullable = false)
    var isPrivate: Boolean = false

    @Column(name = "occupied_slots")
    var availableSlots: Int = 0

    @OneToMany(mappedBy = "event")
    var feedback: MutableList<FeedbackModel> = ArrayList()

    var status: String = ""

    @ManyToMany
    @JoinTable(
        name = "event_hosts",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    var hosts: MutableSet<UserModel> = HashSet()

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
        deletedAt = LocalDateTime.now()
    }



}

