
## API Contract: `api/user`


### Base URL
`localhost:8080/api/user`

### Authentication
All endpoints require Bearer Token authentication. Include the following header in your requests:
```
Authorization: Bearer <your-token>
```

### Endpoints

#### 1. Get RSVP Events
**Description:** Retrieve the RSVP events for the user.

- **Endpoint:** `GET /get_rspv_events`
- **Headers:** 
  - `Authorization: Bearer <token>`
- **Response:** 
  - Status: `200 OK`
  - Body: JSON array of RSVP events.

#### 2. Get Saved Events
**Description:** Retrieve the saved events for the user.

- **Endpoint:** `GET /get_saved_events`
- **Headers:** 
  - `Authorization: Bearer <token>`
- **Response:** 
  - Status: `200 OK`
  - Body: JSON array of saved events.

#### 3. Update User Profile
**Description:** Update the user's profile information.

- **Endpoint:** `PUT /update_profile`
- **Headers:** 
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Request Body:** 
  ```json
  {
      "email": "test@gmail.com",
      "fullName": "Testing",
      "profileImage": "https://example.com/image.jpg"
  }
  ```
- **Response:** 
  - Status: `200 OK`
  - Body: Updated user profile information.

#### 4. Save Event for User
**Description:** Save an event for the user.

- **Endpoint:** `PUT /save_event/{eventId}`
- **Headers:** 
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Path Parameters:** 
  - `eventId`: UUID of the event to be saved.
- **Response:** 
  - Status: `200 OK`
  - Body: Confirmation of the event being saved.

#### 5. RSVP Event for User
**Description:** RSVP an event for the user.

- **Endpoint:** `PUT /rspv_event/{eventId}`
- **Headers:** 
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Path Parameters:** 
  - `eventId`: UUID of the event to RSVP.
- **Response:** 
  - Status: `200 OK`
  - Body: Confirmation of the RSVP.

#### 6. Delete Saved Event
**Description:** Delete a saved event for the user.

- **Endpoint:** `DELETE /delete_saved_event/{eventId}`
- **Headers:** 
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Path Parameters:** 
  - `eventId`: UUID of the event to be deleted.
- **Response:** 
  - Status: `200 OK`
  - Body: Confirmation of the event being deleted.

#### 7. Delete RSVP Event
**Description:** Delete an RSVP event for the user.

- **Endpoint:** `DELETE /delete_rspv_event/{eventId}`
- **Headers:** 
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`
- **Path Parameters:** 
  - `eventId`: UUID of the event to be deleted.
- **Response:** 
  - Status: `200 OK`
  - Body: Confirmation of the RSVP event being deleted.

