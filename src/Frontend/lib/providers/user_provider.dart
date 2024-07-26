import 'package:flutter/material.dart';

import 'dart:typed_data';





//will let the listeners know when the state has changed

class userProvider extends ChangeNotifier{
  String _Fullname = 'Testing';
  String _Email = '';
  String _Password = '';
  String _Role= '';
  String _userId= '';
  String? profileimage;

  String get Fullname => _Fullname;
  String get email => _Email;
  String get password => _Password;
  String? get profileImage => profileimage;
  String get role => _Role;
  String get userId => _userId;




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

}