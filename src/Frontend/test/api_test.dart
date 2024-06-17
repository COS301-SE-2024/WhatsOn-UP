import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  // Singleton instance
  static final Api _instance = Api._internal();
  factory Api() => _instance;
  Api._internal();

  // Secure Storage
  final _secureStorage = FlutterSecureStorage();

  // Base URLs
  final String _loginUrl = 'http://localhost:8080/api/auth/login';
  final String _userUrl = 'http://localhost:8080/api/auth/get_user';

  // Keys for storing JWT and refresh token
  final String _jwtKey = 'jwtToken';
  final String _refreshTokenKey = 'refreshToken';

  // Method to log in the user and store JWT token
  Future<bool> loginUser(String email, String password) async {
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
        var responseBody = jsonDecode(response.body)['body'];
        var jwt = responseBody['jwtToken'];
        var refreshToken = responseBody['refreshToken'];

        // Store tokens securely
        await _secureStorage.write(key: _jwtKey, value: jwt);
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
        return true;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Method to retrieve user details using stored JWT token
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      var jwt = await _secureStorage.read(key: _jwtKey);
      if (jwt == null) throw Exception('No JWT token found');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      };

      var response = await http.post(Uri.parse(_userUrl), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user details');
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }
}

// Example usage
Future<void> main() async {
  var email = 'your-email@example.com';
  var password = 'your-password';

  var api = Api();

  var loginSuccess = await api.loginUser(email, password);
  if (loginSuccess) {
    var userDetails = await api.getUserDetails();
    print(userDetails);
  }
}
