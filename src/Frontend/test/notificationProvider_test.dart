
import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'api_test.mocks.dart';

void main() {
  late MockApi mockApi;
  late notificationProvider provider;

  setUp(() {
    mockApi = MockApi();
    provider = notificationProvider();
    provider.api = mockApi;
  });

  group('fetchNotifications', () {
    test('should fetch notifications successfully', () async {
      // Arrange
      final notifications = [
        AppNotification(
          notificationTypes: 'invite',
          message: 'You have a new invite!',
          sentAt: '2024-08-01T12:00:00Z',
          userId: 'user123',
          notificationId: 'notif123',
          seenAt: '',
          eventId: '',
        ),
      ];

      when(mockApi.getAllNotification(JWT: 'user123')).thenAnswer((_) async => notifications);


      await provider.refreshNotifications('user123');


      expect(provider.notifications, notifications);
    });

    test('should handle API failure when fetching notifications', () async {

      when(mockApi.getAllNotification(JWT: 'user123')).thenThrow(Exception('Failed to fetch notifications'));


      expect(() async => await provider.refreshNotifications('user123'), throwsA(isA<Exception>()));
    });
  });

  group('removeNotification', () {
    test('should remove notification by ID', () {

      final notification1 = AppNotification(
        notificationTypes: 'invite',
        message: 'You have a new invite!',
        sentAt: '2024-08-01T12:00:00Z',
        userId: 'user123',
        notificationId: 'notif123',
        seenAt: '2024-08-01T12:30:00Z',
        eventId: '',
      );

      final notification2 = AppNotification(
        notificationTypes: 'message',
        message: 'You have a new message!',
        sentAt: '2024-08-01T13:00:00Z',
        userId: 'user124',
        notificationId: 'notif124',
        seenAt: '2024-08-01T13:30:00Z',
        eventId: '',
      );

      provider.notifications.add(notification1);
      provider.notifications.add(notification2);


      provider.removeNotification('notif123');


      expect(provider.notifications.length, 1);
      expect(provider.notifications[0].notificationId, 'notif124');
    });

    test('should do nothing if notification ID not found', () {

      final notification = AppNotification(
        notificationTypes: 'invite',
        message: 'You have a new invite!',
        sentAt: '2024-08-01T12:00:00Z',
        userId: 'user123',
        notificationId: 'notif123',
        seenAt: '2024-08-01T12:30:00Z',
        eventId: '',
      );

      provider.notifications.add(notification);


      provider.removeNotification('nonexistent_id');


      expect(provider.notifications.length, 1);
      expect(provider.notifications[0].notificationId, 'notif123');
    });
  });
}
