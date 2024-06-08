package com.devforce.backend.security

import com.devforce.backend.repos.UserRepo
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
        val user = userRepo.findByUsername(email)
            ?: throw UsernameNotFoundException("User not found")
        val authorities = user.roles.map { SimpleGrantedAuthority(it.name) }
        return User(user.username, user.password, authorities)
    }
}
