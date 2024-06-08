//package com.devforce.backend.controllers
//
//import com.devforce.backend.Dtos.ResponseDTO
//import com.devforce.backend.models.UserModel
//import com.devforce.backend.repos.UserRepo
//import org.springframework.beans.factory.annotation.Autowired
//import org.springframework.http.ResponseEntity
//import org.springframework.security.access.prepost.PreAuthorize
//import org.springframework.web.bind.annotation.PostMapping
//import org.springframework.web.bind.annotation.RequestBody
//import org.springframework.web.bind.annotation.RequestMapping
//import org.springframework.web.bind.annotation.RestController
//
//@RestController
//@RequestMapping("/user")
//class UserController {
//    @Autowired
//    lateinit var userRepository: UserRepo
//
//    @PostMapping("/register")
//    fun registerUser(@RequestBody userData: Map<String, String>): ResponseEntity<Any> {
//        val email = userData["email"] ?: return ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(),"Email is required"))
//        val password = userData["password"] ?: return ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(), "Password is required"))
//        val name = userData["name"] ?: return ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(),"Name is required"))
//
//        return try {
//            val user = UserModel().apply {
//                this.email = email
//                this.password = password
//                this.fullName = name
//            }
//            val savedUser = userRepository.save(user)
//            ResponseEntity.ok(ResponseDTO("success", System.currentTimeMillis(), mapOf("id" to savedUser.id, "name" to savedUser.fullName, "email" to savedUser.email, "role" to savedUser.roles)))
//        } catch (e: Exception) {
//            ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(), "An error occurred while registering user"))
//        }
//    }
//
//    @PostMapping("/validate")
//    fun loginUser(@RequestBody userData: Map<String, String>): ResponseEntity<Any> {
//        val email = userData["email"] ?: return ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(),"Email is required"))
//        val password = userData["password"] ?: return ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(), "Password is required"))
//
//        return try {
//            val user = userRepository.findByEmailAndPassword(email, password)
//            if (user != null) {
//                val userDetails = mapOf("id" to user.id, "name" to user.fullName, "email" to user.email, "role" to user.roles)
//                ResponseEntity.ok(ResponseDTO("success", System.currentTimeMillis(), userDetails))
//            } else {
//                ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(),"Invalid email or password"))
//            }
//        } catch (e: Exception) {
//            ResponseEntity.badRequest().body(ResponseDTO("error", System.currentTimeMillis(), "An error occurred while logging in user"))
//        }
//    }
//
//    @PostMapping("/testing")
//    @PreAuthorize("hasRole('ADMIN')")
//    fun test(): ResponseEntity<Any> {
//        return ResponseEntity.ok(ResponseDTO("success", System.currentTimeMillis(), "Testing endpoint"))
//    }
//
//
//}