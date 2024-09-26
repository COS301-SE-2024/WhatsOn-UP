package com.devforce.backend.service

import com.devforce.backend.model.*
import com.devforce.backend.repo.*
import com.devforce.backend.security.CustomUser
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.mail.MailSender
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import java.time.LocalDateTime
import java.time.temporal.ChronoUnit
import java.util.*

@AutoConfigureMockMvc
class InteractionsServiceTest {


    @InjectMocks
    private lateinit var interactionsService: InteractionsService

    @Mock
    private lateinit var statusRepo: StatusRepo

    @Mock
    lateinit var roleRepo: RoleRepo

    @Mock
    lateinit var hostApplicationsRepo: HostApplicationsRepo

    @Mock
    lateinit var broadcastRepo: BroadcastRepo

    @Mock
    lateinit var userRepo: UserRepo

    @Mock
    lateinit var inviteeRepo: InviteeRepo

    @Mock
    lateinit var eventRepo: EventRepo

    var userid = UUID.randomUUID()

    var user = UserModel().apply {
        userId= userid
    }

    @BeforeEach
    fun setUp() {
        MockitoAnnotations.openMocks(this)

        userid = UUID.randomUUID()
        user = UserModel().apply {
            userId= userid
            role = RoleModel().apply { name = "HOST" }
        }
        val roleName = "HOST"
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(userid, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }


    fun setUp(roleName: String) {
        MockitoAnnotations.openMocks(this)

        userid = UUID.randomUUID()
        user = UserModel().apply {
            userId= userid
            role = RoleModel().apply { name = roleName }
        }
        val authorities = setOf(SimpleGrantedAuthority(roleName))
        val userDetails = CustomUser(userid, authorities, user)
        val auth = UsernamePasswordAuthenticationToken(userDetails, authorities, userDetails.authorities)
        SecurityContextHolder.getContext().authentication = auth
    }

    @Test
    fun `Test invite user`(){
        val eventid = UUID.randomUUID()
        val inviteeId = UUID.randomUUID()

        `when`(inviteeRepo.findByUserAndEvent(inviteeId, eventid)).thenReturn(
            InviteeModel().apply {
                this.user = UserModel().apply { userId = inviteeId }
                this.event = EventModel().apply { eventId = eventid }
            }
        )

        var response = interactionsService.inviteUser(eventid, inviteeId)
        assertEquals("error", response.body?.status)
        assertEquals("User already invited", response.body?.data)

        `when`(inviteeRepo.findByUserAndEvent(inviteeId, eventid)).thenReturn(null)

        `when`(eventRepo.findById(eventid)).thenReturn(Optional.empty())

        response = interactionsService.inviteUser(eventid, inviteeId)
        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

        `when`(eventRepo.findById(eventid)).thenReturn(Optional.of(EventModel().apply {
            eventId = eventid
            hosts = mutableSetOf(UserModel().apply { userId = inviteeId })
        }))

        `when`(userRepo.findById(inviteeId)).thenReturn(Optional.empty())

        response = interactionsService.inviteUser(eventid, inviteeId)
        assertEquals("error", response.body?.status)
        assertEquals("User not found", response.body?.data)


        `when`(userRepo.findById(inviteeId)).thenReturn(Optional.of(UserModel().apply {
            userId = inviteeId
        }))

        response = interactionsService.inviteUser(eventid, inviteeId)
        assertEquals("error", response.body?.status)
        assertEquals("User is already a host of this event", response.body?.data)

        `when`(eventRepo.findById(eventid)).thenReturn(Optional.of(EventModel().apply {
            eventId = eventid
            hosts = mutableSetOf()
            invitees = mutableSetOf(UserModel().apply { userId = inviteeId })
        }))

        response = interactionsService.inviteUser(eventid, inviteeId)

        assertEquals("error", response.body?.status)
        assertEquals("User is already attending this event", response.body?.data)

        `when`(eventRepo.findById(eventid)).thenReturn(Optional.of(EventModel().apply {
            eventId = eventid
            hosts = mutableSetOf()
            invitees = mutableSetOf()
            isPrivate = true
        }))

        response = interactionsService.inviteUser(eventid, inviteeId)

        assertEquals("error", response.body?.status)
        assertEquals("You are not authorized to invite users to this event", response.body?.data)

        setUp("HOST")

        `when`(eventRepo.findById(eventid)).thenReturn(Optional.of(EventModel().apply {
            eventId = eventid
            hosts = mutableSetOf(user)
            invitees = mutableSetOf()
            isPrivate = true
        }))


        `when`(userRepo.findById(inviteeId)).thenReturn(Optional.of(UserModel().apply {
            userId = inviteeId
        }))

        response = interactionsService.inviteUser(eventid, inviteeId)

        assertEquals("success", response.body?.status)

       val result = response.body?.data as Map<*, *>
        assertEquals("User invited successfully", result["message"])


        `when`(eventRepo.findById(eventid)).thenReturn(Optional.of(EventModel().apply {
            eventId = eventid
            invitees = mutableSetOf()
            isPrivate = false
        }))


        response = interactionsService.inviteUser(eventid, inviteeId)

        assertEquals("success", response.body?.status)

        val result2 = response.body?.data as Map<*, *>
        assertEquals("User invited successfully", result2["message"])

    }

    @Test
    fun `Test accept invite`(){
        val inviteId = UUID.randomUUID()

        var invitee = InviteeModel().apply {
            this.event = EventModel().apply {
                eventId = UUID.randomUUID()
                availableSlots = 0
            }

            accepted = true
        }

        invitee.user = UserModel().apply {
            userId = UUID.randomUUID()
        }

        `when`(inviteeRepo.findById(inviteId)).thenReturn(Optional.empty())

        var response = interactionsService.acceptInvite(inviteId)

        assertEquals("error", response.body?.status)
        assertEquals("Invite not found", response.body?.data)


        response = interactionsService.acceptInvite(inviteId)

        assertEquals("error", response.body?.status)
        assertEquals("Invite not found", response.body?.data)

        invitee.eventInviteeId = inviteId
        invitee.user = user

        `when`(inviteeRepo.findById(inviteId)).thenReturn(Optional.of(invitee))

        response = interactionsService.acceptInvite(inviteId)


        assertEquals("error", response.body?.status)
        assertEquals("Invite already accepted or rejected", response.body?.data)

        invitee.accepted = null

        response = interactionsService.acceptInvite(inviteId)

        assertEquals("error", response.body?.status)
        assertEquals("Event is full", response.body?.data)

        invitee.event!!.availableSlots = 1

        response = interactionsService.acceptInvite(inviteId)

        assertEquals("success", response.body?.status)
        val result = response.body?.data as Map<*, *>
        assertEquals("Invite accepted successfully", result["message"])

    }

    @Test
    fun `Test reject invite`() {
        val inviteId = UUID.randomUUID()

        var invitee = InviteeModel().apply {
            this.event = EventModel().apply {
                eventId = UUID.randomUUID()
                availableSlots = 0
            }

            accepted = true
        }

        invitee.user = UserModel().apply {
            userId = UUID.randomUUID()
        }

        `when`(inviteeRepo.findById(inviteId)).thenReturn(Optional.empty())

        var response = interactionsService.rejectInvite(inviteId)

        assertEquals("error", response.body?.status)
        assertEquals("Invite not found", response.body?.data)

        response = interactionsService.rejectInvite(inviteId)

        assertEquals("error", response.body?.status)

        assertEquals("Invite not found", response.body?.data)

        invitee.eventInviteeId = inviteId

        invitee.user = user

        invitee.accepted = false

        `when`(inviteeRepo.findById(inviteId)).thenReturn(Optional.of(invitee))


        response = interactionsService.rejectInvite(inviteId)

        assertEquals("error", response.body?.status)
        assertEquals("Invite already accepted or rejected", response.body?.data)

        invitee.accepted = null

        response = interactionsService.rejectInvite(inviteId)

        assertEquals("success", response.body?.status)

        val result = response.body?.data as Map<*, *>

        assertEquals("Invite rejected successfully", result["message"])

    }

    @Test
    fun `Test get all users`() {

        val user1 = UserModel().apply {
            userId = UUID.randomUUID()
        }

        val user2 = UserModel().apply {
            userId = UUID.randomUUID()
        }

        val user3 = UserModel().apply {
            userId = UUID.randomUUID()
        }

        `when`(userRepo.findAllUsers()).thenReturn(listOf(user1, user2, user3))

        val response = interactionsService.getAllUsers()

        assertEquals("success", response.body?.status)

        assertEquals(3, (response.body?.data as List<*>).size)
    }
}
