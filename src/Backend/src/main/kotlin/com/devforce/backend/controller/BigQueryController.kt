package com.devforce.backend.controller


import com.devforce.backend.service.BigQueryService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class BigQueryController(private val bigQueryService: BigQueryService) {

    @GetMapping("/query")
    fun getQueryResults(@RequestParam query: String): ResponseEntity<List<Map<String, Any>>> {
        return try {
            val results = bigQueryService.executeQuery(query)
            ResponseEntity.ok(results)
        } catch (e: Exception) {
            // Log the exception and return an error response
            e.printStackTrace()
            ResponseEntity.status(500).body(emptyList())
        }
    }
}
