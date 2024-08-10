
import 'dart:convert';

import 'package:firstapp/pages/ManageGeneralApplicationsTabs.dart';
import 'package:firstapp/pages/Promotion_Applications.dart';
import 'package:firstapp/pages/application_event.dart';
import 'package:firstapp/pages/attendee.dart';
import 'package:firstapp/pages/editProfile_page.dart';
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
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'api_test.mocks.dart';

void main() {
  group('ManageEvents Widget Tests', () {
    late MockEventProvider mockEventProvider;
    late MockuserProvider mockUserProvider;
    late MockApi mockApi;

    setUp(() {
      mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      mockUserProvider = MockuserProvider();
      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockApi.getAllEvents()).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          venue: null,
          description: 'Test Description 1',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [],
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2',
          venue: null,
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [],
        ),
      ]);
      when(mockEventProvider.eventsHome).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1 HOME',
          venue: null,
          description: 'Test Description 1',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [],
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2 HOME',
          venue: null,
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ),


        ),
        Event(
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
          ), invitees: [],
        ),
      ]);
      when(mockEventProvider.eventsRsvp).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1 RSVP',
          venue: null,
          description: 'Test Description 1',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [],
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2 RSVP',
          venue: null,
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],
          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [],
        ),
        Event(
          id: '3',
          nameOfEvent: 'Test Event 3 RSVP',
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
          ), invitees: [],
        ),
      ]);
    });

    testWidgets('Renders ManageEvents correctly for ADMIN role', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );

      // Assert
      expect(find.text('Manage Events'), findsOneWidget);
      expect(find.text('All Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);
      expect(find.text('Attendees for All Events'), findsOneWidget);
      expect(find.text('General user Host Applications'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsNWidgets(5));
    });

    testWidgets('Renders ManageEvents correctly for non-ADMIN role', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('HOST');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );

      expect(find.text('Manage Events'), findsOneWidget);
      expect(find.text('My Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);
      expect(find.text('My Attendees'), findsOneWidget);
    });

    testWidgets('Navigates to EventManagementCategory when All Events is tapped', (WidgetTester tester) async {

      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );

       expect(find.text('All Events'), findsOneWidget);
       await tester.tap(find.text('All Events'));
      await tester.pumpAndSettle();

      expect(find.byType(EventmanagementCategory), findsOneWidget);
    });

    testWidgets('Navigates to ApplicationEvent when Create Event is tapped', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );


      await tester.tap(find.text('Create Event'));
      await tester.pumpAndSettle();
      expect(find.byType(ApplicationEvent), findsOneWidget);
    });
    testWidgets('Navigates to Attendee when Attendee is tapped when the user is an ADMIN', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );

      expect(find.text('Attendees for All Events'), findsOneWidget);
      await tester.tap(find.text('Attendees for All Events'));
      await tester.pumpAndSettle();
      expect(find.byType(Attendees), findsOneWidget);

    });

    testWidgets('Navigates to Attendee when Attendee is tapped when the user is an HOST', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('HOST');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );

      expect(find.text('My Attendees'), findsOneWidget);
      await tester.tap(find.text('My Attendees'));
      await tester.pumpAndSettle();
      expect(find.byType(Attendees), findsOneWidget);

    });
testWidgets('setLoading method updates _isLoading state', (WidgetTester tester) async{
      when(mockUserProvider.role).thenReturn('HOST');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(),
          ),
        ),
      );
      expect(find.byType(SpinKitPianoWave), findsNothing);
      final statefulElement = tester.element(find.byType(ManageEvents)) as StatefulElement;
      final state = statefulElement.state as dynamic;
      state.setLoading(true);
      await tester.pump();
      expect(find.byType(SpinKitPianoWave), findsOneWidget);
    });


    testWidgets('Navigates to General user applications page when Event Applications is tapped', (WidgetTester tester) async {
      String jsonData = '''
  {
    "status": "success",
    "timestamp": 123456789,
    "data": [
      {
        "applicationId": "app123",
        "status": {"id": 1, "name": "Pending"},
        "user": {
          "userId": "user123",
          "fullName": "John Doe",
          "profileImage":"",
          "role": {"id": 1, "name": "User"}
        },
        "expiryDateTime": "2024-12-31T23:59:59",
        "acceptedRejectedBy": null,
        "reason": "No reason",
        "verificationCode": "123456"
      }
    ]
  }
  ''';

      GeneralApplications generalApplications = GeneralApplications.fromJson(jsonDecode(jsonData));
      when(mockUserProvider.generalApplications).thenAnswer((_) async => generalApplications);

      when(mockUserProvider.role).thenReturn('ADMIN');



        final fakeUsers = [
          User(name: 'John Doe', profileImage: '', userStatus: 'Accepted', email: '', password: '123', userId: '1'),
          User(name: 'Jane Smith', profileImage: '', userStatus: 'Pending', email: '', password: '123', userId: '2'),
          User(name: 'Bob Johnson', profileImage: '', userStatus: 'Rejected', email: '', password: '123', userId: '3'),
        ];

        when(mockUserProvider.Generalusers('')).thenAnswer((_) async => fakeUsers);
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<userProvider>(
                create: (_) => mockUserProvider,
              ),
            ],
            child: MaterialApp(
              home: ManageEvents(),
            ),
          ),
        );
      });
      await tester.pumpAndSettle();
      await tester.tap(find.text('General user Host Applications'));
      await tester.pumpAndSettle();

      expect(find.byType(TabGeneral), findsOneWidget);
      // expect(generalApplications.status, "success");
      // expect(generalApplications.timestamp, 123456789);
      // expect(generalApplications.data.length, 1);
      // expect(generalApplications.data[0].applicationId, "app123");
    });

  });
}
