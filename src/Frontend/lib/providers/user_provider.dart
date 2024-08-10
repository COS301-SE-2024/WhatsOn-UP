import 'package:flutter/material.dart';



import '../pages/editProfile_page.dart';
import '../services/api.dart';




//will let the listeners know when the state has changed

class userProvider extends ChangeNotifier{
  late  Api api= Api();
  String _Fullname = 'Testing';
  String _Email = '';
  String _Password = '';
  String _Role= '';
  String _userId= '';
  String? profileimage;
  bool _isGuest = false;
  late  Future<List<User>> _generaluserTohost;
  String get Fullname => _Fullname;
  String get email => _Email;
  String get password => _Password;
  String? get profileImage => profileimage;
  String get role => _Role;
  String get userId => _userId;
  bool get isGuest => _isGuest;
  Future<GeneralApplications>? _generalApplications;
  Future<GeneralApplications>? get  generalApplications => _generalApplications;





set generalapplications( Future<GeneralApplications>? value) {
    _generalApplications = value;
    notifyListeners();
}
   set Fullname(String value){
    _Fullname = value;
    notifyListeners();
   }
    set email(String value){
      _Email = value;
      notifyListeners();
    }
    set password(String value){
      _Password = value;
      notifyListeners();
    }
    set profileImage(String?value){
      profileimage = value;
      notifyListeners();
    }
    set role(String value){
      _Role = value;
      notifyListeners();
    }
    set userId(String value){
      _userId = value;
      notifyListeners();
    }
    set isGuest(bool value) {
      _isGuest = value;
      notifyListeners();
  }


  void setUserData({
    required String userId,
    required String fullName,
    required String email,
    String? password,
    required String role,
    String? profileImage,
    required bool isGuest,
  }) {
    _userId = userId;
    _Fullname = fullName;
    _Email = email;
    if (password != null) _Password = password;
    _Role = role;
    this.profileImage = profileImage;
    _isGuest = isGuest;
    notifyListeners();
  }

  void setGuestUser() {
    _userId = 'guest';
    _Fullname = 'Guest User';
    _Email = '';
    _Password = '';
    _Role = 'GUEST';
    profileImage = null;
    _isGuest = true;
    notifyListeners();
  }

  void clearUser() {
    _userId = '';
    _Fullname = '';
    _Email = '';
    _Password = '';
    _Role = '';
    profileImage = null;
    _isGuest = false;
    notifyListeners();
  }

  Future<void> Generalusers(String userId) async {
    try {
       _fetchGeneralusers(userId);
      notifyListeners();
    } catch (e) {
      print('something is wrong');
      throw Exception('Failed to refresh events: $e');
    }
  }
  Future<void> _fetchGeneralusers(String userId) async {
    try {

      final response = await api.getGeneralusersToHost(userId);
      print('Response from API: $response');
      generalapplications = Future.value(response);
      notifyListeners();
    } catch (e) {
      print('Error: $e'); // Print the error
      throw Exception('Failed to load general users');
    }

  }
}

class Status {
  final int id;
  final String name;

  Status({required this.id, required this.name});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      name: json['name'],
    );
  }
}
class Role {
  final int id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}
class UserGeneral {
  final String userId;
  final String? fullName;
  final String profileImage;
  final Role role;

  UserGeneral({
    required this.userId,
    required this.fullName,
    required this.profileImage,
    required this.role,
  });

  factory UserGeneral.fromJson(Map<String, dynamic> json) {
    return UserGeneral(
      userId: json['userId'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      role: Role.fromJson(json['role']),
    );
  }
}
class AcceptedRejectedBy {
  final String userId;
  final String? fullName;
  final String profileImage;
  final Role role;

  AcceptedRejectedBy({
    required this.userId,
    required this.fullName,
    required this.profileImage,
    required this.role,
  });

  factory AcceptedRejectedBy.fromJson(Map<String, dynamic> json) {
    return AcceptedRejectedBy(
      userId: json['userId'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      role: Role.fromJson(json['role']),
    );
  }
}
class Application {
  final String applicationId;
  final Status status;
  final UserGeneral user;
  final String expiryDateTime;
  final AcceptedRejectedBy? acceptedRejectedBy;
  final String reason;
  final String? verificationCode;

  Application({
    required this.applicationId,
    required this.status,
    required this.user,
    required this.expiryDateTime,
    this.acceptedRejectedBy,
    required this.reason,
    this.verificationCode,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['applicationId'],
      status: Status.fromJson(json['status']),
      user:UserGeneral.fromJson(json['user']),
      expiryDateTime: json['expiryDateTime'],
      acceptedRejectedBy: json['acceptedRejectedBy'] != null ? AcceptedRejectedBy.fromJson(json['acceptedRejectedBy']) : null,
      reason: json['reason'],
      verificationCode: json['verificationCode'],
    );
  }
}
class GeneralApplications {
  final String status;
  final int timestamp;
  final List<Application> data;

  GeneralApplications({
    required this.status,
    required this.timestamp,
    required this.data,
  });

  factory  GeneralApplications.fromJson(Map<String, dynamic> json) {
    print('GeneralApplications: $json');
    var list = json['data'] as List;
    print('list: $list');
    List<Application> applicationsList = list.map((i) => Application.fromJson(i)).toList();

    return  GeneralApplications(
      status: json['status'],
      timestamp: json['timestamp'],
      data: applicationsList,
    );
  }
}


