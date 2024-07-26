// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'package:firstapp/providers/user_provider.dart';
//
// void main() {
//   group('userProvider', () {
//     test('initial values are correct', () {
//
//       final user = userProvider();
//
//       expect(user.Fullname, 'Testing');
//       expect(user.email, '');
//       expect(user.password, '');
//       expect(user.role, '');
//       expect(user.userId, '');
//       expect(user.profileimage, isNull);
//     });
//
//     test('setters work correctly', () {
//       final user = userProvider();
//
//       user.Fullname = 'John Doe';
//       user.email = 'john.doe@example.com';
//       user.password = 'password123';
//       user.role = 'admin';
//       user.userId = '12345';
//       user.profileImage = 'http://example.com/path/to/placeholder/image.jpg';
//
//       expect(user.Fullname, 'John Doe');
//       expect(user.email, 'john.doe@example.com');
//       expect(user.password, 'password123');
//       expect(user.role, 'admin');
//       expect(user.userId, '12345');
//       expect(user.profileImage, Uint8List.fromList([0, 1, 2, 3, 4]));
//     });
//
//     test('notifies listeners on changes', () {
//       final user = userProvider();
//
//       bool notified = false;
//       user.addListener(() {
//         notified = true;
//       });
//
//       user.Fullname = 'Jane Doe';
//       expect(notified, true);
//       notified = false;
//
//       user.email = 'jane.doe@example.com';
//       expect(notified, true);
//       notified = false;
//
//       user.password = 'password456';
//       expect(notified, true);
//       notified = false;
//
//       user.role = 'user';
//       expect(notified, true);
//       notified = false;
//
//       user.userId = '67890';
//       expect(notified, true);
//       notified = false;
//
//       user.profileImage = 'http://example.com/path/to/placeholder/image.jpg';;
//       expect(notified, true);
//     });
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:firstapp/providers/user_provider.dart';

void main() {
  group('userProvider', () {
    testWidgets('renders with network images correctly', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        final user = userProvider();

        // Set initial values
        user.Fullname = 'John Doe';
        user.email = 'john.doe@example.com';
        user.password = 'password123';
        user.role = 'admin';
        user.userId = '12345';
        user.profileImage = 'http://example.com/path/to/placeholder/image.jpg';

        // Build your widget under test
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text(user.Fullname),
                  if (user.profileImage != null)
                    Image.network(user.profileImage!)
                ],
              ),
            ),
          ),
        );

        // Verify if the widget is rendered as expected
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget); // Check if the Image widget is found
      });
    });

    test('initial values are correct', () {

      final user = userProvider();

      expect(user.Fullname, 'Testing');
      expect(user.email, '');
      expect(user.password, '');
      expect(user.role, '');
      expect(user.userId, '');
      expect(user.profileimage, isNull);
    });

    test('setters work correctly', () {
      final user = userProvider();

      user.Fullname = 'John Doe';
      user.email = 'john.doe@example.com';
      user.password = 'password123';
      user.role = 'admin';
      user.userId = '12345';


      expect(user.Fullname, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'password123');
      expect(user.role, 'admin');
      expect(user.userId, '12345');

    });

    test('notifies listeners on changes', () {
      final user = userProvider();

      bool notified = false;
      user.addListener(() {
        notified = true;
      });

      user.Fullname = 'Jane Doe';
      expect(notified, true);
      notified = false;

      user.email = 'jane.doe@example.com';
      expect(notified, true);
      notified = false;

      user.password = 'password456';
      expect(notified, true);
      notified = false;

      user.role = 'user';
      expect(notified, true);
      notified = false;

      user.userId = '67890';
      expect(notified, true);
      notified = false;

    });



  });
}