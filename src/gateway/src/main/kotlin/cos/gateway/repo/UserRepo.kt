package cos.gateway.repo

import cos.gateway.model.UserModel
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*


interface UserRepo : JpaRepository<UserModel, UUID> {
    fun findByUserId(userId: UUID): UserModel?

    @Query("SELECT u FROM UserModel u "+
            "JOIN FETCH u.role")
    fun findAllUsers(): List<UserModel>


}
