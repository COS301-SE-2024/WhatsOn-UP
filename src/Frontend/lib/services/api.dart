import 'dart:convert';
import 'package:firstapp/schemas/recommendation_schemas.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/main.dart';
import 'package:json_schema/json_schema.dart';
import 'globals.dart' as globals;
import '../pages/editProfile_page.dart';
import '../providers/user_provider.dart';
import '../widgets/notification_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/screens/InviteUsers.dart';
import 'package:path/path.dart' as path;



class Api {
  // Singleton instance
  static final Api _instance = Api._internal();
  factory Api() => _instance;

  Api._internal();


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
      var response = await http.post(
          Uri.parse(_loginUrl), headers: headers, body: body);

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
      var response = await http.get(
        Uri.parse(_rsvpEventsURL),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> eventsJson = decodedJson['data'];

        final List<Event> events =
            eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();

        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Event>> getAllSavedEvents(String userId) async {
    final _savedEventsURL = 'http://${globals.domain}:8080/api/user/get_saved_events';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(
        Uri.parse(_savedEventsURL),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> eventsJson = decodedJson['data'];

        final List<Event> events =
            eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Event>> getRecommendedEvents(String userId) async {
    final URL = 'http://${globals.domain}:8086/events/recommended_events';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(
        Uri.parse(URL),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        //validate json schema
        final schema = JsonSchema.create(RECOMMENDED_EVENTS_SCHEMA);
        final validationResult = schema.validate(decodedJson);

        if (validationResult.isValid) {
          print('getRecommendedEvents JSON is valid');
        } else {
          print('getRecommendedEvents JSON is invalid. Errors:');
          for (var error in validationResult.errors) {
            print(error);
          }
        }
        final List<dynamic> eventsJson = decodedJson['data']['message'];

        // final List<Event> events =
        // eventsJson.map((jsonEvent) => Event.fromJson(jsonEvent)).toList();
        final List<Event> events = eventsJson.map((jsonEvent) {
          // Extract the event part of the JSON
          final eventJson = jsonEvent['event'];
          // final rating = jsonEvent['rating'];
          return Event.fromJson(eventJson);
        }).toList();
        print('Recommended events: $events');
        return events;
      } else {
        throw Exception('Failed to load recommended events');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<dynamic>> getRSVPEvents(String userId) async {
    try {
      final String _rsvpEventsURL = 'http://${globals.domain}:8080/api/user/get_rsvp_events';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userId',
      };

      var response =
          await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> postChangeUser(String name, String userId) async {

    var userChangeUrl = Uri.parse('http://${globals.domain}:8080/api/user/update_profile?fullName=$name');


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

  Future<Map<String, dynamic>> updatePassword(
      String password, String userId) async {
    var Url = Uri.parse('http://${globals.domain}:8080/api/auth/reset_password');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtKey',
    };
    var body = jsonEncode({
      'password': password,
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
    required String locationId,
    int? maxParticipants,
    Map<String, String>? metadata,
    bool? isPrivate,
    //List<String>? media,
    required String userId,
    //List<String> imageUrls,
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
      'startDateTime': startDate.toIso8601String(),
      'endDateTime': endDate.toIso8601String(),
      'location': locationId,
      'maxParticipants': maxParticipants,
      'metadata': metadata,
      'isPrivate': isPrivate,
     // 'media': media,
    });

    try {
      var response = await http.post(Uri.parse(_createEventUrl),
          headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print( responseData['data']);
        String eventId = responseData['data']['id'];
       // for (String imagePath in imageUrls) {
         // Uint8List imageBytes = await _loadImageAsBytes(imagePath);
        //  var uploadResult = await eventUploadImage(imageBytes, userId, eventId);
         // if (uploadResult.containsKey('error')) {
         //   throw Exception('Image upload failed: ${uploadResult['error']}');

         // }



        //print("image uploaded");
        return responseData;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  /*Future<void> _uploadEventImage(String eventId, String imagePath, String userId) async {
    final String _uploadUrl = 'http://$domain:8083/media/upload?event_id=$eventId';

    var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

    request.headers['Authorization'] = 'Bearer $userId';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imagePath,
    ));

    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload image');
    }
  }

*/
  Future<Map<String, dynamic>> rsvpEvent(String eventId, String UserId) async {
    final String _rsvpEventUrl =
        'http://${globals.domain}:8080/api/user/rsvp_event/$eventId';

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
  Future<Map<String, dynamic>> putSavedEvent(String eventId, String UserId) async {
    final String _rsvpEventUrl =
        'http://${globals.domain}:8080/api/user/save_event/$eventId';

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
  Future<Map<String, dynamic>> DeleteSavedEvent(String eventId, String UserId) async {
    final String _rsvpEventUrl =
        'http://${globals.domain}:8080/api/user/delete_saved_event/$eventId';

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
Future<List<AppNotification>> getAllNotification(
      {required String userId}) async {
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

        final List<AppNotification> events = eventsJson
            .map((jsonEvent) => AppNotification.fromJson(jsonEvent))
            .toList();
        return events;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> AcceptInvite(
      {String? userId, String? notificationId}) async {
    String notifyUserUrl =
        'http://${globals.domain}:8080/api/interactions/accept_invite/$notificationId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response =
          await http.post(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(jsonDecode(response.body));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> postNotifyUser(
      {required String userId, required String message}) async {
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
      var response = await http.post(Uri.parse(notifyUserUrl),
          headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<GeneralApplications> getGeneralusersToHost(String userid) async {
    String notifyUserUrl =
        'http://${globals.domain}:8080/api/admin/all_applications';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
    };

    try {
      var response = await http.get(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Response body decoded in applications: $jsonResponse');
        var generalApplications = GeneralApplications.fromJson(jsonResponse);

        return generalApplications;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> DeletersvpEvent(
      String eventId, String UserId) async {
    final String _rsvpEventUrl =
        'http://${globals.domain}:8080/api/user/delete_rsvp_event/$eventId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $UserId',
    };

    try {
      var response =
          await http.delete(Uri.parse(_rsvpEventUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> DeleteEvent(
      String eventId, String userid) async {
    var Url = Uri.parse('http://${globals.domain}:8080/api/events/remove/$eventId');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
    };

    try {
      var response = await http.delete(Url, headers: headers);
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

  Future<Map<String, dynamic>> postUsername(
      String username, String userid) async {
    String encodedUsername = Uri.encodeComponent(username);
    var userChangeUrl = Uri.parse(
        'http://${globals.domain}:8080/api/user/update_profile?fullName=$encodedUsername');

    print("Username received in postUsername: $username");
    print("Encoded url: $userChangeUrl");

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userid',
    };

    try {
      var response = await http.put(userChangeUrl, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        print('Failed to change user: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to change user: ${response.statusCode}');
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

      var response =
          await http.get(Uri.parse(_rsvpEventsURL), headers: headers);

      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body)['data'];
        return decodedJson;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
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
  }) async {
    final String _userUrl = 'http://${globals.domain}:8080/api/events/update/$eventId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    print(location);
    var body = jsonEncode({
      'title': title,
      'description': description,
      // 'startDate': startDate.toIso8601String(),
      // 'endDate': endDate.toIso8601String(),
      'location': location,
      'maxParticipants': maxParticipants,
      'metadata': metadata,
    });

    try {
      var response =
          await http.put(Uri.parse(_userUrl), headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> uploadImage(
      Uint8List imageBytes, String userid) async {
    String generateFilename(String userId) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'profile_image_${userId}_$timestamp.png';
    }

    final uri = Uri.parse('http://${globals.domain}:8083/media/update');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $userid';

    final filename = generateFilename(userid);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('Failed to parse response as JSON: ${response.body}');
        return {
          'success': true,
          'raw_response': response.body,
        };
      }
    } else {
      throw Exception('Upload failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception during upload: $e');
    return {'error': e.toString()};
  }
}
/*from dev
*   Future<Map<String, dynamic>> eventUploadImage(Uint8List imageBytes,
      String userid, String EventId) async {
    String generateFilename(String userId) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'profile_image_${userId}_$timestamp.png';
    }*/
  Future<Uint8List> _loadImageAsBytes(String imagePath) async {
    try {
      return await rootBundle.load(imagePath).then((data) => data.buffer.asUint8List());
    } catch (e) {
      throw Exception("Failed to load image: $e");
    }
  }
/*Future<void> _uploadProofImage(String applicationId, Uint8List imageBytes, String userId) async {

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
  }*/
  Future<Map<String, dynamic>> eventUploadImage(Uint8List mediaBytes, String userId, String eventId, String originalFilename) async {
    String generateFilename(String eventId, String originalFilename) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(originalFilename);
      return 'event_media_${eventId}_$timestamp$extension';
    }

    final uri = Uri.parse('http://${globals.domain}:8083/media/upload?event_id=$eventId');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $userId';
    
    final filename = generateFilename(eventId, originalFilename);
    
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        mediaBytes,
        filename: filename,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        print(jsonDecode(responseBody));
        return jsonDecode(responseBody);
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
    final String _applyUrl = 'http://${globals.domain}:8080/api/user/apply_for_host';

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
        var errorData = jsonDecode(response.body);
        if (errorData['status'] == 'error' && errorData['data'] == 'User has already applied') {
          throw Exception('already_applied');
        } else {
          throw Exception(errorData);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
Future<Map<String, dynamic>> broadcastEvent(String eventId, String message, String userId) async {

    final String url='http://${globals.domain}:8080/api/events/broadcast?eventId=$eventId&message=$message';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.put(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to BROADCAST EVENT');
      }
    } catch (e) {
      return {'error': e.toString()};
    }

}
  Future<Map<String, dynamic>> broadcast(String message, String userId ) async {

    final String url='http://${globals.domain}:8080/api/admin/broadcast?message=$message';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    try {
      var response = await http.put(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to BROADCAST');
      }
    } catch (e) {
      return {'error': e.toString()};
    }

  }
  Future<void> _uploadProofImage(
      String applicationId, Uint8List imageBytes, String userId) async {
    final String _uploadUrl =
        'http://${globals.domain}:8083/media/proof?application_id=$applicationId';

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
  static Future<List<UserModel>> getAllUsers(String userId) async {
    print("User Id below");
    print(userId);

      //var response = await http.put(uri, headers: headers);
/* final String _userUrl = 'http://$domain:8080/api/auth/get_user';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtKey',
      };

      var response = await http.get(Uri.parse(_userUrl), headers: headers);
*/
    final String _userUrl = 'http://${globals.domain}:8080/api/interactions/get_all_users';
      var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    final response = await http.get(Uri.parse(_userUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => UserModel.fromJson(json)).toList(); // Adjust based on your UserModel structure
    } else {
      throw Exception('Failed to load users');
    }
  }
  static Future<void> inviteUser(String eventId, String userId , String inviteeUserId) async {
    final response = await http.put(
      Uri.parse('http://${globals.domain}:8080/api/interactions/send_invite?eventId=$eventId&userId=$inviteeUserId'),
      headers: {
        'Authorization': 'Bearer $userId', // Adjust for authentication
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send invite');
    }
  }
  Future<Map<String, dynamic>> AcceptApplication(
      {required String userId, required String applicationId}) async {
    String notifyUserUrl =
        'http://${globals.domain}:8080/api/admin/accept_application?applicationId=$applicationId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    try {
      var response =
          await http.post(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(jsonDecode(response.body));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> DeclineApplication(
      {required String userId, required String applicationId}) async {
    String notifyUserUrl =
        'http://${globals.domain}:8080/api/admin/reject_application?applicationId=$applicationId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    try {
      var response =
          await http.post(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(jsonDecode(response.body));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> DemoteApplicant(
      {required String userIdAdmin,
      required String userId,
      required String applicationId}) async {
    String notifyUserUrl =
        'http://${globals.domain}:8080/api/admin/demote?userId=$userId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userIdAdmin',
    };
    try {
      var response =
          await http.post(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(jsonDecode(response.body));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> Acknowledgeapplication(
      {required String userId}) async {
    String notifyUserUrl =
        'http://${globals.domain}:8080/api/user/acknowledge_application';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    try {
      var response =
          await http.post(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(jsonDecode(response.body));
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }






  Future<List<Category>> getCategories({required String userId}) async {
    String notifyUserUrl = 'http://${globals.domain}:8080/api/events/categories';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(Uri.parse(notifyUserUrl), headers: headers);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final List<dynamic> jsonResponse = jsonDecode(response.body)['data'];

        return  jsonResponse.map((json) => Category.fromJson(json as String)).toList();

      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<Map<String, dynamic>> postRecommendationData(
      {required String userId,
        required Map<String, dynamic> data,}) async {
        String notifyUserUrl =
        'http://${globals.domain}:8086/preferences/init';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };
    try {
      var response =
          await http.post(Uri.parse(notifyUserUrl), headers: headers,body: jsonEncode(data));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Error response: $errorResponse');
        throw Exception('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught in postRecommendationData: $e');
      throw Exception('An error occurred while posting recommendation data: $e');
    }
  }


  Future<Map<String, dynamic>> rateEvent(String eventId, String userID, int rating, String comment) async {
    String rateEventURL;

    if (comment == '') {
      rateEventURL = 'http://${globals.domain}:8080/api/user/rate_event/$eventId?rating=$rating';
    }
    else {
      rateEventURL = 'http://${globals.domain}:8080/api/user/rate_event/$eventId?comment=${Uri.encodeComponent(comment)}&rating=$rating';
    }

    var headers = {
      'Content-Type': 'application/json', 
      'Accept': 'application/json',
      'Authorization': 'Bearer $userID',
    };

    print("CALLING RATE WITH: " + rateEventURL);

    try {
      var response = await http.put(Uri.parse(rateEventURL), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> deleteEventMedia(String imageName, String userId) async {
    final String deleteMediaUrl = 'http://${globals.domain}:8083/media/delete?media_name=$imageName';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.delete(Uri.parse(deleteMediaUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else {
        throw Exception(jsonDecode(response.body));
      }
    } 
    catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> deleteNotification(String notificationId, String userId) async {
    final String deleteNotificationUrl = 'http://${globals.domain}:8081/notifications/delete/$notificationId';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.delete(Uri.parse(deleteNotificationUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else {
        throw Exception(jsonDecode(response.body));
      }
    } 
    catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAllEventsAnalytics(String userId) async {
    final String getAllAnalyticsURL = 'http://${globals.domain}:8084/analytics/admin/get_all_events';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(Uri.parse(getAllAnalyticsURL), headers: headers);

      if (response.statusCode == 200) {
        // print("ANALYTICS: " + jsonDecode(response.body));
        return jsonDecode(response.body);
      } 
      else {
        throw Exception(jsonDecode(response.body));
      }
    } 
    catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAllHostsAnalytics(String userId) async {
    final String getAllHostsAnalyticsURL = 'http://${globals.domain}:8084/analytics/admin/get_for_all_hosts';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(Uri.parse(getAllHostsAnalyticsURL), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else {
        throw Exception(jsonDecode(response.body));
      }
    } 
    catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<Map<String, dynamic>> getHostEventAnalytics(String userId) async {
    final String getHostEventAnalyticsURL = 'http://${globals.domain}:8084/analytics/admin/get_past_events_by_host/${userId}';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(Uri.parse(getHostEventAnalyticsURL), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else {
        throw Exception(jsonDecode(response.body));
      }
    } 
    catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAllPopularEvents(String userId) async {
    final String getAllPopularEventsURL = 'http://${globals.domain}:8084/analytics/admin/get_popular_events';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userId',
    };

    try {
      var response = await http.get(Uri.parse(getAllPopularEventsURL), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else {
        throw Exception(jsonDecode(response.body));
      }
    } 
    catch (e) {
      throw Exception(e.toString());
    }
  }
}




