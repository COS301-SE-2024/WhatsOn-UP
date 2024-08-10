package cos.gateway

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
class GatewayController {

    private val restTemplate = AuthConfig().restTemplate()
    private val targetUrl = "http://localhost:8085/api/events"

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun createEvent(@RequestHeader headers: HttpHeaders, @RequestBody event: Any): ResponseEntity<Any> {
        val entity = HttpEntity(event, headers)
        return restTemplate.exchange("$targetUrl/create", HttpMethod.POST, entity, Any::class.java)
    }

    @GetMapping("/get_all")
    @PreAuthorize("permitAll()")
    fun getAllEvents(): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(HttpHeaders.EMPTY)
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
        @RequestParam(required = true) searchString: String
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
        val params = mutableMapOf<String, String?>()
        startDate?.let { params["startDate"] = it }
        endDate?.let { params["endDate"] = it }
        minCapacity?.let { params["minCapacity"] = it.toString() }
        maxCapacity?.let { params["maxCapacity"] = it.toString() }
        isPrivate?.let { params["isPrivate"] = it.toString() }

        val url = params.entries.joinToString("&", "$targetUrl/filterEvents?") { "${it.key}=${it.value}" }
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
