import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firstapp/models/Location.dart';

class PlacesService{
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:searchText';

  final Dio _dio;
  static const String key = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "No api key found");

  PlacesService({Dio? dio}) : _dio = dio ?? Dio(); //should be an independent singleton in the future

  //returns a list of locations from the passed in query
  Future<List<Location>> findLocationFromQuery(
    {
      required String query,
      int radius = 5000, // default radius in meters
    }
  ) async
  {
    print("KEEEYYYY: $key");
    //find place in given location
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': key,
      'X-Goog-FieldMask': 'places.displayName,places.name,places.id,places.formattedAddress,places.location,places.photos,places.types'
    };

    final body = {
    'textQuery': query,
    'locationBias': {
      'circle': {
          'center': { //Hatfield campus coordinates
          'latitude': -25.7545492,
          'longitude': 28.2314676
          },
          'radius': 5000.0
        }
      }
    };

    final response = await _dio.post(
      _baseUrl,
      options: Options(headers: headers),
      data: jsonEncode(body)
    );

    print(response);

    if (response.statusCode == 200) {
      final List results = response.data['places'];
      return results.map((place) => Location.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places. Status code: ${response.statusCode}');
    }

    //return list of locations
  }
}