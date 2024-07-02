package com.devforce.backend.security

import jakarta.servlet.FilterChain
import jakarta.servlet.ServletException
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.security.SecurityProperties
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import java.io.IOException

@Component
class AuthFilter: OncePerRequestFilter() {

    @Autowired
    private lateinit var customUserDetailsService: CustomUserDetailsService

    @Throws(ServletException::class, IOException::class)
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        // Ignore authentication for specific URL pattern
        val requestURI = request.requestURI
        if (requestURI.endsWith("/api/events/get_all")) {
            filterChain.doFilter(request, response)
            return
        }

        val id = getBearer(request)
        if (id != null) {
            try {
                val userDetails: CustomUser = customUserDetailsService.loadUserByUsername(id)
                val authenticationToken = UsernamePasswordAuthenticationToken(userDetails, null, userDetails.authorities)
                authenticationToken.details = WebAuthenticationDetailsSource().buildDetails(request)
                SecurityContextHolder.getContext().authentication = authenticationToken
            } catch (e: Exception) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid user ID")
                return
            }
        } else {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid user ID")
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

}
