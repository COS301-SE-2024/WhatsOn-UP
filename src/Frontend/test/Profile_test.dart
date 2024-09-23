
// import 'dart:typed_data';
// import 'package:firstapp/pages/editProfile_page.dart';
// import 'package:firstapp/pages/profilePage.dart';
// import 'package:firstapp/pages/supabase_resetPassword.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:image/image.dart' as img;
// import 'api_test.mocks.dart';
//
// void main() {
//   group('ProfilePage Tests', () {
//     late MockuserProvider mockUserProvider;
//
//     setUp(() {
//       mockUserProvider = MockuserProvider();
//       when(mockUserProvider.Fullname).thenReturn('User Name');
//       when(mockUserProvider.email).thenReturn('user@gmail.com');
//       when(mockUserProvider.password).thenReturn('password123');
//
//       final placeholderImage = img.Image(width: 20, height: 20);
//       final placeholderImageData = img.encodePng(placeholderImage);
//
//       when(mockUserProvider.profileImage)
//           .thenReturn(Uint8List.fromList(placeholderImageData));
//     });
//
//     testWidgets('should display profile image and admin badge',
//         (WidgetTester tester) async {
//       when(mockUserProvider.role).thenReturn('ADMIN');
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: ChangeNotifierProvider<userProvider>.value(
//             value: mockUserProvider,
//             child: ProfilePage(),
//           ),
//         ),
//       );
//       expect(find.byType(CircleAvatar), findsOneWidget);
//       expect(find.byWidgetPredicate((widget) {
//         if (widget is Image) {
//           return widget.image is AssetImage &&
//               (widget.image as AssetImage).assetName ==
//                   'assets/images/adminBadge.png';
//         }
//         return false;
//       }), findsOneWidget);
//     });
//
//     testWidgets('should display profile image only for GENERAL role',
//         (WidgetTester tester) async {
//       when(mockUserProvider.role).thenReturn('GENERAL');
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: ChangeNotifierProvider<userProvider>.value(
//             value: mockUserProvider,
//             child: ProfilePage(),
//           ),
//         ),
//       );
//       expect(find.byType(CircleAvatar), findsOneWidget);
//       expect(find.byWidgetPredicate((widget) {
//         if (widget is Image) {
//           return widget.image is AssetImage &&
//               (widget.image as AssetImage).assetName ==
//                   'assets/images/adminBadge.png';
//         }
//         return false;
//       }), findsNothing);
//     });
//
//     testWidgets('should navigate to EditProfilePage on button press',
//         (WidgetTester tester) async {
//       when(mockUserProvider.role).thenReturn('ADMIN');
//
//       await tester.pumpWidget(
//         MaterialApp(
//             home: MultiProvider(
//           providers: [
//             ChangeNotifierProvider<userProvider>(
//                 create: (_) => mockUserProvider),
//           ],
//
//           child: MaterialApp(
//             home: ProfilePage(),
//             routes: {
//               '/editProfile': (context) => EditprofilePage(),
//             },
//           ),
//         )),
//       );
//
//       await tester.tap(find.text('Edit Profile'));
//       await tester.pumpAndSettle();
//
//       expect(find.byType(EditprofilePage), findsOneWidget);
//     });
//
//     testWidgets('should navigate to resetPassword on logout',
//         (WidgetTester tester) async {
//       when(mockUserProvider.profileimage).thenReturn(null);
//       when(mockUserProvider.role).thenReturn('USER');
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: ChangeNotifierProvider<userProvider>.value(
//             value: mockUserProvider,
//             child: ProfilePage(),
//           ),
//           routes: {
//             '/resetPassword': (context) => ResetPasswordPage(),
//           },
//         ),
//       );
//
//       await tester.tap(find.text('Security'));
//       await tester.pumpAndSettle();
//       expect(find.byType(ResetPasswordPage), findsOneWidget);
//     });
//   });
// }
import 'package:firstapp/pages/editProfile_page.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:firstapp/pages/supabase_resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'api_test.mocks.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:firstapp/pages/host_analytics.dart';


void main() {
  group('ProfilePage Tests', () {
    late MockuserProvider mockUserProvider;

    setUp(() {
      mockUserProvider = MockuserProvider();
      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockUserProvider.email).thenReturn('user@gmail.com');
      when(mockUserProvider.password).thenReturn('password123');

      String mockImageUrl = 'https://via.placeholder.com/150';
      when(mockUserProvider.profileImage)
          .thenReturn(mockImageUrl);
    });

    testWidgets('should display profile image and admin badge',
            (WidgetTester tester) async {
          when(mockUserProvider.role).thenReturn('ADMIN');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: ChangeNotifierProvider<userProvider>.value(
                  value: mockUserProvider,
                  child:  ProfilePage(),
                ),
              ),
            );
          });
          expect(find.byType(CircleAvatar), findsOneWidget);
          expect(find.byWidgetPredicate((widget) {
            if (widget is Image) {
              return widget.image is AssetImage &&
                  (widget.image as AssetImage).assetName ==
                      'assets/images/adminBadge.png';
            }
            return false;
          }), findsOneWidget);
        });

    testWidgets('should display profile image only for GENERAL role',
            (WidgetTester tester) async {
          when(mockUserProvider.role).thenReturn('GENERAL');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: ChangeNotifierProvider<userProvider>.value(
                  value: mockUserProvider,
                  child:  ProfilePage(),
                ),
              ),
            );
          });
          expect(find.byType(CircleAvatar), findsOneWidget);
          expect(find.byWidgetPredicate((widget) {
            if (widget is Image) {
              return widget.image is AssetImage &&
                  (widget.image as AssetImage).assetName ==
                      'assets/images/adminBadge.png';
            }
            return false;
          }), findsNothing);
        });

    testWidgets('should navigate to EditProfilePage on button press',
            (WidgetTester tester) async {
          when(mockUserProvider.role).thenReturn('ADMIN');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                  home: MultiProvider(
                    providers: [
                      ChangeNotifierProvider<userProvider>(
                          create: (_) => mockUserProvider),
                    ],

                    child: MaterialApp(
                      home:  ProfilePage(),
                      routes: {
                        '/editProfile': (context) =>  EditprofilePage(),
                      },
                    ),
                  )),
            );});

          await tester.tap(find.text('Edit Profile'));
          await tester.pumpAndSettle();

          expect(find.byType(EditprofilePage), findsOneWidget);
        });

    testWidgets('should navigate to resetPassword on logout',
            (WidgetTester tester) async {
          when(mockUserProvider.profileimage).thenReturn(null);
          when(mockUserProvider.role).thenReturn('USER');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: ChangeNotifierProvider<userProvider>.value(
                  value: mockUserProvider,
                  child:  ProfilePage(),
                ),
                routes: {
                  '/resetPassword': (context) => const ResetPasswordPage(),
                },
              ),
            );
          });
          await tester.tap(find.text('Reset Password'));
          await tester.pumpAndSettle();
          expect(find.byType(ResetPasswordPage), findsOneWidget);
        });

        testWidgets('should find the host analytics button if user is admin',
            (WidgetTester tester) async {
          when(mockUserProvider.role).thenReturn('ADMIN');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: ChangeNotifierProvider<userProvider>.value(
                  value: mockUserProvider,
                  child:  ProfilePage(),
                ),
              ),
            );
          });
          expect(find.text('My Event Analytics'), findsOneWidget);

        });

        testWidgets('should find the host analytics button if user is host',
            (WidgetTester tester) async {
          when(mockUserProvider.role).thenReturn('HOST');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: ChangeNotifierProvider<userProvider>.value(
                  value: mockUserProvider,
                  child:  ProfilePage(),
                ),
              ),
            );
          });
          expect(find.text('My Event Analytics'), findsOneWidget);
          
        });
  });
}
