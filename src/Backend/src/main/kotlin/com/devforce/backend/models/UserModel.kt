package com.devforce.backend.models

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
    var id: UUID = UUID.randomUUID()

    var fullName: String = ""

    @Column(unique = true)
    var email: String = "" //This is the user email

    var password: String = ""

    private var createdAt: LocalDateTime = LocalDateTime.now()

    private var updatedAt: LocalDateTime = LocalDateTime.now()

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id")
    var role: RoleModel? = null

    @ManyToMany
    @JoinTable(
        name = "saved_events",
        joinColumns = [JoinColumn(name = "user_id")],
        inverseJoinColumns = [JoinColumn(name = "event_id")]
    )
    var savedEvents: Set<UserModel> = HashSet()

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
