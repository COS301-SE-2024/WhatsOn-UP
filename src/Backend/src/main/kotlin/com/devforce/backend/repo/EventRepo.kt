package com.devforce.backend.repo

import com.devforce.backend.dto.FilterByDto
import com.devforce.backend.model.EventModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*


interface EventRepo: JpaRepository<EventModel, UUID> {

    @Query("SELECT DISTINCT e FROM EventModel e " +
            "LEFT JOIN FETCH e.attendees a " +
            "LEFT JOIN FETCH a.role ar " +
            "LEFT JOIN FETCH e.hosts h " +
            "LEFT JOIN FETCH h.role hr " +
            "LEFT JOIN FETCH e.invitees i " +
            "LEFT JOIN FETCH i.role ir " +
            "LEFT JOIN FETCH e.eventMedia em")
    override fun findAll(): List<EventModel>

    @Query(
        "SELECT DISTINCT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.savedEvents se " +
                "WHERE se.userId = :userId"
    )
    fun getSavedEvents(@Param("userId") userId: UUID): List<EventModel>

    @Query(
        "SELECT DISTINCT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "WHERE a.userId = :userId"
    )
    fun getRspvdEvents(@Param("userId") userId: UUID): List<EventModel>

    @Query(
        "SELECT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "WHERE e.title ILIKE %:searchString% " +
                "OR e.description ILIKE %:searchString% " +
                "OR e.location ILIKE %:searchString% " +
                "OR e.metadata ILIKE %:searchString% " +
                "ORDER BY (CASE WHEN e.title ILIKE %:searchString% THEN 3 ELSE 0 END + " +
                "CASE WHEN e.description ILIKE %:searchString% THEN 2 ELSE 0 END + " +
                "CASE WHEN e.location ILIKE %:searchString% THEN 1 ELSE 0 END + " +
                "CASE WHEN e.metadata ILIKE %:searchString% THEN 1 ELSE 0 END) DESC"
    )
    fun searchEvents(@Param("searchString") searchString: String): List<EventModel>




    @Query(
        "SELECT DISTINCT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "WHERE " +
                "(:#{#filterByDto.startTime} IS NULL OR e.startTime >= :#{#filterByDto.startTime}) AND " +
                "(:#{#filterByDto.endTime} IS NULL OR e.endTime <= :#{#filterByDto.endTime}) AND " +
                "(:#{#filterByDto.location} IS NULL OR e.location ILIKE %:#{#filterByDto.location}%) AND " +
                "(:#{#filterByDto.isPrivate} IS NULL OR e.isPrivate = :#{#filterByDto.isPrivate}) AND " +
                "(:#{#filterByDto.maxAttendees} IS NULL OR e.maxAttendees <= :#{#filterByDto.maxAttendees})"
    )
    fun filterEvents(@Param("filterByDto") filterByDto: FilterByDto): List<EventModel>
}

