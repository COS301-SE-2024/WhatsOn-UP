package com.devforce.backend.repo

import com.devforce.backend.model.HostApplicationsModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.*


interface HostApplicationsRepo: JpaRepository<HostApplicationsModel, UUID> {
    @Query(
        "SELECT DISTINCT h FROM HostApplicationsModel h "+
                "LEFT JOIN FETCH h.user u " +
                "LEFT JOIN FETCH h.acceptedRejectedBy arb "+
                "LEFT JOIN FETCH arb.role arbr " +
                "LEFT JOIN FETCH u.role ur " +
                "LEFT JOIN FETCH h.status s "+
                "WHERE :status is null or  s.name = :status"
    )
    fun findByStatus(@Param("status") status: String?): List<HostApplicationsModel?>


    @Query(
        "SELECT h FROM HostApplicationsModel h " +
                "JOIN FETCH h.user u " +
                "WHERE u.userId = :userId"
    )
    fun findByUserId(@Param("userId") userId: UUID): List<HostApplicationsModel?>

    @Query(
        "SELECT h FROM HostApplicationsModel h " +
                "WHERE h.verificationCode = :veriCode"
    )
    fun findByVerificationCode(veriCode: UUID): HostApplicationsModel?


}