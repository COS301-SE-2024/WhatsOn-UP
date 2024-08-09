import 'dart:convert';

import 'package:firstapp/pages/ManageGeneralApplicationsTabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';


import 'package:firstapp/providers/user_provider.dart';


import 'api_test.mocks.dart';




void main() {
  late MockuserProvider mockUserProvider;

  testWidgets('UserList widget displays users and navigates to details', (WidgetTester tester) async {

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
          "fullName": "John",
          "profileImage": "",
          "role": {"id": 1, "name": "general"}
        },
        "expiryDateTime": "2024-12-31T23:59:59",
        "acceptedRejectedBy": null,
        "reason": "No reason",
        "verificationCode": "123456"
      }
    ]
  }
  ''';
    mockUserProvider = MockuserProvider();
    GeneralApplications generalApplications = GeneralApplications.fromJson(jsonDecode(jsonData));
    when(mockUserProvider.generalApplications).thenAnswer((_) async => generalApplications);
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        ChangeNotifierProvider<userProvider>(
          create: (context) => mockUserProvider,
          child: MaterialApp(
            home: UserList(statusFilter: null),

          ),
        ),
      );
    });

    await tester.pumpAndSettle();
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('John'), findsOneWidget);

  });
}
