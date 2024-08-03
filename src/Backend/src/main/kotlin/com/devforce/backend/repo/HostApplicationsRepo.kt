package com.devforce.backend.repo

import com.devforce.backend.model.HostApplicationsModel
import com.devforce.backend.model.Status
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*


interface HostApplicationsRepo: JpaRepository<HostApplicationsModel, UUID> {
    @Query(
        "SELECT h FROM HostApplicationsModel h " +
                "JOIN FETCH h.user u " +
                "JOIN FETCH h.acceptedRejectedBy arb " +
                "JOIN FETCH arb.role arbr " +
                "JOIN FETCH u.role ur " +
                "WHERE (:status IS NULL OR h.status = :status)"
    )
    fun findByStatus(@Param("status") status: Status?): List<HostApplicationsModel?>


}