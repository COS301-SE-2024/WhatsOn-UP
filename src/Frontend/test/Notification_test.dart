
// import 'package:firstapp/pages/notifications.dart';
// import 'package:firstapp/screens/NotificationDetailScreen.dart';
// import 'package:firstapp/widgets/notification_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/providers/notification_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
//
//
// import 'api_test.mocks.dart';
//
// void main() {
//
//
//
//
//   testWidgets('Tab selection test as General or Host', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//     final notifications = [
//       AppNotification(notificationTypes: 'invites', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//     expect(find.text('Unseen'), findsOneWidget);
//     expect(find.text('Invitations'), findsOneWidget);
//
//     await tester.tap(find.text('Seen'));
//     await tester.pump();
//     expect(find.text('Seen'), findsOneWidget);
//
//     await tester.tap(find.text('Unseen'));
//     await tester.pump();
//     expect(find.text('Unseen'), findsOneWidget);
//
//
//     await tester.tap(find.text('Invitations'));
//     await tester.pumpAndSettle();
//     expect(find.text('You have an invite'), findsOneWidget);
//
//
//   });
//
//   testWidgets('Tab selection test as ADMIN', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("ADMIN");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//     final notifications = [
//       AppNotification(notificationTypes: 'recommendation', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
//       AppNotification(notificationTypes: 'application', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: null),
//
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//     expect(find.text('Unseen'), findsOneWidget);
//     expect(find.text('Applications'), findsOneWidget);
//
//
//     await tester.tap(find.text('Seen'));
//     await tester.pumpAndSettle();
//     expect(find.text('Seen'), findsOneWidget);
//     expect(find.text('You have an invite'), findsOneWidget);
//     expect(find.text('Recommendation'),findsOneWidget);
//
//     await tester.tap(find.text('Unseen'));
//     await tester.pump();
//     expect(find.text('Unseen'), findsOneWidget);
//
//
//
//     await tester.tap(find.text('Applications'));
//     await tester.pump();
//     expect(find.text('Applications'), findsOneWidget);
//     expect(find.text('You have an invite'), findsOneWidget);
//
//   });
//
//   testWidgets('Tab selection test as ADMIN WHEN THERE ARE NO NOTIFICATIONS', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("ADMIN");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//
//     when(mockNotificationProvider.notifications).thenReturn([]);
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//     expect(find.text('Unseen'), findsOneWidget);
//     expect(find.text('Applications'), findsOneWidget);
//
//
//     await tester.tap(find.text('Seen'));
//     await tester.pump();
//     expect(find.text('Seen'), findsOneWidget);
//
//
//     await tester.tap(find.text('Unseen'));
//     await tester.pump();
//     expect(find.text('Unseen'), findsOneWidget);
//
//
//     await tester.tap(find.text('Applications'));
//     await tester.pump();
//     expect(find.text('Applications'), findsOneWidget);
//     expect(find.text('No notifications available.'), findsOneWidget);
//
//   });
//
//   testWidgets('Notifications widget renders without errors', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//
//     expect(find.byType(Notifications), findsOneWidget);
//   });
//   testWidgets('Notifications widget renders without errors IF seenAt is not null', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'broadcast', message: 'Seen broadcast', seenAt: DateTime.now().toString(), eventId: '', userId: '', sentAt: '', notificationId: ''),
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//
//     expect(find.byType(Notifications), findsOneWidget);
//   });
//
//   testWidgets('Notifications widget displays notifications', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.text('You have an invite'), findsOneWidget);
//     expect(find.text('New broadcast message'), findsOneWidget);
//     expect(find.text('Reminder notification'), findsOneWidget);
//     expect(find.text('Recommendation message'), findsOneWidget);
//     expect(find.text('New application'), findsOneWidget);
//
//
//   });
//
//   testWidgets('Notifications widget displays ListTiles', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.byType(ListTile), findsNWidgets(notifications.length));
//
//   });
//
//   testWidgets('Notifications widget handles empty notifications list', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//
//     when(mockNotificationProvider.notifications).thenReturn([]);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.byType(ListTile), findsNothing);
//
//     expect(find.text('No notifications available.'), findsOneWidget);
//   });
//   testWidgets('Notifications widget renders without errors', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("ADMIN");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//
//     expect(find.byType(Notifications), findsOneWidget);
//   });
//
//
//
//
//
//
//       testWidgets('Notifications widget displays notifications AS AN ADMIN', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("ADMIN");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.text('You have an invite'), findsOneWidget);
//     expect(find.text('New broadcast message'), findsOneWidget);
//     expect(find.text('Reminder notification'), findsOneWidget);
//     expect(find.text('Recommendation message'), findsOneWidget);
//     expect(find.text('New application'), findsOneWidget);
//
//   });
//
//   testWidgets('Notifications widget displays ListTiles AS AN ADMIN', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("GENERAL");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//     final notifications = [
//       AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
//       AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: ''),
//     ];
//
//     when(mockNotificationProvider.notifications).thenReturn(notifications);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.byType(ListTile), findsNWidgets(notifications.length));
//
//   });
//
//   testWidgets('Notifications widget handles empty notifications list AS AN ADMIN', (WidgetTester tester) async {
//     final mockUserProvider = MockuserProvider();
//     final mockNotificationProvider = MocknotificationProvider();
//
//     when(mockUserProvider.Fullname).thenReturn('User Name');
//     when(mockUserProvider.email).thenReturn('user@gmail.com');
//     when(mockUserProvider.password).thenReturn('password123');
//     when(mockUserProvider.userId).thenReturn('1');
//     when(mockUserProvider.role).thenReturn("ADMIN");
//     when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
//
//
//     when(mockNotificationProvider.notifications).thenReturn([]);
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//           ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
//         ],
//         child: const MaterialApp(home: Notifications()),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.byType(ListTile), findsNothing);
//
//     expect(find.text('No notifications available.'), findsOneWidget);
//   });
//
//
//
// }
import 'package:firstapp/exceptions/session_not_set_exception.dart';
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
      AppNotification(notificationTypes: 'invites', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: '', seenAt:''),
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
    await tester.pump();
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
      AppNotification(notificationTypes: 'recommendation', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'application', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: null),
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
    await tester.pumpAndSettle();
    expect(find.text('Seen'), findsOneWidget);
    expect(find.text('You have an invite'), findsOneWidget);
    expect(find.text('Recommendation'), findsOneWidget);

    await tester.tap(find.text('Unseen'));
    await tester.pump();
    expect(find.text('Unseen'), findsOneWidget);

    await tester.tap(find.text('Applications'));
    await tester.pump();
    expect(find.text('Applications'), findsOneWidget);
    expect(find.text('You have an invite'), findsOneWidget);
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
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: '', seenAt: null),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: '', seenAt: null),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: '', seenAt: null),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt: '', notificationId: '',seenAt: null),
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
    await tester.tap(find.text('Unseen'));
    await tester.pump();
    expect(find.text('Unseen'), findsOneWidget);



    expect(find.text('New broadcast message'), findsOneWidget);
    expect(find.text('Reminder notification'), findsOneWidget);
    expect(find.text('Recommendation message'), findsOneWidget);
    expect(find.text('New application'), findsOneWidget);
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


    expect(find.text('No notifications available.'), findsOneWidget);
  });

  testWidgets('Displays notifications correctly in Seen tab', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();


    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');

    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString(),),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt:DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
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
    await tester.tap(find.text('Seen'));
    await tester.pump();
    expect(find.text('Seen'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('BROADCASTS'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('REMINDERS'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('RECOMMENDATIONS'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('APPLICATIONS'), findsOneWidget);
  });

  testWidgets('Testing notificationId and JWT', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();


    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
    when(mockUserProvider.JWT).thenReturn('jwt');
    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '1', seenAt: DateTime.now().toString(),),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '2', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '3', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '4', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt:DateTime.now().toString(), notificationId: '5', seenAt: DateTime.now().toString()),
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
    await tester.tap(find.text('Seen'));
    await tester.pumpAndSettle();
    expect(find.text('New broadcast message'), findsOneWidget);
    final textFinder = find.text('New broadcast message');
    await tester.tap(textFinder);
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    expect(find.byType(NotificationDetailScreen), findsOneWidget);

  });

  testWidgets('Testing without notificationId and JWT', (WidgetTester tester) async {
    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();


    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');
    when(mockUserProvider.role).thenReturn("ADMIN");
    when(mockUserProvider.profileImage).thenReturn('https://via.placeholder.com/150');
    when(mockUserProvider.JWT).thenThrow(JWTNotSetException());
    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString(),),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
      AppNotification(notificationTypes: 'application', message: 'New application', eventId: '', userId: '', sentAt:DateTime.now().toString(), notificationId: '', seenAt: DateTime.now().toString()),
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
    await tester.tap(find.text('Seen'));
    await tester.pumpAndSettle();
    expect(find.text('New broadcast message'), findsOneWidget);
    final textFinder = find.text('New broadcast message');
    await tester.tap(textFinder);
    await tester.pumpAndSettle();
    // expect(find.byType(NotificationDetailScreen), findsNothing);


  });



}
