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
      "message": "User registered successfully"
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
      "token": "eyJhbGciOiJIUzUxMiJ9...",
      "refreshToken": "b736ae4a-bd7e-4fcf-9af9-fab045639aa1"
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
      "message": "User logged out successfully"
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
      "id": "1",
      "fullName": "test",
      "email": "test@gmail.com",
      "role": "USER"
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
      "token": "eyJhbGciOiJIUzUxMiJ9...",
      "refreshToken": "new-refresh-token"
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
      "message": "Password reset successfully"
  }
  ```
