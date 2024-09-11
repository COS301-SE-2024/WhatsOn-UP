package com.devforce.backend.service


import com.google.cloud.bigquery.BigQuery
import com.google.cloud.bigquery.BigQueryOptions
import com.google.cloud.bigquery.QueryJobConfiguration
import com.google.cloud.bigquery.TableResult
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class BigQueryService {

    private val bigQuery: BigQuery = BigQueryOptions.getDefaultInstance().service
    private val logger = LoggerFactory.getLogger(BigQueryService::class.java)

    fun executeQuery(query: String): List<Map<String, Any>> {
        return try {
            val queryConfig = QueryJobConfiguration.newBuilder(query).build()
            val results: TableResult = bigQuery.query(queryConfig)

            val rows = mutableListOf<Map<String, Any>>()
            for (row in results.iterateAll()) {
                val rowMap = mutableMapOf<String, Any>()
                val schema = results.schema
                if (schema != null) {
                    for (i in schema.fields.indices) {
                        val fieldName = schema.fields[i].name
                        val fieldValue = row.get(i) // Use index-based access
                        rowMap[fieldName] = fieldValue.toString() // Convert to string if necessary
                    }

            }
                rows.add(rowMap)
            }
            rows

    }
    catch (e: Exception) {
        logger.error("BigQuery query execution failed: ${e.message}", e)
        emptyList() // Return empty list in case of failure
    }}
}