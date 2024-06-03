import org.springframework.data.jpa.repository.JpaRepository
import java.util.Optional
import java.util.UUID

abstract class User: JpaRepository<User, UUID>{

    abstract fun findByEmail(email: String): Optional<User>
}