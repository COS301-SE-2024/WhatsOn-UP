import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    return Location(
      name: json['name'],
      id: json['id'],
      formattedAddress: json['formattedAddress'],
      displayName: json['displayName']['text'],
      languageCode: json['displayName']['languageCode'],
      location: LatLng(json['location']['latitude'], json['location']['longitude']),
      imageUrls: _extractUrls(json['photos']),
      types: List<String>.from(json['types'])
    );
  }
  
  static List<String> _extractUrls(List<dynamic> jsonPhotos) {
    String apiKey = dotenv.env['Google_Maps_API_Key'] ?? 'No API Key Found';
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

  
}
