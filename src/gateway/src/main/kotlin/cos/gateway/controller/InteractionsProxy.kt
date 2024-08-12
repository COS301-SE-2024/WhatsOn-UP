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
@RequestMapping("/api/interactions")
class InteractionsProxy {

    private val restTemplate = RestTemplate()

    @Value("\${interactions.service.url:http://localhost:8085/api/interactions}")
    private lateinit var interactionsServiceUrl: String

    @GetMapping("/get_all_users")
    @PreAuthorize("isAuthenticated()")
    fun getAllUsers(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$interactionsServiceUrl/get_all_users", HttpMethod.GET, entity, Any::class.java)
    }

    @PutMapping("/send_invite")
    @PreAuthorize("isAuthenticated()")
    fun inviteUser(@RequestHeader headers: HttpHeaders, @RequestParam eventId: UUID, @RequestParam userId: UUID): ResponseEntity<Any> {
        val url = "$interactionsServiceUrl/send_invite?eventId=$eventId&userId=$userId"
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.PUT, entity, Any::class.java)
    }

    @PostMapping("/accept_invite/{id}")
    @PreAuthorize("isAuthenticated()")
    fun acceptInvite(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$interactionsServiceUrl/accept_invite/$id", HttpMethod.POST, entity, Any::class.java)
    }

    @PostMapping("/reject_invite/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rejectInvite(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$interactionsServiceUrl/reject_invite/$id", HttpMethod.POST, entity, Any::class.java)
    }
}
