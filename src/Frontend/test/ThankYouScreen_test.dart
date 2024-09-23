import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:firstapp/surveys/ThankYou_Survey.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'api_test.mocks.dart';

void main() {
  late MockuserProvider mockUserProvider;
  late MockEventProvider mockEventProvider;
  late MockApi mockApi;
  setUp(() {
    mockApi = MockApi();
    mockUserProvider = MockuserProvider();
    mockEventProvider = MockEventProvider();
    when(mockApi.getAllEvents('JWT')).thenAnswer((_) async => [
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
        ), invitees: [], saved: true,
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
        ), invitees: [], saved: true,
      ),
    ]);
    when(mockEventProvider.eventsHome).thenAnswer((_) async =>
    [
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
        ),
        invitees: [], saved: true,
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
        invitees: [], saved: true,
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
        ),
        invitees: [], saved: false,
      ),
    ]);
    when(mockEventProvider.eventsSaved).thenAnswer((_) async =>
    [
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
        ),
        invitees: [], saved: false,
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
        ),
        invitees: [], 
        saved: true,
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
        ),
        invitees: [], saved: true,
      ),
    ]);
    when(mockEventProvider.recommendations).thenAnswer((_) async =>
    [
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
        ),
        invitees: [], saved: false,
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
        ),
        invitees: [], saved: true,
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
        ),
        invitees: [], saved: false,
      ),
    ]);

    String mockImageUrl = '';
    when(mockUserProvider.profileImage)
        .thenReturn(mockImageUrl);
    when(mockUserProvider.role).thenReturn('ADMIN');
    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
  });
  testWidgets('ThankYouScreen displays all elements correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThankYouScreen(),
      ),
    );


    expect(find.byType(Icon), findsOneWidget);
    expect(find.text('Thank You!'), findsOneWidget);
    expect(find.text('We appreciate your time and effort in completing the survey. Your feedback is valuable to us.'), findsOneWidget);
    expect(find.text('Let\'s see WHAT IS ON AT UP!'), findsOneWidget);
    expect(find.text('Go to Home'), findsOneWidget);
  });

  testWidgets('Go to Home button navigates to HomePage', (WidgetTester tester) async {
    await mockNetworkImages(() async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<EventProvider>(
              create: (_) => mockEventProvider),
          ChangeNotifierProvider<userProvider>(
            create: (_) => mockUserProvider,
          ),
        ],
        child: MaterialApp(
          home: ThankYouScreen(),
          routes: {
            '/home': (context) => HomePage(),
          },
        ),
      ),
    );
    await tester.tap(find.text('Go to Home'));
    await tester.pumpAndSettle();


    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(ThankYouScreen), findsNothing);
  });



  });

}
