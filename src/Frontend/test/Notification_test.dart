import 'package:firstapp/pages/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/screens/NotificationDetailScreen.dart';
import 'package:firstapp/widgets/notification_card.dart';

import 'api_test.mocks.dart';

void main() {
  testWidgets('Notifications widget test', (WidgetTester tester) async {

    final mockUserProvider = MockuserProvider();
    final mockNotificationProvider = MocknotificationProvider();


    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.userId).thenReturn('1');

    String mockImageUrl = 'https://via.placeholder.com/150';
    when(mockUserProvider.profileImage).thenReturn(mockImageUrl);


    final notifications = [
      AppNotification(notificationTypes: 'invite', message: 'You have an invite', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'broadcast', message: 'New broadcast message', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'reminder', message: 'Reminder notification', eventId: '', userId: '', sentAt: '', notificationId: ''),
      AppNotification(notificationTypes: 'recommendation', message: 'Recommendation message', eventId: '', userId: '', sentAt: '', notificationId: ''),
    ];

    when(mockNotificationProvider.notifications).thenAnswer(
          (_) async => notifications,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ChangeNotifierProvider<notificationProvider>(create: (_) => mockNotificationProvider),
        ],
        child: const MaterialApp(home: Notifications()),
      ),
    );


    expect(find.byType(SpinKitPianoWave), findsOneWidget);


    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(find.text('INVITES'), findsOneWidget);
    expect(find.text('You have an invite'), findsOneWidget);
    expect(find.text('BROADCASTS'), findsOneWidget);
    expect(find.text('New broadcast message'), findsOneWidget);
    expect(find.text('REMINDERS'), findsOneWidget);
    expect(find.text('Reminder notification'), findsOneWidget);
    expect(find.text('RECOMMENDATIONS'), findsOneWidget);
    expect(find.text('Recommendation message'), findsOneWidget);


    expect(find.byType(ListTile), findsNWidgets(4));


    await tester.tap(find.text('You have an invite'));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationDetailScreen), findsOneWidget);
  });
}
