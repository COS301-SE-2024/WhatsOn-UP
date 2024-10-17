import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/settings_page.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'api_test.mocks.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:firstapp/providers/events_providers.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
void main() {
  group('GuestView Tests', () {
    late MockuserProvider mockUserProvider;
    late MockEventProvider mockEventProvider;
    late MockApi mockApi;
    late MockThemeNotifier mockThemeNotifier;

    setUp(() {
      mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      
      mockUserProvider = MockuserProvider();

      mockThemeNotifier=MockThemeNotifier();
      final ThemeData lightThemeData = ThemeData.light();


      when(mockThemeNotifier.lightTheme).thenReturn(lightThemeData);


      when(mockThemeNotifier.getTheme()).thenReturn(lightThemeData);
      
      when(mockUserProvider.Fullname).thenReturn('Guest User');
      when(mockUserProvider.email).thenReturn('');
      when(mockUserProvider.password).thenReturn('');
      when(mockUserProvider.role).thenReturn('GUEST');

      // final placeholderImage = img.Image(width: 20, height: 20);
      // final placeholderImageData = img.encodePng(placeholderImage);

      // when(mockUserProvider.profileImage)
      //     .thenReturn(Uint8List.fromList(placeholderImageData));

      String mockImageUrl = '';
      when(mockUserProvider.profileImage)
          .thenReturn(mockImageUrl);
      when(mockApi.getAllEvents('JWT')).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
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
      when(mockEventProvider.eventsHome).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1 HOME',
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
          ), saved: false, metadataString: '',


        ),
        Event(
          id: '3',
          nameOfEvent: 'Test Event 3 HOME',
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
          ), invitees: [], saved: false, metadataString: ''
        ),
        Event(
          id: '3',
          nameOfEvent: 'Test Event 3 RSVP',
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


      // when(mockUserProvider.profileimage).thenReturn(Uint8List.fromList(placeholderImageData));
    });

    // testWidgets('should display Guest User on HomePage', (WidgetTester tester) async {
    //   await mockNetworkImages(() async {
    //   await tester.pumpWidget(
    //     MultiProvider(
    //       providers: [
    //
    //         ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
    //         ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
    //       ],
    //       child: const MaterialApp(
    //         home: HomePage(),
    //       ),
    //     ),
    //   );
    //   });
    //   await tester.pumpAndSettle();
    //   expect(find.text('Welcome, Guest User'), findsOneWidget);
    // });

    testWidgets('should not display Account button on SettingsPage for GUEST role', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('GUEST');
      await tester.pumpWidget(
        MultiProvider(
          providers: [

            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
            ChangeNotifierProvider<ThemeNotifier>(create:(_)=>mockThemeNotifier),
          ],
          child: const MaterialApp(
            home:  SettingsPage(),
          ),
        ),
      );

      expect(find.text('Account'), findsNothing);
      
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      // expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
    });

    testWidgets('should display correct buttons and links on ProfilePage for GUEST user', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('GUEST');
      await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<userProvider>.value(
            value: mockUserProvider,
            child: ProfilePage(),
          ),
        ),
      );
      });
      expect(find.text('Guest User'), findsOneWidget);
      expect(find.text('Create an account to access more features!'), findsOneWidget);
      expect(find.text('Already have an account? Log In'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.text('Limited Guest Features'), findsOneWidget);
    });
  });
}