import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> postRequest(email, password) async {
  // Define the URL
  final url = Uri.parse('http://ec2-13-60-34-71.eu-north-1.compute.amazonaws.com:8080/login');

  // Define the headers and body
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({
    'email': email,
    'password': password
  });

  try {
    // Make the POST request
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
}