import com.devforce.backend.dto.LoginDto
import com.devforce.backend.dto.RegisterDto
import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.UserModel
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.JwtGenerator
import com.devforce.backend.service.AuthService
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.ArgumentMatchers.anyString
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.crypto.password.PasswordEncoder
import javax.naming.AuthenticationException

@ExtendWith(MockitoExtension::class)
class AuthServiceTests {

    @Mock
    lateinit var authenticationManager: AuthenticationManager

    @Mock
    lateinit var userRepo: UserRepo

    @Mock
    lateinit var passwordEncoder: PasswordEncoder

    @Mock
    lateinit var jwtGenerator: JwtGenerator

    @InjectMocks
    lateinit var authService: AuthService

    @Test
    fun `test registerUser success`() {
        // Mock data
        val registerDto = RegisterDto("test@example.com", "password", "Test User")

        // Mock behavior of userRepo and jwtGenerator
        `when`(userRepo.findByEmail(registerDto.email)).thenReturn(null)
        `when`(passwordEncoder.encode(registerDto.password)).thenReturn("encodedPassword")
        `when`(jwtGenerator.generateToken(anyString(), anyString())).thenReturn(mapOf("jwtToken" to "mockJwt", "refreshToken" to "mockRefresh"))

        // Execute the method
        val response = authService.registerUser(registerDto)

        assertEquals("success", response.body!!.status)
    }

    @Test
    fun `test registerUser error`() {
        // Mock data
        val registerDto = RegisterDto("test@example.com", "password", "Test User")

        // Mock behavior of userRepo and jwtGenerator
        `when`(userRepo.findByEmail(registerDto.email)).thenReturn(UserModel())
        `when`(passwordEncoder.encode(registerDto.password)).thenReturn("encodedPassword")
        `when`(jwtGenerator.generateToken(anyString(), anyString())).thenReturn(mapOf("jwtToken" to "mockJwt", "refreshToken" to "mockRefresh"))

        // Execute the method
        val response = authService.registerUser(registerDto)

        assertEquals("error", response.body!!.status)
    }

    @Test
    fun `test loginUser with authentication exception`() {
        // Mock data
        val loginDto = LoginDto("test@example.com", "password")

        // Mock behavior of userRepo
        `when`(userRepo.findByEmail(loginDto.email)).thenThrow(AuthenticationException("Authentication failed"))

        // Execute the method
        val response = authService.loginUser(loginDto)

        // Assert the response
        assertEquals(HttpStatus.UNAUTHORIZED, response.statusCode)
        assertEquals("error", response.body!!.status)
    }


}
