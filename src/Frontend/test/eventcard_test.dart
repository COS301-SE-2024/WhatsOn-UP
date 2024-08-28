import 'dart:convert';

import 'package:firstapp/pages/BroadcastEvent.dart';
import 'package:firstapp/pages/Event_Attendance.dart';
// import 'package:firstapp/providers/events_providers.dart';

// import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/widgets/event_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'api_test.mocks.dart';


void main() {
  group('Category', () {
    test('fromJson and toJson should work correctly', () {

      final json = '1,Technology';


      final category = Category.fromJson(json);
      expect(category.id, '1');
      expect(category.name, 'Technology');
      expect(category.isSelected, false);
      expect(category.rating, '0');
      expect(category.faculty, '');


      final categoryToJson = category.toJson();
      expect(categoryToJson['id'], '1');
      expect(categoryToJson['name'], 'Technology');
      expect(categoryToJson['rating'], '0');
      expect(categoryToJson['faculty'], '');
    });

    test('toString should work correctly', () {
      final category = Category(
        id: '1',
        name: 'Technology',
        isSelected: true,
        rating: '4.5',
        faculty: 'Engineering',
      );
      expect(
          category.toString(),
          'Category(id: 1, name: Technology, isSelected: true, rating: 4.5, faculty: Engineering)'
      );
    });
  });

  group('Role', () {
    test('fromJson should parse Role correctly', () {
      final json = {'id': 1, 'name': 'Organizer'};
      final role = Role.fromJson(json);
      expect(role.id, 1);
      expect(role.name, 'Organizer');
    });
  });

  group('Attendee', () {
    test('fromJson should parse Attendee correctly', () {
      final json = {
        'userId': '123',
        'fullName': 'John Doe',
        'profileImage': 'profile.png',
        'role': {'id': 1, 'name': 'Organizer'}
      };
      final attendee = Attendee.fromJson(json);
      expect(attendee.userId, '123');
      expect(attendee.fullName, 'John Doe');
      expect(attendee.profileImage, 'profile.png');
      expect(attendee.role.id, 1);
      expect(attendee.role.name, 'Organizer');
    });

    test('toString should work correctly', () {
      final role = Role(id: 1, name: 'Organizer');
      final attendee = Attendee(
        userId: '123',
        fullName: 'John Doe',
        profileImage: 'profile.png',
        role: role,
      );
      expect(attendee.toString(), 'Attendee(id: 123, name: John Doe, role: $role, profileImage: profile.png)');
    });
  });

  group('Metadata', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'mentors': ['Mentor1', 'Mentor2'],
        'categories': ['Tech', 'Science'],
        'sessions': ['Session1', 'Session2']
      };
      final metadata = Metadata.fromJson(json);
      expect(metadata.mentors, ['Mentor1', 'Mentor2']);
      expect(metadata.categories, ['Tech', 'Science']);
      expect(metadata.sessions, ['Session1', 'Session2']);
      expect(metadata.toJson(), json);
    });
  });

  group('Campus', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'campusId': 'campus1',
        'name': 'Main Campus',
        'location': 'City Center',
        'parking': true
      };
      final campus = Campus.fromJson(json);
      expect(campus.campusId, 'campus1');
      expect(campus.name, 'Main Campus');
      expect(campus.location, 'City Center');
      expect(campus.parking, true);
      expect(campus.toJson(), json);
    });
  });

  group('Building', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'buildingId': 'building1',
        'name': 'Building A',
        'accessType': 'Open',
        'location': 'North Wing',
        'campus': {'campusId': 'campus1', 'name': 'Main Campus', 'location': 'City Center', 'parking': true}
      };
      final building = Building.fromJson(json);
      expect(building.buildingId, 'building1');
      expect(building.name, 'Building A');
      expect(building.accessType, 'Open');
      expect(building.location, 'North Wing');
      expect(building.campus?.name, 'Main Campus');
      expect(building.toJson(), json);
    });
  });

  group('Venue', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'venueId': 'venue1',
        'building': {
          'buildingId': 'building1',
          'name': 'Building A',
          'accessType': 'Open',
          'location': 'North Wing',
          'campus': {
            'campusId': 'campus1',
            'name': 'Main Campus',
            'location': 'City Center',
            'parking': true
          }
        },
        'name': 'Conference Room',
        'boards': 'Whiteboard',
        'ac': true,
        'wifi': true,
        'dataProject': 2,
        'docCam': true,
        'mic': true,
        'windows': true,
        'capacity': 100,
        'available': true
      };
      final venue = Venue.fromJson(json);
      expect(venue.venueId, 'venue1');
      expect(venue.building?.name, 'Building A');
      expect(venue.name, 'Conference Room');
      expect(venue.boards, 'Whiteboard');
      expect(venue.ac, true);
      expect(venue.wifi, true);
      expect(venue.dataProject, 2);
      expect(venue.docCam, true);
      expect(venue.mic, true);
      expect(venue.windows, true);
      expect(venue.capacity, 100);
      expect(venue.available, true);
      expect(venue.toJson(), json);
    });
  });

  group('Host', () {
    test('fromJson and toJson should work correctly', () {
      final json = {'user_id': 'user1', 'event_id': 'event1'};
      final host = Host.fromJson(json);
      expect(host.userId, 'user1');
      expect(host.eventId, 'event1');
      expect(host.toJson(), json);
    });
  });
  // group('Bookmark Button', () {
  //
  //   final mockUserProvider = MockuserProvider();
  //   final mockNotificationProvider = MocknotificationProvider();
  //   final mockEventProvider = MockEventProvider();
  //
  //   testWidgets('Bookmark button visibility and functionality test', (WidgetTester tester) async {
  //
  //     when(mockUserProvider.role).thenReturn('ADMIN');
  //     bool isBookmarked = false;
  //
  //
  //     final mockEvent = Event(
  //       id: '3',
  //       nameOfEvent: 'Test Event 3 HOME',
  //       venue: null,
  //       description: 'Test Description 3',
  //       imageUrls: [],
  //       hosts: [],
  //       startTime: '2022-01-03T10:00:00.000Z',
  //       endTime: '2022-01-03T12:00:00.000Z',
  //       maxAttendees: 200,
  //       isPrivate: false,
  //       attendees: [],
  //       metadata: Metadata(
  //         mentors: [],
  //         categories: [],
  //         sessions: [],
  //       ),
  //       invitees: [],
  //     );
  //
  //
  //
  //
  //
  //     await tester.pumpWidget(MaterialApp(
  //       home: Scaffold(
  //         body: EventCard(
  //           showBookmarkButton: true,
  //           event: mockEvent,
  //
  //
  //         ),
  //       ),
  //     ));
  //
  //
  //     expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
  //
  //
  //     await tester.tap(find.byIcon(Icons.bookmark_border));
  //     await tester.pump();
  //
  //
  //     expect(isBookmarked, isTrue);
  //     // verify(eventP.addEventSaved(mockEvent)).called(1);
  //     //
  //     //
  //     // await tester.tap(find.byIcon(Icons.bookmark));
  //     // await tester.pump();
  //     //
  //     //
  //     // expect(isBookmarked, isFalse);
  //     // verify(eventP.removeEventSaved(mockEvent)).called(1);
  //   });
  // });
  //
  // group('Broadcast and Attendance Button', () {
  //   final mockUserProvider = MockuserProvider();
  //
  //   final mockEventProvider = MockEventProvider();
  //   testWidgets('Broadcast and Attendance button visibility and functionality test', (WidgetTester tester) async {
  //     when(mockUserProvider.role).thenReturn('ADMIN');
  //     final mockEvent = Event(
  //       id: '3',
  //       nameOfEvent: 'Test Event 3 HOME',
  //       venue: null,
  //       description: 'Test Description 3',
  //       imageUrls: [],
  //       hosts: [],
  //       startTime: '2022-01-03T10:00:00.000Z',
  //       endTime: '2022-01-03T12:00:00.000Z',
  //       maxAttendees: 200,
  //       isPrivate: false,
  //       attendees: [],
  //       metadata: Metadata(
  //         mentors: [],
  //         categories: [],
  //         sessions: [],
  //       ),
  //       invitees: [],
  //     );;
  //
  //
  //
  //     await tester.pumpWidget(MaterialApp(
  //       home: Scaffold(
  //         body:MultiProvider(
  //           providers: [
  //             ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
  //             ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
  //           ],
  //           child:  EventCard(
  //               showBookmarkButton:true,
  //               broadcast:'EDIT',
  //               event: mockEvent,
  //             ),
  //         ),
  //         // body:  EventCard(
  //         //   showBookmarkButton:true,
  //         //   broadcast:'EDIT',
  //         //   event: mockEvent,
  //         // ),
  //       ),
  //     ));
  //
  //
  //     expect(find.text('Attendees: 0'), findsOneWidget);
  //
  //
  //     await tester.tap(find.text('Attendees: 0'));
  //     await tester.pumpAndSettle();
  //     expect(find.byType(EventAttendance), findsOneWidget);
  //
  //     expect(find.text('Broadcast'), findsOneWidget);
  //
  //
  //     await tester.tap(find.text('Broadcast'));
  //     await tester.pumpAndSettle();
  //     expect(find.byType(BroadcastEventDialog), findsOneWidget);
  //   });
  // });



}
