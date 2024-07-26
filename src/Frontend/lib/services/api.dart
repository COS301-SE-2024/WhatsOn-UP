import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/main.dart';
class Api {
  // Singleton instance
  static final Api _instance = Api._internal();
  // static const String domain = '10.0.2.2';
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
  final _rsvpEventsURL = 'http://$domain:8080/api/events/get_all';
  var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtKey',
      };

  try {
    var response = await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<dynamic> eventsJson = decodedJson['data'];

      // Map the JSON objects to Event objects
      final List<Event> events = eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

//Method to retrieve rsvpd events
  Future<List<dynamic>> getRSVPEvents(String userId) async {
    print('the id in rsvp is $userId');
    try {
      final String _rsvpEventsURL = 'http://$domain:8080/api/user/get_rspv_events';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userId',
      };

      var response = await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

      if (response.statusCode == 200) {
        print('WORKING RSVP API!');
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body));
      }
    }
    catch (e) {
      print('Error RSVP API: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> postChangeUser(String name,String profileImage, String userId) async {
    // Url for posting new informaion

    var userChangeUrl = Uri.parse('http://$domain:8080/api/user/update_profile');

    // Define the headers and body for login request
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',

    };
    var body = jsonEncode({
      'fullName':name,
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
  Future<Map<String, dynamic>> updatePassword(String password,String userId) async {

    var Url = Uri.parse('http://$domain:8080/api/auth/reset_password');
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

  Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    int? maxParticipants,
    String? metadata,
    bool isPrivate = false,
    List<String>? media,
    required String userId,
  }) async {
    final String _createEventUrl = 'http://$domain:8080/api/events/create';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    var body = jsonEncode({
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'maxParticipants': maxParticipants,
      'metadata': metadata,
      'isPrivate': isPrivate,
      'media': media,
    });

    try {
      var response = await http.post(Uri.parse(_createEventUrl), headers: headers, body: body);

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


  Future<Map<String, dynamic>> rsvpEvent(String eventId, String UserId) async {
    final String _rsvpEventUrl = 'http://$domain:8080/api/user/rspv_event/$eventId';
    
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $UserId',
    };

    try {
      var response = await http.put(Uri.parse(_rsvpEventUrl), headers: headers);

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





   Future<Map<String, dynamic>> postUsername(String username,String userid) async {

    var userChangeUrl = Uri.parse('http://$domain:8080/api/user/update_profile');
  //
  //   // Define the headers and body for login request
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
     };
     var body = jsonEncode({
       'fullName':username
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
  Future<Map<String, dynamic>> getUser(String userid) async {
    final String _userUrl = 'http://$domain:8080/api/user/get_user';

    //
    //   // Define the headers and body for login request
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
    };


    try {

      var response = await http.get(Uri.parse(_userUrl), headers: headers);
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

  Future<List<dynamic>> getAllEventsGuest() async {
  
  // var headers = {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //     };

  // try {
  //   var response = await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

  //   if (response.statusCode == 200) {
  //     // Parse the JSON response
  //     final Map<String, dynamic> decodedJson = json.decode(response.body);
  //     final List<dynamic> eventsJson = decodedJson['data'];

  //     // Map the JSON objects to Event objects
  //     final List<Event> events = eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
  //     return events;
  //   } else {
  //     throw Exception('Failed to load events');
  //   }
  // } catch (e) {
  //   print('Error: $e');
  //   rethrow;
  // }

  try {
      final _allEventsGuestURL = 'http://$domain:8080/api/events/get_all';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var response = await http.get(Uri.parse(_allEventsGuestURL), headers: headers);

      if (response.statusCode == 200) {
        // print('WORKING RSVP API!');
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body));
      }
    }
    catch (e) {
      print('Error all events guest: $e');
      throw Exception(e.toString());
    }


}


}
