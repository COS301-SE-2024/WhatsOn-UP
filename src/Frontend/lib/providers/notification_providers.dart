import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../widgets/notification_card.dart';

class notificationProvider extends ChangeNotifier {
  late Api api = Api();
  late List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  Future<void> fetchNotifications(String JWT) async {
    try {
      List<AppNotification> response = await api.getAllNotification(JWT: JWT);
      _notifications = response;
      notifyListeners();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<void> refreshNotifications(String JWT) async {
    await fetchNotifications(JWT);
  }



  void removeNotification(String notificationId) {
    _notifications.removeWhere((notification) => notification.notificationId == notificationId);
    notifyListeners();
  }
}