

import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/widgets/Pastevents.dart';
import 'package:firstapp/widgets/eventManagement_category.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/manageEvents.dart';
import 'package:firstapp/providers/user_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart' as SupabaseAuthUI;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as SupabaseFlutter;
import 'api_test.mocks.dart';


void main() {
  group('ManageEvents Widget Tests', () {
    late MockEventProvider mockEventProvider;
    late MockuserProvider mockUserProvider;
    late MockApi mockApi;

    late MockSupabase mockSupabase;



    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});

      await Supabase.initialize(
        url: 'https://mehgbhiirnmypfgnkaud.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI5NDMyMzYsImV4cCI6MjAzODUxOTIzNn0.g_oLlSZE3AH_nBntVe_hBPdthFDQHZqn0wxzS23kyrc',
      );
       mockSupabase = MockSupabase();
      final mockSupabaseClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();


      when(mockAuth.currentUser).thenReturn(
          const SupabaseAuthUI.User(
              id: '12345',
              appMetadata: {'role': 'admin'},
              userMetadata: {
                'name': 'John Doe',
                'email': 'john.doe@example.com'
              },
              aud: 'authenticated',
              createdAt: "now"
          ));


    });

    setUp(() {
      mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      mockUserProvider = MockuserProvider();
      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockApi.getAllEvents('JWT')).thenAnswer((_) async =>
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
          invitees: [], saved: true,
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
          invitees: [], saved: true,
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
          ), saved: false,


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
          invitees: [], saved: true,
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
          invitees: [], saved: true,
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
    });


    testWidgets('Renders ManageEvents correctly for ADMIN role', (
        WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<userProvider>(
                create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(supabaseClient: Supabase.instance.client),
          ),
        ),
      );


      expect(find.text('Manage Events'), findsOneWidget);
      expect(find.text('All Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);
      expect(find.text('General User Host Applications'), findsOneWidget);
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.group), findsOneWidget);


    });
    testWidgets('Tapping on Past Events navigates to Pastevents page', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents(supabaseClient: Supabase.instance.client),
          ),
        ),
      );


      await tester.tap(find.text('Past Events'));
      await tester.pumpAndSettle();


      expect(find.byType(Pastevents), findsOneWidget);
    });

    testWidgets('Tapping Past Events does not cause errors', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents( supabaseClient: Supabase.instance.client),
          ),
        ),
      );


      await tester.tap(find.text('Past Events'));
      await tester.pumpAndSettle();



      expect(find.byType(Pastevents), findsOneWidget);
    });
//
//
    testWidgets('General User Host Applications is visible for ADMIN role only', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents( supabaseClient: Supabase.instance.client),
          ),
        ),
      );


      expect(find.text('General User Host Applications'), findsOneWidget);

      when(mockUserProvider.role).thenReturn('HOST');
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: MaterialApp(
            home: ManageEvents( supabaseClient: Supabase.instance.client),
          ),
        ),
      );


      expect(find.text('General User Host Applications'), findsNothing);
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
            home: ManageEvents( supabaseClient: Supabase.instance.client),
          ),
        ),
      );

      expect(find.text('Manage Events'), findsOneWidget);
      expect(find.text('My Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);

    });
//
    testWidgets('Navigates to EventManagementCategory when All Events is tapped', (WidgetTester tester) async {
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
              home: ManageEvents(supabaseClient: Supabase.instance.client),
            ),
          ),
        );

        expect(find.text('All Events'), findsOneWidget);
        await tester.tap(find.text('All Events'));
        await tester.pumpAndSettle();

        expect(find.byType(EventmanagementCategory), findsOneWidget);
      });
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
            home: ManageEvents( supabaseClient: Supabase.instance.client),
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




  });

}
