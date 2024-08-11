package cos.gateway.model

import cos.gateway.model.RoleModel
import jakarta.persistence.*
import lombok.Builder
import lombok.Data
import java.util.*

@Data
@Builder
@Entity
@Table(name = "profiles")
class UserModel{

    @Id
    @Column(columnDefinition = "UUID")
    var userId: UUID = UUID.randomUUID()

    var fullName: String = ""

    @Column(columnDefinition = "TEXT")
    var profileImage: String = ""

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id")
    var role: RoleModel? = null

}
