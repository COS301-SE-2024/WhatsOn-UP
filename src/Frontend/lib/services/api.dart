import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';
class Api {
  // Singleton instance
  static final Api _instance = Api._internal();
  factory Api() => _instance;
  Api._internal();

  // Secure Storage instance
  // final _secureStorage = const FlutterSecureStorage();

  // Keys for storing JWT and refresh token
  var jwtKey = 'jwtToken';
  var refreshToken = 'refreshToken';

  // Method to log in the user and store JWT token
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final String _loginUrl = 'http://localhost:8080/api/auth/login';
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
        // await _secureStorage.write(key: 'jwtToken', value: jwtKey);
        // await _secureStorage.write(key: 'refreshToken', value: refreshToken);
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

      final String _userUrl = 'http://localhost:8080/api/auth/get_user';

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

  //Method to retrieve rsvpd events
  Future<List<dynamic>> getRSVPEvents() async {
    try {
      final String _rsvpEventsURL = 'http://localhost:8080/api/user/get_rspv_events';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtKey',
      };

      var response = await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body));
      }
    }
    catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
    }
  }


  Future<Map<String, dynamic>> postChangeUser(String name, String email,  String profileImage) async {
    // Url for posting new informaion

    var userChangeUrl = Uri.parse('http://localhost:8080/api/user/update_profile');

    // Define the headers and body for login request
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtKey',

    };
    var body = jsonEncode({
      'fullName':name,
      'email': email,
      "profileImage":profileImage,
    });

    try {

      var response = await http.put(userChangeUrl, headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);

      } else {
        throw Exception('Failed to change user');
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }

  }
  Future<Map<String, dynamic>> updatePassword(String password) async {

    var Url = Uri.parse('http://localhost:8080/api/auth/reset_password');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtKey',

    };
    var body = jsonEncode({

      'password':password,

    });

    try {

      var response = await http.post(Url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("sucessfully changed password");
        return jsonDecode(response.body);

      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }
}
