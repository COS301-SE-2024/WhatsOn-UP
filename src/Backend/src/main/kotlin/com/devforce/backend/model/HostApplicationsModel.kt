package com.devforce.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime
import java.util.*;


@Data
@Builder
@Entity
@Table(name = "host_applications")
@NoArgsConstructor
@AllArgsConstructor
class HostApplicationsModel {
    @Id
    @GeneratedValue
    @Column(name = "application_id", columnDefinition = "UUID")
    var applicationId: UUID? = null

    @ManyToOne
    @JoinColumn(name = "status_id")
    var status: ApplicationStatusModel? = null

    @OneToOne
    @JoinColumn(name = "user_id")
    var user: UserModel? = null

    @Column(name = "expiry_date_time")
    var expiryDateTime: LocalDateTime? = null


    @OneToOne
    @JoinColumn(name = "accepted_rejected_by")
    var acceptedRejectedBy: UserModel? = null

    var reason: String = ""

    @Column(name = "verification_code")
    var verificationCode: UUID? = null

}
