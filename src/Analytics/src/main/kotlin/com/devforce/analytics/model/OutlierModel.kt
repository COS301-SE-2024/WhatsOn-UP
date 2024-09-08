package com.devforce.analytics.model
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.Id
import jakarta.persistence.JoinColumn
import jakarta.persistence.ManyToOne
import jakarta.persistence.OneToOne
import jakarta.persistence.Table
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import java.util.UUID

@Data
@Builder
@Entity
@Table(name = "outliers")
@NoArgsConstructor
@AllArgsConstructor
class OutlierModel {

    @Column(name = "feedback_id", columnDefinition = "UUID")
    @Id
    @GeneratedValue
    var feedbackId: UUID? = null

    @OneToOne
    @JoinColumn(name = "feedback_id")
    var feedback: FeedbackModel? = null

    @ManyToOne
    @JoinColumn(name = "event_id")
    var event: PastEventModel? = null

}