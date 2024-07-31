
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';



class notificationProvider extends  ChangeNotifier {
  final Api api= Api();
  late Future <List<AppNotification>> _Notifications;
   Future <List<AppNotification>> get notifications => _Notifications;


  notificationProvider(String userId) {
    _Notifications = _fetchNotifications(userId);
  }
  Future<List<AppNotification>> _fetchNotifications(String userId) async {
    try {
      return await api.getAllNotification(userId: userId);
    } catch (e) {
      throw Exception('Failed to fetch notifications providers: $e');
    }
  }

  Future<void> refreshEvents(String userId) async {
    try {
      _Notifications = _fetchNotifications(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh notifications: $e');
    }
  }


}