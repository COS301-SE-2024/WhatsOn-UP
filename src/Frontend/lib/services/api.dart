import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firstapp/widgets/event_card.dart';

class Api {
  // Singleton instance
  static final Api _instance = Api._internal();
  static const String domain = 'localhost';
  factory Api() => _instance;
  Api._internal();

  // Secure Storage instance
  // final _secureStorage = const FlutterSecureStorage();

  // Keys for storing JWT and refresh token
  var jwtKey = 'jwtToken';
  var refreshToken = 'refreshToken';

  // Method to log in the user and store JWT token
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final String _loginUrl = 'http://$domain:8080/api/auth/login';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      'email': email,
      'password': password
    });

    try {
      var response = await http.post(Uri.parse(_loginUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body)['data'];
        jwtKey = responseBody['jwtToken'];
        refreshToken = responseBody['refreshToken'];
        // Store tokens securely
        // await _secureStorage.write(key: jwtKey, value: jwtToken);
        // await _secureStorage.write(key: refreshTokenKey, value: refreshToken);
        // Return user details
        return await getUserDetails();
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
    }
  }

  // Method to retrieve user details using stored JWT token
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      // Retrieve tokens from secure storage
      // String? jwtToken = await _secureStorage.read(key: jwtKey);
      // if (jwtToken == null) {
      //   print('JWT token not found');
      //   throw Exception('JWT token not found');
      // }

      final String _userUrl = 'http://$domain:8080/api/auth/get_user';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtKey',
      };

      var response = await http.get(Uri.parse(_userUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Event>> getAllEvents() async {
  final url = 'http://$domain:8080/api/events/get_all';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<dynamic> eventsJson = decodedJson['data'];

      // Map the JSON objects to Event objects
      final List<Event> events = eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
      print(events[0]);
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

}
