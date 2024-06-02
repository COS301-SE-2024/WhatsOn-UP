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

    var name: String = ""

    @Column(unique = true)
    var email: String = ""

    var password: String = ""

    @Enumerated(EnumType.STRING)
    var role: Role = Role.GENERAL

    var active: Boolean = false

    var createdAt: LocalDateTime = LocalDateTime.now()

    var updatedAt: LocalDateTime = LocalDateTime.now()

    @ManyToMany
    @JoinTable(
        name = "saved_events",
        joinColumns = [JoinColumn(name = "event_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
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

//    override fun getAuthorities(): MutableCollection<out GrantedAuthority> {
//        return listOf(SimpleGrantedAuthority("ROLE_${role.name}")).toMutableList()
//    }
//
//    override fun getUsername(): String {
//        return email
//    }
//
//    override fun getPassword(): String {
//        return user_password
//    }
}
