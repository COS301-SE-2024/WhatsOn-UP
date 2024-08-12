package cos.gateway.controller

import org.springframework.beans.factory.annotation.Value
import org.springframework.http.*
import org.springframework.http.client.ClientHttpResponse
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import org.springframework.web.client.RestTemplate
import org.springframework.web.client.ResponseErrorHandler
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.client.HttpServerErrorException
import java.io.IOException
import java.util.*

@RestController
@RequestMapping("/api/user")
class UserProxy {

    private val restTemplate: RestTemplate

    init {
        // Configure RestTemplate to handle errors
        restTemplate = RestTemplate().apply {
            requestFactory = HttpComponentsClientHttpRequestFactory() // Optional: Use Apache HttpClient
            errorHandler = CustomResponseErrorHandler()
        }
    }

    @Value("\${user.service.url:http://localhost:8085/api/user}")
    private lateinit var userServiceUrl: String

    @PutMapping("/save_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun saveEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/save_event/$id", HttpMethod.PUT, entity)
    }

    @DeleteMapping("/delete_saved_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteSavedEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/delete_saved_event/$id", HttpMethod.DELETE, entity)
    }

    @GetMapping("/get_saved_events")
    @PreAuthorize("isAuthenticated()")
    fun getSavedEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/get_saved_events", HttpMethod.GET, entity)
    }

    @PutMapping("/rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun rspvEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/rspv_event/$id", HttpMethod.PUT, entity)
    }

    @GetMapping("/get_rspv_events")
    @PreAuthorize("isAuthenticated()")
    fun getRspvEvents(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/get_rspv_events", HttpMethod.GET, entity)
    }

    @DeleteMapping("/delete_rspv_event/{id}")
    @PreAuthorize("isAuthenticated()")
    fun deleteRspvEvent(@RequestHeader headers: HttpHeaders, @PathVariable id: UUID): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/delete_rspv_event/$id", HttpMethod.DELETE, entity)
    }

    @PutMapping("/update_profile")
    @PreAuthorize("isAuthenticated()")
    fun updateProfile(@RequestHeader headers: HttpHeaders, @RequestParam fullName: String): ResponseEntity<Any> {
        val url = "$userServiceUrl/update_profile?fullName=$fullName"
        val entity = HttpEntity<Any>(headers)
        return executeRequest(url, HttpMethod.PUT, entity)
    }

    @GetMapping("/get_user")
    @PreAuthorize("isAuthenticated()")
    fun getUser(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/get_user", HttpMethod.GET, entity)
    }

    @DeleteMapping("/delete_user")
    @PreAuthorize("isAuthenticated()")
    fun deleteUser(@RequestHeader headers: HttpHeaders): ResponseEntity<Any> {
        val entity = HttpEntity<Any>(headers)
        return executeRequest("$userServiceUrl/delete_user", HttpMethod.DELETE, entity)
    }

    @PutMapping("/apply_for_host")
    @PreAuthorize("isAuthenticated()")
    fun applyHost(
        @RequestHeader headers: HttpHeaders,
        @RequestParam howLong: Int,
        @RequestParam reason: String,
        @RequestParam studentEmail: String?,
        @RequestParam fromWhen: String,
    ): ResponseEntity<Any> {
        val url = "$userServiceUrl/apply_for_host?howLong=$howLong&reason=$reason&studentEmail=$studentEmail&fromWhen=$fromWhen"
        val entity = HttpEntity<Any>(headers)
        return executeRequest(url, HttpMethod.PUT, entity)
    }

    @PostMapping("/acknowledge_application")
    @PreAuthorize("isAuthenticated()")
    fun acknowledgeApplication(@RequestHeader headers: HttpHeaders, @RequestParam applicationId: UUID): ResponseEntity<Any> {
        val url = "$userServiceUrl/acknowledge_application?applicationId=$applicationId"
        val entity = HttpEntity<Any>(headers)
        return executeRequest(url, HttpMethod.POST, entity)
    }

    @PostMapping("/dispute_application")
    @PreAuthorize("isAuthenticated()")
    fun disputeApplication(@RequestHeader headers: HttpHeaders, @RequestParam applicationId: UUID): ResponseEntity<Any> {
        val url = "$userServiceUrl/dispute_application?applicationId=$applicationId"
        val entity = HttpEntity<Any>(headers)
        return executeRequest(url, HttpMethod.POST, entity)
    }

    @GetMapping("/verify_application")
    @PreAuthorize("permitAll()")
    fun verifyApplication(@RequestHeader headers: HttpHeaders, @RequestParam veriCode: UUID): ResponseEntity<Any> {
        val url = "$userServiceUrl/verify_application?veriCode=$veriCode"
        val entity = HttpEntity<Any>(headers)
        return executeRequest(url, HttpMethod.GET, entity)
    }

    private fun executeRequest(url: String, method: HttpMethod, entity: HttpEntity<Any>): ResponseEntity<Any> {
        return try {
            restTemplate.exchange(url, method, entity, Any::class.java)
        } catch (ex: HttpClientErrorException) {
            ResponseEntity.status(ex.statusCode).body(ex.responseBodyAsString)
        } catch (ex: HttpServerErrorException) {
            ResponseEntity.status(ex.statusCode).body(ex.responseBodyAsString)
        } catch (ex: IOException) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("I/O error occurred: ${ex.message}")
        } catch (ex: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unexpected error occurred: ${ex.message}")
        }
    }

    private class CustomResponseErrorHandler : ResponseErrorHandler {
        override fun hasError(response: ClientHttpResponse): Boolean {
            return response.statusCode.isError
        }

        override fun handleError(response: ClientHttpResponse) {
            // Log the error or handle it as needed
        }
    }
}
