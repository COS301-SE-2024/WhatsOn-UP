package cos.gateway.controller

import org.springframework.beans.factory.annotation.Value
import org.springframework.http.*
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.RestTemplate

@RestController
@RequestMapping("/notifications")
class NotificationProxy {
    private val restTemplate = RestTemplate()

    @Value("\${notifications.service.url:http://localhost:8081/notifications}")
    private lateinit var notificationsServiceUrl: String

    @GetMapping("/get_all")
    @PreAuthorize("isAuthenticated()")
    fun getNotifications(@RequestHeader headers: HttpHeaders): ResponseEntity<*> {

        val url = "$notificationsServiceUrl/get_all"
        val entity = HttpEntity<String>(headers)
        return try {
            val response = restTemplate.exchange(
                url, HttpMethod.GET, entity,
                Any::class.java
            )

            ResponseEntity.ok(response.body)
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("Error fetching notifications: ${e.message}")
        }
    }
}
