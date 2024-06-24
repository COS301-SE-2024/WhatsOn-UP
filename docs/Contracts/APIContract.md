# API Contract

## UserController
### POST /register

**Request:**
- Method: POST
- Path: /register
- Headers: Content-Type: application/json
- Data: 
  ```json
  {
    "email": "string",
    "password": "string",
    "name": "string"
  }
  ```

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "success",
      "timestamp": "timestamp",
      "data": {
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "string"
      }
    }
    ```
- 400 Bad Request
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

### POST /login

**Request:**
- Method: POST
- Path: /login
- Headers: Content-Type: application/json
- Data:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "success",
      "timestamp": "timestamp",
      "data": {
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "string"
      }
    }
    ```
- 400 Bad Request
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

## EventController

### GET /get_events

**Request:**
- Method: GET
- Path: /get_events

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "success",
      "timestamp": "timestamp",
      "data": [
        {
          "id": "string",
          "name": "string",
          "description": "string",
          "metadata": "string",
          "eventMedia": ["string"],
          "hosts": "string",
          "location": "string",
          "startTime": "string (ISO 8601)",
          "endTime": "string (ISO 8601)",
          "maxAttendees": "integer",
          "isPrivate": "boolean"
        }
      ]
    }
    ```
- 500 Internal Server Error
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

### POST /add_event

**Request:**
- Method: POST
- Path: /add_event
- Headers: Content-Type: application/json
- Data:
  ```json
  {
    "name": "string",
    "description": "string",
    "startTime": "string (ISO 8601)",
    "endTime": "string (ISO 8601)",
    "metadata": "string",
    "eventMedia": ["string"],
    "hosts": "string",
    "location": "string",
    "maxAttendees": "integer",
    "isPrivate": "boolean"
  }
  ```

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "success",
      "timestamp": "timestamp",
      "data": {
        "event": {
          "id": "string",
          "name": "string",
          "description": "string",
          "metadata": "string",
          "eventMedia": ["string"],
          "hosts": "string",
          "location": "string",
          "startTime": "string (ISO 8601)",
          "endTime": "string (ISO 8601)",
          "maxAttendees": "integer",
          "isPrivate": "boolean"
        }
      }
    }
    ```
- 400 Bad Request
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

### POST /delete_event

**Request:**
- Method: POST
- Path: /delete_event
- Headers: Content-Type: application/json
- Data:
  ```json
  {
    "eventId": "string (UUID)"
  }
  ```

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "success",
      "timestamp": "timestamp",
      "data": "string"
    }
    ```
- 404 Not Found
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```
- 400 Bad Request
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

### POST /update_event

**Request:**
- Method: POST
- Path: /update_event
- Headers: Content-Type: application/json
- Data:
  ```json
  {
    "eventId": "string (UUID)",
    "name": "string",
    "description": "string",
    "startTime": "string (ISO 8601)",
    "endTime": "string (ISO 8601)",
    "metadata": "string",
    "eventMedia": ["string"],
    "hosts": "string",
    "location": "string",
    "maxAttendees": "integer",
    "isPrivate": "boolean"
  }
  ```

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Data:
    ```json
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "metadata": "string",
      "eventMedia": ["string"],
      "hosts": "string",
      "location": "string",
      "startTime": "string (ISO 8601)",
      "endTime": "string (ISO 8601)",
      "maxAttendees": "integer",
      "isPrivate": "boolean"
    }
    ```
- 404 Not Found
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```
- 400 Bad Request
  - Content-Type: application/json
  - Data:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```
------

### Example 1: Register a User
#### Request:
```http
POST /register
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Response:
```json
{
  "status": "success",
  "timestamp": "timestamp",
  "data": {
    "id": "string",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "string"
  }
}
```

### Example 2: Login
#### Request:
```http
POST /login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

#### Response:
```json
{
  "status": "success",
  "timestamp": "timestamp",
  "data": {
    "id": "string",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "string"
  }
}
```

### Example 3: Get Events
#### Request:
```http
GET /get_events
```

#### Response:
```json
{
  "status": "success",
  "timestamp": "timestamp",
  "data": [
    {
      "id": "string",
      "name": "Event Name",
      "description": "Event Description",
      "metadata": "Event Metadata",
      "eventMedia": ["media1.jpg", "media2.jpg"],
      "hosts": "Host Name",
      "location": "Event Location",
      "startTime": "2024-06-01T12:00:00",
      "endTime": "2024-06-01T15:00:00",
      "maxAttendees": 100,
      "isPrivate": false
    }
  ]
}
```

### Example 4: Add Event
#### Request:
```http
POST /add_event
Content-Type: application/json

{
  "name": "Event Name",
  "description": "Event Description",
  "startTime": "2024-06-01T12:00:00",
  "endTime": "2024-06-01T15:00:00",
  "metadata": "Event Metadata",
  "eventMedia": ["media1.jpg", "media2.jpg"],
  "hosts": "Host Name",
  "location": "Event Location",
  "maxAttendees": 100,
  "isPrivate": false
}
```

#### Response:
```json
{
  "status": "success",
  "timestamp": "timestamp",
  "data": {
    "event": {
      "id": "string",
      "name": "Event Name",
      "description": "Event Description",
      "metadata": "Event Metadata",
      "eventMedia": ["media1.jpg", "media2.jpg"],
      "hosts": "Host Name",
      "location": "Event Location",
      "startTime": "2024-06-01T12:00:00",
      "endTime": "2024-06-01T15:00:00",
      "maxAttendees": 100,
      "isPrivate": false
    }
  }
}
```

### Example 5: Delete Event
#### Request:
```http
POST /delete_event
Content-Type: application/json

{
  "eventId": "string (UUID)"
}
```

#### Response:
```json
{
  "status": "success",
  "timestamp": "timestamp",
  "data": "Event deleted successfully"
}
```

### Example 6: Update Event
#### Request:
```http
POST /update_event
Content-Type: application/json

{
  "eventId": "string (UUID)",
  "name": "Updated Event Name",
  "description": "Updated Event Description",
  "startTime": "2024-06-01T12:00:00",
  "endTime": "2024-06-01T15:00:00",
  "metadata": "Updated Event Metadata",
  "eventMedia": ["updated_media1.jpg", "updated_media2.jpg"],
  "hosts": "Updated Host Name",
  "location": "Updated Event Location",
  "maxAttendees": 150,
  "isPrivate": true
}
```

#### Response:
```json
{
  "id": "string",
  "name": "Updated Event Name",
  "description": "Updated Event Description",
  "metadata": "Updated Event Metadata",
  "eventMedia": ["updated_media1.jpg", "updated_media2.jpg"],
  "hosts": "Updated Host Name",
  "location": "Updated Event Location",
  "startTime": "2024-06-01T12:00:00",
  "endTime": "2024-06-01T15:00:00",
  "maxAttendees": 150,
  "isPrivate": true
}
```

