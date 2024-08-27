package com.devforce.backend.model

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.Id
import jakarta.persistence.JoinColumn
import jakarta.persistence.ManyToOne
import jakarta.persistence.Table
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.util.UUID

@Data
@Builder
@Entity
@Table(name = "feedback")
@NoArgsConstructor
@AllArgsConstructor
class FeedbackModel {

    @Column(name = "feedback_id", columnDefinition = "UUID")
    @Id
    @GeneratedValue
    var feedbackId: UUID? = null

    @ManyToOne
    @JoinColumn(name = "user_id")
    var user: UserModel? = null

    @ManyToOne
    @JoinColumn(name = "event_id")
    var event: EventModelAll? = null

    @Column(name = "rating")
    var rating: Int? = null

    @Column(name = "comment", columnDefinition = "TEXT")
    var comment: String? = null

}