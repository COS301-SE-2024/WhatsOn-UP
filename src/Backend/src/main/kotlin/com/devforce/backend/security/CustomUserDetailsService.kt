package com.devforce.backend.security

import com.devforce.backend.repo.UserRepo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service

@Service
class CustomUserDetailsService: UserDetailsService {

    @Autowired
    lateinit var userRepo: UserRepo

    override fun loadUserByUsername(email: String): UserDetails {
        val user = userRepo.findByEmail(email)
            ?: throw UsernameNotFoundException("User not found")

        val roleName = user.role?.name ?: "GENERAL"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        return User(user.email, user.password, authorities)
    }
}
