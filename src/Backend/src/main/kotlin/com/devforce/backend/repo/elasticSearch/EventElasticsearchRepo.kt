package com.devforce.backend.repo.elasticSearch

import com.devforce.backend.model.EventModel
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository
//import org.springframework.stereotype.Repository

//@Repository
interface EventElasticsearchRepo : ElasticsearchRepository<EventModel, String> {
    fun findByTitle(title: String): List<EventModel>
    fun findByDescription(description: String): List<EventModel>
}
