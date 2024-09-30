package com.devforce.analytics.config

import com.devforce.analytics.security.CustomUserDetailsService
import com.devforce.analytics.security.AuthFilter
import com.devforce.analytics.security.EntryPoint
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.invoke
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
class AuthConfig {

    @Autowired
    lateinit var entryPoint: EntryPoint

    @Autowired
    lateinit var customUserDetailsService: CustomUserDetailsService

    @Bean
    @Throws(Exception::class)
    fun defaultSecurityFilterChain(http: HttpSecurity): SecurityFilterChain {
        http {
            httpBasic {}
            sessionManagement {
                sessionCreationPolicy = SessionCreationPolicy.STATELESS
            }
            exceptionHandling {
                authenticationEntryPoint = entryPoint
            }
            cors {
                configurationSource = corsConfigurationSource()

            }
            csrf {
                disable()
            }
        }
        http.addFilterBefore(authFilter(), UsernamePasswordAuthenticationFilter::class.java)
        return http.build()
    }

    @Bean
    @Throws(Exception::class)
    fun authenticationManager(authenticationConfiguration: AuthenticationConfiguration): AuthenticationManager {
        return authenticationConfiguration.authenticationManager
    }

    @Bean
    fun passwordEncoder(): PasswordEncoder {
        return BCryptPasswordEncoder()
    }

    @Bean
    fun authFilter(): AuthFilter {
        return AuthFilter()
    }

    @Bean
    fun corsConfigurationSource(): CorsConfigurationSource {
        val configuration = CorsConfiguration().apply {
            allowedOrigins = mutableListOf("https://frontend-1035006743185.us-central1.run.app")
            allowedMethods = mutableListOf("GET", "POST", "PUT", "DELETE", "OPTIONS")
            allowedHeaders = mutableListOf("Content-Type", "Authorization", "X-Requested-With", "Accept", "access-control-allow-origin")
            exposedHeaders = mutableListOf("Authorization", "Content-Disposition")
            allowCredentials = true
            maxAge = 3600L  // Cache preflight response for 1 hour to reduce preflight requests
        }

        val source = UrlBasedCorsConfigurationSource()
        source.registerCorsConfiguration("/**", configuration)
        return source
    }


}
