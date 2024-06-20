package com.devforce.backend.security

import com.devforce.backend.ApplicationConstants.EXPIRY
import com.devforce.backend.ApplicationConstants.SECRET
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.repo.jpa.UserRepo
import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.stereotype.Component
import java.util.*

@Component
class JwtGenerator {

    @Autowired
    lateinit var userRepo: UserRepo

    fun generateToken(authentication: Authentication): ResponseDto {
        val email = authentication.name
        val userDetails = authentication.principal as UserDetails
        val role = userDetails.authorities.firstOrNull()?.authority ?: "" // Get the first role
        val currentDate = Date()
        val expirationDate = Date(currentDate.time + EXPIRY)
        val refreshToken = UUID.randomUUID().toString()

        val token = Jwts.builder()
            .setSubject(email)
            .claim("role", role) // Include role as a custom claim
            .setIssuedAt(currentDate)
            .setExpiration(expirationDate)
            .signWith(io.jsonwebtoken.SignatureAlgorithm.HS512, SECRET)
            .compact()

        val user = userRepo.findByEmail(email)
        if (user != null) {
            user.jwtToken = token
            user.refreshToken = refreshToken
            userRepo.save(user)
        }

        return ResponseDto("success", System.currentTimeMillis(), mapOf("jwtToken" to token, "refreshToken" to refreshToken))
    }

    fun checkExpiry(jwtToken: String): Boolean {
        val claims: Claims = Jwts.parser()
            .setSigningKey(SECRET)
            .parseClaimsJws(jwtToken)
            .body

        return claims.expiration.after(Date())
    }

    fun refreshToken(jwtToken: String, refreshToken: String): ResponseDto {
        return try {
            val claims: Claims = Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(jwtToken)
                .body

            val email = claims.subject
            val user = userRepo.findByEmailAndJwtTokenAndRefreshToken(email, jwtToken, refreshToken)

            if (user != null && email == user.email) {
                val role = claims["role"] as? String ?: ""
                val newRefreshToken = UUID.randomUUID().toString()

                // Generate a new JWT with the updated refresh token
                val currentDate = Date()
                val expirationDate = Date(currentDate.time + EXPIRY)
                val newToken = Jwts.builder()
                    .setSubject(email)
                    .claim("role", role) // Include role as a custom claim
                    .setIssuedAt(currentDate)
                    .setExpiration(expirationDate)
                    .signWith(io.jsonwebtoken.SignatureAlgorithm.HS512, SECRET)
                    .compact()

                // Update the refresh token in the database
                user.refreshToken = newRefreshToken
                user.jwtToken = newToken
                userRepo.save(user)

                ResponseDto("success", System.currentTimeMillis(), mapOf("jwtToken" to newToken, "refreshToken" to newRefreshToken))
            } else {
                ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Invalid token"))
            }
        } catch (e: Exception) {
            ResponseDto("error", System.currentTimeMillis(), mapOf("message" to "Error refreshing token: ${e.message}"))
        }
    }


    fun validateToken(jwtToken: String): Boolean {
        return try {
            val claims: Claims = Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(jwtToken)
                .body

            val email = claims.subject
            val user = userRepo.findByEmailAndJwtToken(email, jwtToken)

            if (user != null && email == user.email) {
                claims.expiration.after(Date())
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }


    fun getUsernameFromToken(jwtToken: String): String {
        val claims: Claims = Jwts.parser()
            .setSigningKey(SECRET)
            .parseClaimsJws(jwtToken)
            .body

        return claims.subject
    }





}