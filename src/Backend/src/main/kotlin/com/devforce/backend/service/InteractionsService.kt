package com.devforce.backend.service

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.InviteeModel
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.InviteeRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import jakarta.transaction.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import java.util.*

@Service
@Transactional
class InteractionsService {

    @Autowired
    lateinit var eventRepo: EventRepo

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var inviteeRepo: InviteeRepo


    fun inviteUser(eventId: UUID, userId: UUID): ResponseEntity<ResponseDto>{
        val alreadyInvited = inviteeRepo.findByUserAndEvent(userId, eventId)
        if (alreadyInvited != null) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User already invited"))
        }
        val from = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel
        val event = eventRepo.findById(eventId)
        if (event.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event not found"))
        }

        val user = userRepo.findById(userId)
        if (user.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User not found"))
        }
        val eventModel = event.get()
        val userModel = user.get()

        if (eventModel.hosts.any { it.userId == userModel.userId }) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User is already a host of this event"))

        }

        if (eventModel.invitees.any { it.userId == userModel.userId }) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "User is already attending this event"))
        }

        if (eventModel.isPrivate){
            if (eventModel.hosts.none { it.userId == from.userId }) {
                return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "You are not authorized to invite users to this event"))
            }
        }

        val invite = InviteeModel().apply {
            this.event = eventModel
            this.user = userModel
            this.from = from
        }

        inviteeRepo.save(invite)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "User invited successfully")))
    }

    fun acceptInvite(inviteId: UUID): ResponseEntity<ResponseDto> {
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val invite = inviteeRepo.findById(inviteId)

        if (invite.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite not found"))
        }

        val inviteModel = invite.get()

        if (inviteModel.user!!.userId != user.userId) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite not found"))
        }


        if (inviteModel.accepted != null){
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite already accepted or rejected"))
        }

        val event = inviteModel.event!!

        if (event.availableSlots <= 0) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event is full"))
        }

        event.availableSlots = event.availableSlots.minus(1)


        inviteModel.accepted = true

        inviteeRepo.save(inviteModel)


        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Invite accepted successfully")))
    }

    fun rejectInvite(inviteId: UUID): ResponseEntity<ResponseDto>{
        val user = (SecurityContextHolder.getContext().authentication.principal as CustomUser).userModel

        val invite = inviteeRepo.findById(inviteId)

        if (invite.isEmpty) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite not found"))
        }

        val inviteModel = invite.get()

        if (inviteModel.user!!.userId != user.userId) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite not found"))
        }

        if (inviteModel.accepted != null){
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite already accepted or rejected"))
        }

        inviteModel.accepted = false

        inviteeRepo.save(inviteModel)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Invite rejected successfully")))

    }


    fun getAllUsers(): ResponseEntity<ResponseDto> {
        val users = userRepo.findAllUsers()
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), users))
    }


}