import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:firstapp/widgets/event_card.dart';
//import 'api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'globals.dart' as globals;

import 'package:intl/intl.dart';
import 'package:firstapp/widgets/event_card.dart';

class EventService {
  final SupabaseClient supabase;
  EventService(this.supabase);
  static final String baseUrl = 'https://${globals.gatewayDomain}';

  Future<String?> _getJwtToken() async {
    final session = supabase.auth.currentSession;
    print(session);
    print(session?.accessToken);
    return session?.accessToken;
  }
  Future<List<Event>> fetchPastEvents(String userId) async {

    final uri = Uri.parse('$baseUrl/api/events/get_passed_events');

    try {

      // final jwtToken = await _getJwtToken();

      //if (jwtToken == null) {

      //throw Exception('JWT token not found');

      //}

      var headers = {

        'Content-Type': 'application/json',

        'Accept': 'application/json',

        'Authorization': 'Bearer $userId',

      };



      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {

        final Map<String, dynamic> decodedJson = json.decode(response.body);

        final List<dynamic> eventsJson = decodedJson['data'];

        final List<Event> events = eventsJson.map((jsonEvent) =>

            Event.fromJson(jsonEvent)).toList();

        return events;

      } else if (response.statusCode == 401) {

        throw Exception('Unauthorized request');

      } else {

        throw Exception('Failed to load past events');

      }

    } catch (e) {

      throw Exception('Failed to connect to the server: $e');

    }

  }
  Future<List<Category>> fetchUniqueCategories() async {
    final uri = Uri.parse('$baseUrl/api/events/categories');

    try {
      /* final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }*/

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        //  'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        print("processing..");
        final List<dynamic> jsonResponse = jsonDecode(response.body)['data'];

        if (jsonResponse == null || jsonResponse.isEmpty) {
          print('No categories found.');
          return [];
        }

        return   jsonResponse.map((json) => Category.fromJson(json as String)).toList();;
      } else if (response.statusCode == 401) {
        print('Unauthorized request');
        throw Exception('Unauthorized request');
        print("Unauth req");
      } else {
        print('Failed to load categories');
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<dynamic>> searchEvents(String searchTerm) async {
    final queryParams = {
      'searchString': searchTerm,
    };
    final uri = Uri.parse('$baseUrl/api/events/search')
        .replace(queryParameters: queryParams);
    try {
      /* final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }
*/
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> eventsJson = decodedJson['data'];
        final List<Event> events =
            eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
        return events;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized request');
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  /* Future<List<dynamic>> filterEventsByKeyword(String keyword) async {
    final queryParams = {'keywordFilter': keyword};
    final uri = Uri.parse('$baseUrl/api/events/filter').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data;
      } else {
        throw Exception('Failed to filter events');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
*/
  Future<List<Event>> filterEvents(String? startDate, String? endDate,
      int? maxCapacity, bool isPrivate) async {
    Map<String, String> queryParameters = {};

    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    if (startDate != null) {
      DateTime startDateTime = DateTime.parse(startDate);
      queryParameters['startDateTime'] = formatter.format(startDateTime);
    }
    if (endDate != null) {
      DateTime endDateTime = DateTime.parse(endDate);
      queryParameters['endDateTime'] = formatter.format(endDateTime);
    }
    if (maxCapacity != null)
      queryParameters['maxAttendees'] = maxCapacity.toString();
    queryParameters['isPrivate'] = isPrivate.toString();

    Uri uri = Uri.parse('$baseUrl/api/events/filter').replace(
        queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> eventJsonList = jsonResponse['data'];
        return eventJsonList.map((eventJson) => Event.fromJson(eventJson))
            .toList();
      } else {
        throw Exception('Failed to filter events');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Venue>> getLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/api/events/get_locations'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Response body: ${response.body}');

      final data = responseData['data'] as List<dynamic>;
      return data.map((item) => Venue.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }
}