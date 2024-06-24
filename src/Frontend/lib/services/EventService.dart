import 'dart:convert';
import 'package:http/http.dart' as http;


class EventService {
  static const String baseUrl = 'http://localhost:8080';


  Future<List<dynamic>> searchEvents(String searchTerm) async {
    final uri = Uri.parse('$baseUrl/api/events/search/$searchTerm');
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
