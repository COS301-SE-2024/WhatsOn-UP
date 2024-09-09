package com.devforce.backend.controller


import com.devforce.backend.service.BigQueryService
import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class BigQueryController(private val bigQueryService: BigQueryService) {

    private val logger = LoggerFactory.getLogger(BigQueryController::class.java)

    @GetMapping("/query")
    fun getQueryResults(@RequestParam query: String): ResponseEntity<List<Map<String, Any>>> {
        return try {
            val results = bigQueryService.executeQuery(query)
            ResponseEntity.ok(results)
        } catch (e: Exception) {
            logger.error("Error during BigQuery query execution: ${e.message}", e)
          //  e.printStackTrace()
            ResponseEntity.status(500).body(emptyList())
        }
    }
}
