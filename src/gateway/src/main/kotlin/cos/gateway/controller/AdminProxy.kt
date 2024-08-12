package cos.gateway.controller

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
@RequestMapping("/api/admin")
@PreAuthorize("hasAnyRole('ADMIN')")
class AdminProxy {

    private val restTemplate = RestTemplate()

    @Value("\${admin.service.url:http://localhost:8085/api/admin}")
    private lateinit var adminServiceUrl: String

    @PostMapping("/promote")
    fun promoteUser(@RequestHeader headers: HttpHeaders, @RequestParam userId: UUID): ResponseEntity<Any> {
        val url = "$adminServiceUrl/promote?userId=$userId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.POST, entity, Any::class.java)
    }

    @PostMapping("/demote")
    fun demoteUser(@RequestHeader headers: HttpHeaders, @RequestParam userId: UUID): ResponseEntity<Any> {
        val url = "$adminServiceUrl/demote?userId=$userId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.POST, entity, Any::class.java)
    }

    @DeleteMapping("/delete_user")
    fun deleteUser(@RequestHeader headers: HttpHeaders, @RequestParam userId: UUID): ResponseEntity<Any> {
        val url = "$adminServiceUrl/delete_user?userId=$userId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.DELETE, entity, Any::class.java)
    }

    @PostMapping("/accept_application")
    fun acceptApplication(@RequestHeader headers: HttpHeaders, @RequestParam applicationId: UUID): ResponseEntity<Any> {
        val url = "$adminServiceUrl/accept_application?applicationId=$applicationId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.POST, entity, Any::class.java)
    }

    @PostMapping("/reject_application")
    fun rejectApplication(@RequestHeader headers: HttpHeaders, @RequestParam applicationId: UUID): ResponseEntity<Any> {
        val url = "$adminServiceUrl/reject_application?applicationId=$applicationId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.POST, entity, Any::class.java)
    }

    @GetMapping("/all_applications")
    fun allApplications(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$adminServiceUrl/all_applications", HttpMethod.GET, entity, Any::class.java)
    }

    @GetMapping("/all_applications/{status}")
    fun allApplications(@RequestHeader headers: HttpHeaders, @PathVariable status: String): ResponseEntity<Any> {
        // Validate the status
        val validStatuses = listOf("PENDING", "ACCEPTED", "REJECTED", "ACKNOWLEDGED", "DISPUTED", "VERIFIED")
        if (!validStatuses.contains(status)) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invalid status"))
        }

        val url = "$adminServiceUrl/all_applications/$status"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.GET, entity, Any::class.java)
    }
}
