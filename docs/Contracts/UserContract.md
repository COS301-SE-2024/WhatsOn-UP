
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
  - Body:
  ```json
  {
    "status": "success",
    "timestamp": 1718705146639,
    "data": [
        {
            "id": "04a211f0-892d-41b0-92ff-438d09538d44",
            "title": "Annual Tech Conference 2.0",
            "description": "A conference discussing the latest trends in technology and innovation.",
            "metadata": "{\"keynoteSpeakers\": [\"John Doe\", \"Jane Smith\"], \"sponsors\": [\"TechCorp\", \"InnovateX\"]}",
            "eventMedia": [
                "https://t4.ftcdn.net/jpg/02/16/94/65/360_F_216946587_rmug8FCNgpDCPQlstiCJ0CAXJ2sqPRU7.jpg"
            ],
            "location": "Silicon Valley Conference Center",
            "startTime": "2024-09-15T09:00:00",
            "endTime": "2024-09-15T17:00:00",
            "maxAttendees": 500,
            "isPrivate": false,
            "hosts": [
                {
                    "fullName": "Testing",
                    "email": "test@gmail.com"
                }
            ],
            "attendees": [
                {
                    "fullName": "Testing",
                    "email": "test@gmail.com"
                }
            ],
            "invitees": []
        }
    ]
  }
  ```

#### 2. Get Saved Events
**Description:** Retrieve the saved events for the user.

- **Endpoint:** `GET /get_saved_events`
- **Headers:** 
  - `Authorization: Bearer <token>`
- **Response:** 
  - Status: `200 OK`
  - Body: 
  ```json
  {
    "status": "success",
    "timestamp": 1718705051142,
    "data": [
        {
            "id": "04a211f0-892d-41b0-92ff-438d09538d44",
            "title": "Annual Tech Conference 2.0",
            "description": "A conference discussing the latest trends in technology and innovation.",
            "metadata": "{\"keynoteSpeakers\": [\"John Doe\", \"Jane Smith\"], \"sponsors\": [\"TechCorp\", \"InnovateX\"]}",
            "eventMedia": [
                "https://t4.ftcdn.net/jpg/02/16/94/65/360_F_216946587_rmug8FCNgpDCPQlstiCJ0CAXJ2sqPRU7.jpg"
            ],
            "location": "Silicon Valley Conference Center",
            "startTime": "2024-09-15T09:00:00",
            "endTime": "2024-09-15T17:00:00",
            "maxAttendees": 500,
            "isPrivate": false,
            "hosts": [
                {
                    "fullName": "Testing",
                    "email": "test@gmail.com"
                }
            ],
            "attendees": [
                {
                    "fullName": "Testing",
                    "email": "test@gmail.com"
                }
            ],
            "invitees": []
        }
    ]
  }
  ```

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
  - Body:
  ```json
  {
    "status": "success",
    "timestamp": 1718705320813,
    "data": {
        "user": {
            "email": "test1@gmail.com",
            "role": "GENERAL",
            "id": "f85f7087-777a-46e0-b572-008b682f351f",
            "fullName": "Testing One",
            "profileImage": "https://people.com/thmb/CmROfB5Fw4H3oJmGwr7qJTGDCGg=/4000x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(509x0:511x2)/people-headshot-lindsay-kimble-9855440283c440159d1684a4befaa97d.jpg"
        }
    }
  }
  ```

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
  - Body: 
  ```json
  {
    "status": "success",
    "timestamp": 1718704835243,
    "data": {
        "message": "Event saved successfully"
    }
  }
  ```

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
  - Body: 
   ```json
  {
    "status": "success",
    "timestamp": 1718704835243,
    "data": {
        "message": "Event RSVP'd successfully"
    }
  }
  ```
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

