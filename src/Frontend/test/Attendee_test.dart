
import 'package:firstapp/pages/attendee.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'api_test.mocks.dart';

void main() {
  group('Attendees Widget Tests', () {
    late MockEventProvider mockEventProvider;
    late MockuserProvider mockUserProvider;
    late MockApi mockApi;

    setUp(() async {
      mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      mockUserProvider = MockuserProvider();

      when(mockApi.getAllEvents('JWT')).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          venue: null,
          description: 'Test Description 1',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2',
          venue: null,
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
      ]);
      when(mockUserProvider.Fullname).thenReturn('User Name');

      when(mockEventProvider.eventsHome).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1 HOME',
          venue: null,
          description: 'Test Description 1',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2 HOME',
          venue: null,
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
        Event(
          id: '3',
          nameOfEvent: 'Test Event 3 HOME',
          venue: null,
          description: 'Test Description 3',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-03T10:00:00.000Z',
          endTime: '2022-01-03T12:00:00.000Z',
          maxAttendees: 200,
          isPrivate: false,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
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
          hostIds: [],
          startTime: '2022-01-01T10:00:00.000Z',
          endTime: '2022-01-01T12:00:00.000Z',
          maxAttendees: 100,
          isPrivate: true,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2 RSVP',
          venue: null,
          description: 'Test Description 2',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-02T10:00:00.000Z',
          endTime: '2022-01-02T12:00:00.000Z',
          maxAttendees: 150,
          isPrivate: false,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
        Event(
          id: '3',
          nameOfEvent: 'Test Event 3 RSVP',
          venue: null,
          description: 'Test Description 3',
          imageUrls: [],
          hosts: [],
          hostIds: [],
          startTime: '2022-01-03T10:00:00.000Z',
          endTime: '2022-01-03T12:00:00.000Z',
          maxAttendees: 200,
          isPrivate: false,
          attendees: [],

          metadata: Metadata(
            mentors: [],
            categories: [],
            sessions: [],
          ), invitees: [], saved: false, metadataString: '',
        ),
      ]);
    });

    testWidgets('Renders Attendees correctly for ADMIN role', (WidgetTester tester) async {

      when(mockUserProvider.role).thenReturn('ADMIN');


      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
              ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
            ],
            child: Attendees(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Attendees'), findsOneWidget);
      verify(mockEventProvider.eventsHome).called(1);
      verifyNever(mockEventProvider.eventsRsvp);
       final events = await mockEventProvider.eventsHome;
      expect(events.length, 3);
      expect(events[0].nameOfEvent, 'Test Event 1 HOME');
      expect(events[1].nameOfEvent, 'Test Event 2 HOME');
      expect(events[2].nameOfEvent, 'Test Event 3 HOME');


    });

    testWidgets('Renders Attendees correctly for HOST role', (WidgetTester tester) async {

      when(mockUserProvider.role).thenReturn('HOST');


      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
              ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
            ],
            child: Attendees(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Attendees'), findsOneWidget);
      verify(mockEventProvider.eventsHome).called(1);
      verifyNever(mockEventProvider.eventsRsvp);
      final events = await mockEventProvider.eventsRsvp;
      expect(events.length, 3);
      expect(events[0].nameOfEvent, 'Test Event 1 RSVP');
      expect(events[1].nameOfEvent, 'Test Event 2 RSVP');
      expect(events[2].nameOfEvent, 'Test Event 3 RSVP');

    });
  });
}
