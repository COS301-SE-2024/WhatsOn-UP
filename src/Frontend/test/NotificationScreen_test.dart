// import 'package:firstapp/screens/NotificationDetailScreen.dart';
// import 'package:firstapp/widgets/notification_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
//
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import 'api_test.mocks.dart';
//
//
//
// void main() {
//   late MockApi mockApi;
//   // Sample notification data
//   final sampleNotification = AppNotification(
//     userId: 'user1',
//     notificationId: 'notif1',
//     notificationTypes: 'invite',
//     message: 'You have a new invite!',
//     sentAt: DateTime.now().toIso8601String(),
//     seenAt: null,
//     eventInvite: false,
//     eventId: '',
//   );
//   setUp(() {
//
//    mockApi = MockApi();
//
//
//   });
//
//   // testWidgets('NotificationDetailScreen displays notification details correctly', (WidgetTester tester) async {
//   //
//   //
//   //
//   //   when(mockApi.AcceptInvite(userId: anyNamed('userId'), notificationId: anyNamed('notificationId')))
//   //       .thenAnswer((_) async => Future.value());
//   //   await tester.pumpWidget(
//   //     MaterialApp(
//   //       home: NotificationDetailScreen(notification: sampleNotification),
//   //     ),
//   //   );
//   //
//   //   // Check if the notification message is displayed
//   //   expect(find.text('You have a new invite!'), findsOneWidget);
//   //
//   //   // Check if the sent at time is displayed
//   //   expect(find.text('Sent At:'), findsOneWidget);
//   //
//   //   // Check if the "Accept" button is displayed
//   //   expect(find.text('Accept'), findsOneWidget);
//   //
//   //   // Check if the "Seen At" text is displayed with 'Not seen yet'
//   //   expect(find.text('Seen At: Not seen yet'), findsOneWidget);
//   // });
//
//   testWidgets('NotificationDetailScreen shows loading indicator during Accept', (WidgetTester tester) async {
//
//     final mockApi = MockApi();
//
//     // Setup mock response
//     when(() => mockApi.AcceptInvite(userId: any(), notificationId: any()))
//         .thenAnswer((_) async => {'status': 'success'});
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: NotificationDetailScreen(notification: sampleNotification),
//       ),
//     );
//
//     // Trigger the _Accept method
//     final acceptButton = find.text('Accept');
//     await tester.tap(acceptButton);
//     await tester.pump(); // Trigger the state change
//     await tester.pump(const Duration(seconds: 1)); // Wait for the loading indicator to appear
//
//     // Check if the loading indicator is shown
//     expect(find.byType(SpinKitPianoWave), findsOneWidget);
//
//     // Wait for the state to be settled
//     await tester.pumpAndSettle();
//
//     // Verify if the loading indicator is no longer displayed
//     expect(find.byType(SpinKitPianoWave), findsNothing);
//
//     // Verify navigation to notifications list
//     expect(find.text('Notifications'), findsOneWidget);
//   });
//
//   testWidgets('NotificationDetailScreen navigates to Calendar on "Go to Calendar" button click', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MaterialApp(
//         home: NotificationDetailScreen(notification: sampleNotification),
//         routes: {
//           '/calendar': (context) => Scaffold(body: Center(child: Text('Calendar Screen'))),
//         },
//       ),
//     );
//
//     // Find and tap the "Go to Calendar" button
//     final goToCalendarButton = find.text('Go to Calendar');
//     await tester.tap(goToCalendarButton);
//     await tester.pumpAndSettle();
//
//     // Verify if the navigation was successful
//     expect(find.text('Calendar Screen'), findsOneWidget);
//   });
// }





import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/screens/NotificationDetailScreen.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'api_test.mocks.dart';


class MockApi extends Mock implements Api {}

void main() {
  // late MockApi mockApi;
  late AppNotification sampleNotification;

  setUp(() {
    var mockApi = MockApi();
    // mockApi = MockApi();
    final mockNotificationProvider = MocknotificationProvider();
    registerFallbackValue(<String, dynamic>{});

    sampleNotification = AppNotification(
      userId: 'testUserId',
      notificationId: 'testNotificationId',
      notificationTypes: 'invite',
      message: 'Test Message',
      sentAt: DateTime.now().toIso8601String(),
      seenAt: null,
      eventInvite: false,
      eventId: '',
    );
  });

  // testWidgets('NotificationDetailScreen displays notification details correctly', (WidgetTester tester) async {
  //   when(() => mockApi.AcceptInvite(userId: any(named: 'userId'), notificationId: any(named: 'notificationId')))
  //       .thenAnswer((_) async => {'status': 'success'});
  //
  //   await tester.pumpWidget(MaterialApp(
  //     home: NotificationDetailScreen(notification: sampleNotification),
  //   ));
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.text('Test Message'), findsOneWidget);
  //   expect(find.text('Go to Calendar'), findsNothing);
  // });

  // testWidgets('NotificationDetailScreen shows loading indicator during Accept', (WidgetTester tester) async {
  //   final mockApi = MockApi();
  //   final mockNotificationProvider = MocknotificationProvider();
  //
  //   // Correctly set up the mock to match any arguments
  //   when(() => mockApi.AcceptInvite(userId: any(named: 'userId'), notificationId: any(named: 'notificationId')))
  //       .thenAnswer((_) async => {'status': 'success'});
  //
  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //
  //         ChangeNotifierProvider<notificationProvider>.value(value: mockNotificationProvider),
  //
  //       ],
  //       child: MaterialApp(
  //         home:NotificationDetailScreen(notification: sampleNotification),
  //       ),
  //     ),
  //   );
  //
  //
  //   await tester.tap(find.text('Accept'));
  //   await tester.pump();
  //
  //   expect(find.byType(SpinKitPianoWave), findsOneWidget);
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(SpinKitPianoWave), findsNothing);
  // });

  testWidgets('NotificationDetailScreen navigates to Calendar on "Go to Calendar" button click', (WidgetTester tester) async {
    sampleNotification = AppNotification(
      userId: 'testUserId',
      notificationId: 'testNotificationId',
      notificationTypes: 'reminder',
      message: 'Test Message',
      sentAt: DateTime.now().toIso8601String(),
      seenAt: null,
      eventInvite: false,
      eventId: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: NotificationDetailScreen(notification: sampleNotification),
      routes: {
        '/calendar': (context) => Scaffold(body: Text('Calendar')),
      },
    ));

    await tester.pumpAndSettle();

    final goToCalendarButton = find.text('Go to Calendar');
    expect(goToCalendarButton, findsOneWidget);

    await tester.tap(goToCalendarButton);
    await tester.pumpAndSettle();

    // Verify navigation or other side effects here
  });
}
// import 'package:firstapp/services/api.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
//
// // Mock class
// class MockApi extends Mock implements Api {}
//
// void main() {
//   test('should return success when AcceptInvite is called', () async {
//     final mockApi = MockApi();
//     when(mockApi.AcceptInvite(userId: 'userId', notificationId: 'notificationId'))
//         .thenAnswer((_) async => {'status': 'success'});
//
//     final result = await mockApi.AcceptInvite(userId: 'testUserId', notificationId: 'testNotificationId');
//     expect(result['status'], 'success');
//   });
// }