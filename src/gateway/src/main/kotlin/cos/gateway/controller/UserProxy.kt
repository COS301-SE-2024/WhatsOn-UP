import cos.gateway.dto.ResponseDto
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import org.springframework.web.client.RestTemplate
import java.util.*

@RestController
@RequestMapping("/api/user")
class UserProxy {

    private val restTemplate = RestTemplate()

    @Value("\${user.service.url:http://localhost:8085/api/user}")
    private lateinit var userServiceUrl: String

    @PutMapping("/save_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun saveEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/save_event/$id", HttpMethod.PUT, entity, ResponseDto::class.java)
    }

    @DeleteMapping("/delete_saved_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteSavedEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/delete_saved_event/$id", HttpMethod.DELETE, entity, ResponseDto::class.java)
    }

    @GetMapping("/get_saved_events")
    @PreAuthorize("isAuthenticated()")
    fun getSavedEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/get_saved_events", HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @PutMapping("/rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rspvEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/rspv_event/$id", HttpMethod.PUT, entity, ResponseDto::class.java)
    }

    @GetMapping("/get_rspv_events")
    @PreAuthorize("isAuthenticated()")
    fun getRspvEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/get_rspv_events", HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @DeleteMapping("/delete_rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteRspvEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/delete_rspv_event/$id", HttpMethod.DELETE, entity, ResponseDto::class.java)
    }

    @PutMapping("/update_profile")
    @PreAuthorize("isAuthenticated()")
    fun updateProfile(@RequestHeader headers: HttpHeaders, @RequestParam fullName: String): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/update_profile?fullName=$fullName", HttpMethod.PUT, entity, ResponseDto::class.java)
    }

    @GetMapping("/get_user")
    @PreAuthorize("isAuthenticated()")
    fun getUser(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/get_user", HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @DeleteMapping("/delete_user")
    @PreAuthorize("isAuthenticated()")
    fun deleteUser(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$userServiceUrl/delete_user", HttpMethod.DELETE, entity, ResponseDto::class.java)
    }

    @PutMapping("/apply_for_host")
    @PreAuthorize("isAuthenticated()")
    fun applyHost(
        @RequestHeader headers: HttpHeaders,
        @RequestParam howLong: Int,
        @RequestParam reason: String,
        @RequestParam studentEmail: String?,
        @RequestParam fromWhen: String,
    ): ResponseEntity<ResponseDto> {
        val url = "$userServiceUrl/apply_for_host?howLong=$howLong&reason=$reason&studentEmail=$studentEmail&fromWhen=$fromWhen"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.PUT, entity, ResponseDto::class.java)
    }

    @PostMapping("/acknowledge_application")
    @PreAuthorize("isAuthenticated()")
    fun acknowledgeApplication(@RequestHeader headers: HttpHeaders, @RequestParam applicationId: UUID): ResponseEntity<ResponseDto> {
        val url = "$userServiceUrl/acknowledge_application?applicationId=$applicationId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.POST, entity, ResponseDto::class.java)
    }

    @PostMapping("/dispute_application")
    @PreAuthorize("isAuthenticated()")
    fun disputeApplication(@RequestHeader headers: HttpHeaders, @RequestParam applicationId: UUID): ResponseEntity<ResponseDto> {
        val url = "$userServiceUrl/dispute_application?applicationId=$applicationId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.POST, entity, ResponseDto::class.java)
    }

    @GetMapping("/verify_application")
    @PreAuthorize("permitAll()")
    fun verifyApplication(@RequestHeader headers: HttpHeaders, @RequestParam veriCode: UUID): ResponseEntity<String> {
        val url = "$userServiceUrl/verify_application?veriCode=$veriCode"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.GET, entity, String::class.java)
    }
}