// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
//
//
// Future<Map<String, dynamic>> postChangeUser(String name, String email, String password, String id, String profileImage) async {
//   // Url for posting new informaion
//   var userChangeUrl = Uri.parse('http://localhost:8080/api/user/update_Profile');
//
//   // Define the headers and body for login request
//   var headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//
//   };
//   var body = jsonEncode({
//     'fullName':name,
//     'email': email,
//     // 'password': password,
//     "profileImage":profileImage,
//   });
//
//   try {
//
//     var response = await http.post(userChangeUrl, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//
//     } else {
//       throw Exception('Failed to change user');
//     }
//   } catch (e) {
//     print('Error: $e');
//     return {'error': e.toString()};
//   }
//
// }