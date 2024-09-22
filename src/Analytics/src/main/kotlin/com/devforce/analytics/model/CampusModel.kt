package com.devforce.analytics.model

import jakarta.persistence.*
import lombok.*
import java.util.*

@Data
@Builder
@Entity
@Table(name = "campuses")
@NoArgsConstructor
@AllArgsConstructor
class CampusModel {
    @Id
    @Column(name = "campus_id", columnDefinition = "UUID")
    var campusId: UUID? = null

    var name: String = ""
    var location: String = ""
    var parking: Boolean = false
}
