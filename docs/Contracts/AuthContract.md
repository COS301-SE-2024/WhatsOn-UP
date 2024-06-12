# Auth API Contract

## Base URL

`/api/auth`

## Endpoints

### Register User

**URL:** `/register`

**Method:** `POST`

**Authorization:** `None`

**Request Body:**

```json
{
  "fullName": "example",
  "email": "example@gmail.com",
  "password": "password"
}
```

**Response:**

```json
{
    "status": "success",
    "timestamp": 1717950387589,
  "body": {
    "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJleGFtcGxlQGdtYWlsLmNvbSIsInJvbGUiOiJHRU5FUkFMIiwiaWF0IjoxNzE3OTUwMzg2LCJleHAiOjE3MTgwMzY3ODZ9.Kgn-ndGNcpHJIko1KXDNQlHr5dvHwY1YyBn_w0qMd8meN3Fm5cdigy6bBpNQwuFNCS1uh8l2aOX6xUZyK2A83g",
    "refreshToken": "1b3956c5-edb2-4a4f-8987-dca1d27d0260"
  }
}
```

**OR** if email already taken
```json
{
  "status": "error",
  "timestamp": 1717950453669,
  "body": "Email is already taken"
}
```
### Login User

**URL:** `/login`

**Method:** `POST`

**Authorization:** `None`

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "status": "success",
  "timestamp": 1717950531170,
  "body": {
    "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJleGFtcGxlQGdtYWlsLmNvbSIsInJvbGUiOiJHRU5FUkFMIiwiaWF0IjoxNzE3OTUwNTMwLCJleHAiOjE3MTgwMzY5MzB9.sL7oxyr8JJ7edapjcJ3qk6qNdjrqKMErHtvO4DCAmZF7Fd09stvdnAgimGsgHE2QKFj7A6JdHSQM6quO49hs8Q",
    "refreshToken": "8dc46996-ed59-44ce-864f-0427d52ed9bd"
  }
}
```

### Refresh Token

**URL:** `/refresh_token`

**Method:** `POST`

**Authorization:** `Bearer <jwt_token>`

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Refresh-Token: <refresh_token>`

**Response:**

```json
{
    "status": "success",
    "timestamp": 1717950776460,
    "body": {
        "jwtToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJleGFtcGxlQGdtYWlsLmNvbSIsInJvbGUiOiJHRU5FUkFMIiwiaWF0IjoxNzE3OTUwNzc1LCJleHAiOjE3MTgwMzcxNzV9.QHK-I49sJfj-iNkZtcdZKtnoEgKG4pnuOM5JAesUS9jYMd_AfvfFp3OIwSmXVsHM32BwhqgWw5_1suLbSgD00w",
        "refreshToken": "320f6d7e-71e5-448e-acc4-04aa511b14a5"
    }
}
```

### Logout User

**URL:** `/logout`

**Method:** `POST`

**Authorization:** `Bearer <jwt_token>`

**Headers:**

- `Authorization: Bearer <jwt_token>`

**Response:**

```json
{
  "status": "success",
  "timestamp": 1717950837131,
  "body": "User logged out successfully"
}
```

### Get User

**URL:** `/get_user`

**Method:** `POST`

**Authorization:** `Bearer <jwt_token>`

**Headers:**

- `Authorization: Bearer <jwt_token>`

**Response:**

```json
{
  "status": "success",
  "timestamp": 1717950632879,
  "body": {
    "user": {
      "email": "example@gmail.com",
      "role": "GENERAL",
      "id": "dfec9fa6-b812-4451-a7d8-2bae345f6fa5",
      "fullName": "example"
    }
  }
}
```

### Delete User

**URL:** `/delete_user`

**Method:** `DELETE`

**Authorization:** `Bearer <jwt_token>`

**Headers:**

- `Authorization: Bearer <jwt_token>`

**Response:**

```json
{
    "status": "success",
    "timestamp": 1717951099108,
    "body": {
        "message": "Account deleted successfully"
    }
}
```
