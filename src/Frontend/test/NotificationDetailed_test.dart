import 'package:firstapp/screens/NotificationDetailScreen.dart';
import 'package:firstapp/utils.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';



import 'api_test.mocks.dart';

void main() {
  final mockApi = MockApi();

  group('NotificationDetailScreen widget tests', () {

    testWidgets('Displays correct information for invite notification', (WidgetTester tester) async {
      final notification = AppNotification(
        notificationTypes: 'invite',
        message: 'You have a new invite!',
        sentAt: '2024-08-01T12:00:00Z',
        userId: 'user123',
        notificationId: 'notif123',
        seenAt: null,
        eventId: '1',
        eventInvite: false,
      );

      when(mockApi.AcceptInvite(JWT: 'user123', notificationId: 'notif123'))
          .thenAnswer((_) async => {'success': true});
      var testTimeandDate = formatDateTime('2024-08-01T12:00:00Z');
      print(testTimeandDate);
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailScreen(notification: notification),

        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sent At: $testTimeandDate'), findsOneWidget);
      expect(find.text('You have a new invite!'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      // expect(find.text('Seen At: Not seen yet'), findsOneWidget);
      // Uncomment below to test the tap functionality
      // await tester.tap(find.text('Accept'));
      // await tester.pump();
      // verify(mockApi.AcceptInvite(userId: 'user123', notificationId: 'notif123')).called(1);
    });

    testWidgets('Displays correct information for reminder notification and navigates to calendar', (WidgetTester tester) async {
      final reminderNotification = AppNotification(
        notificationTypes: 'reminder',
        message: 'Reminder for your event',
        sentAt: '2024-08-01T12:00:00Z',
        userId: 'user123',
        notificationId: 'notif124',
        seenAt: null,
        eventId: '2',

      );

      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailScreen(notification: reminderNotification),
          routes: {
            '/calendar': (context) => const Scaffold(body: Text('Calendar')),
          },
        ),
      );

      expect(find.text('Go to Calendar'), findsOneWidget);

      await tester.tap(find.text('Go to Calendar'));
      await tester.pumpAndSettle();

      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('Displays correct information for already accepted invite notification', (WidgetTester tester) async {
      final alreadyAcceptedNotification = AppNotification(
        notificationTypes: 'invite',
        message: 'You have a new invite!',
        sentAt: '2024-08-01T12:00:00Z',
        userId: 'user123',
        notificationId: 'notif124',
        seenAt: null,
        eventId: '2',
          eventInvite: true,

      );

      var testTimeandDate2 = formatDateTime('2024-08-01T12:00:00Z');
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationDetailScreen(notification: alreadyAcceptedNotification),

        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sent At: $testTimeandDate2'), findsOneWidget);
      expect(find.text('You have a new invite!'), findsOneWidget);
      expect(find.text('Accepted'), findsOneWidget);
    });
  });
}
