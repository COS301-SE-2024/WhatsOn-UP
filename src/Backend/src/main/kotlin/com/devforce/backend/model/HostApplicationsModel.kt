package com.devforce.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.*;


enum class Status {
    PENDING,
    ACCEPTED,
    REJECTED,
    ACKNOWLEDGED,
    DISPUTED
}


@Data
@Builder
@Entity
@Table(name = "host_applications")
@NoArgsConstructor
@AllArgsConstructor
class HostApplicationsModel {
    @Id
    @Column(name = "application_id", columnDefinition = "UUID")
    var applicationId: UUID? = null

    @Enumerated(EnumType.STRING)
    @Column(name = "status", columnDefinition = "event_status")
    var status: Status = Status.PENDING

    @OneToOne
    @JoinColumn(name = "user_id")
    var user: UserModel? = null

    @Column(name = "expiry_date_time")
    var expiryDateTime: Date = Date()


    @OneToOne
    @JoinColumn(name = "accepted_rejected_by")
    var acceptedRejectedBy: UserModel? = null

    @Column(name = "how_long")
    var howLong: Int = 0

    var reason: String = ""

    @Column(name = "verification_code")
    var verificationCode: UUID = UUID.randomUUID()
}
