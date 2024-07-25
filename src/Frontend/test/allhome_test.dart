// import 'package:firstapp/pages/detailed_event_page.dart';
// import 'package:firstapp/widgets/event_card.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/pages/allhome_events.dart';
//
// import 'package:firstapp/providers/events_providers.dart';
// import 'api_test.mocks.dart';
//
//
// void main() {
//   group('AllhomeEvents Tests', () {
//     late MockEventProvider mockEventProvider;
//     late MockuserProvider mockUserProvider;
//     late MockApi mockApi;
//
//     setUp(() {
//       mockApi = MockApi();
//       mockEventProvider = MockEventProvider();
//       mockUserProvider = MockuserProvider();
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
//           metadata: Metadata(
//             mentors: [],
//             categories: [],
//             sessions: [],
//           ),
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
//           metadata: Metadata(
//             mentors: [],
//             categories: [],
//             sessions: [],
//           ),
//         ),
//       ]);
//     });
//
//     testWidgets('displays loading spinner when events are being fetched',
//             (WidgetTester tester) async {
//           when(mockApi.getAllEvents()).thenAnswer((_) async => []);
//
//           await tester.pumpWidget(
//             ChangeNotifierProvider<EventProvider>(
//               create: (_) => mockEventProvider,
//               child: MaterialApp(home: AllhomeEvents()),
//             ),
//
//           );
//
//           expect(find.byType(SpinKitPianoWave), findsOneWidget);
//         });
//
//     testWidgets('displays error message when event fetch fails',
//             (WidgetTester tester) async {
//           when(mockApi.getAllEvents()).thenThrow(Exception('Failed to load events'));
//
//           await tester.pumpWidget(
//             ChangeNotifierProvider<EventProvider>(
//               create: (_) => mockEventProvider,
//               child: MaterialApp(home: AllhomeEvents()),
//             ),
//           );
//
//           await tester.pumpAndSettle();
//
//           expect(find.text('Failed to load events. Please try again later.'), findsOneWidget);
//         });
//
//     testWidgets('displays events correctly when data is loaded',
//             (WidgetTester tester) async {
//           await tester.pumpWidget(
//             ChangeNotifierProvider<EventProvider>(
//               create: (_) => mockEventProvider,
//               child: MaterialApp(home: AllhomeEvents()),
//             ),
//           );
//
//           await tester.pumpAndSettle();
//
//           expect(find.text('Test Event 1'), findsOneWidget);
//           expect(find.text('Test Event 2'), findsOneWidget);
//         });
//
//     testWidgets('navigates to DetailedEventPage when an event card is tapped',
//             (WidgetTester tester) async {
//           final testEvent = Event(
//             id: '1',
//             nameOfEvent: 'Test Event 1 HOME',
//             dateAndTime: '2022-01-01T00:00:00.000Z',
//             location: 'Test Location 1',
//             description: 'Test Description 1',
//             imageUrls: [],
//             hosts: [],
//             startTime: '2022-01-01T10:00:00.000Z',
//             endTime: '2022-01-01T12:00:00.000Z',
//             maxAttendees: 100,
//             isPrivate: true,
//             attendees: [],
//             startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
//             metadata: Metadata(
//               mentors: [],
//               categories: [],
//               sessions: [],
//             ),
//           );
//
//
//           await tester.pumpWidget(
//             ChangeNotifierProvider<EventProvider>(
//               create: (_) => mockEventProvider,
//               child: MaterialApp(
//                   home: AllhomeEvents(),
//                 routes: {
//                   '/detailed_event': (context) => DetailedEventPage(event: testEvent),
//                 },
//               ),
//             ),
//           );
//
//
//
//
//
//           await tester.pumpAndSettle();
//           await tester.tap(find.byType(EventCardH));
//           await tester.pumpAndSettle();
//
//           expect(find.byType(DetailedEventPage), findsOneWidget);
//         });
//   });
// }
