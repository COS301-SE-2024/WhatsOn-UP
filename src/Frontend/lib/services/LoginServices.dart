import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> postRequest(String email, String password) async {
  // Define the URL for login
  var loginUrl = Uri.parse('http://localhost:8080/api/auth/login');

  // Define the headers and body for login request
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  var body = jsonEncode({
    'email': email,
    'password': password
  });

  try {
    // Make the login request
    var response = await http.post(loginUrl, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Extract JWT from response
      var jwt = jsonDecode(response.body)['body']['jwtToken'];

      // Define the URL and headers for the get_user request
      var userUrl = Uri.parse("http://localhost:8080/api/auth/get_user");
      var userHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      };

      // Make the get_user request
      response = await http.post(userUrl, headers: userHeaders);
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user details');
      }
    } else {
      throw Exception('Failed to login');
    }
  } catch (e) {
    print('Error: $e');
    return {'error': e.toString()};
  }
}
