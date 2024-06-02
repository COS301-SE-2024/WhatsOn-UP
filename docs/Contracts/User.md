# User Contract

### POST /register

**Request:**
- Method: POST
- Path: /register
- Headers: 
  - Content-Type: application/json
- Body: 
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
  - Body:
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
  - Body:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

## POST /login

**Request:**
- Method: POST
- Path: /login
- Headers: 
  - Content-Type: application/json
- Body:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```

**Responses:**
- 200 OK
  - Content-Type: application/json
  - Body:
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
  - Body:
    ```json
    {
      "status": "error",
      "timestamp": "timestamp",
      "message": "string"
    }
    ```

-----
Here are examples of how you can use the API endpoints described for the `/register` and `/login` routes:

### Example 1: Register a User
#### Request:
```http
POST /register
Content-Type: application/json

{
  "email": "john.doe@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Response (Success):
```json
{
  "status": "success",
  "timestamp": "2024-06-02T12:00:00",
  "data": {
    "id": "1234567890",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "role": "user"
  }
}
```

#### Response (Error - Missing Field):
```json
{
  "status": "error",
  "timestamp": "2024-06-02T12:01:00",
  "message": "Name is required"
}
```

### Example 2: Login
#### Request:
```http
POST /login
Content-Type: application/json

{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

#### Response (Success):
```json
{
  "status": "success",
  "timestamp": "2024-06-02T12:05:00",
  "data": {
    "id": "1234567890",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "role": "user"
  }
}
```

#### Response (Error - Invalid Credentials):
```json
{
  "status": "error",
  "timestamp": "2024-06-02T12:06:00",
  "message": "Invalid email or password"
}
```

These examples demonstrate how to register a user and login with the registered credentials, along with possible responses for both successful and error scenarios.