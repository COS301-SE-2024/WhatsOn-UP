import 'package:firstapp/pages/Broadcast.dart';
import 'package:firstapp/pages/BroadcastEvent.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  testWidgets('Renders BroadcastEventDialog with correct components', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: BroadcastEventDialog(event: Event(
          id: '3',
          nameOfEvent: 'Test Event 3 HOME',
          venue: null,
          description: 'Test Description 3',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-03T10:00:00.000Z',
          endTime: '2022-01-03T12:00:00.000Z',
          maxAttendees: 200,
          isPrivate: false,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ),
          invitees: [], saved: false,
        ),),
      ),
    );

    // Assert
    expect(find.text('Broadcast Message'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  // testWidgets('Submit button triggers API call and shows success message', (WidgetTester tester) async {
  //   // Arrange
  //   final mockApi = MockApi();
  //   final mockUserProvider = MockuserProvider();
  //   when(mockUserProvider.userId).thenReturn('1');
  //   when(mockApi.broadcastEvent(any, any, any)).thenAnswer((_) async => {'status': 'success'});
  //
  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         Provider<Api>.value(value: mockApi),
  //         ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
  //       ],
  //       child: MaterialApp(
  //         home: Scaffold(  // Add a Scaffold widget
  //           body: BroadcastEventDialog(
  //             event: Event(
  //               id: '3',
  //               nameOfEvent: 'Test Event 3 HOME',
  //               venue: null,
  //               description: 'Test Description 3',
  //               imageUrls: [],
  //               hosts: [],
  //               startTime: '2022-01-03T10:00:00.000Z',
  //               endTime: '2022-01-03T12:00:00.000Z',
  //               maxAttendees: 200,
  //               isPrivate: false,
  //               attendees: [],
  //               metadata: Metadata(
  //                 mentors: [],
  //                 categories: [],
  //                 sessions: [],
  //               ),
  //               invitees: [],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   await tester.enterText(find.byType(TextField), 'Test message');
  //   await tester.tap(find.text('Submit'));
  //   await tester.pump(); // Trigger a frame
  //   await tester.pump(const Duration(milliseconds: 500)); // Add a delay
  //   await tester.pumpAndSettle();
  //   expect(find.byType(SnackBar), findsOneWidget);
  //   expect(find.text('Broadcast sent successfully'), findsOneWidget);
  //
  // });
  testWidgets('Cancel button closes the dialog', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(  // Ensure Scaffold is included
          body: BroadcastEventDialog(
            event: Event(
              id: '3',
              nameOfEvent: 'Test Event 3 HOME',
              venue: null,
              description: 'Test Description 3',
              imageUrls: [],
              hosts: [],
              startTime: '2022-01-03T10:00:00.000Z',
              endTime: '2022-01-03T12:00:00.000Z',
              maxAttendees: 200,
              isPrivate: false,
              attendees: [],
              metadata: Metadata(
                mentors: [],
                categories: [],
                sessions: [],
              ),
              invitees: [], saved: false,
            ),
          ),
        ),
      ),
    );




    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();


    expect(find.byType(Dialog), findsNothing);
  });
  testWidgets('should close the dialog when Cancel is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(  // Ensure Scaffold is included
          body: BroadcastEventDialog(
            event: Event(
              id: '3',
              nameOfEvent: 'Test Event 3 HOME',
              venue: null,
              description: 'Test Description 3',
              imageUrls: [],
              hosts: [],
              startTime: '2022-01-03T10:00:00.000Z',
              endTime: '2022-01-03T12:00:00.000Z',
              maxAttendees: 200,
              isPrivate: false,
              attendees: [],
              metadata: Metadata(
                mentors: [],
                categories: [],
                sessions: [],
              ),
              invitees: [], saved: false,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(Broadcast), findsNothing);
  });
//   testWidgets('Shows error message on API call failure', (WidgetTester tester) async {
//
//     final mockApi = MockApi();
//     final mockUserProvider = MockuserProvider();
//     when(mockApi.broadcastEvent(any, any, any)).thenThrow(Exception('API Error'));
//     when(mockUserProvider.userId).thenReturn('1');
//
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           Provider<Api>.value(value: mockApi),
//           ChangeNotifierProvider<userProvider>.value(value: mockUserProvider),
//         ],
//         child: MaterialApp(
//           home: Scaffold(  // Add a Scaffold widget
//             body: BroadcastEventDialog(
//               event: Event(
//                 id: '3',
//                 nameOfEvent: 'Test Event 3 HOME',
//                 venue: null,
//                 description: 'Test Description 3',
//                 imageUrls: [],
//                 hosts: [],
//                 startTime: '2022-01-03T10:00:00.000Z',
//                 endTime: '2022-01-03T12:00:00.000Z',
//                 maxAttendees: 200,
//                 isPrivate: false,
//                 attendees: [],
//                 metadata: Metadata(
//                   mentors: [],
//                   categories: [],
//                   sessions: [],
//                 ),
//                 invitees: [],
//               ),
//             ),
//           ),
//       ),
//     )
//     );
//
//     await tester.enterText(find.byType(TextField), 'Test message');
//     await tester.tap(find.text('Submit'));
//
//
// await tester.pump();
//     await tester.pumpAndSettle();
//
//
//     expect(find.byType(SnackBar), findsOneWidget);
//   });
}
