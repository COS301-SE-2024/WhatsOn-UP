const Map<String,dynamic> RECOMMENDED_EVENTS_SCHEMA = {
  "type": "object",
  "properties": {
    "status": {
      "type": "string"
    },
    "data": {
      "type": "object",
      "properties": {
        "message": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "event": {
                "type": "object",
                "properties": {
                  "id": {
                    "type": "string",
                    "format": "uuid"
                  },
                  "title": {
                    "type": "string"
                  },
                  "description": {
                    "type": "string"
                  },
                  "metadata": {
                    "type": "string"
                  },
                  "eventmedia": {
                    "type": "array",
                    "items": {}
                  },
                  "location": {
                    "type": "object",
                    "properties": {
                      "venueId": {
                        "type": "string",
                        "format": "uuid"
                      },
                      "building": {
                        "type": "object",
                        "properties": {
                          "buildingId": {
                            "type": "string",
                            "format": "uuid"
                          },
                          "name": {
                            "type": "string"
                          },
                          "accessType": {
                            "type": "string"
                          },
                          "location": {
                            "type": "string",
                            "format": "uri"
                          },
                          "campus": {
                            "type": "object",
                            "properties": {
                              "campusId": {
                                "type": "string",
                                "format": "uuid"
                              },
                              "name": {
                                "type": "string"
                              },
                              "location": {
                                "type": "string",
                                "format": "uri"
                              },
                              "parking": {
                                "type": "boolean"
                              }
                            },
                            "required": ["campusId", "name", "location", "parking"]
                          }
                        },
                        "required": ["buildingId", "name", "accessType", "location", "campus"]
                      },
                      "name": {
                        "type": "string"
                      },
                      "boards": {
                        "type": ["null", "string"]
                      },
                      "ac": {
                        "type": "boolean"
                      },
                      "wifi": {
                        "type": "boolean"
                      },
                      "dataProject": {
                        "type": "integer"
                      },
                      "docCam": {
                        "type": "boolean"
                      },
                      "mic": {
                        "type": "boolean"
                      },
                      "windows": {
                        "type": "boolean"
                      },
                      "capacity": {
                        "type": "integer"
                      },
                      "available": {
                        "type": "boolean"
                      }
                    },
                    "required": ["venueId", "building", "name", "ac", "wifi", "dataProject", "docCam", "mic", "windows", "capacity", "available"]
                  },
                  "startDateTime": {
                    "type": "string",
                    "format": "date-time"
                  },
                  "endDateTime": {
                    "type": "string",
                    "format": "date-time"
                  },
                  "maxAttendees": {
                    "type": "integer"
                  },
                  "isPrivate": {
                    "type": "boolean"
                  },
                  "attendees": {
                    "type": "array",
                    "items": {}
                  },
                  "invitees": {
                    "type": "array",
                    "items": {}
                  },
                  "category": {
                    "type": "string"
                  },
                  "availableSlots": {
                    "type": "integer"
                  }
                },
                "required": ["id", "title", "description", "metadata", "eventmedia", "location", "startDateTime", "endDateTime", "maxAttendees", "isPrivate", "attendees", "invitees", "category", "availableSlots"]
              },
              "rating": {
                "type": "number"
              }
            },
            "required": ["event", "rating"]
          }
        }
      },
      "required": ["message"]
    }
  },
  "required": ["status", "data"]
};
