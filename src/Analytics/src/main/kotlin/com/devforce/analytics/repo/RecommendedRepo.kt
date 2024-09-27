package com.devforce.analytics.repo

import com.devforce.analytics.dto.RecommendedDateDto
import com.devforce.analytics.dto.RecommendedVenueDto
import jakarta.persistence.EntityManager
import jakarta.persistence.PersistenceContext
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface RecommendedDateRepo {

    @Query(value = "SELECT * FROM recommend_event_times(:userId, :title, :category)", nativeQuery = true)
    fun getPossibleDates(
        @Param("userId") userId: UUID,
        @Param("title") title: String,
        @Param("category") category: String
    ): List<RecommendedDateDto>
}

@Repository
interface RecommendedVenueRepo {

    @Query(value = "SELECT * FROM get_top_venues_by_event(:userId, :title, :category)", nativeQuery = true)
    fun getPossibleVenues(
        @Param("userId") userId: UUID,
        @Param("title") title: String,
        @Param("category") category: String
    ): List<RecommendedVenueDto>
}

@Repository
class RecommendedDateRepoImpl(
    @PersistenceContext private val entityManager: EntityManager
) : RecommendedDateRepo {
    override fun getPossibleDates(userId: UUID, title: String, category: String): List<RecommendedDateDto> {
        val query = entityManager.createNativeQuery(
            "SELECT * FROM recommend_event_times(:userId, :title, :category)",
            RecommendedDateDto::class.java
        )
        query.setParameter("userId", userId)
        query.setParameter("title", title)
        query.setParameter("category", category)
        return query.resultList as List<RecommendedDateDto>
    }
}

@Repository
class RecommendedVenueRepoImpl(
    @PersistenceContext private val entityManager: EntityManager
) : RecommendedVenueRepo {
    override fun getPossibleVenues(userId: UUID, title: String, category: String): List<RecommendedVenueDto> {
        val query = entityManager.createNativeQuery(
            "SELECT * FROM get_top_venues_by_event(:userId, :title, :category)",
            RecommendedVenueDto::class.java
        )
        query.setParameter("userId", userId)
        query.setParameter("title", title)
        query.setParameter("category", category)
        return query.resultList as List<RecommendedVenueDto>
    }
}
