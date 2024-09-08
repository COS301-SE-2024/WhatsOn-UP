import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/widgets/nav_bar.dart';
import 'package:mockito/mockito.dart';
import 'api_test.mocks.dart';

void main() {
  group('HomePage Widget Tests', ()
  {
    late MockuserProvider mockUserProvider;
    late MockEventProvider mockEventProvider;

    setUp(() async {

      mockEventProvider = MockEventProvider();
      mockUserProvider = MockuserProvider();
      when(mockEventProvider.eventsHome).thenAnswer((_) async =>
      [
        Event(
          id: '1',
          nameOfEvent: 'Event 1',
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
          nameOfEvent: 'Event 2',
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

      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockUserProvider.email).thenReturn('user@gmail.com');
      when(mockUserProvider.password).thenReturn('password123');
      when(mockUserProvider.role).thenReturn('USER');
      String mockImageUrl = '';
      when(mockUserProvider.profileImage)
          .thenReturn(mockImageUrl);
    });

    testWidgets('Renders HomePage widget with NavBar',
            (WidgetTester tester) async {
          when(mockUserProvider.role).thenReturn('ADMIN');
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: MultiProvider(
                  providers: [
                    ChangeNotifierProvider<userProvider>(
                        create: (_) => mockUserProvider),
                    ChangeNotifierProvider<EventProvider>(
                        create: (_) => mockEventProvider),
                  ],
                  child: MaterialApp(
                    home: HomePage(),
                  ),
                ),),
            );
          });
          expect(find.byType(NavBar), findsOneWidget);
        });


    testWidgets('TabController is initialized with 2 tabs', (
        WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<userProvider>(
                    create: (_) => mockUserProvider),
                ChangeNotifierProvider<EventProvider>(
                    create: (_) => mockEventProvider),
              ],
              child: MaterialApp(home: HomePage()),
            ),
          ),
        );
      });


      final tabBarFinder = find.byType(TabBar);
      expect(tabBarFinder, findsOneWidget);


      final tabBar = tester.widget<TabBar>(tabBarFinder);
      expect(tabBar.tabs.length, 2);


      final firstTab = tabBar.tabs[0] as Tab;
      expect(firstTab.text, equals('Explore'));

      final secondTab = tabBar.tabs[1] as Tab;
      expect(secondTab.text, equals('Saved Events'));
    });



    testWidgets('FloatingActionButton is shown only for HOST or ADMIN', (WidgetTester tester) async {

      when(mockUserProvider.role).thenReturn('HOST');
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
                ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
              ],
              child: MaterialApp(home: HomePage()),
            ),
          ),
        );
      });


      expect(find.byType(FloatingActionButton), findsOneWidget);

      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
              ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ],
            child: MaterialApp(home: HomePage()),
          ),
        ),
      );
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
    testWidgets('FloatingActionButton is not shown  for other users except HOST and ADMIN', (WidgetTester tester) async {

      when(mockUserProvider.role).thenReturn('GENERAL');
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
                ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
              ],
              child: MaterialApp(home: HomePage()),
            ),
          ),
        );
      });

      expect(find.byType(FloatingActionButton), findsNothing);
    });


    testWidgets('Fetch events calls Provider methods', (WidgetTester tester) async {

      when(mockUserProvider.role).thenReturn('GENERAL');
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
                ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
              ],
              child: MaterialApp(home: HomePage()),
            ),
          ),
        );
      });

      verify(mockEventProvider.eventsHome).called(greaterThanOrEqualTo(1));
      verify(mockEventProvider.eventsSaved).called(greaterThanOrEqualTo(1));
      verify(mockEventProvider.recommendations).called(greaterThanOrEqualTo(1));
    });

    testWidgets('Explore Tab shows events', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
                ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
              ],
              child: MaterialApp(home: HomePage()),
            ),
          ),
        );

      await tester.pump();
      expect(find.text('All Events'), findsOneWidget);
      expect(find.text('Event 1'), findsOneWidget);
      expect(find.text('Recommended Events'), findsOneWidget);
      expect(find.text('Event 2'), findsOneWidget);
      });
    });


  });

}

