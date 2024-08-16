import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_schema/json_schema.dart';

class Location {
  final String name;
  final String id;
  final String formattedAddress;
  final String displayName;
  final String languageCode;
  final LatLng location;
  final List<String> imageUrls;
  final List<String> types;

  Location({
    required this.name,
    required this.id,
    required this.formattedAddress,
    required this.displayName,
    this.languageCode = "en",
    required this.location,
    required this.imageUrls,
    required this.types
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final schema = JsonSchema.create(locationSchema);
    final ValidationResults validationResult = schema.validate(json);

    if (validationResult.isValid) {
      print('JSON is valid!');
    } else {
      print('JSON is invalid! Errors:');
      for (var error in validationResult.errors) {
        print(error);
      }
    }

    return Location(
      name: json['name'],
      id: json['id'],
      formattedAddress: json['formattedAddress'],
      displayName: json['displayName']['text'],
      languageCode: json['displayName']['languageCode'],
      location: LatLng(json['location']['latitude'], json['location']['longitude']),
      imageUrls: (json['photos'] != null) ? _extractUrls(json['photos']) : ['https://meshhevents.com/wp-content/plugins/elementor/assets/images/placeholder.png'],
      types: List<String>.from(json['types'])
    );
  }
  
  static List<String> _extractUrls(List<dynamic> jsonPhotos) {
    const String apiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "No api key found");
    List<String> photoUrls = [];
     for (var photo in jsonPhotos) {
        String photoReference = photo['name'].split('/').last;
        String url = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
        photoUrls.add(url);
    }
    print(photoUrls);
    return photoUrls;
  }

  Location.copy(Location other)
      : name = other.name,
        id = other.id,
        formattedAddress = other.formattedAddress,
        displayName = other.displayName,
        languageCode = other.languageCode,
        location = other.location,
        imageUrls = List.from(other.imageUrls),
        types = List.from(other.types);
  
  static final Map<String, dynamic> locationSchema = {
  "type": "object",
  "properties": {
    "name": {"type": "string"},
    "id": {"type": "string"},
    "types": {
      "type": "array",
      "items": {"type": "string"}
    },
    "formattedAddress": {"type": "string"},
    "location": {
      "type": "object",
      "properties": {
        "latitude": {"type": "number"},
        "longitude": {"type": "number"}
      },
      "required": ["latitude", "longitude"]
    },
    "displayName": {
      "type": "object",
      "properties": {
        "text": {"type": "string"},
        "languageCode": {"type": "string"}
      },
      "required": ["text", "languageCode"]
    },
    "photos": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "widthPx": {"type": "integer"},
          "heightPx": {"type": "integer"},
          "authorAttributions": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "displayName": {"type": "string"},
                "uri": {"type": "string"},
                "photoUri": {"type": "string"}
              },
              "required": ["displayName", "uri", "photoUri"]
            }
          }
        },
        "required": ["name", "widthPx", "heightPx", "authorAttributions"]
      }
    }
  },
  "required": ["name", "id", "types", "formattedAddress", "location", "displayName", "photos"]
};

  
}
