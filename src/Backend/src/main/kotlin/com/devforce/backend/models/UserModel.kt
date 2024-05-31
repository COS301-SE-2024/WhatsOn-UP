package com.devforce.backend.models

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
//import org.springframework.security.core.GrantedAuthority
//import org.springframework.security.core.authority.SimpleGrantedAuthority
//import org.springframework.security.core.userdetails.UserDetails
import java.time.LocalDateTime
import java.util.*

@Data
@Builder
@Entity
@Table(name = "`user`")
class UserModel(email: String, password: String){
    constructor() : this("", "") {}

    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID")
    var id: UUID = UUID.randomUUID()

    var firstName: String = ""
    var lastName: String = ""

    @Column(unique = true)
    var email: String = ""

    var password: String = ""

    @Enumerated(EnumType.STRING)
    var role: Role = Role.GENERAL

    var active: Boolean = false

    var createdAt: LocalDateTime = LocalDateTime.now()

    var updatedAt: LocalDateTime = LocalDateTime.now()

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
