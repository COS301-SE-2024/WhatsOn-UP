import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const String baseUrl = 'http://localhost:8080';


  Future<List<dynamic>> searchEvents({
    String? title,
    String? description,
    int? startDate,
    int? endDate,
  }) async {
    final queryParams = {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startDate != null) 'startDate': startDate.toString(),
      if (endDate != null) 'endDate': endDate.toString(),
    };
    //yet to remove startDate and enddate when cleaning up code. trying to ensure functionality is solid

    final uri = Uri.parse('$baseUrl/api/events/search').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
  Future<List<dynamic>> filterEventsByKeyword(String keyword) async {
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

  Future<List<dynamic>> filterEvents({
    String date = '',
    int maxAttendees = 0,
    String type = '',
  }) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/events/filterEvents?date=$date&maxAttendees=$maxAttendees&type=$type'));

    if (response.statusCode == 200) {
      final List<dynamic> events = json.decode(response.body);
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }
}
