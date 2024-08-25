package com.devforce.backend.model

import jakarta.persistence.*

@Entity
@Table(name = "roles")
class RoleModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column(unique = true)
    var name: String = ""
}