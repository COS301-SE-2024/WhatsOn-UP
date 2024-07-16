// import 'package:firstapp/pages/Event_Attendance.dart';
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:firstapp/services/api.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:provider/provider.dart';
// import 'Attendee_test.mocks.dart';
// import 'Mock_User_event_Providers.dart';
//
//
//
//
// void main() {
//   // Wrap widget test within setup for providers and MaterialApp
//   setUp(() {
//     final  MockApi mockApi = MockApi();
//     final mockEventProvider = MockEventProvider(api: mockApi);
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
//           home:  Attendees(),
//         ),
//       ),
//     );
//   });
//
//   testWidgets('Test Attendee Widget', (WidgetTester tester) async {
//
//     await tester.pumpWidget(MaterialApp(home: Attendees()));
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
// import 'package:firstapp/pages/Event_Attendance.dart';
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'Mock_User_event_Providers.dart'; // Import your MockUserProvider file
//
// void main() {
//   setUp(() {
//     // Mock providers setup
//     final mockEventProvider = MockEventProvider();
//     final mockUserProvider = MockUserProvider(); // Initialize your MockUserProvider
//
//     // Initialize providers within MultiProvider and MaterialApp
//     runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//           ChangeNotifierProvider<MockUserProvider>.value(value: mockUserProvider), // Provide MockUserProvider
//         ],
//         child: MaterialApp(
//           home: Attendee(),
//         ),
//       ),
//     );
//   });
//
//   testWidgets('Test Attendee Widget', (WidgetTester tester) async {
//     // ... (Mock providers setup)
//     final mockEventProvider = MockEventProvider();
//     final mockUserProvider = MockUserProvider();
//     await tester.pumpWidget(
//       MultiProvider(
//         // ... (Providers)
//         providers: [
//           ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//           ChangeNotifierProvider<MockUserProvider>.value(value: mockUserProvider), // Provide MockUserProvider
//         ],
//         child: Attendee(),
//       ),
//     );
//
//     // Wait for the _eventsRsvp future to complete
//     await tester.pumpAndSettle();
//
//     // Now you can perform your assertions on the widgets that are built
//     // based on the result of the _eventsRsvp future
//     expect(find.text('Event 1'), findsOneWidget);
//     // ... (Other assertions)
//   });
// }
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'Mock_User_event_Providers.dart';
//
// void main() {
//   testWidgets('Test Attendee Widget', (WidgetTester tester) async {
//     final mockEventProvider = MockEventProvider();
//     final mockUserProvider = MockUserProvider();
//
//     await tester.pumpWidget(
//       // ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider, builder: (context,child)=>Attendee(),),
//       // ChangeNotifierProvider<MockUserProvider>.value(value: mockUserProvider, builder: (context,child)=>Attendee(),),
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<MockUserProvider>.value(value: mockUserProvider),
//           ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//
//         ],
//         child: MaterialApp( // Wrap in MaterialApp for navigation
//           home: Attendee(),
//         ),
//       ),
//     );
//
//     await tester.pumpAndSettle();
//
//
//     expect(find.text('Event 1'), findsOneWidget);
//     expect(find.text('Event 2'), findsOneWidget);
//     expect(find.text('Event 3'), findsNothing);
//
//
//     // await tester.tap(find.text('Event 1'));1
//     // await tester.pumpAndSettle();
//     // expect(find.text('Attandees'), findsOneWidget); // Adjust title as needed
//   });
// }
//
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:firstapp/widgets/event_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
//
//
//
// import 'Mock_User_event_Providers.dart';
// import 'api_test.mocks.dart';
//
// void main() {
//   late MockApi mockApi;
//   late EventProvider eventProvider;
//   late MockUserProvider mockUserProvider;
//
//   setUp(() {
//     mockApi = MockApi();
//     mockUserProvider = MockUserProvider();
//
//     //Mock API responses
//     when(mockApi.getAllEvents()).thenAnswer((_) async => [
//
//       Event(
//         id: '1',
//         nameOfEvent: 'Event 1',
//         dateAndTime: '2022-01-01T00:00:00.000Z',
//         location: 'Test Location 1',
//         description: 'Test Description 1',
//         imageUrls: [],
//         hosts: [],
//         startTime: '2022-01-01T10:00:00.000Z',
//         endTime: '2022-01-01T12:00:00.000Z',
//         maxAttendees: 100,
//         isPrivate: true,
//         attendees: [],
//         startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
//       ),
//       Event(
//         id: '2',
//         nameOfEvent: 'Event 2',
//         dateAndTime: '2022-01-02T00:00:00.000Z',
//         location: 'Test Location 2',
//         description: 'Test Description 2',
//         imageUrls: [],
//         hosts: [],
//         startTime: '2022-01-02T10:00:00.000Z',
//         endTime: '2022-01-02T12:00:00.000Z',
//         maxAttendees: 150,
//         isPrivate: false,
//         attendees: [],
//         startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
//       ),
//       Event(
//         id: '3',
//         nameOfEvent: 'Event 3',
//         dateAndTime: '2022-01-02T00:00:00.000Z',
//         location: 'Test Location 2',
//         description: 'Test Description 2',
//         imageUrls: [],
//         hosts: [],
//         startTime: '2022-01-02T10:00:00.000Z',
//         endTime: '2022-01-02T12:00:00.000Z',
//         maxAttendees: 150,
//         isPrivate: false,
//         attendees: [],
//         startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
//       ),
//
//     ]);
//
//     when(mockApi.getRSVPEvents(any)).thenAnswer((_) async => [
//       Event(
//         id: '1',
//         nameOfEvent: 'Event 1',
//         dateAndTime: '2022-01-01T00:00:00.000Z',
//         location: 'Test Location 1',
//         description: 'Test Description 1',
//         imageUrls: [],
//         hosts: [],
//         startTime: '2022-01-01T10:00:00.000Z',
//         endTime: '2022-01-01T12:00:00.000Z',
//         maxAttendees: 100,
//         isPrivate: true,
//         attendees: [],
//         startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
//       ),
//       Event(
//         id: '2',
//         nameOfEvent: 'Event 2',
//         dateAndTime: '2022-01-02T00:00:00.000Z',
//         location: 'Test Location 2',
//         description: 'Test Description 2',
//         imageUrls: [],
//         hosts: [],
//         startTime: '2022-01-02T10:00:00.000Z',
//         endTime: '2022-01-02T12:00:00.000Z',
//         maxAttendees: 150,
//         isPrivate: false,
//         attendees: [],
//         startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
//       ),
//       Event(
//         id: '3',
//         nameOfEvent: 'Event 3',
//         dateAndTime: '2022-01-02T00:00:00.000Z',
//         location: 'Test Location 2',
//         description: 'Test Description 2',
//         imageUrls: [],
//         hosts: [],
//         startTime: '2022-01-02T10:00:00.000Z',
//         endTime: '2022-01-02T12:00:00.000Z',
//         maxAttendees: 150,
//         isPrivate: false,
//         attendees: [],
//         startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
//       ),
//     ]);
//
//
//     eventProvider = EventProvider(api: mockApi);
//   });
//
//   testWidgets('Test Attendee Widget', (WidgetTester tester) async {
//
//         await tester.pumpWidget(
//           MultiProvider(
//             providers: [
//               ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
//               FutureProvider<List<Event>>(
//                 create: (_) => mockApi.getAllEvents(),
//                 initialData: [], // Provide initial data if needed
//                 child: MaterialApp(
//                   home: Scaffold(
//                     body: Attendees(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//
//
//
//     await tester.pumpAndSettle();
//
//     // Assertions based on your expected widget tree
//     expect(find.text('Attandees'), findsOneWidget);
//
//     // Check if events are displayed (adjust based on your mock data)
//     expect(find.text('Event 1'), findsOneWidget);
//
//     // Test navigation to EventAttendance (adjust title as needed)
//     await tester.tap(find.text('Event 1'));
//     await tester.pumpAndSettle();
//     expect(find.text('Event Attendance'), findsOneWidget);
//   });
// }
// import 'package:firstapp/pages/attendee.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:firstapp/widgets/event_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
//
// import 'Mock_User_event_Providers.dart';
// import 'Attendee_test.mocks.dart';
//
// void main() {
//   group('Attendees Widget Tests', () {
//     late EventProvider eventProvider;
//
//     late MockApi mockApi;
//     late MockUserProvider mockUserProvider;
//     late MockEventProvider mockEventProvider;
//     setUp(() {
//       mockApi = MockApi();
//
//       mockUserProvider = MockUserProvider();
//       mockEventProvider=MockEventProvider(api: mockApi);
//       eventProvider=EventProvider(api: mockApi);
//
//
//     });
//
//     testWidgets('Renders Attendees correctly for ADMIN role', (WidgetTester tester) async {
//       // Mock user provider role
//       when(mockUserProvider.role).thenReturn('ADMIN');
//       // Mock event provider eventsHome and eventsRsvp futures
//       when(mockEventProvider.eventsHome).thenAnswer((_) async => [
//         Event(
//           id: '1',
//           nameOfEvent: 'Test Event 1',
//           dateAndTime: '2022-01-01T00:00:00.000Z',
//           location: 'Test Location 1',
//           description: 'Test Description 1',
//           imageUrls: [],
//           hosts: ['Admin User'],
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
//           hosts: ['Admin User'],
//           startTime: '2022-01-02T10:00:00.000Z',
//           endTime: '2022-01-02T12:00:00.000Z',
//           maxAttendees: 150,
//           isPrivate: false,
//           attendees: [],
//           startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
//         ),
//       ]);
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: MultiProvider(
//             providers: [
//               ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//               ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
//             ],
//             child: Attendees(),
//           ),
//         ),
//       );
//
//       // Allow the widget tree to build and any asynchronous operations to complete
//       await tester.pumpAndSettle();
//
//       // expect(find.text('Test Event 1'), findsOneWidget);
//       // expect(find.text('Test Event 2'), findsOneWidget);
//       expect(find.text('Attandees'), findsOneWidget); // AppBar title
//     });
//
//     testWidgets('Renders Attendees correctly for non-ADMIN role', (WidgetTester tester) async {
//       mockUserProvider.role = 'HOST'; // Or any role other than 'ADMIN'
//       await tester.pumpWidget(
//         MaterialApp( // Single MaterialApp at the root
//           home: MultiProvider(
//             providers: [
//               ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
//               ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
//             ],
//             child: Scaffold(
//               body: Attendees(),
//             ),
//           ),
//         ),
//       );
//       // verify(mockApi.getRSVPEvents(any)).called(1);
//       // verifyNever(mockApi.getAllEvents());
//       await tester.pumpAndSettle();
//       // expect(find.text('Test Event 1'), findsOneWidget);
//       // expect(find.text('Test Event 2'), findsOneWidget);
//       expect(find.text('Attandees'), findsOneWidget);
//       // ... (Add more assertions based on expected content for non-ADMIN)
//     });
//   });
// }


import 'package:firstapp/pages/attendee.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'Mock_User_event_Providers.dart';
import 'Attendee_test.mocks.dart';


void main() {
  group('Attendees Widget Tests', () {
    late MockEventProvider mockEventProvider;
    late MockUserProvider mockUserProvider;
    late MockApi mockApi;


    setUp(() {
      mockApi = MockApi();
      mockEventProvider = MockEventProvider(api: mockApi);
      mockUserProvider = MockUserProvider();

      // Properly stub the getAllEvents method
      when(mockApi.getAllEvents()).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          dateAndTime: '2022-01-01T00:00:00.000Z',
          location: 'Test Location 1',
          description: 'Test Description 1',
          imageUrls: [],
          hosts: ['Admin User'],
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
          hosts: ['Admin User'],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
        ),
      ]);

      // Properly stub the eventsHome and eventsRsvp getters
      when(mockEventProvider.eventsHome).thenAnswer((_) async =>[
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          dateAndTime: '2022-01-01T00:00:00.000Z',
          location: 'Test Location 1',
          description: 'Test Description 1',
          imageUrls: [],
          hosts: ['Admin User'],
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
          hosts: ['Admin User'],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
        ),
      ]);

      when(mockEventProvider.eventsRsvp).thenAnswer((_) async =>[
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          dateAndTime: '2022-01-01T00:00:00.000Z',
          location: 'Test Location 1',
          description: 'Test Description 1',
          imageUrls: [],
          hosts: ['Host User'],
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
          hosts: ['Host User'],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
        ),
      ]);
    });

    testWidgets('Renders Attendees correctly for ADMIN role', (WidgetTester tester) async {
      // Mock user provider role
      when(mockUserProvider.role).thenReturn('ADMIN');
      // Mock event provider eventsHome and eventsRsvp futures


      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
              ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
            ],
            child: Attendees(),
          ),
        ),
      );

      // Allow the widget tree to build and any asynchronous operations to complete
      await tester.pumpAndSettle();

      expect(find.text('Test Event 1'), findsOneWidget);
      expect(find.text('Test Event 2'), findsOneWidget);
      expect(find.text('Attandees'), findsOneWidget); // AppBar title
    });

    testWidgets('Renders Attendees correctly for HOST role', (WidgetTester tester) async {
      // Mock user provider role
      when(mockUserProvider.role).thenReturn('HOST');
      // Mock event provider eventsHome and eventsRsvp futures


      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<EventProvider>.value(value: mockEventProvider),
              ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
            ],
            child: Attendees(),
          ),
        ),
      );

      // Allow the widget tree to build and any asynchronous operations to complete
      await tester.pumpAndSettle();

      // expect(find.text('Test Event 1'), findsOneWidget);
      // expect(find.text('Test Event 2'), findsOneWidget);
      expect(find.text('Attandees'), findsOneWidget);
    });
  });
}
// import 'package:firstapp/pages/ attendee. dart' ;
// import 'package:firstapp/providers/ events_ providers. dart' ;
// import 'package:firstapp/providers/ user_ provider. dart' ;
// import 'package:firstapp/widgets/ event_ card. dart' ;
// import 'package:flutter/material. dart' ;
// import 'package:flutter_test/ flutter_ test. dart' ;
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito. dart' ;
// import 'package:provider/provider. dart' ;
// import 'api_test.mocks.dart' ;
// void main() {
//   group('Attendees Widget Tests', (){
//     late EventProvider eventProvider;
//     late MockApi mockApi;
//     final user = userProvider();
//
// setUp(() {
//   mockApi = MockApi();
//   when(mockApi.getAllEvents( ) ) . thenAnswer( ( _ )  async => [
//     Event(
//       id: '1',
//       nameOfEvent: 'Test Event 1',
//       dateAndTime: '2022-01-01T00:00:00. 000Z' ,
//       location: 'Test Location 1',
//       description: 'Test Description 1',
//       imageUrls: [],
//       hosts: [],
//       startTime: '2022-01-01T10:00:00. 000Z' ,
//       endTime: '2022-01-01T12:00:00. 000Z' ,
//       maxAttendees: 100,
//       isPrivate: true,
//       attendees: [],
//       startDate: DateTime.parse('2022- 01- 01T10: 00: 00. 000Z' ) ,
//     ),
//     Event(
//       id: '2',
//       nameOfEvent: 'Test Event 2',
//       dateAndTime: '2022-01-02T00:00:00. 000Z' ,
//       location: 'Test Location 2',
//       description: 'Test Description 2',
//       imageUrls: [],
//       hosts: [],
//       startTime: '2022-01-02T10:00:00. 000Z' ,
//       endTime: '2022-01-02T12:00:00. 000Z' ,
//       maxAttendees: 150,
//       isPrivate: false,
//       attendees: [],
//       startDate: DateTime.parse('2022- 01- 02T10: 00: 00. 000Z' ) ,
//     ),       ]);
//   when(mockApi.getRSVPEvents( any) ) . thenAnswer( ( _ )  async => [
//     Event(
//       id: '1',
//       nameOfEvent: 'Test Event 1',
//       dateAndTime: '2022-01-01T00:00:00. 000Z' ,
//       location: 'Test Location 1',
//       description: 'Test Description 1',
//       imageUrls: [],
//       hosts: [],
//       startTime: '2022-01-01T10:00:00. 000Z' ,
//       endTime: '2022-01-01T12:00:00. 000Z' ,
//       maxAttendees: 100,
//       isPrivate: true,
//       attendees: [],
//       startDate: DateTime.parse('2022- 01- 01T10: 00: 00. 000Z' ) ,
//     ),
//     Event(
//       id: '2',
//       nameOfEvent: 'Test Event 2',
//       dateAndTime: '2022-01-02T00:00:00. 000Z' ,
//       location: 'Test Location 2',
//       description: 'Test Description 2',
//       imageUrls: [],
//       hosts: [],
//       startTime: '2022-01-02T10:00:00. 000Z' ,
//       endTime: '2022-01-02T12:00:00. 000Z' ,
//       maxAttendees: 150,
//       isPrivate: false,
//       attendees: [],
//       startDate: DateTime.parse('2022- 01- 02T10: 00: 00. 000Z' ) ,
//     ),       ]);
//   eventProvider = EventProvider(api: mockApi);
// });
// testWidgets('Renders Attendees correctly for ADMIN role', (WidgetTester tester) async {
//   user.role = 'ADMIN';
//   await tester.pumpWidget(
//       MaterialApp( // Single MaterialApp at the root
//       //     home: MultiProvider(
//       //     providers: [
//       //     ChangeNotifierProvider( create:  (_) => eventProvider),
//       //     ChangeNotifierProvider. value( value:  user),
//       //     ],
//       //     child: Scaffold(
//       //     body: Attendees(),
//       //     ),
//       //     ),
//       //     ),
//       //     );
//
//     // Assertions for ADMIN role       expect(find.text('Attandees' ) ,  findsOneWidget); // AppBar title       // ... (Add more assertions based on expected content for ADMIN)     });
//     testWidgets('Renders Attendees correctly for non-ADMIN role', (WidgetTester tester) async {
//       user.role = 'HOST'; // Or any role other than 'ADMIN'
//   // await tester.pumpWidget(
//   // MaterialApp( // Single MaterialApp at the root
//   // home: MultiProvider(
//   // providers: [
//   // ChangeNotifierProvider( create:  (_) => eventProvider),
//   // ChangeNotifierProvider. value( value:  user),
//   // ],
//   // child: Scaffold(
//   // body: Attendees(),
//   // ),
//   // ),
//   // ),
//   // );
//   // Assertions for non-ADMIN role       expect(find.text('Attandees' ) ,  findsOneWidget);       // ... (Add more assertions based on expected content for non-ADMIN)     });   }); }
