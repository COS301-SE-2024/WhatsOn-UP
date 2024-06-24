package com.devforce.backend.model

import jakarta.persistence.*
import lombok.Builder
import lombok.Data
import java.time.LocalDateTime
import java.util.*

@Data
@Builder
@Entity
@Table(name = "`user`")
class UserModel{

    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID")
    var userId: UUID = UUID.randomUUID()

    var fullName: String = ""

    @Column(unique = true)
    var email: String = "" //This is the user email

    var password: String = ""

    private var createdAt: LocalDateTime = LocalDateTime.now()

    private var updatedAt: LocalDateTime = LocalDateTime.now()

    var jwtToken: String = ""
    var refreshToken: String = ""

    @Column(columnDefinition = "TEXT")
    var profileImage: String = ""

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id")
    var role: RoleModel? = null

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
