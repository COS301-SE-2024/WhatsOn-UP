// import 'package:firstapp/pages/Event_Attendance.dart';
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'Mock_User_event_Providers.dart';
//
//
//
//
// void main() {
//   // Wrap widget test within setup for providers and MaterialApp
//   setUp(() {
//     // Mock providers setup
//     final mockEventProvider = MockEventProvider();
//     final mockUserProvider = MockUserProvider();
//
//
//     runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//           ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
//         ],
//         child: MaterialApp(
//           home:  Attendee(),
//         ),
//       ),
//     );
//   });
//
//   testWidgets('Test Attendee Widget', (WidgetTester tester) async {
//
//     await tester.pumpWidget(MaterialApp(home: Attendee()));
//
//
//     expect(find.byType(SpinKitPianoWave), findsOneWidget);
//
//
//     await tester.pump(Duration(seconds: 1));
//
//
//     expect(find.text('Event 1'), findsOneWidget);
//     expect(find.text('Event 2'), findsOneWidget);
//     expect(find.text('Event 3'), findsNothing); // Event 3 shouldn't be visible due to user role filtering
//
//     // Tap on the first event to navigate
//     await tester.tap(find.text('Event 1'));
//     await tester.pumpAndSettle();
//
//     // Verify navigation to EventAttendance screen
//     expect(find.byType(EventAttendance), findsOneWidget);
//   });
// }
// import 'package:firstapp/pages/Event_Attendance.dart';
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'Mock_User_event_Providers.dart';
//
// void main() {
//   setUp(() {
//     // Mock providers setup
//     final mockEventProvider = MockEventProvider();
//     final mockUserProvider = MockUserProvider();
//
//     // Initialize providers within MultiProvider and MaterialApp
//     runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//           ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
//         ],
//         child: MaterialApp(
//           home: Attendee(),
//         ),
//       ),
//     );
//   });
//
//   testWidgets('Test Attendee Widget', (WidgetTester tester) async {
//     // Verify initial loading state
//     final mockUserProvider = Provider.of<MockUserProvider>(tester.element);
//     print('Mock User Role: ${mockUserProvider.role}');
//     // Print the user's role for verification
//
//     // Let the initial loading state settle
//     await tester.pumpAndSettle();
//
//     // Verify content after loading completes
//     expect(find.text('Event 1'), findsOneWidget);
//     expect(find.text('Event 2'), findsOneWidget);
//     expect(find.text('Event 3'), findsNothing); // Event 3 shouldn't be visible due to user role filtering
//
//     // Tap on the first event to navigate
//     await tester.tap(find.text('Event 1'));
//     await tester.pumpAndSettle();
//
//     // Verify navigation to EventAttendance screen
//     expect(find.byType(EventAttendance), findsOneWidget);
//   });
// }
import 'package:firstapp/pages/Event_Attendance.dart';
import 'package:firstapp/pages/attendee.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'Mock_User_event_Providers.dart'; // Import your MockUserProvider file

void main() {
  setUp(() {
    // Mock providers setup
    final mockEventProvider = MockEventProvider();
    final mockUserProvider = MockUserProvider(); // Initialize your MockUserProvider

    // Initialize providers within MultiProvider and MaterialApp
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
          ChangeNotifierProvider<MockUserProvider>.value(value: mockUserProvider), // Provide MockUserProvider
        ],
        child: MaterialApp(
          home: Attendee(),
        ),
      ),
    );
  });

  testWidgets('Test Attendee Widget', (WidgetTester tester) async {
    // Find the MaterialApp widget
    await tester.pumpWidget(MaterialApp(home: Builder(
      builder: (BuildContext context) {
        final mockUserProvider = Provider.of<MockUserProvider>(context);


        print('Mock User Role: ${mockUserProvider.role}');




        // Let the initial loading state settle
         tester.pumpAndSettle();

        // Verify content after loading completes
        expect(find.text('Event 1'), findsOneWidget);
        expect(find.text('Event 2'), findsOneWidget);
        expect(find.text('Event 3'), findsNothing); // Event 3 shouldn't be visible due to user role filtering

        // Tap on the first event to navigate
         tester.tap(find.text('Event 1'));
         tester.pumpAndSettle();

        // Verify navigation to EventAttendance screen
        expect(find.byType(EventAttendance), findsOneWidget);

        return SizedBox.shrink();
      },
    )));

  });
}
