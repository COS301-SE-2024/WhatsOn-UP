
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'api_test.mocks.dart';

void main() {
  group('EventProvider', () {
    late MockEventProvider mockEventProvider;
    late MockApi mockApi;
  late EventProvider eventProvider;
    setUp(() {

      mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      when(mockApi.getAllEvents('JWT')).thenAnswer((_) async => [
        Event(
          id: '1',
          nameOfEvent: 'Test Event 1',
          venue: Venue(venueId: 'V123', building:
                 Building(buildingId: 'B001', name: 'Main Building', accessType: 'Public', location: 'Central Campus', campus: null), 
                 name: 'Conference Room A', boards: 'Whiteboard', ac: true, wifi: true, dataProject: 1, docCam: true, 
                 mic: true, windows: true, capacity: 50, available: true),
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
          ), invitees: [], saved: false,
        ),
        Event(
          id: '2',
          nameOfEvent: 'Test Event 2',
          venue: Venue(venueId: 'V123', building:
                 Building(buildingId: 'B001', name: 'Main Building', accessType: 'Public', location: 'Central Campus', campus: null), 
                 name: 'Conference Room A', boards: 'Whiteboard', ac: true, wifi: true, dataProject: 1, docCam: true, 
                 mic: true, windows: true, capacity: 50, available: true),
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
          saved: false,
        ),
      ]);

      when(mockApi.putSavedEvent(any, any)).thenAnswer((_) async => Future.value());
      when(mockApi.DeleteSavedEvent(any, any)).thenAnswer((_) async => Future.value());

      eventProvider = EventProvider(api: mockApi);



    });


    test('Fetch eventsHome should return a list of events', () async {
      await eventProvider.refreshEvents('JWT');
      var events = await eventProvider.eventsHome;
      print(events);
      expect(events.isNotEmpty, true);

    });


    test('Add and remove event from eventsHome', () async {
      var initialEvents = await eventProvider.eventsHome;
      print(initialEvents);
       var eventToAdd = Event(
         id: '3',
         nameOfEvent: 'Test Event 3',
         venue: Venue(venueId: 'V123', building:
                 Building(buildingId: 'B001', name: 'Main Building', accessType: 'Public', location: 'Central Campus', campus: null), 
                 name: 'Conference Room A', boards: 'Whiteboard', ac: true, wifi: true, dataProject: 1, docCam: true, 
                 mic: true, windows: true, capacity: 50, available: true),
        description: 'Test Description',
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
      );




       var updatedEvents = await eventProvider.eventsHome;


       expect(updatedEvents.length, initialEvents.length);



      var finalEvents = await eventProvider.eventsHome;
       expect(finalEvents.length, initialEvents.length);
     });

    // test('Edit event name in eventsHome', () async {
    //
    //   Event mockEvent =   Event(
    //     id: '1',
    //     nameOfEvent: 'Test Event 1',
    //     venue: Venue(venueId: 'V123', building:
    //     Building(buildingId: 'B001', name: 'Main Building', accessType: 'Public', location: 'Central Campus', campus: null),
    //         name: 'Conference Room A', boards: 'Whiteboard', ac: true, wifi: true, dataProject: 1, docCam: true,
    //         mic: true, windows: true, capacity: 50, available: true),
    //     description: 'Test Description 1',
    //     imageUrls: [],
    //     hosts: [],
    //     startTime: '2022-01-01T10:00:00.000Z',
    //     endTime: '2022-01-01T12:00:00.000Z',
    //     maxAttendees: 100,
    //     isPrivate: true,
    //     attendees: [],
    //
    //     metadata: Metadata(
    //       mentors: [],
    //       categories: [],
    //       sessions: [],
    //     ), invitees: [], saved: false,
    //   );
    //   when(mockEventProvider.eventsHome).thenAnswer((_) async => [mockEvent]);
    //
    //   var newName = 'Updated Event Name';
    //
    //   print("Before edit: ${(await mockEventProvider.eventsHome).map((e) => e.nameOfEvent)}");
    //
    //
    //   await mockEventProvider.EditEventName(mockEvent.id!, newName);
    //
    //
    //   print("After edit: ${(await mockEventProvider.eventsHome).map((e) => e.nameOfEvent)}");
    //
    //
    //   var updatedEvent = (await mockEventProvider.eventsHome).firstWhere((e) => e.id == mockEvent.id);
    //   expect(updatedEvent.nameOfEvent, newName);
    //
    //
    //   await mockEventProvider.EditEventName(mockEvent.id!, 'Test Event 1');
    // });












  });
}
