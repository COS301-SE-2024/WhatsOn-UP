// import 'package:firstapp/pages/application_event.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/widgets/eventManagement_category.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/pages/manageEvents.dart';
// import 'package:firstapp/providers/user_provider.dart';
//
// import 'api_test.mocks.dart';
//
// void main() {
//   group('ManageEvents Widget Tests', () {
//     late EventProvider eventProvider;
//     late MockApi mockApi;
//
//     setUp(() {
//       mockApi = MockApi();
//       eventProvider = EventProvider(api: mockApi);
//     });
//     testWidgets('Renders ManageEvents correctly for ADMIN role', (WidgetTester tester) async {
//
//       await tester.pumpWidget(
//             child: MaterialApp(
//             home: ManageEvents(),
//           ),
//
//       );
//
//
//       // Assert
//       expect(find.text('Manage Events'), findsOneWidget);
//       expect(find.text('All Events'), findsOneWidget);
//       expect(find.text('Past Events'), findsOneWidget);
//       expect(find.text('Create Event'), findsOneWidget);
//       expect(find.text('Attendees for All Events'), findsOneWidget);
//     });
//
//     testWidgets('Renders ManageEvents correctly for non-ADMIN role', (WidgetTester tester) async {
//       // Arrange
//       await tester.pumpWidget(
//         ChangeNotifierProvider(
//           create: (context) => userProvider()..role = 'HOST',
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//       // Assert
//       expect(find.text('Manage Events'), findsOneWidget);
//       expect(find.text('My Events'), findsOneWidget);
//       expect(find.text('Past Events'), findsOneWidget);
//       expect(find.text('Create Event'), findsOneWidget);
//       expect(find.text('My Attendees'), findsOneWidget);
//     });
//
//
//
//     testWidgets('Navigates to EventManagementCategory when All Events is tapped', (WidgetTester tester) async {
//       // Arrange
//       await tester.pumpWidget(
//         ChangeNotifierProvider(
//           create: (context) => userProvider()..role = 'ADMIN',
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//       // Act
//       await tester.tap(find.text('All Events'));
//       await tester.pumpAndSettle();
//
//       // Assert
//       expect(find.byType(EventmanagementCategory), findsOneWidget);
//     });
//
//     testWidgets('Navigates to ApplicationEvent when Create Event is tapped', (WidgetTester tester) async {
//       // Arrange
//       await tester.pumpWidget(
//         ChangeNotifierProvider(
//           create: (context) => userProvider(),
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//       // Act
//       await tester.tap(find.text('Create Event'));
//       await tester.pumpAndSettle();
//
//       // Assert
//       expect(find.byType(ApplicationEvent), findsOneWidget);
//     });
//
//     // Add more tests for other interactions and navigation as needed
//   });
// }
// import 'package:firstapp/pages/application_event.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/widgets/eventManagement_category.dart';
// import 'package:firstapp/widgets/event_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/pages/manageEvents.dart';
// import 'package:firstapp/providers/user_provider.dart';
//
// import 'api_test.mocks.dart';
//
// void main() {
//   group('ManageEvents Widget Tests', () {
//     late EventProvider eventProvider;
//     late MockApi mockApi;
//
//     setUp(() {
//       mockApi = MockApi();
//       when(mockApi.getAllEvents()).thenAnswer((_) async => [
//         Event(
//           id: '1',
//           nameOfEvent: 'Test Event 1',
//           dateAndTime: '2022-01-01T00:00:00.000Z',
//           location: 'Test Location 1',
//           description: 'Test Description 1',
//           imageUrls: [],
//           hosts: [],
//           startTime: '2022-01-01T10:00:00.000Z',
//           endTime: '2022-01-01T12:00:00.000Z',
//           maxAttendees: 100,
//           isPrivate: true,
//           attendees: [],
//           startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
//         ),
//         Event(
//           id: '2',
//           nameOfEvent: 'Test Event 2',
//           dateAndTime: '2022-01-02T00:00:00.000Z',
//           location: 'Test Location 2',
//           description: 'Test Description 2',
//           imageUrls: [],
//           hosts: [],
//           startTime: '2022-01-02T10:00:00.000Z',
//           endTime: '2022-01-02T12:00:00.000Z',
//           maxAttendees: 150,
//           isPrivate: false,
//           attendees: [],
//           startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
//         ),
//       ]);
//       eventProvider = EventProvider(api: mockApi);
//     });
//
//     testWidgets('Renders ManageEvents correctly for ADMIN role', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => eventProvider),
//             ChangeNotifierProvider(create: (_) => userProvider()..role = 'ADMIN'),
//           ],
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//
//       expect(find.text('Manage Events'), findsOneWidget);
//       expect(find.text('All Events'), findsOneWidget);
//       expect(find.text('Past Events'), findsOneWidget);
//       expect(find.text('Create Event'), findsOneWidget);
//       expect(find.text('Attendees for All Events'), findsOneWidget);
//     });
//
//     testWidgets('Renders ManageEvents correctly for non-ADMIN role', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => eventProvider),
//             ChangeNotifierProvider(create: (_) => userProvider()..role = 'HOST'),
//           ],
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//       // Assert
//       expect(find.text('Manage Events'), findsOneWidget);
//       expect(find.text('My Events'), findsOneWidget);
//       expect(find.text('Past Events'), findsOneWidget);
//       expect(find.text('Create Event'), findsOneWidget);
//       expect(find.text('My Attendees'), findsOneWidget);
//     });
//
//     testWidgets('Navigates to EventManagementCategory when All Events is tapped', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => eventProvider),
//             ChangeNotifierProvider(create: (_) => userProvider()..role = 'ADMIN'),
//           ],
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//       // Act
//       await tester.tap(find.text('All Events'));
//       await tester.pump();
//       print('Tapped on All Events, pumping...');
//
//       await tester.pumpAndSettle(const Duration(seconds: 20));
//       print('Finished waiting for pumpAndSettle...');
//
//       // Assert
//       expect(find.byType(EventmanagementCategory), findsOneWidget);
//     });
//
//     testWidgets('Navigates to ApplicationEvent when Create Event is tapped', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => eventProvider),
//             ChangeNotifierProvider(create: (_) => userProvider()),
//           ],
//           child: MaterialApp(
//             home: ManageEvents(),
//           ),
//         ),
//       );
//
//       // Act
//       await tester.tap(find.text('Create Event'));
//       await tester.pumpAndSettle();
//
//       // Assert
//       expect(find.byType(ApplicationEvent), findsOneWidget);
//     });
//
//     // Add more tests for other interactions and navigation as needed
//   });
// }
import 'package:firstapp/pages/application_event.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/widgets/eventManagement_category.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/manageEvents.dart';
import 'package:firstapp/providers/user_provider.dart';

