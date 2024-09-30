import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.security.AuthFilter
import com.devforce.backend.security.CustomUserDetailsService
import com.fasterxml.jackson.databind.ObjectMapper
import io.github.cdimascio.dotenv.Dotenv
import io.jsonwebtoken.Claims
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.SignatureException
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.ArgumentMatchers.anyString
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.MockitoAnnotations
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.setup.MockMvcBuilders
import java.util.*

class AuthFilterTest {

    private lateinit var mockMvc: MockMvc

    @InjectMocks
    private lateinit var authFilter: AuthFilter

    @Mock
    private lateinit var customUserDetailsService: CustomUserDetailsService

    @Mock
    private lateinit var filterChain: FilterChain

    @Mock
    private lateinit var request: HttpServletRequest

    @Mock
    private lateinit var response: HttpServletResponse

    @Value("\${SECRET}")
    private val SECRET: String? = null

    @Value("\${BEARER_TOKEN}")
    private val bearerToken: String? = null

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)
        mockMvc = MockMvcBuilders.standaloneSetup(authFilter).build()
    }

    @Test
    fun `should set CORS headers for all requests`() {
        // Simulate a GET request
        Mockito.`when`(request.method).thenReturn("OPTIONS")
        Mockito.`when`(request.requestURI).thenReturn("/")

        authFilter.doFilterInternal(request, response, filterChain)

        Mockito.verify(response).setHeader("Access-Control-Allow-Origin", "https://frontend-1035006743185.us-central1.run.app")
        Mockito.verify(response).setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        Mockito.verify(response).setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type")
        Mockito.verify(response).setHeader("Access-Control-Allow-Credentials", "true")

        Mockito.verify(response).status = HttpServletResponse.SC_OK
    }


    @Test
    fun `should allow access to endpoints without JWT if it matches any public endpoint`() {
        Mockito.`when`(request.requestURI).thenReturn("/api/events/get_all")
        Mockito.`when`(request.method).thenReturn("GET")
//        Mockito.`when`(request.getHeader("Authorization")).thenReturn(null)

        authFilter.doFilterInternal(request, response, filterChain)

        Mockito.verify(filterChain).doFilter(request, response)
    }

    @Test
    fun `should return UNAUTHORIZED if JWT is not provided for protected endpoints`() {
        Mockito.`when`(request.requestURI).thenReturn("/api/events/protected")
        Mockito.`when`(request.method).thenReturn("GET")
        Mockito.`when`(response.writer).thenReturn(Mockito.mock(java.io.PrintWriter::class.java))

        authFilter.doFilterInternal(request, response, filterChain)

        Mockito.verify(response).status = HttpServletResponse.SC_UNAUTHORIZED
        Mockito.verify(response).contentType = "application/json"
    }


    companion object {
        @JvmStatic
        @BeforeAll
        fun globalSetUp(): Unit {  // Rename the method to avoid conflict
            val dotenv: Dotenv = Dotenv.load()

            System.setProperty("DB_USERNAME", dotenv["DB_USERNAME"])
            System.setProperty("MAIL_PASSWORD", dotenv["MAIL_PASSWORD"])
            System.setProperty("MAIL_USERNAME", dotenv["MAIL_USERNAME"])
            System.setProperty("SECRET", dotenv["SECRET"])

            System.setProperty("CORS_ORIGINS", dotenv["CORS_ORIGINS"])
            System.setProperty("DB_PASSWORD", dotenv["DB_PASSWORD"])
            System.setProperty("DB_URL", dotenv["DB_URL"])
            System.setProperty("BEARER_TOKEN", dotenv["BEARER_TOKEN"])
        }
    }


}
