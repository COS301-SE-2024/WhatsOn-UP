import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/widgets/notification_card.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import 'api_test.mocks.dart';


void main() {
  late MockApi mockApi;
  late notificationProvider provider;

  setUp(() {
    mockApi = MockApi();
    provider = notificationProvider();
    provider.api = mockApi;

  });

  test('should fetch notifications successfully', () async {
    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have a new invite!', sentAt: '2024-08-01T12:00:00Z', userId: 'user123', notificationId: 'notif123', seenAt: null, eventId: ''),
    ];


    when(mockApi.getAllNotification(userId: 'user123')).thenAnswer((_) async => notifications);

    await provider.refreshNotifications('user123');


    expect(provider.notifications, completion(equals(notifications)));
  });

  test('should handle API failure when fetching notifications', () async {

    when(mockApi.getAllNotification(userId: 'user123')).thenThrow(Exception('Failed to fetch notifications'));


    expect(() async => await provider.refreshNotifications('user123'), throwsA(isA<Exception>()));
  });
}
