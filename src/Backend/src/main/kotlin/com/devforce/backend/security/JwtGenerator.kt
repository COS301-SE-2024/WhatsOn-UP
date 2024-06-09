package com.devforce.backend.security

import com.devforce.backend.ApplicationConstants.EXPIRY
import com.devforce.backend.ApplicationConstants.SECRET
import io.jsonwebtoken.Jwts
import org.springframework.security.core.Authentication
import org.springframework.stereotype.Component
import java.util.*

@Component
class JwtGenerator {
    fun generateToken(authentication: Authentication): String{
        val email = authentication.name
        val currentDate = Date()
        val expirationDate = Date(currentDate.time + EXPIRY)
        val token = Jwts.builder()
            .setSubject(email)
            .setIssuedAt(currentDate)
            .setExpiration(expirationDate)
            .signWith(io.jsonwebtoken.SignatureAlgorithm.HS512, SECRET)
            .compact()
        return  token
    }

    fun getUsernameFromToken(token: String): String{
        return Jwts.parser()
            .setSigningKey(SECRET)
            .parseClaimsJws(token)
            .body
            .subject
    }

    fun validateToken(token: String): Boolean{
        return try {
            val claims = Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(token)
            !claims.body.expiration.before(Date())
        } catch (e: Exception){
            false
        }
    }

    fun refreshToken(token: String): String{
        val claims = Jwts.parser()
            .setSigningKey(SECRET)
            .parseClaimsJws(token)
        val currentDate = Date()
        val expirationDate = Date(currentDate.time + EXPIRY)
        return Jwts.builder()
            .setClaims(claims.body)
            .setIssuedAt(currentDate)
            .setExpiration(expirationDate)
            .signWith(io.jsonwebtoken.SignatureAlgorithm.HS512, SECRET)
            .compact()
    }
}