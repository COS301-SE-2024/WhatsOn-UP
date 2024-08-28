package com.devforce.backend.repo

import com.devforce.backend.dto.FilterByDto
import com.devforce.backend.model.AllEventModel
import com.devforce.backend.model.EventModel
import jakarta.transaction.Transactional
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.jpa.repository.query.Procedure
import org.springframework.data.repository.query.Param
import java.util.*
//FUTURE - filterEvents

interface EventRepo: JpaRepository<EventModel, UUID> {

    @Query(
        "SELECT DISTINCT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "WHERE (e.isPrivate = false " +
                "OR :userId IS NULL " +
                "OR a.userId = :userId " +
                "OR i.userId = :userId " +
                "OR h.userId = :userId)"
    )
    fun findAllByUser(@Param("userId") userId: UUID?): List<EventModel>



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
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "WHERE se.userId = :userId "
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
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "WHERE (a.userId = :userId " +
                "OR h.userId = :userId) "
    )
    fun getRsvpdEvents(@Param("userId") userId: UUID): List<EventModel>

    @Query(
        "SELECT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "WHERE (e.isPrivate = false " +
                "OR :userId IS NULL " +
                "OR a.userId = :userId " +
                "OR i.userId = :userId " +
                "OR h.userId = :userId) "+
                "AND e.title ILIKE %:searchString% " +
                "OR e.description ILIKE %:searchString% " +
                "ORDER BY (CASE WHEN e.title ILIKE %:searchString% THEN 3 ELSE 0 END + " +
                "CASE WHEN e.description ILIKE %:searchString% THEN 2 ELSE 0 END) DESC"
    )
    fun searchEvents(@Param("searchString") searchString: String, @Param("userId") userId: UUID?): List<EventModel>


   // fun findByTitleContainingIgnoreCase(title: String): List<Event>


   @Query(value = """
        SELECT DISTINCT * FROM category
        """, nativeQuery = true)
    fun findUniqueCategories(): List<String>


   /* FUTURE

    */
   @Query(
        "SELECT DISTINCT e FROM EventModel e " +
                "LEFT JOIN FETCH e.attendees a " +
                "LEFT JOIN FETCH a.role ar " +
                "LEFT JOIN FETCH e.hosts h " +
                "LEFT JOIN FETCH h.role hr " +
                "LEFT JOIN FETCH e.invitees i " +
                "LEFT JOIN FETCH i.role ir " +
                "LEFT JOIN FETCH e.eventMedia em " +
                "LEFT JOIN FETCH e.venue v " +
                "LEFT JOIN FETCH v.building b " +
                "LEFT JOIN FETCH b.campus c " +
                "WHERE (e.isPrivate = false " +
                "OR :userId IS NULL " +
                "OR a.userId = :userId " +
                "OR i.userId = :userId " +
                "OR h.userId = :userId) "+
                "AND (:#{#filterByDto.startDateTime} IS NULL OR e.startDateTime > TO_TIMESTAMP(:#{#filterByDto.startDateTime}, 'YYYY-MM-DD HH24:MI:SS')) AND " +
                "(:#{#filterByDto.endDateTime} IS NULL OR e.endDateTime < TO_TIMESTAMP(:#{#filterByDto.endDateTime}, 'YYYY-MM-DD HH24:MI:SS')) AND " +
                "(:#{#filterByDto.isPrivate} IS NULL OR e.isPrivate = :#{#filterByDto.isPrivate}) AND " +
                "(:#{#filterByDto.maxAttendees} IS NULL OR e.maxAttendees <= :#{#filterByDto.maxAttendees})"
    )
    fun filterEvents(@Param("filterByDto") filterByDto: FilterByDto, @Param("userId") userId: UUID?): List<EventModel>


   /*@Query(value = """
    SELECT * FROM events e
    WHERE (:startDateTime IS NULL OR e.start_date_time >= CAST(:startDateTime AS TIMESTAMP))
    AND (:endDateTime IS NULL OR e.end_date_time <= CAST(:endDateTime AS TIMESTAMP))
    AND (:minCapacity IS NULL OR e.max_attendees >= :minCapacity)
    AND (:maxCapacity IS NULL OR e.max_attendees <= :maxCapacity)
    AND (:isPrivate IS NULL OR  e.is_private = :isPrivate)
""", nativeQuery = true)
   fun filteringEvents(
       @Param("startDate") startDateTime: String?,
       @Param("endDate") endDateTime: String?,
       @Param("minCapacity") minCapacity: Int?,
       @Param("maxCapacity") maxCapacity: Int?,
       @Param("isPrivate") isPrivate: Boolean?
   ): List<EventModel>
*/
    @Transactional
    @Procedure(procedureName = "delete_event")
    fun deleteEvent(eventId: UUID)

}

interface AllEventRepo: JpaRepository<AllEventModel, UUID>{
}


