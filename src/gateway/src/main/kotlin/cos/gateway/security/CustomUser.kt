package cos.gateway.security

import cos.gateway.model.UserModel
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.User
import java.util.UUID

class CustomUser(
    id: UUID?,
    authorities: Collection<GrantedAuthority>,
    var userModel: UserModel
) : User(id.toString(), "???", authorities)