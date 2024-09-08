import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../widgets/notification_card.dart';

class notificationProvider extends ChangeNotifier {
  late Api api = Api();
  late List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  Future<void> fetchNotifications(String userId) async {
    try {
      List<AppNotification> response = await api.getAllNotification(userId: userId);
      _notifications = response;
      notifyListeners();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<void> refreshNotifications(String userId) async {
    await fetchNotifications(userId);
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
      _notifications.add(newNotification);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add notification: $e');
    }
  }

  void removeNotification(String notificationId) {
    _notifications.removeWhere((notification) => notification.notificationId == notificationId);
    notifyListeners();
  }
}