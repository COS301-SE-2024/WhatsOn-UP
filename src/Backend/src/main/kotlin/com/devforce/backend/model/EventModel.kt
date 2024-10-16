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
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "events")
class EventModel{
    @Id
    @Column(name = "event_id", columnDefinition = "UUID")
    var eventId: UUID? = null

    @Column(name = "code", nullable = false)
    var code: String? = ""

    @Column(name = "recurring")
    var recurring: Int? = 0

    var title: String = ""
    var description: String = ""

    @Column(name = "metadata", columnDefinition = "TEXT")
    var metadata: String = ""

    @ElementCollection
    @CollectionTable(name = "event_media", joinColumns = [JoinColumn(name = "event_id")])
    @Column(name = "media_link" , columnDefinition = "TEXT")
    var eventMedia: List<String> = ArrayList()

    @Column(name = "created_at", updatable = false)
    private var createdAt: LocalDateTime = LocalDateTime.now()

    @Column(name = "updated_at")
    private var updatedAt: LocalDateTime = LocalDateTime.now()

    @OneToOne
    @JoinColumn(name = "created_by")
    var createdBy: UserModel? = null

    @OneToOne
    @JoinColumn(name = "updated_by")
    var updatedBy: UserModel? = null

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

    @Column(name = "available_slots")
    var availableSlots: Int = 0

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
        createdAt = LocalDateTime.now()
        updatedAt = LocalDateTime.now()
    }


    @PreUpdate
    fun preUpdate() {
        updatedAt = LocalDateTime.now()
    }





}

