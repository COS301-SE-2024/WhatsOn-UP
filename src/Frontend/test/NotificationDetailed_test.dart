import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/screens/NotificationDetailScreen.dart';
import 'package:firstapp/utils.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';



import 'api_test.mocks.dart';

void main() {
  final mockApi = MockApi();

  group('NotificationDetailScreen widget tests', () {

    late MockuserProvider mockUserProvider;

    late MocknotificationProvider mocknotificationProvider;
    setUp(() {
      mocknotificationProvider = MocknotificationProvider();
      mockUserProvider = MockuserProvider();
      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockUserProvider.email).thenReturn('user@gmail.com');
      when(mockUserProvider.password).thenReturn('password123');
      when(mockUserProvider.JWT).thenReturn('user123');

      String mockImageUrl = 'https://via.placeholder.com/150';
      when(mockUserProvider.profileImage)
          .thenReturn(mockImageUrl);

      final emptyResponse = {
        'status': 'success',
        'timestamp': 1234567890,
        'data': [],
      };

      final emptySeenAtResponse = GeneralApplications.fromJson(emptyResponse);

      when(mockApi.markSeen(any,any)).thenAnswer((_) async => emptySeenAtResponse);
    });

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

  await mockNetworkImages(() async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(
            create: (_) => mockUserProvider,
          ),
          ChangeNotifierProvider<notificationProvider>(
            create: (_) => mocknotificationProvider,
          ),
        ],
        child: MaterialApp(
          home: NotificationDetailScreen(notification: notification, api: mockApi),
          routes: {
            '/calendar': (context) => Scaffold(body: Text('Calendar')),
          },
        ),
      ),
    );

    when(mockApi.AcceptInvite(JWT: 'user123', notificationId: 'notif123'))
        .thenAnswer((_) async => {'success': true});

    var testTimeAndDate = formatDateTime('2024-08-01T12:00:00Z');
    print(testTimeAndDate);

    MultiProvider(
                    providers: [
                      ChangeNotifierProvider<userProvider>(
                          create: (_) => mockUserProvider),
                      ChangeNotifierProvider<notificationProvider>(
                          create: (_) => mocknotificationProvider),
                    ],

                    child: MaterialApp(
                      home:  NotificationDetailScreen(notification: notification, api:mockApi),
                      routes: {
                        '/calendar': (context) => Scaffold(body: Text('Calendar')),
                      },
                    ),
                  );
    await tester.pumpAndSettle();

    expect(find.text('Sent At: $testTimeAndDate'), findsOneWidget);
    expect(find.text('You have a new invite!'), findsOneWidget);
    expect(find.text('Accept invite'), findsOneWidget);

    // Uncomment below to test the tap functionality
    // await tester.tap(find.text('Accept'));
    // await tester.pump();
    // verify(mockApi.AcceptInvite(userId: 'user123', notificationId: 'notif123')).called(1);
  });
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

      // when(mockApi.markSeen(String as String?,String)).thenAnswer((Invocation invocation) async {
      //   String? firstArg = invocation.positionalArguments[0] as String?;
      //   String? secondArg = invocation.positionalArguments[1] as String?;
      //   return;
      // });

    await mockNetworkImages(() async {
      await tester.pumpWidget(
          MultiProvider(
                    providers: [
                      ChangeNotifierProvider<userProvider>(
                          create: (_) => mockUserProvider),
                      ChangeNotifierProvider<notificationProvider>(
                          create: (_) => mocknotificationProvider),
                    ],

                    child: MaterialApp(
                      home:  NotificationDetailScreen(notification: reminderNotification, api:mockApi),
                      routes: {
                        '/calendar': (context) => Scaffold(body: Text('Calendar')),
                      },
                    ),
                  )
      );

      expect(find.text('Go to Calendar'), findsOneWidget);

      await tester.tap(find.text('Go to Calendar'));
      await tester.pumpAndSettle();

      expect(find.text('Calendar'), findsOneWidget);
    });
    });
    testWidgets('Displays correct information for already accepted invite notification', (WidgetTester tester) async {
      final alreadyAcceptedNotification = AppNotification(
        notificationTypes: 'invite',
        message: '###You have a new invite!',
        sentAt: '2024-08-01T12:00:00Z',
        userId: 'user123',
        notificationId: 'notif124',
        seenAt: null,
        eventId: '2',
          eventInvite: true,

      );

      var testTimeandDate2 = formatDateTime('2024-08-01T12:00:00Z');
      await tester.pumpWidget(
        MultiProvider(
                    providers: [
                      ChangeNotifierProvider<userProvider>(
                          create: (_) => mockUserProvider),
                      ChangeNotifierProvider<notificationProvider>(
                          create: (_) => mocknotificationProvider),
                    ],

                    child: MaterialApp(
                      home:  NotificationDetailScreen(notification: alreadyAcceptedNotification, api:mockApi),
                      routes: {
                        '/calendar': (context) => Scaffold(body: Text('Calendar')),
                      },
                    ),
                  )
      );
      await tester.pumpAndSettle();

      expect(find.text('Sent At: $testTimeandDate2'), findsOneWidget);
      expect(find.text('###You have a new invite!'), findsOneWidget);
      expect(find.text('Already Accepted'), findsOneWidget);
    });
  });
}
