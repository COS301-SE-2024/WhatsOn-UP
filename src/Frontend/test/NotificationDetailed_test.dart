import 'package:firstapp/screens/NotificationDetailScreen.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';



import 'api_test.mocks.dart';



void main() {
  testWidgets('NotificationDetailScreen widget test', (WidgetTester tester) async {

    final mockApi = MockApi();


    final notification = AppNotification(
      notificationTypes: 'invite',
      message: 'You have a new invite!',
      sentAt: '2024-08-01T12:00:00Z',
      userId: 'user123',
      notificationId: 'notif123',
      seenAt: null,
      eventId: '1',
    );


    when(mockApi.AcceptInvite(userId: 'user123', notificationId: 'notif123'))
        .thenAnswer((_) async => {'success': true});


    await tester.pumpWidget(
      MaterialApp(
        home: NotificationDetailScreen(notification: notification),
        routes: {
          '/calendar': (context) => Scaffold(body: Text('Calendar')),
        },
      ),
    );


    expect(find.text('Sent At: 2024-08-01T12:00:00Z'), findsOneWidget);
    expect(find.text('Subject: invite'), findsOneWidget);
    expect(find.text('Message:'), findsOneWidget);
    expect(find.text('You have a new invite!'), findsOneWidget);



    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);


    // await tester.tap(find.text('Accept'));
    // await tester.pump();

    // verify(mockApi.AcceptInvite(userId: 'user123', notificationId: 'notif123')).called(1);


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
          '/calendar': (context) => Scaffold(body: Text('Calendar')),
        },
      ),
    );

    expect(find.text('Go to Calendar'), findsOneWidget);


    await tester.tap(find.text('Go to Calendar'));
    await tester.pumpAndSettle();

    expect(find.text('Calendar'), findsOneWidget);
  });
}
