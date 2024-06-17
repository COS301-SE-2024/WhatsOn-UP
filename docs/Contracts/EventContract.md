# API Contract: Events Endpoints


## Base URL

```plaintext
http://localhost:8080
```

## Endpoints

### 1. Get Events

**Endpoint:** `GET /api/events/get_all`

**Description:** Retrieves all events.

**Request:**

- **Headers:** None
- **Body:** None

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  [
      {
          "id": "1",
          "title": "Annual Tech Conference",
          "description": "A conference discussing the latest trends in technology and innovation.",
          "startDate": "2024-09-15T09:00:00",
          "endDate": "2024-09-15T17:00:00",
          "location": "Silicon Valley Conference Center",
          "maxParticipants": 500,
          "metadata": "{\"keynoteSpeakers\": [\"John Doe\", \"Jane Smith\"], \"sponsors\": [\"TechCorp\", \"InnovateX\"]}",
          "media": ["https://example.com/image.jpg"],
          "isPrivate": false
      }
  ]
  ```

### 2. Add Event

**Endpoint:** `POST /api/events/create`

**Description:** Creates a new event.

**Request:**

- **Headers:** None
- **Authorization:** Bearer token required
- **Body:**

  ```json
  {
      "title": "Annual Tech Conference 2.0",
      "description": "A conference discussing the latest trends in technology and innovation.",
      "startDate": "2024-09-15T09:00:00",
      "endDate": "2024-09-15T17:00:00",
      "location": "Silicon Valley Conference Center",
      "maxParticipants": 500,
      "metadata": "{\"keynoteSpeakers\": [\"John Doe\", \"Jane Smith\"], \"sponsors\": [\"TechCorp\", \"InnovateX\"]}",
      "media": ["https://example.com/image.jpg"],
      "isPrivate": false
  }
  ```

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
      "message": "Event created successfully"
  }
  ```

### 3. Delete Event

**Endpoint:** `DELETE /api/events/delete/:eventId`

**Description:** Deletes an event by ID.

**Request:**

- **Headers:** None
- **Authorization:** Bearer token required
- **Body:** None
- **URL Params:**
  - `eventId`: The ID of the event to be deleted

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
      "message": "Event deleted successfully"
  }
  ```
