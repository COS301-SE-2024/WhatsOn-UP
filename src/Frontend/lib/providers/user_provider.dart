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
  late  Future<List<User>> _generaluserTohost;
  String get Fullname => _Fullname;
  String get email => _Email;
  String get password => _Password;
  String? get profileImage => profileimage;
  String get role => _Role;
  String get userId => _userId;
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
    set profileImage(String? value){
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