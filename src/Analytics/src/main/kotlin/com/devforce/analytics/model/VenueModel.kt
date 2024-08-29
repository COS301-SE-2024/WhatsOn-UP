package com.devforce.analytics.model

import jakarta.persistence.*
import lombok.*
import java.util.*

@Data
@Builder
@Entity
@Table(name = "venues")
@NoArgsConstructor
@AllArgsConstructor
class VenueModel {
    @Id
    @Column(name = "venue_id", columnDefinition = "UUID")
    var venueId: UUID? = null

    @ManyToOne
    @JoinColumn(name = "building_id")
    var building: BuildingModel? = null

    var name: String = ""
    var boards: String? = null
    var ac: Boolean = false
    var wifi: Boolean = false
    var dataProject: Int = 0
    var docCam: Boolean = false
    var mic: Boolean = false
    var windows: Boolean = false
    var capacity: Int = 0
    var available: Boolean = false
}
