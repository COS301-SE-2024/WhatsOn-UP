package com.devforce.backend.service

import com.devforce.backend.dto.ResponseDto
import com.devforce.backend.model.InviteeModel
import com.devforce.backend.repo.AvailableSlotsRepo
import com.devforce.backend.repo.EventRepo
import com.devforce.backend.repo.InviteeRepo
import com.devforce.backend.repo.UserRepo
import com.devforce.backend.security.CustomUser
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import java.util.*

@Service
class InteractionsService {

    @Autowired
    lateinit var eventRepo: EventRepo

    @Autowired
    lateinit var userRepo: UserRepo

    @Autowired
    lateinit var inviteeRepo: InviteeRepo

    @Autowired
    lateinit var availableSlotsRepo: AvailableSlotsRepo

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

        if (inviteModel.accepted) {
            return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Invite already accepted"))
        }

        val availableSlots = inviteModel.event!!.eventId?.let { availableSlotsRepo.findByEventId(it) }

        if (availableSlots != null) {
            if (availableSlots.availableSlots <= 0) {
                return ResponseEntity.badRequest().body(ResponseDto("error", System.currentTimeMillis(), "Event is full"))
            }
        }

        inviteModel.accepted = true

        inviteeRepo.save(inviteModel)

        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), mapOf("message" to "Invite accepted successfully")))
    }

    fun getAllUsers(): ResponseEntity<ResponseDto> {
        val users = userRepo.findAllUsers()
        return ResponseEntity.ok(ResponseDto("success", System.currentTimeMillis(), users))
    }


}