import 'package:flutter/material.dart';



import '../pages/editProfile_page.dart';
import '../services/api.dart';




//will let the listeners know when the state has changed

class userProvider extends ChangeNotifier{
  late final Api api= Api();
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
  Future<List<User>> get generalUserEvents => _generaluserTohost;



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
  Future<void> refreshGeneralUsers() async {
    try {
      _generaluserTohost = _fetchGeneralusers();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh events: $e');
    }
  }
  Future<List<User>> _fetchGeneralusers() async {
    try {
      return  await api.getGeneralusersToHost(); //await api.getAllEvents();//need list of general users events
    } catch (e) {
      throw Exception('Failed to fetch General user events: $e');
    }
  }
}