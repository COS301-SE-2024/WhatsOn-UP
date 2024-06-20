import 'dart:convert';
import 'package:http/http.dart' as http;

// Future<Map<String, dynamic>>  postEditUser(String name, String email, String password) async { //i want to add the user id parameter to search for the user
//   // Define the URL like login but we want o check if the user exists
//   var EditUserUrl = Uri.parse('');
//
//   // Define the headers and body for login request
//   var headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   };
//   var body = jsonEncode({
//   //  'id': userId,
//                    //want to check using the user id
//
//    });
//
//   try {
//     // Make the login request
//     var response = await http.post(EditUserUrl, headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       // Extract JWT from response
//       var jwt = jsonDecode(response.body)['body']['jwtToken'];
//
//
//       var userUrl = Uri.parse("http://localhost:8080/api/auth/get_user");//
//       var userHeaders = {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $jwt',
//       };
//
//
//       response = await http.post(userUrl, headers: userHeaders);
//       print(response.body);
//
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to get user details');
//       }
//     } else {
//       throw Exception('Failed to login');
//     }
//   } catch (e) {
//     print('Error: $e');
//     return {'error': e.toString()};
//   }
// }

//above we are trying t find the user //just to test that we can identify the user before we make any changes



Future<Map<String, dynamic>> postChangeUser(String name, String email, String password) async {
  // Url for posting new informaion
  var userChangeUrl = Uri.parse('http://ec2-13-60-34-71.eu-north-1.compute.amazonaws.com:8080/api/..');

  // Define the headers and body for login request
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',

  };
  var body = jsonEncode({
    'name':name,
    'email': email,
    'password': password
  });

  try {

    var response = await http.post(userChangeUrl, headers: headers, body: body);

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