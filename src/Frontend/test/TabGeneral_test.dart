import 'dart:convert';

import 'package:firstapp/pages/ManageGeneralApplicationsTabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:firstapp/providers/user_provider.dart';

import 'api_test.mocks.dart';



void main() {
  late MockuserProvider mockUserProvider;

  testWidgets('TabGeneral widget shows correct tabs and navigates properly', (WidgetTester tester) async {


    mockUserProvider = MockuserProvider();
    String jsonData = '''
  {
    "status": "success",
    "timestamp": 123456789,
    "data": [
      {
        "applicationId": "app123",
        "status": {"id": 1, "name": "PENDING"},
        "user": {
          "userId": "user123",
          "fullName": "John Doe",
          "profileImage":"",
          "role": {"id": 1, "name": "User"}
        },
        "expiryDateTime": "2024-12-31T23:59:59",
        "acceptedRejectedBy": null,
        "reason": "No reason",
        "verificationCode": "123456"
      }
    ]
  }
  ''';

    GeneralApplications generalApplications = GeneralApplications.fromJson(jsonDecode(jsonData));
    when(mockUserProvider.generalApplications).thenAnswer((_) async => generalApplications);


    await tester.pumpWidget(
      ChangeNotifierProvider<userProvider>(
        create: (context) => mockUserProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<userProvider>.value(
              value: mockUserProvider,
              child: TabGeneral(),
            ),
          ),
        )
        ),
      );

    await tester.pumpAndSettle();
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('Promoted'), findsOneWidget);


    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();
    expect(find.byType(UserList), findsOneWidget);


  });
}
