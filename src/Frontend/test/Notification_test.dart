
import 'package:firstapp/pages/notifications.dart';
import 'package:firstapp/screens/NotificationDetailScreen.dart';
import 'package:firstapp/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/providers/user_provider.dart';


import 'api_test.mocks.dart';

void main() {




  testWidgets('Tab selection test as General or Host', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();
    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),

    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );
    expect(find.text('Unseen'), findsOneWidget);
    expect(find.text('Invitations'), findsOneWidget);

    await tester.tap(find.text('Seen'));
    await tester.pump();
    expect(find.text('Seen'), findsOneWidget);

    await tester.tap(find.text('Unseen'));
    await tester.pump();
    expect(find.text('Unseen'), findsOneWidget);


    await tester.tap(find.text('Invitations'));
    await tester.pumpAndSettle();
    expect(find.text('You have an invite'), findsOneWidget);


  });

  testWidgets('Tab selection test as ADMIN', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();
    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '67986508805', notificationId: ''),

    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );
    expect(find.text('Unseen'), findsOneWidget);
    expect(find.text('Applications'), findsOneWidget);


    await tester.tap(find.text('Seen'));
    await tester.pump();
    expect(find.text('Seen'), findsOneWidget);


    await tester.tap(find.text('Unseen'));
    await tester.pump();
    expect(find.text('Unseen'), findsOneWidget);


    await tester.tap(find.text('Applications'));
    await tester.pump();
    expect(find.text('Applications'), findsOneWidget);

  });

  testWidgets('Tab selection test as ADMIN WHEN THERE ARE NO NOTIFICATIONS', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();
    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');


    when(mockNotificationProvider.notifications).thenReturn([]);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );
    expect(find.text('Unseen'), findsOneWidget);
    expect(find.text('Applications'), findsOneWidget);


    await tester.tap(find.text('Seen'));
    await tester.pump();
    expect(find.text('Seen'), findsOneWidget);


    await tester.tap(find.text('Unseen'));
    await tester.pump();
    expect(find.text('Unseen'), findsOneWidget);


    await tester.tap(find.text('Applications'));
    await tester.pump();
    expect(find.text('Applications'), findsOneWidget);
    expect(find.text('No notifications available.'), findsOneWidget);

  });

  testWidgets('Notifications widget renders without errors', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),

    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );


    expect(find.byType(Notifications), findsOneWidget);
  });
  testWidgets('Notifications widget renders without errors IF seenAt is not null', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'broadcast', message: 'Seen broadcast', seenAt: DateTime.now().toString(), eventId: '', userId: '', sentAt: '', notificationId: ''),
    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );


    expect(find.byType(Notifications), findsOneWidget);
  });

  testWidgets('Notifications widget displays notifications', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );

    await tester.pumpAndSettle();


    expect(find.text('You have an invite'), findsOneWidget);
    expect(find.text('New broadcast message'), findsOneWidget);
    expect(find.text('Reminder notification'), findsOneWidget);
    expect(find.text('Recommendation message'), findsOneWidget);
    expect(find.text('New application'), findsOneWidget);


  });

  testWidgets('Notifications widget displays ListTiles', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );

    await tester.pumpAndSettle();


    expect(find.byType(ListTile), findsNWidgets(notifications.length));

  });

  testWidgets('Notifications widget handles empty notifications list', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');


    when(mockNotificationProvider.notifications).thenReturn([]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );

    await tester.pumpAndSettle();


    expect(find.byType(ListTile), findsNothing);

    expect(find.text('No notifications available.'), findsOneWidget);
  });
  testWidgets('Notifications widget renders without errors', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),

    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );


    expect(find.byType(Notifications), findsOneWidget);
  });






      testWidgets('Notifications widget displays notifications AS AN ADMIN', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );

    await tester.pumpAndSettle();


    expect(find.text('You have an invite'), findsOneWidget);
    expect(find.text('New broadcast message'), findsOneWidget);
    expect(find.text('Reminder notification'), findsOneWidget);
    expect(find.text('Recommendation message'), findsOneWidget);
    expect(find.text('New application'), findsOneWidget);

  });

  testWidgets('Notifications widget displays ListTiles AS AN ADMIN', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("GENERAL");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
    ];

    when(mockNotificationProvider.notifications).thenReturn(notifications);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );

    await tester.pumpAndSettle();


    expect(find.byType(ListTile), findsNWidgets(notifications.length));

  });

  testWidgets('Notifications widget handles empty notifications list AS AN ADMIN', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();

    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');


    when(mockNotificationProvider.notifications).thenReturn([]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );

    await tester.pumpAndSettle();


    expect(find.byType(ListTile), findsNothing);

    expect(find.text('No notifications available.'), findsOneWidget);
  });



}
