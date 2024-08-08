package com.devforce.backend.model

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.util.*

@Data
@Builder
@Entity
@Table(name = "event_invitees")
@NoArgsConstructor
@AllArgsConstructor
class InviteeModel {

    @Id
    @GeneratedValue
    @Column(name = "invite_id", columnDefinition = "UUID")
    var eventInviteeId: UUID = UUID.randomUUID()

    @ManyToOne
    @JoinColumn(name = "event_id", nullable = false)
    var event: EventModel? = null

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    var user: UserModel? = null

    @ManyToOne
    @JoinColumn(name = "from_id", nullable = false)
    var from: UserModel? = null

    var accepted: Boolean? = null
}