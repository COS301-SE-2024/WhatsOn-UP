package com.devforce.backend.repo

import com.devforce.backend.model.EventModel
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface EventSearchRepo: ElasticsearchRepository<EventModel, String> {
    fun findByName(name: String): List<EventModel>
    fun findByDescription(description: String): List<EventModel>
}
