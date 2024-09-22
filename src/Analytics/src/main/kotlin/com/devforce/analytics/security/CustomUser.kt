package com.devforce.analytics.security

import com.devforce.analytics.model.UserModel
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.User
import java.util.UUID

class CustomUser(
    id: UUID?,
    authorities: Collection<GrantedAuthority>,
    var userModel: UserModel
) : User(id.toString(), "???", authorities)