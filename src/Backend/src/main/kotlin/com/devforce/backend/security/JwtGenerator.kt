package com.devforce.backend.security

import com.devforce.backend.ApplicationConstants.EXPIRY
import com.devforce.backend.ApplicationConstants.SECRET
import com.devforce.backend.repo.UserRepo
import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import java.util.*

@Component
class JwtGenerator {

    @Autowired
    lateinit var userRepo: UserRepo

    fun generateToken(email: String, role: String): Map<String, String> {
        val currentDate = Date()
        val expirationDate = Date(currentDate.time + EXPIRY)
        val refreshToken = UUID.randomUUID().toString()

        val token = Jwts.builder()
            .setSubject(email)
            .claim("role", role)
            .setIssuedAt(currentDate)
            .setExpiration(expirationDate)
            .signWith(io.jsonwebtoken.SignatureAlgorithm.HS512, SECRET)
            .compact()


        return mapOf("jwtToken" to token, "refreshToken" to refreshToken)
    }



    fun validateToken(jwtToken: String): Boolean {
        return try {
            val claims: Claims = Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(jwtToken)
                .body

            claims.expiration.after(Date())
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