package com.devforce.backend.security

import com.devforce.backend.model.UserModel
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.User

class CustomUser(
    username: String?,
    password: String?,
    authorities: Collection<GrantedAuthority?>?,
    var userModel: UserModel
) : User(username, password, authorities)