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
}
