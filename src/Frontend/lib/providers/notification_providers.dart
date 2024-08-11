
import 'dart:convert';

import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';



class notificationProvider extends  ChangeNotifier {

  final Api api;
  userProvider userP= userProvider();
  late Future <List<AppNotification>> _Notifications;
   Future <List<AppNotification>> get notifications => _Notifications;


  notificationProvider({required this.api});

  Future<List<AppNotification>> _fetchNotifications(String userId) async {
    try {
      List<AppNotification> response=await api.getAllNotification(userId: userId);

      return response;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch notifications providers: $e');
    }
  }

  Future<void> refreshNotifications(String userId) async {
    try {
      _Notifications = _fetchNotifications(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh notifications: $e');
    }
  }
  void addNotification(var eventData) {
    try {
      Map<String, dynamic> eventJson;
      if (eventData is String) {
        eventJson = json.decode(eventData);
      } else {
        eventJson = eventData;
      }
      AppNotification newNotification = AppNotification.fromJson(eventJson['data']);
      print(newNotification);

       _Notifications.then((value) => value.add(newNotification));

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add notification: $e');
    }
  }


}

