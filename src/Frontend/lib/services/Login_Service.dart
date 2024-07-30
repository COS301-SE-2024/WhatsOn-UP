/*import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

Future<Map<String, dynamic>> postRequest(email, password) async {

  final url = Uri.parse('http://${globals.domain}:8080/login');

  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({
    'email': email,
    'password': password
  });

  try {

    final response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create post');
    }
  } catch (e) {
    print('Error: $e');
    return {'error': e.toString()};
  }
}*/