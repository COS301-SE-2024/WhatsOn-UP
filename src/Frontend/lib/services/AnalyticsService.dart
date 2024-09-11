/*import 'dart:convert';
import 'package:http/http.dart' as http;


  Future<Map<String, dynamic>> fetchEventAnalyticsData() async {
    final response = await http.get(Uri.parse('http://your-backend-url/api/event-analytics'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load event analytics');
    }
  }

  Future<Map<String, dynamic>> fetchSecondaryAnalyticsData() async {
    final response = await http.get(Uri.parse('http://your-backend-url/api/secondary-analytics'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load secondary analytics');
    }
  }

*/
