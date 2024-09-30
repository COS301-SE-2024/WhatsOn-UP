package com.devforce.backend.model

import jakarta.persistence.*
import lombok.*
import java.util.*

@Data
@Builder
@Entity
@Table(name = "buildings")
@NoArgsConstructor
@AllArgsConstructor
class BuildingModel {
    @Id
    @Column(name = "building_id", columnDefinition = "UUID")
    var buildingId: UUID? = null

    var name: String = ""
    var accessType: String = ""
    var location: String = ""

    @ManyToOne
    @JoinColumn(name = "campus_id")
    var campus: CampusModel? = null

}
