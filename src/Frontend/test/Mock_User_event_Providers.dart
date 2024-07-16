import 'dart:typed_data';

import 'package:firstapp/services/api.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';



class MockEventProvider extends ChangeNotifier implements EventProvider {
  late final Api api ;
  late Future<List<Event>> _eventsHome;
  late Future<List<Event>> _eventsRsvp;

  @override
  MockEventProvider({required this.api}) {
    _eventsHome = _fetchEventsHome();
  }
  @override
  Future<List<Event>> get eventsRsvp async {
    List<Attendee> attendees1 = [
      Attendee(
          userId: '1',
          fullName: 'John Doe',
          profileImage: 'path/to/john_doe.jpg',
          role: {'Admin': 'Organizer', 'permissions': ['manage']}
      ),
      Attendee(
          userId: '2',
          fullName: 'Jane Smith',
          profileImage: 'path/to/jane_smith.jpg',
          role: {'title': 'Attendee', 'permissions': ['view']}
      ),
    ];

    List<Attendee> attendees2 = [
      Attendee(
          userId: '3',
          fullName: 'Alice Johnson',
          profileImage: 'path/to/alice_johnson.jpg',
          role: {'title': 'Organizer', 'permissions': ['manage']}
      ),
      Attendee(
          userId: '4',
          fullName: 'Bob Brown',
          profileImage: 'path/to/bob_brown.jpg',
          role: {'title': 'Attendee', 'permissions': ['view']}
      ),
    ];
    return Future.value([
      Event(
        id: '1',
        nameOfEvent: 'Test Event 1',
        dateAndTime: '2022-01-01T00:00:00.000Z',
        location: 'Test Location 1',
        description: 'Test Description 1',
        imageUrls: [],
        hosts: [],
        startTime: '2022-01-01T10:00:00.000Z',
        endTime: '2022-01-01T12:00:00.000Z',
        maxAttendees: 100,
        isPrivate: true,
        attendees: [attendees1[0], attendees1[1]],
        startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
      ),
      Event(
        id: '2',
        nameOfEvent: 'Test Event 2',
        dateAndTime: '2022-01-02T00:00:00.000Z',
        location: 'Test Location 2',
        description: 'Test Description 2',
        imageUrls: [],
        hosts: [],
        startTime: '2022-01-02T10:00:00.000Z',
        endTime: '2022-01-02T12:00:00.000Z',
        maxAttendees: 150,
        isPrivate: false,
        attendees: [attendees2[0], attendees2[1]],
        startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
      ),
    ]);
  }

  @override
  Future<List<Event>> get eventsHome async {
    List<Attendee> attendees1 = [
      Attendee(
          userId: '1',
          fullName: 'John Doe',
          profileImage: 'path/to/john_doe.jpg',
          role: {'Admin': 'Organizer', 'permissions': ['manage']}
      ),
      Attendee(
          userId: '2',
          fullName: 'Jane Smith',
          profileImage: 'path/to/jane_smith.jpg',
          role: {'title': 'Attendee', 'permissions': ['view']}
      ),
    ];

    List<Attendee> attendees2 = [
      Attendee(
          userId: '3',
          fullName: 'Alice Johnson',
          profileImage: 'path/to/alice_johnson.jpg',
          role: {'title': 'Organizer', 'permissions': ['manage']}
      ),
      Attendee(
          userId: '4',
          fullName: 'Bob Brown',
          profileImage: 'path/to/bob_brown.jpg',
          role: {'title': 'Attendee', 'permissions': ['view']}
      ),
    ];
    return Future.value([

      Event(
        id: '1',
        nameOfEvent: 'Event 1',
        dateAndTime: '2022-01-01T00:00:00.000Z',
        location: 'Test Location 1',
        description: 'Test Description 1',
        imageUrls: [],
        hosts: [],
        startTime: '2022-01-01T10:00:00.000Z',
        endTime: '2022-01-01T12:00:00.000Z',
        maxAttendees: 100,
        isPrivate: true,
        attendees: [attendees1[0],attendees1[1]],
        startDate: DateTime.parse('2022-01-01T10:00:00.000Z'),
      ),
      Event(
        id: '2',
        nameOfEvent: 'Event 2',
        dateAndTime: '2022-01-02T00:00:00.000Z',
        location: 'Test Location 2',
        description: 'Test Description 2',
        imageUrls: [],
        hosts: [],
        startTime: '2022-01-02T10:00:00.000Z',
        endTime: '2022-01-02T12:00:00.000Z',
        maxAttendees: 150,
        isPrivate: false,
        attendees: [ attendees2[0], attendees2[1]],
        startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
      ),
      Event(
        id: '3',
        nameOfEvent: 'Event 3',
        dateAndTime: '2022-01-02T00:00:00.000Z',
        location: 'Test Location 2',
        description: 'Test Description 2',
        imageUrls: [],
        hosts: [],
        startTime: '2022-01-02T10:00:00.000Z',
        endTime: '2022-01-02T12:00:00.000Z',
        maxAttendees: 150,
        isPrivate: false,
        attendees: [],
        startDate: DateTime.parse('2022-01-02T10:00:00.000Z'),
      ),
    ]);
  }



