// import 'package:firstapp/pages/ManageGeneralApplicationsTabs.dart';
// import 'package:firstapp/pages/editProfile_page.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:mockito/mockito.dart';
//
// import 'api_test.mocks.dart';
//
//
//
//
//
// void main() {
//   late MockuserProvider mockUserProvider;
//   late MockEventProvider mockEventProvider;
//   late MockApi mockApi;
//
//     mockEventProvider = MockEventProvider();
//     mockUserProvider = MockuserProvider();
//
//   testWidgets('TabGeneral renders correctly', (WidgetTester tester) async {
//     when(mockUserProvider.generalApplications).thenAnswer(
//           (_) async => GeneralApplications(
//         data: [
//           // Provide a list of mocked user data
//           Application(
//             user: UserGeneral(
//               profileImage: 'https://example.com/image.png',
//               fullName: 'John Doe',
//               userId: '1', role: Role(
//               id: 1,  // Mock role data
//               name: 'Admin',  // Provide a role name
//             ),
//
//             ),
//             status: Status(name: 'PENDING', id: 1),
//             applicationId: '1',
//             expiryDateTime: '2024-09-18T12:00:00Z',
//             reason: 'Some reason',
//
//           ),
//           // Add more mock Application objects as needed
//         ], status: 'PENDING', timestamp: DateTime.daysPerWeek,
//       ),
//     );
//     final mockUserProvider = MockuserProvider();
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: ChangeNotifierProvider<userProvider>.value(
//           value: mockUserProvider,
//           child: const TabGeneral(),
//         ),
//       ),
//     );
//
//     expect(find.text('Manage General Applications'), findsOneWidget);
//     expect(find.text('All'), findsOneWidget);
//     expect(find.text('Pending'), findsOneWidget);
//     expect(find.text('Verified'), findsOneWidget);
//     expect(find.text('Promoted'), findsOneWidget);
//   });
// }
import 'package:firstapp/pages/ManageGeneralApplicationsTabs.dart';
import 'package:firstapp/pages/editProfile_page.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'api_test.mocks.dart';

void main() {
  late MockuserProvider mockUserProvider;

  setUp(() {
    mockUserProvider = MockuserProvider();
  });

  testWidgets('TabGeneral renders correctly', (WidgetTester tester) async {
    when(mockUserProvider.generalApplications).thenAnswer(
          (_) async => GeneralApplications(
        data: [
          Application(
            user: UserGeneral(
              profileImage: 'https://example.com/image.png',
              fullName: 'John Doe',
              userId: '1',
              role: Role(
                id: 1,  // Mock role data
                name: 'Admin',  // Provide a role name
              ),
            ),
            status: Status(name: 'PENDING', id: 1),
            applicationId: '1',
            expiryDateTime: '2024-09-18T12:00:00Z',
            reason: 'Some reason',
          ),
          // Add more mock Application objects as needed
        ],
        status: 'PENDING',
        timestamp: 3563, // Use DateTime.now() or other valid DateTime
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<userProvider>.value(
          value: mockUserProvider,
          child: const TabGeneral(),
        ),
      ),
    );

    expect(find.text('Manage General Applications'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('Promoted'), findsOneWidget);
  });

  testWidgets('UserList displays list of users', (WidgetTester tester) async {



    when(mockUserProvider.generalApplications).thenAnswer(
          (_) async => GeneralApplications(
        data: [
          // Provide a list of mocked user data
          Application(
            user: UserGeneral(
              profileImage: 'https://example.com/image.png',
              fullName: 'Harry Potter',
              userId: '1',
              role: Role(
                id: 1,  // Mock role data
                name: 'Admin',  // Provide a role name
              ),
            ),
            status: Status(name: 'PENDING', id: 1),
            applicationId: '1',
            expiryDateTime: '2024-09-18T12:00:00Z',
            reason: 'Some reason',
          ),
          // Add more mock Application objects as needed
        ],
        status: 'SUCCESS',
        timestamp: 3563, // Use DateTime.now() or other valid DateTime
      ),
    );
    await mockNetworkImages(() async {
    await tester.pumpWidget(
      ChangeNotifierProvider<userProvider>.value(
        value: mockUserProvider,
        child: MaterialApp(
          home: Scaffold(
            body: UserList(statusFilter: null),
          ),
        ),
      ),
    );

    // Trigger a frame
    await tester.pump();

    expect(find.text('Harry Potter'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });
  });

  testWidgets('Applicant displays details correctly', (WidgetTester tester) async {
    final application = Application(
      user: UserGeneral(
        profileImage: 'https://example.com/image.png',
        fullName: 'John Doe',
        userId: '1',
        role: Role(id: 1, name: 'Admin'),
      ),
      status: Status(name: 'ACKNOWLEDGED', id: 1),
      applicationId: '1',
      expiryDateTime: '2024-09-18T12:00:00Z',
      reason: 'Some reason',
      proofUrl: 'http://example.com',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<userProvider>.value(
          value: MockuserProvider(),
          child: Applicant(user: application),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('John Doe'), findsNWidgets(2));
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

}
