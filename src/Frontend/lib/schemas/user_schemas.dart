const Map<String,dynamic> GET_USER_SCHEMA =
{
  "type": "object",
  "properties": {
    "status": {
      "type": "string"
    },
    "timestamp": {
      "type": "integer"
    },
    "data": {
      "type": "object",
      "properties": {
        "user": {
          "type": "object",
          "properties": {
            "role": {
              "type": "string"
            },
            "fullName": {
              "type": "string"
            },
            "profileImage": {
              "type": "string"
            },
            "userId": {
              "type": "string",
              "format": "uuid"
            }
          },
          "required": ["role", "fullName", "profileImage", "userId"]
        }
      },
      "required": ["user"]
    }
  },
  "required": ["status", "timestamp", "data"]
};