import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String name;
  final String id;
  final String formattedAddress;
  final String displayName;
  final String languageCode;
  final LatLng location;

  Location({
    required this.name,
    required this.id,
    required this.formattedAddress,
    required this.displayName,
    this.languageCode = "en",
    required this.location
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      id: json['id'],
      formattedAddress: json['formattedAddress'],
      displayName: json['displayName']['text'],
      languageCode: json['displayName']['languageCode'],
      location: LatLng(json['location']['latitude'], json['location']['longitude']),
    );
  }
}
