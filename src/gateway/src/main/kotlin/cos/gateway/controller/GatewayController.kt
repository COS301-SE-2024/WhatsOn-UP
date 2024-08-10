package cos.gateway.controller

import cos.gateway.config.AuthConfig
import cos.gateway.dto.CreateEventDto
import cos.gateway.dto.ResponseDto
import cos.gateway.dto.UpdateEventDto
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
    fun createEvent(@RequestHeader headers: HttpHeaders, @RequestBody event: CreateEventDto): ResponseEntity<ResponseDto> {
        val entity = HttpEntity(event, headers)
        println(event)
        return restTemplate.exchange("$targetUrl/create", HttpMethod.POST, entity, ResponseDto::class.java)
    }

    @GetMapping("/get_all")
    @PreAuthorize("permitAll()")
    fun getAllEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/get_all", HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @PutMapping("/update/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun updateEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID, @RequestBody event: UpdateEventDto): ResponseEntity<ResponseDto> {
        val entity = HttpEntity(event, headers)
        return restTemplate.exchange("$targetUrl/update/$id", HttpMethod.PUT, entity, ResponseDto::class.java)
    }

    @DeleteMapping("/remove/{id}")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun deleteEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/remove/$id", HttpMethod.DELETE, entity, ResponseDto::class.java)
    }

    @GetMapping("/categories")
    @PreAuthorize("permitAll()")
    fun getUniqueCategories(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/categories", HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @GetMapping("/search")
    @PreAuthorize("permitAll()")
    fun searchEvents(
        @RequestHeader headers: HttpHeaders,
        @RequestParam searchString: String
    ): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/search?searchString=$searchString", HttpMethod.GET, entity, ResponseDto::class.java)
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
    ): ResponseEntity<ResponseDto> {
        val params = mutableMapOf<String, String?>().apply {
            startDate?.let { put("startDate", it) }
            endDate?.let { put("endDate", it) }
            minCapacity?.let { put("minCapacity", it.toString()) }
            maxCapacity?.let { put("maxCapacity", it.toString()) }
            isPrivate?.let { put("isPrivate", it.toString()) }
        }

        val url = "$targetUrl/filterEvents?" + params.entries.joinToString("&") { "${it.key}=${it.value}" }
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange(url, HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @GetMapping("/get_passed_events")
    @PreAuthorize("hasAnyRole('HOST', 'ADMIN')")
    fun getPassedEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/get_passed_events", HttpMethod.GET, entity, ResponseDto::class.java)
    }

    @GetMapping("/get_locations")
    @PreAuthorize("permitAll()")
    fun getLocations(@RequestHeader headers: HttpHeaders): ResponseEntity<ResponseDto> {
        val entity = HttpEntity<Any>(headers)
        return restTemplate.exchange("$targetUrl/get_locations", HttpMethod.GET, entity, ResponseDto::class.java)
    }
}
