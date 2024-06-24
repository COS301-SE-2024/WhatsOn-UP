# API Contract: Authentication Endpoints


## Base URL

```plaintext
http://localhost:8080
```

## Endpoints

### 1. Register

**Endpoint:** `POST /api/auth/register`

**Description:** Registers a new user.

**Request:**

- **Headers:** None
- **Body:**

  ```json
  {
      "fullName": "test",
      "email": "test@gmail.com",
      "password": "password"
  }
  ```

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
      "status": "success",
      "timestamp": 1718704075174,
      "data": {
          "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MkBnbWFpbC5jb20iLCJyb2xlIjoiR0VORVJBTCIsImlhdCI6MTcxODcwNDA3MywiZXhwIjoxNzE4NzkwNDczfQ.Y6SXC4w3vuZ0TybrRIxi9SJK0R-OHvz9kT8-OPBCaAo4xapfzHlbBw1DMZ1hqxJIjtTrW2UNn0yn54ufDE4nQw",
          "refreshToken": "b79f2c5b-c345-4f38-9443-74f7371cc53f"
      }
  }
  ```

### 2. Login

**Endpoint:** `POST /api/auth/login`

**Description:** Logs in a user.

**Request:**

- **Headers:** None
- **Body:**

  ```json
  {
      "email": "test@gmail.com",
      "password": "password1"
  }
  ```

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
    "status": "success",
    "timestamp": 1718704184387,
    "data": {
        "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MkBnbWFpbC5jb20iLCJyb2xlIjoiR0VORVJBTCIsImlhdCI6MTcxODcwNDE4MywiZXhwIjoxNzE4NzkwNTgzfQ.agcX6o1rF0HPRF5319_T_9rvcLo5gQq1KQFHwwz14jXlXda4lGHkFh2MJpGbrgCGmjSg3g5oMHcZJYIkR9Y7Jg",
        "refreshToken": "e7f1ebac-fe43-4a61-b1b7-f9a8e1098d09"
    }
  }
  ```

### 3. Logout

**Endpoint:** `POST /api/auth/logout`

**Description:** Logs out a user.

**Request:**

- **Headers:**
  - `Authorization: Bearer <token>`
- **Body:** None

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
    "status": "success",
    "timestamp": 1718704269400,
    "data": "User logged out successfully"
  }
  ```

### 4. Get User

**Endpoint:** `GET /api/auth/get_user`

**Description:** Retrieves the authenticated user's details.

**Request:**

- **Headers:**
  - `Authorization: Bearer <token>`
- **Body:** None

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
    "status": "success",
    "timestamp": 1718704321769,
    "data": {
        "user": {
            "email": "test2@gmail.com",
            "role": "GENERAL",
            "id": "20db8059-c73a-4f8c-afa3-37a24e2997f7",
            "fullName": "test2",
            "profileImage": ""
        }
    }
  }
  ```

### 5. Refresh Token

**Endpoint:** `POST /api/auth/refresh_token`

**Description:** Refreshes the authentication token.

**Request:**

- **Headers:**
  - `Authorization: Bearer <token>`
  - `Refresh-Token: b736ae4a-bd7e-4fcf-9af9-fab045639aa1`
- **Body:** None

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
    "status": "success",
    "timestamp": 1718704418436,
    "data": {
        "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MkBnbWFpbC5jb20iLCJyb2xlIjoiR0VORVJBTCIsImlhdCI6MTcxODcwNDQxNywiZXhwIjoxNzE4NzkwODE3fQ.0wo4ZVT69xGUYV5eCwp8uiPeK0l1IA5t9ZEauYidciDmT_GPSRwOzM8KToxHEecj8CYu7PaAt6wuIK8Qeiz-nQ",
        "refreshToken": "5ee7e3d1-e316-4490-8c77-e0268a91874b"
    }
  }
  ```

### 6. Password Reset

**Endpoint:** `PUT /api/auth/reset_password`

**Description:** Resets the user's password.

**Request:**

- **Headers:**
  - `Authorization: Bearer <token>`
- **Body:**

  ```json
  {
      "password": "newpassword"
  }
  ```

**Response:**

- **Status:** `200 OK` on success
- **Body:** (Sample)

  ```json
  {
    "status": "success",
    "timestamp": 1718704418436,
    "data": {
        "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MkBnbWFpbC5jb20iLCJyb2xlIjoiR0VORVJBTCIsImlhdCI6MTcxODcwNDQxNywiZXhwIjoxNzE4NzkwODE3fQ.0wo4ZVT69xGUYV5eCwp8uiPeK0l1IA5t9ZEauYidciDmT_GPSRwOzM8KToxHEecj8CYu7PaAt6wuIK8Qeiz-nQ",
        "refreshToken": "5ee7e3d1-e316-4490-8c77-e0268a91874b"
    }
  }
  ```
