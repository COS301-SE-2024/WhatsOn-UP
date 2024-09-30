import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firstapp/models/Route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RouteService{
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;
  static const String key = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "No api key found");

  RouteService({Dio? dio}) : _dio = dio ?? Dio();

  Future<MapRoute> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': '$key',
        'mode': 'walking' //should be distance dependant
      },
    );

    print(MapRoute.fromMap(response.data).totalDistance);

    if (response.statusCode == 200) {
      return MapRoute.fromMap(response.data);
    }
    else{ //handle error accordingly
      throw Exception('Failed to load route. Status code: ${response.statusCode}');    
    }
  }
}