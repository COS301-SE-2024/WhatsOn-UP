# Contracts
# Description
The documentation below provides a detailed specification the formatting of requests to, and subsequent responses from, the Spring Boot API.

Please note that text wrapped in handlebars (`{{ }}`) will likely change in the, near, future.

**Note that for all subsequent requests to the API:**
- `POST` will be used
- JSON format will be required in the request body
- The server's response body will contain data in JSON format
- {{ JWTs will be used for authentication }}

For each request, the following will need to be included in the header: 
```json
{
    "Content-Type": "application/json",
    "Authorization": "<AUTH KEY>"
}
```
# User Management

### General Request Format
|Field|Required|Type|Description|
|:---:|:---:|:---:|:---:|
|request_type|yes|string|The type of API request|
|auth_token|API request|yes|string|The auth token used to identify the user|
|return|request dependent|string/array|The results to be returned from the API|
|API endpoint specific request data|<...>|<...>|<...>|

### Response Format
|Field|Type|Description|
|:---:|:---:|:---:|
|status|string|Indicates the success or failure of the request|
|timestamp|signed int| The UNIX timestamp indicating the time in which the server responded to the request|
|data|JSON|The data returned from the server, or error hint (and additional error information) should the request have been unsuccessful|

## Register User
This will manage creation, deletion, updating, and viewing of user accounts and details

**Request format**

|Field|Required|Type|value|Description|
|:---:|:---:|:---:|:---:|:---:|
|request type|yes|string|`register_user`|The type of API request|
|return|no|string\|array|`*`|The results to be returned from the API|
|first_name|yes|string|`<first_name>`|first name of the user|
|last_name|yes|string|`<last name>`|last name of the user
|Email|yes|string|`<email address>`|email of the user|
|Password|yes|string|`<encrypted password>`|encrypted user password|

**Request Example**
```json
{
    "request": "register_user",
    "auth_token": "<token>",
    "first_name": "John",
    "last_name": "Doe",
    "email": "jDoe@email.com",
    "password": "<encrypted password>"
}
```
**Successful response example**
```json
{
    "status": "success",
    "timestamp": 1703277000,
    "data": {
        "message": "user successfully created"
    }
}
```

**Error response example**
```json
{
    "status": "failure",
    "timestamp": 1703277000,
    "data": {
        "hint": "user already exists - duplicate email"
    }
}
```
## Login User
|Field|Required|Type|Value|Description|
|:---:|:---:|:---:|:---:|:---:|
|request type|yes|string|`login_user`|The type of API request|
|return|yes|string/array|`*\|[auth_token\|user_name\|profile_picture]`|The results to be returned from the API|
|Email|yes|string|`<email>`|email of the user|
|Password|yes|string|`<encrypted password>`|encrypted user password|

**Request Example**
```json
{
    "request": "login_user",
    "return": "auth_token",
    "email": "jDoe@email.com",
    "password": "<encrypted password>"
}
```

**Successful response example**
```json
{
    "status": "success",
    "timestamp": 1703277000,
    "data": {
        "auth_token": "<token>"
    }
}
```

**Error response example**
```json
{
    "status": "failure",
    "timestamp": 1703277000,
    "data": {
        "hint": "user 'jDoe@email.com' not found - invalid email address"
    }
}
```

# Event Management
# Get upcoming events
|Field|Required|Type|Value|Description|
|:---:|:---:|:---:|:---:|:---:|
|request type|yes|string|`get_upcoming_events`|The type of API request|
|auth_token|yes|string|`<valid token>`|The auth token used to identify the user|
|return|yes|string/array|{{`[event_id\|title\|description\|time\|attendees\|organizer\|location\|images]`}}|The results to be returned from the API|
|filter|no|JSON|A JSON object with key-value pairs of filter options|filter used to select which events should be returned|

**Request Example 1**
```json
{
    "request": "get_upcoming_events",
    "auth_token": "<token>",
    "return": ["event_id", "title"]
}
```

**Success response example 1**
```json
{
    "status": "success",
    "timestamp": 1703277000,
    "data": {
        [
            {
                "event_id": {{001}},
                "title": "Super cool first event"
            },
            {
                "event_id": {{002}},
                "title": "Slightly less cool second event"
            },
            {
                "event_id": {{003}},
                "title": "Some other event"
            }
        ]
    }
}
```

**Request Example 2**
```json
{
    "request": "get_upcoming_events",
    "auth_token": "<token>",
    "return": ["event_id", "title", "attendees"],
    "filter": {
        "event_id": {{001}}
    }
}
```

**Success response example 2**
```json
{
    "status": "success",
    "timestamp": 1703277000,
    "data": {
        [
            {
                "event_id": {{001}},
                "title": "Super cool first event",
                "attendees":[
                    {
                    "user_id": {{uid001}},
                    "user_name": "J0hN_2005"
                    },
                    {
                    "user_id": {{uid005}},
                    "user_name": "Janeee"
                    }
                ]
            }
        ]
    }
}
```
**Error response example**
```json
{
    "status": "failure",
    "timestamp": 1703277000,
    "data": {
        "hint": "No event with id '{{001}}' exists}"
    }
}
```

## Get saved events
|Field|Required|Type|Value|Description|
|:---:|:---:|:---:|:---:|:---:|
|request type|yes|string|`get_saved_events`|The type of API request|
|auth_token|yes|string|`<valid token>`|The auth token used to identify the user|
|user_id|yes|string|`<user id>`|The id of the current user|
|return|yes|string/array|{{`[event_id\|title\|description\|time\|attendees\|organizer\|location\|images]`}}|The results to be returned from the API|
|filter|no|JSON|A JSON object with key-value pairs of filter options|filter used to select which saved events should be returned|

**Request Example 1**
```json
{
    "request": "get_saved_events",
    "auth_token": "<token>",
    "user_id": {{uid001}},
    "return": ["event_id", "title", "description", "event_type"]
}
```

**_Note that fuzzy sort is to be used for fuzzy searchable fields such as (title or description)_**

**Success response example 1**
```json
{
    "status": "success",
    "timestamp": 1703277000,
    "data": {
        [
            {
                "event_id": {{004}},
                "title": "Campus wedding",
                "description": "watch two star-crossed lovers get together right here on hatfield campus",
                "event_type": "Workshop"
            },
            {
                "event_id": {{006}},
                "title": "Blood drive"
                "description": "Donate blood on hatfield campus - in the student centre",
                "event_type": "Career fair"
            },
            {
                "event_id": {{003}},
                "title": "Some other event"
                "description": "You have no reason to not attend",
                "event_type": "Career fair"
            }
        ]
    }
}
```

**Request Example 2**
```json
{
    "request": "get_upcoming_events",
    "auth_token": "<token>",
    "return": ["event_id", "title", "description", "event_type"],
    "filter": {
        "description": "On Hatfield Campus",
        "event_type": "Workshop"
    }
}
```

**Success response example 2**
```json
{
    "status": "success",
    "timestamp": 1703277000,
    "data": {
        [
            {
                "event_id": {{004}},
                "title": "Campus wedding",
                "description": "watch two star-crossed lovers get together right here on hatfield campus",
                "event_type": "workshop"
            }
        ]
    }
}
```