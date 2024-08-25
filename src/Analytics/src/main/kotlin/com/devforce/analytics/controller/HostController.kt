package com.devforce.analytics.controller

import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasAnyRole('HOST')")
class HostController {

}