  @override
  void EditEventDescription(String id, String Description) {
    // TODO: implement EditEventDescription
  }

  @override
  void EditEventEndTime(String id, DateTime endTime) {
    // TODO: implement EditEventEndTime
  }

  @override
  Future<void> EditEventLocation(String id, String Location) {
    // TODO: implement EditEventLocation
    throw UnimplementedError();
  }

  @override
  Future<void> EditEventMaxParticipants(String id, int maxParticipants) {
    // TODO: implement EditEventMaxParticipants
    throw UnimplementedError();
  }

  @override
  Future<void> EditEventName(String id, String eventName) {
    // TODO: implement EditEventName
    throw UnimplementedError();
  }

  @override
  void EditEventStartTime(String id, DateTime startTime) {
    // TODO: implement EditEventStartTime
  }

  @override
  void EditEventsIsPrivate(String id, bool isPrivate) {
    // TODO: implement EditEventsIsPrivate
  }

  @override
  Future<void> addEventHome(Map<String, dynamic> eventData) {
    // TODO: implement addEventHome
    throw UnimplementedError();
  }

  @override
  void addEventRSVP(Event event) {
    // TODO: implement addEventRSVP
  }

  @override
  void addEventSaved(Event event) {
    // TODO: implement addEventSaved
  }

  @override
  void addEventsHome(List<Event> events) {
    // TODO: implement addEventsHome
  }

  @override
  void addEventsRSVP(List<Event> events) {
    // TODO: implement addEventsRSVP
  }

  @override
  // TODO: implement eventsSaved
  List<Event> get eventsSaved => throw UnimplementedError();

  @override
  void fetchfortheFirstTimeRsvp(String userId) {
    // TODO: implement fetchfortheFirstTimeRsvp
  }

  @override
  Future<Event?> getEventById(String id) {
    // TODO: implement getEventById
    throw UnimplementedError();
  }

  @override
  Future<void> refreshEvents() {
    // TODO: implement refreshEvents
    throw UnimplementedError();
  }

  @override
  Future<void> refreshRSVPEvents(String userId) {
    // TODO: implement refreshRSVPEvents
    throw UnimplementedError();
  }

  @override
  Future<void> removeEventHome(Event event) {
    // TODO: implement removeEventHome
    throw UnimplementedError();
  }

  @override
  void removeEventRSVP(Event event) {
    // TODO: implement removeEventRSVP
  }

  @override
  void removeEventSaved(Event event) {
    // TODO: implement removeEventSaved
  }
  @override
  Future<List<Event>> _fetchEventsHome() async {
    try {
      return await api.getAllEvents();
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
}

class MockUserProvider extends ChangeNotifier implements userProvider {
  String _Fullname = 'Testing';
  String _Email = '';
  String _Password = '';
  String _Role= '';
  String _userId= '';
  Uint8List? profileImage;


  String get Fullname => _Fullname;
  String get email => _Email;
  String get password => _Password;
  Uint8List? get profileimage => profileImage;
  String get role => _Role;
  String get userId => _userId; 
  

  @override
  set Fullname(String value) {
    _Fullname = value;
    notifyListeners();
  }

  @override
  set role(String value) {
    _Role = value;
    notifyListeners();
  }

  @override
  set email(String value) {
    _Email = value;
    notifyListeners();
  }

  @override
  set password(String value) {
    _Password = value;
    notifyListeners();
  }

  @override
  set profileimage(Uint8List? value) {
    profileImage = value;
    notifyListeners();
  }

  @override
  set userId(String value) {
    _userId = value;
    notifyListeners();
  } // Mock Fullname for testing
}
