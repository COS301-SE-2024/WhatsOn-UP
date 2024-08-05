import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/main.dart';
import 'globals.dart' as globals;
import '../pages/editProfile_page.dart';
import '../widgets/notification_card.dart';
import 'package:intl/intl.dart';
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
    final String _loginUrl = 'http://${globals.domain}:8080/api/auth/login';
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

      throw Exception(e.toString());
    }
  }

  // Method to retrieve user details using stored JWT token
  Future<Map<String, dynamic>> getUserDetails() async {
    try {


      final String _userUrl = 'http://${globals.domain}:8080/api/auth/get_user';
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

      throw Exception(e.toString());
    }
  }

  Future<List<Event>> getAllEvents() async {
  final _rsvpEventsURL = 'http://${globals.domain}:8080/api/events/get_all';


  try {
    var response = await http.get(Uri.parse(_rsvpEventsURL),);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<dynamic> eventsJson = decodedJson['data'];
      // Map the JSON objects to Event objects
      final List<Event> events = eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
      print("events");
      print(events);
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  } catch (e) {

    rethrow;
  }
}
  Future<List<Event>> getAllSavedEvents(String userId) async {
    final _savedEventsURL = 'http://${globals.domain}:8080/api/events/get_saved_events';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(Uri.parse(_savedEventsURL),headers: headers,);

      if (response.statusCode == 200) {

        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> eventsJson = decodedJson['data'];


        final List<Event> events = eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {

      rethrow;
    }
  }
//Method to retrieve rsvpd events
  Future<List<dynamic>> getRSVPEvents(String userId) async {

    try {
      final String _rsvpEventsURL = 'http://${globals.domain}:8080/api/user/get_rspv_events';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userId',
      };

      var response = await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

      if (response.statusCode == 200) {

        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body));
      }
    }
    catch (e) {

      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> postChangeUser(String name, String userId) async {

    var userChangeUrl = Uri.parse('http://${globals.domain}:8080/api/user/update_profile');


    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',

    };


    try {

      var response = await http.put(userChangeUrl, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);

      } else {
        throw Exception('Failed to change user');
      }
    } catch (e) {

      return {'error': e.toString()};
    }

  }
  Future<Map<String, dynamic>> updatePassword(String password,String userId) async {

    var Url = Uri.parse('http://${globals.domain}:8080/api/auth/reset_password');
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
    final String _createEventUrl = 'http://${globals.domain}:8080/api/events/create';

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

      throw Exception(e.toString());
    }
  }


  Future<Map<String, dynamic>> rsvpEvent(String eventId, String UserId) async {
    final String _rsvpEventUrl = 'http://${globals.domain}:8080/api/user/rspv_event/$eventId';
    
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

      throw Exception(e.toString());
    }


  }
  Future<List<AppNotification>> getAllNotification({required String userId}) async {

    String notifyUserUrl = 'http://${globals.domain}:8081/notifications/get_all';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };



    try {
      var response = await http.get(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {


        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> eventsJson = decodedJson['data'];

        // Map the JSON objects to Event objects
        final List<AppNotification> events = eventsJson.map((jsonEvent) =>  AppNotification.fromJson(jsonEvent)).toList();
        return events;





        // // return jsonDecode(response.body);
        // final List<dynamic> jsonResponse = json.decode(response.body);
        //
        // return jsonResponse.map((json) => AppNotification.fromJson(json)).toList();
      } else {

        print(jsonDecode(response.body
        ));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {

      throw Exception(e.toString());
    }
  }
  Future<Map<String, dynamic>> AcceptInvite({required String userId, required String notificationId}) async {

    String notifyUserUrl = 'http:${globals.domain}:8081/api/invite/accept/$notificationId';
    // final uri = Uri.parse('http://localhost:8083/media/upload?event_id=$EventId');


    // final request = http.MultipartRequest('POST', uri);
    // request.headers['Authorization']= 'Bearer $userid';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };



    try {
      var response = await http.post(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {


        return jsonDecode(response.body);





        // // return jsonDecode(response.body);
        // final List<dynamic> jsonResponse = json.decode(response.body);
        //
        // return jsonResponse.map((json) => AppNotification.fromJson(json)).toList();
      } else {

        print(jsonDecode(response.body
        ));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {

      throw Exception(e.toString());
    }
  }
  Future<Map<String, dynamic>> postNotifyUser({required String userId, required String message}) async {
    const String notifyUserUrl = '';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    var body = jsonEncode({
      'userId': userId,
      'message': message,
    });

    try {
      var response = await http.post(Uri.parse(notifyUserUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {

      throw Exception(e.toString());
    }
  }
  Future<List<User>> getGeneralusersToHost() async {
    const String generalEventsURL = '';

    try {
      var response = await http.get(Uri.parse(generalEventsURL));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {

      throw Exception(e.toString());
    }
  }
  Future<Map<String, dynamic>> DeletersvpEvent(String eventId, String UserId) async {
    final String _rsvpEventUrl = 'http://${globals.domain}:8080/api/user/delete_rspv_event/$eventId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $UserId',
    };

    try {
      var response = await http.delete(Uri.parse(_rsvpEventUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {

      throw Exception(e.toString());
    }


  }

  Future<Map<String, dynamic>> DeleteEvent(String eventId,String userid) async {
    var Url = Uri.parse('http://${globals.domain}:8080/api/events/delete/$eventId');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
    };

    try {
    var response = await http.delete( Url,headers: headers );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      throw Exception('Failed to delete event');
    }

  } catch (e) {
  print('Error: $e');
  return {'error': e.toString()};
  }
  }



   Future<Map<String, dynamic>> postUsername(String username,String userid) async {

    var userChangeUrl = Uri.parse('http://${globals.domain}:8080/api/user/update_profile');
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
    final String _userUrl = 'http://${globals.domain}:8080/api/user/get_user';

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

      return {'error': e.toString()};
    }

  }


Future<List<dynamic>> getAllEventsGuest() async {
  try {
      final _rsvpEventsURL = 'http://${globals.domain}:8080/api/events/get_all';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var response = await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

      if (response.statusCode == 200) {

        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body));
      }
    }
    catch (e) {

      throw Exception(e.toString());
    }
}


  Future<Map<String, dynamic>> updateEvent({

    required String userId,
    required String eventId,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    int? maxParticipants,
    String? metadata,
    bool isPrivate = false,
    List<String>? media,

  })async {
    final String _userUrl = 'http://${globals.domain}:8080/api/events/update/$eventId';

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

    });

    try {

      var response = await http.put(Uri.parse(_userUrl), headers: headers,body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);

      } else {
        throw Exception('Failed to get user details');
      }
    } catch (e) {

      return {'error': e.toString()};
    }

  }
  Future<Map<String, dynamic>> uploadImage(Uint8List imageBytes, String userid) async {
    String generateFilename(String userId) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'profile_image_${userId}_$timestamp.png';
    }
    final uri = Uri.parse('http://${globals.domain}:8083/media/update');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
    };

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization']= 'Bearer $userid';

    final filename = generateFilename(userid);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        return jsonDecode(response.stream.toString());
      } else {

        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> eventUploadImage(Uint8List imageBytes, String userid, String EventId) async {
    String generateFilename(String userId) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'profile_image_${userId}_$timestamp.png';
    }
    final uri = Uri.parse('http://${globals.domain}:8083/media/upload?event_id=$EventId');


    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization']= 'Bearer $userid';

    final filename = generateFilename(userid);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        return jsonDecode(response.stream.toString());
      } else {

        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
  Future<Map<String, dynamic>> applyForHost({
    required String reason,
    required String duration,
    required DateTime fromWhen,
    String? studentEmail,
    Uint8List? proofImage,
    required String userId,
  }) async {

    final String _applyUrl = 'http://$domain:8080/api/user/apply_for_host';
    
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    var queryParams = {
      'reason': reason,
      'fromWhen': DateFormat("yyyy-MM-dd HH:mm:ss").format(fromWhen),
    };

    if (duration != 'Permanent') {
      queryParams['howLong'] = duration == '1 week' ? '7' : '30';
    }

    if (studentEmail != null) {
      queryParams['studentEmail'] = studentEmail;
    }

    var uri = Uri.parse(_applyUrl).replace(queryParameters: queryParams);

    try {
      var response = await http.put(uri, headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        
        // Non UP affiliated students need to upload proof image
        if (studentEmail == null && proofImage != null) {
          String applicationId = responseData['data']['application_id'];
          await _uploadProofImage(applicationId, proofImage, userId);
        }

        return responseData;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _uploadProofImage(String applicationId, Uint8List imageBytes, String userId) async {

    final String _uploadUrl = 'http://$domain:8083/media/proof?application_id=$applicationId';
    
    var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

    request.headers['Authorization'] = 'Bearer $userId';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: 'proof_image.jpg',
    ));

    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload proof image');
    }
  }


}
