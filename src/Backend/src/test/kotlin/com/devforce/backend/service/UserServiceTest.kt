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
class UserServiceTest {

    @Mock
    private lateinit var eventRepo: EventRepo

    @Mock
    private lateinit var userRepo: UserRepo

    @Mock
    private lateinit var hostApplicationsRepo: HostApplicationsRepo


    @InjectMocks
    private lateinit var userServiceWithMocks: UserService

    @Mock
    private lateinit var statusRepo: StatusRepo

    @Mock
    lateinit var mailSender: MailSender

    @Mock
    lateinit var pastEventRepo: PastEventRepo

    @Mock
    lateinit var feedbackRepo: FeedbackRepo

    @Mock
    lateinit var roleRepo: RoleRepo

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
    fun `Save event`() {

        val id = UUID.randomUUID()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        var response = userServiceWithMocks.saveEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

        var event = EventModel().apply {
            savedEvents.add(user)
            eventId = id
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.saveEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event already saved", response.body?.data)

        event = EventModel().apply {
            eventId = id
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.saveEvent(id)

        assertEquals("success", response.body?.status)

        val message: Map<String,String> = response.body?.data as Map<String,String>

        assertEquals("Event saved successfully", message["message"])


    }

    @Test
    fun `Delete event`() {
        val id = UUID.randomUUID()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        var response = userServiceWithMocks.deleteSavedEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

        var event = EventModel().apply {
            savedEvents.add(user)
            eventId = id
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.deleteSavedEvent(id)

        assertEquals("success", response.body?.status)
        val message: Map<String,String> = response.body?.data as Map<String,String>
        assertEquals("Event deleted successfully", message["message"])


        event = EventModel().apply {
            eventId = id
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.deleteSavedEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

    }

    @Test
    fun `Get saved events`() {
        val id = UUID.randomUUID()

        val event = EventModel().apply {
            savedEvents.add(user)
            eventId = id
        }

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(eventRepo.getSavedEvents(user.userId)).thenReturn(listOf(event))

        val response = userServiceWithMocks.getSavedEvents()

        assertEquals("success", response.body?.status)
        val events: List<EventModel> = response.body?.data as List<EventModel>
        assertEquals(1, events.size)

    }

    @Test
    fun `Rsvp event`() {
        val id = UUID.randomUUID()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        var response = userServiceWithMocks.rsvpEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

        var event = EventModel().apply {
            attendees.add(user)
            eventId = id
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.rsvpEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event already RSVP'd", response.body?.data)

        event = EventModel().apply {
            eventId = id
            availableSlots = 0
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.rsvpEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event is full", response.body?.data)

        event = EventModel().apply {
            eventId = id
            availableSlots = 1
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.rsvpEvent(id)

        assertEquals("success", response.body?.status)
        assertEquals(event.availableSlots, 0)

        val message: Map<String, String> = response.body?.data as Map<String, String>

        assertEquals("Event RSVP'd successfully", message["message"])

    }

    @Test
    fun `Delete Rsvp`() {
        val id = UUID.randomUUID()

        `when`(eventRepo.findById(id)).thenReturn(Optional.empty())

        var response = userServiceWithMocks.deleteRsvpEvent(id)

        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

        var event = EventModel().apply {
            attendees.add(user)
            eventId = id
            availableSlots = 0
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.deleteRsvpEvent(id)

        assertEquals("success", response.body?.status)
        val message: Map<String, String> = response.body?.data as Map<String, String>
        assertEquals("Event deleted successfully", message["message"])
        assertEquals(event.availableSlots, 1)

        event = EventModel().apply {
            eventId = id
        }

        `when`(eventRepo.findById(id)).thenReturn(Optional.of(event))

        response = userServiceWithMocks.deleteRsvpEvent(id)

        assertEquals("error", response.body?.status)

        assertEquals("Event not found", response.body?.data)

    }

    @Test
    fun `Get rsvp events`() {
        val id = UUID.randomUUID()

        val event = EventModel().apply {
            attendees.add(user)
            eventId = id
        }

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(eventRepo.getRsvpdEvents(user.userId)).thenReturn(listOf(event))

        val response = userServiceWithMocks.getRsvpEvents()

        assertEquals("success", response.body?.status)
        val events: List<EventModel> = response.body?.data as List<EventModel>
        assertEquals(1, events.size)

    }

    @Test
    fun `Get user details`() {
        val id = UUID.randomUUID()

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))

        val response = userServiceWithMocks.getUser()

        assertEquals("success", response.body?.status)
        var user: Map<String, Any> = response.body?.data as Map<String, Any>
        user = user["user"] as Map<String, Any>
        assertEquals(user["userId"], userid)

    }

    @Test
    fun `Update user details`() {
        val id = UUID.randomUUID()

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))

        val response = userServiceWithMocks.updateProfile("testtttttting")

        assertEquals("success", response.body?.status)
        assertEquals("success", response.body?.status)
        var user: Map<String, Any> = response.body?.data as Map<String, Any>
        user = user["user"] as Map<String, Any>
        assertEquals("testtttttting", user["fullName"])

    }

    @Test
    fun `Apply for host`() {
        var id = userid

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))

        val response = userServiceWithMocks.applyForHost(10, "reason", "u057238448@tuks.co.za", "2024-08-30 17:00:00")

        assertEquals("error", response.body?.status)
        assertEquals("User is already a host", response.body?.data)

        setUp("ADMIN")

        id = userid

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))

        val response8 = userServiceWithMocks.applyForHost(10, "reason", "u057238448@tuks.co.za", "2024-08-30 17:00:00")

        assertEquals("error", response8.body?.status)
        assertEquals("User is already a host", response8.body?.data)

        setUp("GENERAL")

        id = userid

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))

        val list: List<HostApplicationsModel> = listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply {
                name = "PENDING"
            }
        })

        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list)

        val response2 = userServiceWithMocks.applyForHost(10, "reason", null, "2024-08-30 17:00:00")

        assertEquals("error", response2.body?.status)
        assertEquals("User has already applied", response2.body?.data)

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        val list2: List<HostApplicationsModel> = listOf()
        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list2)
        val response3 = userServiceWithMocks.applyForHost(10, "reason", "testing@gmail.com", "2024-08-30 17:00:00")
        assertEquals("error", response3.body?.status)
        assertEquals("Invalid student email", response3.body?.data)

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list2)
        val response4 = userServiceWithMocks.applyForHost(10, "", null, "2024-08-30 17:00:00")
        assertEquals("error", response4.body?.status)
        assertEquals("Reason cannot be blank", response4.body?.data)

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list2)
        val response5 = userServiceWithMocks.applyForHost(10, "reason", null, "2024-08-30 17:00:00")
        assertEquals("success", response5.body?.status)
        var result: Map<String, String> = response5.body?.data as Map<String, String>
        assertEquals("Application submitted successfully", result["message"])


        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list2)
        val response6 = userServiceWithMocks.applyForHost(10, "reason", "u22222222@tuks.co.za", "2024-08-30 17:00:00")
        assertEquals("success", response6.body?.status)
        var result2: Map<String, String> = response6.body?.data as Map<String, String>
        assertEquals("Application submitted successfully. Check your email for verification link", result2["message"])

        `when`(userRepo.findById(id)).thenReturn(Optional.of(user))
        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list2)
        val response7 = userServiceWithMocks.applyForHost(10, "reason", "u22222222@up.ac.za", "2024-08-30 17:00:00")
        assertEquals("success", response7.body?.status)
        var result3: Map<String, String> = response7.body?.data as Map<String, String>
        assertEquals("Application submitted successfully. Check your email for verification link", result3["message"])


    }

    @Test
    fun `Verify application`(){
        val veriCode = UUID.randomUUID()
        `when`(hostApplicationsRepo.findByVerificationCode(veriCode)).thenReturn(null)
        val response = userServiceWithMocks.verifyApplication(veriCode)
        assertEquals("Invalid verification code", response.body)


        `when`(hostApplicationsRepo.findByVerificationCode(veriCode)).thenReturn(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply {
                name = "PENDING"
            }
        })

        `when`(statusRepo.findByName("VERIFIED")).thenReturn(ApplicationStatusModel().apply { name = "VERIFIED" })

        val response2 = userServiceWithMocks.verifyApplication(veriCode)

        assertEquals("Application verified successfully", response2.body)
    }

    @Test
    fun `Rate event test`(){
        val id = UUID.randomUUID()
        `when`(pastEventRepo.findById(id)).thenReturn(Optional.empty())

        val response = userServiceWithMocks.rateEvent(id, 5, "Great event")
        assertEquals("error", response.body?.status)
        assertEquals("Event not found", response.body?.data)

        `when`(pastEventRepo.findById(id)).thenReturn(Optional.of(PastEventModel().apply {
            attendees.add(user)
            eventId = id
        }))

        val response2 = userServiceWithMocks.rateEvent(id, 6, "Great event")

        assertEquals("error", response2.body?.status)
        assertEquals("Rating must be between 1 and 5", response2.body?.data)

        val response3 = userServiceWithMocks.rateEvent(id, 5, "Great event")

        assertEquals("success", response3.body?.status)
        var result: Map<String, String> = response3.body?.data as Map<String, String>
        assertEquals("Event rated successfully", result["message"])
    }

    @Test
    fun `Acknowledge application test`(){
        val list: List<HostApplicationsModel> = listOf()
        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list)

        val response = userServiceWithMocks.acknowledgeApplication()
        assertEquals("error", response.body?.status)
        assertEquals("Application not found", response.body?.data)

        val list2: List<HostApplicationsModel?> = listOf(null)

        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list2)

        val response2 = userServiceWithMocks.acknowledgeApplication()

        assertEquals("error", response2.body?.status)
        assertEquals("Application not found", response2.body?.data)

        val list3: List<HostApplicationsModel?> = listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply {
                name = "PENDING"
            }
        })

        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list3)

        val response3 = userServiceWithMocks.acknowledgeApplication()

        assertEquals("error", response3.body?.status)
        assertEquals("Application not accepted yet", response3.body?.data)

        val list4: List<HostApplicationsModel?> = listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply {
                name = "ACCEPTED"
                expiryDateTime = LocalDateTime.now().minus(1, ChronoUnit.DAYS)
            }
        })

        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list4)

        val response4 = userServiceWithMocks.acknowledgeApplication()

        assertEquals("error", response4.body?.status)
        assertEquals("Application expired", response4.body?.data)

        val list5: List<HostApplicationsModel?> = listOf(HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply {
                name = "ACCEPTED"
                expiryDateTime = LocalDateTime.now().plus(1, ChronoUnit.DAYS)
            }
        })

        `when`(hostApplicationsRepo.findByUserId(user.userId)).thenReturn(list5)
        `when`(roleRepo.findByName("HOST")).thenReturn(RoleModel().apply {
            name = "HOST"
        })

        val applicationModel = HostApplicationsModel().apply {
            status = ApplicationStatusModel().apply {
                name = "ACKNOWLEDGED"
            }
        }
        `when`(statusRepo.findByName("ACKNOWLEDGED")).thenReturn(ApplicationStatusModel().apply {
            name = "ACKNOWLEDGED"
        })

        `when`(hostApplicationsRepo.save(applicationModel)).thenReturn(applicationModel)

        val response5 = userServiceWithMocks.acknowledgeApplication()

        assertEquals("success", response5.body?.status)
        val result: Map<String, String> = response5.body?.data as Map<String, String>
        assertEquals("Application acknowledged successfully", result["message"])

    }






}
