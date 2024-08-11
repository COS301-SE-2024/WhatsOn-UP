
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/screens/ApplicantDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

void main() {
  testWidgets('ApplicantDetailsPage displays applicant details correctly', (WidgetTester tester) async {

    final application = Application(
      applicationId: 'app1',
      status: Status(id: 1, name: 'ACCEPTED'),
      user: UserGeneral(
        userId: 'user1',
        fullName: 'Jane Doe',
        profileImage: 'https://example.com/user-image.jpg',
        role: Role(id: 2, name: 'USER'),
      ),
      expiryDateTime: '2024-12-31T23:59:59Z',
      acceptedRejectedBy: AcceptedRejectedBy(
        userId: 'admin1',
        fullName: 'Admin User',
        profileImage: 'https://example.com/admin-image.jpg',
        role: Role(id: 1, name: 'ADMIN'),
      ),
      reason: 'Test reason',
      verificationCode: '1234',
    );

    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApplicantDetailsPage(user: application),
          ),
        ),
      );

      // Check if the reason is displayed correctly
      expect(find.text('Reason:'), findsOneWidget);
      expect(find.text('Test reason'), findsOneWidget);

      // Check if the duration is displayed correctly
      expect(find.text('Duration:'), findsOneWidget);
      expect(find.text('2024-12-31T23:59:59Z'), findsOneWidget);


      expect(find.text('Accepted by: Admin User'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

    });
  });


  testWidgets('ApplicantDetailsPage displays applicant details correctly for REJECTED status', (WidgetTester tester) async {
    final application = Application(
      applicationId: 'app1',
      status: Status(id: 2, name: 'REJECTED'),
      user: UserGeneral(
        userId: 'user1',
        fullName: 'Jane Doe',
        profileImage: 'https://example.com/user-image.jpg',
        role: Role(id: 2, name: 'USER'),
      ),
      expiryDateTime: '2024-12-31T23:59:59Z',
      acceptedRejectedBy: AcceptedRejectedBy(
        userId: 'admin1',
        fullName: 'Admin User',
        profileImage: 'https://example.com/admin-image.jpg',
        role: Role(id: 1, name: 'ADMIN'),
      ),
      reason: 'Test reason',
      verificationCode: '1234',
    );

    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApplicantDetailsPage(user: application),
          ),
        ),
      );


      expect(find.text('Reason:'), findsOneWidget);
      expect(find.text('Test reason'), findsOneWidget);


      expect(find.text('Duration:'), findsOneWidget);
      expect(find.text('2024-12-31T23:59:59Z'), findsOneWidget);


      expect(find.text('Rejected by: Admin User'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);


      expect(find.text('Accepted by:'), findsNothing);
    });
  });

  testWidgets('ApplicantDetailsPage displays applicant details correctly for PENDING status', (WidgetTester tester) async {
    final application = Application(
      applicationId: 'app1',
      status: Status(id: 3, name: 'PENDING'),
      user: UserGeneral(
        userId: 'user1',
        fullName: 'Jane Doe',
        profileImage: 'https://example.com/user-image.jpg',
        role: Role(id: 2, name: 'USER'),
      ),
      expiryDateTime: '2024-12-31T23:59:59Z',
      acceptedRejectedBy: null,
      reason: 'Test reason',
      verificationCode: '1234',
    );

    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApplicantDetailsPage(user: application),
          ),
        ),
      );
      await tester.pumpAndSettle();


      expect(find.text('Reason:'), findsOneWidget);
      expect(find.text('Test reason'), findsOneWidget);


      expect(find.text('Duration:'), findsOneWidget);
      expect(find.text('2024-12-31T23:59:59Z'), findsOneWidget);




      expect(find.text('Accepted by:'), findsNothing);

      expect(find.text('Rejected by:'), findsNothing);


    });
  });
  // testWidgets('ApplicantDetailsPage displays applicant details correctly for Acknowledge status', (WidgetTester tester) async {
  //   final application = Application(
  //     applicationId: 'app1',
  //     status: Status(id: 3, name: 'ACKNOWLEDGED'),
  //     user: UserGeneral(
  //       userId: 'user1',
  //       fullName: 'Jane Doe',
  //       profileImage: 'https://example.com/user-image.jpg',
  //       role: Role(id: 2, name: 'USER'),
  //     ),
  //     expiryDateTime: '2024-12-31T23:59:59Z',
  //     acceptedRejectedBy: null,
  //     reason: 'Test reason',
  //     verificationCode: '1234',
  //   );
  //
  //   await mockNetworkImages(() async {
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: Scaffold(
  //           body: ApplicantDetailsPage(user: application),
  //         ),
  //       ),
  //     );
  //     await tester.pumpAndSettle();
  //
  //
  //     expect(find.text('Reason:'), findsOneWidget);
  //     expect(find.text('Test reason'), findsOneWidget);
  //
  //
  //     expect(find.text('Duration:'), findsOneWidget);
  //     expect(find.text('2024-12-31T23:59:59Z'), findsOneWidget);
  //     expect(find.text('Demote'), findsOneWidget);
  //
  //
  //
  //
  //     expect(find.text('Accepted by:'), findsNothing);
  //
  //     expect(find.text('Rejected by:'), findsNothing);
  //
  //
  //   });
  // });
}
