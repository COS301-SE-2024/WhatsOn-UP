
const Map<String,dynamic> NOTIFICATION_SOCKET_SCHEMA = {
  "type": "object",
  "properties": {
    "status": { "type": "string" },
    "data": {
      "type": "object",
      "properties": {
        "event_id": { "type": "string", "format": "uuid" },
        "message": { "type": "string" },
        "notification_id": { "type": "string", "format": "uuid" },
        "seen_at": { "type": ["string", "null"], "format": "date-time" },
        "sent_at": { "type": "string", "format": "date-time" },
        "type": { "type": "integer" },
        "user_id": { "type": "string", "format": "uuid" },
        "notification_types": {
          "type": "object",
          "properties": {
            "name": { "type": "string" }
          },
          "required": ["name"]
        },
        "events": {
          "type": "object",
          "properties": {
            "description": { "type": "string" },
            "is_private": { "type": "boolean" },
            "title": { "type": "string" },
            "max_attendees": { "type": "integer" },
            "start_date_time": { "type": "string", "format": "date-time" },
            "end_date_time": { "type": "string", "format": "date-time" },
            "venues": {
              "type": "object",
              "properties": {
                "name": { "type": "string" },
                "buildings": {
                  "type": "object",
                  "properties": {
                    "name": { "type": "string" },
                    "location": { "type": "string", "format": "uri" },
                    "access_type": { "type": "string" }
                  },
                  "required": ["name", "location", "access_type"]
                }
              },
              "required": ["name", "buildings"]
            }
          },
          "required": [
            "description", "is_private", "title", "max_attendees", 
            "start_date_time", "end_date_time", "venues"
          ]
        },
        "event_invitees": {
          "type": "object",
          "properties": {
            "accepted": { "type": ["string", "null"] }
          }
        }
      },
      "required": [
        "event_id", "message", "notification_id", "seen_at", "sent_at", 
        "type", "user_id", "notification_types", "events", "event_invitees"
      ]
    },
    "timestamp": { "type": "string", "format": "date-time" }
  },
  "required": ["status", "data", "timestamp"]
};