import 'api_test.mocks.dart';

void main() {
  group('ManageEvents Widget Tests', () {
    late EventProvider eventProvider;
    late MockApi mockApi;
    final user = userProvider();
    setUp(() {
      mockApi = MockApi();
      when(mockApi.getAllEvents()).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          dateAndTime: '2022-01-01T00:00:00.000Z',
          location: 'Test Location 1',
          description: 'Test Description 1',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],
          startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2',
          dateAndTime: '2022-01-02T00:00:00.000Z',
          location: 'Test Location 2',
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
        ),
      ]);
      eventProvider = EventProvider(api: mockApi);
    });

    testWidgets('Renders ManageEvents correctly for ADMIN role', (WidgetTester tester) async {
      user.role = 'ADMIN';
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => eventProvider),
            ChangeNotifierProvider.value(
              value: user,
              child: MaterialApp(
                home:  ManageEvents(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );
      print('Current role: ${user.role}');
      // Assert
      expect(find.text('Manage Events'), findsOneWidget);
      expect(find.text('All Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);
      expect(find.text('Attendees for All Events'), findsOneWidget);
    });

    testWidgets('Renders ManageEvents correctly for non-ADMIN role', (WidgetTester tester) async {
      user.role = 'HOST';
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => eventProvider),
            ChangeNotifierProvider.value(
              value: user,
              child: MaterialApp(
                home:  ManageEvents(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );
      print('Current role: ${user.role}');
      // Assert
      expect(find.text('Manage Events'), findsOneWidget);
      expect(find.text('My Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);
      expect(find.text('My Attendees'), findsOneWidget);
    });

    testWidgets('Navigates to EventManagementCategory when All Events is tapped', (WidgetTester tester) async {
      user.role = 'ADMIN';
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => eventProvider),
            ChangeNotifierProvider.value(
              value: user,
              child: MaterialApp(
                home:  ManageEvents(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );
      print('Current role: ${user.role}');
      expect(find.text('All Events'), findsOneWidget);
      await tester.tap(find.text('All Events'));
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 30));

      // Assert
      expect(find.byType(EventmanagementCategory), findsOneWidget);
    });

    testWidgets('Navigates to ApplicationEvent when Create Event is tapped', (WidgetTester tester) async {
      user.role = 'ADMIN';
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => eventProvider),
            ChangeNotifierProvider.value(
              value: user,
              child: MaterialApp(
                home:  ManageEvents(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Create Event'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ApplicationEvent), findsOneWidget);
    });
    testWidgets('Navigates to Attendee when Attendee is tapped', (WidgetTester tester) async {
      user.role = 'ADMIN';
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => eventProvider),
            ChangeNotifierProvider.value(
              value: user,
              child: MaterialApp(
                home:  ManageEvents(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );
      print('Current role: ${user.role}');
      expect(find.text('Attendees for All Events'), findsOneWidget);
      await tester.tap(find.text('Attendees for All Events'));
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 30));

      // Assert
      expect(find.byType(EventmanagementCategory), findsOneWidget);
    });
    // Add more tests for other interactions and navigation as needed
  });
}
