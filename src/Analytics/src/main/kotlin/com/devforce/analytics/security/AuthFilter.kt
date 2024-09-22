package com.devforce.analytics.security

import com.devforce.analytics.dto.ResponseDto
import com.fasterxml.jackson.databind.ObjectMapper
import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureException
import io.jsonwebtoken.ExpiredJwtException
import jakarta.servlet.FilterChain
import jakarta.servlet.ServletException
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import java.io.IOException
import java.util.Date

@Component
class AuthFilter : OncePerRequestFilter() {

    @Value("\${SECRET}")
    private val SECRET: String? = null

    @Autowired
    private lateinit var customUserDetailsService: CustomUserDetailsService

    private val ENDPOINTS: List<String> = listOf(
        "/api/events/get_all",
        "/api/events/filter",
        "/api/events/search",
        "/api/events/categories",
        "/api/events/filterEvents",
        "/api/events/get_locations",
        "/api/user/verify_application"
    )

    @Throws(ServletException::class, IOException::class)
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val requestURI = request.requestURI
        response.setHeader("Access-Control-Allow-Origin", "https://frontend-1035006743185.us-central1.run.app")
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        response.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type")
        response.setHeader("Access-Control-Allow-Credentials", "true")

        if (request.method.equals("OPTIONS", ignoreCase = true)) {
            // Respond with a 200 OK and terminate the filter chain
            response.status = HttpServletResponse.SC_OK
            return
        }

        val jwt = getBearer(request)
        val match = ENDPOINTS.any { suffix -> requestURI.endsWith(suffix) }

        if (match && jwt == null) {
            filterChain.doFilter(request, response)
            return
        }

        if (jwt != null) {
            try {
                val claims = getUserIdFromToken(jwt)
                val userId = claims.subject
                if (claims.expiration.before(Date())) {
                    response.status = HttpServletResponse.SC_UNAUTHORIZED
                    response.contentType = "application/json"
                    val responseDto = ResponseDto("error", Date().time, "Token expired")
                    response.writer.write(ObjectMapper().writeValueAsString(responseDto))
                    return
                }

                val userDetails = customUserDetailsService.loadUserByUsername(userId)
                val authenticationToken = UsernamePasswordAuthenticationToken(userDetails, null, userDetails.authorities)
                authenticationToken.details = WebAuthenticationDetailsSource().buildDetails(request)
                SecurityContextHolder.getContext().authentication = authenticationToken
            } catch (e: ExpiredJwtException) {
                response.status = HttpServletResponse.SC_UNAUTHORIZED
                response.contentType = "application/json"
                val responseDto = ResponseDto("error", Date().time, "Token expired")
                response.writer.write(ObjectMapper().writeValueAsString(responseDto))
                return
            } catch (e: SignatureException) {
                response.status = HttpServletResponse.SC_UNAUTHORIZED
                response.contentType = "application/json"
                val responseDto = ResponseDto("error", Date().time, "Invalid token signature")
                response.writer.write(ObjectMapper().writeValueAsString(responseDto))
                return
            } catch (e: Exception) {
                response.status = HttpServletResponse.SC_UNAUTHORIZED
                response.contentType = "application/json"
                val responseDto = ResponseDto("error", Date().time, "Invalid token")
                response.writer.write(ObjectMapper().writeValueAsString(responseDto))
                return
            }
        } else {
            response.status = HttpServletResponse.SC_UNAUTHORIZED
            response.contentType = "application/json"
            val responseDto = ResponseDto("error", Date().time, "Token not provided")
            response.writer.write(ObjectMapper().writeValueAsString(responseDto))
            return
        }

        filterChain.doFilter(request, response)
    }

    private fun getBearer(request: HttpServletRequest): String? {
        val authorizationHeader = request.getHeader("Authorization")
        return if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            authorizationHeader.substring(7)
        } else null
    }

    fun getUserIdFromToken(jwtToken: String): Claims {
        return Jwts.parser()
            .setSigningKey(SECRET?.toByteArray())
            .parseClaimsJws(jwtToken)
            .body
    }
}
