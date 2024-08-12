package cos.gateway.controller

import cos.gateway.config.AuthConfig
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/events")
class EventProxy {

    private val restTemplate = AuthConfig().restTemplate()
    private val targetUrl = "http://localhost:8080/api/events"

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun createEvent(@RequestHeader headers: HttpHeaders, @RequestBody event: Any): ResponseEntity<Any> {
        val entity = HttpEntity(event, headers)
        return restTemplate.exchange("$targetUrl/create", HttpMethod.POST, entity, Any::class.java)
    }

    @GetMapping("/get_all")
    @PreAuthorize("permitAll()")
    fun getAllEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/get_all", HttpMethod.GET, entity, Any::class.java)
    }

    @PutMapping("/update/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun updateEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID, @RequestBody event: Any): ResponseEntity<Any> {
        val entity = HttpEntity(event, headers)
        return restTemplate.exchange("$targetUrl/update/$id", HttpMethod.PUT, entity, Any::class.java)
    }

    @DeleteMapping("/remove/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun deleteEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/remove/$id", HttpMethod.DELETE, entity, Any::class.java)
    }

    @GetMapping("/categories")
    @PreAuthorize("permitAll()")
    fun getUniqueCategories(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/categories", HttpMethod.GET, entity, Any::class.java)
    }

    @GetMapping("/search")
    @PreAuthorize("permitAll()")
    fun searchEvents(
        @RequestHeader headers: HttpHeaders,
        @RequestParam searchString: String
    ): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/search?searchString=$searchString", HttpMethod.GET, entity, Any::class.java)
    }

    @GetMapping("/filterEvents")
    @PreAuthorize("permitAll()")
    fun filterEvents(
        @RequestHeader headers: HttpHeaders,
        @RequestParam(required = false) startDate: String?,
        @RequestParam(required = false) endDate: String?,
        @RequestParam(required = false) minCapacity: Int?,
        @RequestParam(required = false) maxCapacity: Int?,
        @RequestParam(required = false) isPrivate: Boolean?
    ): ResponseEntity<Any> {
        val params = mutableMapOf<String, String?>().apply {
            startDate?.let { put("startDate", it) }
            endDate?.let { put("endDate", it) }
            minCapacity?.let { put("minCapacity", it.toString()) }
            maxCapacity?.let { put("maxCapacity", it.toString()) }
            isPrivate?.let { put("isPrivate", it.toString()) }
        }

        val url = "$targetUrl/filterEvents?" + params.entries.joinToString("&") { "${it.key}=${it.value}" }
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.GET, entity, Any::class.java)
    }

    @GetMapping("/get_passed_events")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun getPassedEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/get_passed_events", HttpMethod.GET, entity, Any::class.java)
    }

    @GetMapping("/get_locations")
    @PreAuthorize("permitAll()")
    fun getLocations(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/get_locations", HttpMethod.GET, entity, Any::class.java)
    }
}
