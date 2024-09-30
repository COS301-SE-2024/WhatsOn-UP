package com.devforce.backend.security

import com.devforce.backend.repo.UserRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service
import java.util.UUID

@Service
class CustomUserDetailsService: UserDetailsService {

    @Autowired
    lateinit var userRepo: UserRepo

    override fun loadUserByUsername(id: String): CustomUser {
        val uuid: UUID = try {
            UUID.fromString(id)
        } catch (e: IllegalArgumentException) {
            throw IllegalArgumentException("Invalid UUID string: $id")
        }

        val user = userRepo.findByUserId(uuid)
            ?: throw UsernameNotFoundException("User not found")

        val roleName = "ROLE_"+ user.role!!.name
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        return CustomUser(user.userId, authorities, user)
    }
}
