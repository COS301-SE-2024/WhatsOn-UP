import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';import 'package:firstapp/widgets/event_card.dart';



class EventService {
  static const String baseUrl = 'http://localhost:8080';
  String authToken = ''; //here

  Future<List<String>> fetchUniqueCategories() async {
    final uri = Uri.parse('$baseUrl/api/events/categories');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $authToken',
      });
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);
        print("body");
        final List<String> categories = decodedJson.map((category) => category.toString()).toList();
        print(categories);
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }


  Future<List<dynamic>> searchEvents(String searchTerm) async {
    final uri = Uri.parse('$baseUrl/api/events/search/$searchTerm');
    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $authToken',
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> eventsJson = decodedJson['data'];


        final List<Event> events = eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
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
  Future<List<dynamic>> filterEvents(String startDate, String endDate, int minCapacity, int maxCapacity, bool isPrivate) async {
    final queryParams = {
      'startDate': startDate,
      'endDate': endDate,
      'minCapacity': minCapacity.toString(),
      'maxCapacity': maxCapacity.toString(),
      'isPrivate': isPrivate.toString(),
    };

    final uri = Uri.parse('$baseUrl/api/events/filterEvents').replace(queryParameters: queryParams);

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
}
