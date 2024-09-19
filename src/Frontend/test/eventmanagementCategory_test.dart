import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_test.mocks.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/widgets/eventManagement_category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';




void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({}); // Mock shared preferences
    
    await Supabase.initialize(
      url: 'https://mehgbhiirnmypfgnkaud.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI5NDMyMzYsImV4cCI6MjAzODUxOTIzNn0.g_oLlSZE3AH_nBntVe_hBPdthFDQHZqn0wxzS23kyrc',
    );
  });
  group('ManageEventsCategory Widget Tests', () {
    late MockEventProvider mockEventProvider;
    late MockuserProvider mockUserProvider;
    late MockApi mockApi;

    setUp(() {
      mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      mockUserProvider = MockuserProvider();
      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockApi.getAllEvents()).thenAnswer((_) async =>
      [
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
          ),
          invitees: [],
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
          ),
          invitees: [],
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
          invitees: [],
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
          invitees: [],
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
          invitees: [],
        ),
      ]);
      when(mockEventProvider.eventsRsvp).thenAnswer((_) async =>
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
          invitees: [],
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
          invitees: [],
        ),
      ]);
    });


    testWidgets('EventmanagementCategory widget builds correctly', (
        WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [

              ChangeNotifierProvider<EventProvider>(
                  create: (_) => mockEventProvider),
              ChangeNotifierProvider<userProvider>(
                  create: (_) => mockUserProvider),
            ],
            child: MaterialApp(
              home: EventmanagementCategory(supabaseClient: Supabase.instance.client,),
            ),
          ),
        );
      });
      expect(find.text('Edit Events'), findsOneWidget);
      expect(find.byType(EventmanagementCategory), findsOneWidget);
    });


    testWidgets(
        'Search and Filter buttons are present', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [

              ChangeNotifierProvider<EventProvider>(
                  create: (_) => mockEventProvider),
              ChangeNotifierProvider<userProvider>(
                  create: (_) => mockUserProvider),
            ],
            child: MaterialApp(
              home: EventmanagementCategory(supabaseClient: Supabase.instance.client),
            ),
          ),
        );
      });
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
    });


    testWidgets('Displays error message when data fails to load', (
        WidgetTester tester) async {
      when(mockEventProvider.eventsHome).thenThrow(
          Exception('Error loading events'));
      when(mockUserProvider.role).thenReturn('ADMIN');
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [

              ChangeNotifierProvider<EventProvider>(
                  create: (_) => mockEventProvider),
              ChangeNotifierProvider<userProvider>(
                  create: (_) => mockUserProvider),
            ],
            child: MaterialApp(
              home: EventmanagementCategory(supabaseClient: Supabase.instance.client,),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Error loading events'), findsOneWidget);
      });
    });

    testWidgets('Displays no events message when data is empty', (
          WidgetTester tester) async {
        when(mockEventProvider.eventsHome).thenAnswer((_) async => []);
        await mockNetworkImages(() async {
          await tester.pumpWidget(
            MultiProvider(
              providers: [

                ChangeNotifierProvider<EventProvider>(
                    create: (_) => mockEventProvider),
                ChangeNotifierProvider<userProvider>(
                    create: (_) => mockUserProvider),
              ],
              child: MaterialApp(
                home: EventmanagementCategory(supabaseClient: Supabase.instance.client,),
              ),
            ),
          );
        });
        await tester.pump();
        await tester.pump();

        expect(find.text('No events available'), findsOneWidget);
      });
  });
}









