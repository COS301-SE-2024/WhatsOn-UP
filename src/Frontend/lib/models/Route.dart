import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapRoute {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;
  final List<String> stepInstructions;

  const MapRoute({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.stepInstructions
  });

  factory MapRoute.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if (map['routes'] == null || (map['routes'] as List).isEmpty) {
      throw ArgumentError('Map does not contain valid routes data');
    }
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    // HTML Instructions
    final steps = data['legs'][0]['steps'] as List;
    
    List<String> htmlInstructions = steps.map((step) {
      return step['html_instructions'] as String;
    }).toList();

    return MapRoute(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
      stepInstructions: htmlInstructions,
    );
  }
}