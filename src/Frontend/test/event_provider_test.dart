
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'api_test.mocks.dart';

void main() {
  group('EventProvider', () {
    late EventProvider eventProvider;
    late MockApi mockApi;

    setUp(() {

      mockApi = MockApi();

      when(mockApi.getAllEvents()).thenAnswer((_) async => [
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
          ),
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
          ),
        ),
      ]);


      eventProvider = EventProvider(api: mockApi);
    });


    test('Fetch eventsHome should return a list of events', () async {
      await eventProvider.refreshEvents();
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
      );

       await eventProvider.addEventHome(eventToAdd.toJson());


       var updatedEvents = await eventProvider.eventsHome;


       expect(updatedEvents.length, initialEvents.length);

      await eventProvider.removeEventHome(eventToAdd);

      var finalEvents = await eventProvider.eventsHome;
       expect(finalEvents.length, initialEvents.length);
     });

    test('Edit event name in eventsHome', () async {
      var eventToUpdate = (await eventProvider.eventsHome).first;
      var originalName = eventToUpdate.nameOfEvent;
      var newName = 'Updated Event Name';

      await  eventProvider.EditEventName(eventToUpdate.id, newName);


      var updatedEvent = (await eventProvider.eventsHome).firstWhere((e) => e.id == eventToUpdate.id);
      expect(updatedEvent.nameOfEvent, newName);


      await eventProvider.EditEventName(eventToUpdate.id, originalName);
    });



    test('Edit event description in eventsHome', () async {
      var eventToUpdate = (await eventProvider.eventsHome).first;
      var originalDescription = eventToUpdate.description;
      var newDescription = 'Updated Event Description';

       eventProvider.EditEventDescription(eventToUpdate.id, newDescription);

      var updatedEvent = (await eventProvider.eventsHome).firstWhere((e) => e.id == eventToUpdate.id);
      expect(updatedEvent.description, newDescription);

       eventProvider.EditEventDescription(eventToUpdate.id, originalDescription);
    });

    test('Edit event location in eventsHome', () async {
      var eventToUpdate = (await eventProvider.eventsHome).first;
      var originalLocation = eventToUpdate.venue;
      var newLocation = 'Updated Event Location';
      print(eventToUpdate.venue?.name);

      await eventProvider.EditEventLocation(eventToUpdate.id, newLocation);

      var updatedEvent = (await eventProvider.eventsHome).firstWhere((e) => e.id == eventToUpdate.id);
      expect(updatedEvent.venue!.name, newLocation);

      // eventProvider.EditEventLocation(eventToUpdate.id, originalLocation);
    });



    test('Edit event max participants in eventsHome', () async {
      var eventToUpdate = (await eventProvider.eventsHome).first;
      var originalMaxParticipants = eventToUpdate.maxAttendees;
      var newMaxParticipants = 200;

      await eventProvider.EditEventMaxParticipants(eventToUpdate.id, newMaxParticipants);

      var updatedEvent = (await eventProvider.eventsHome).firstWhere((e) => e.id == eventToUpdate.id);
      expect(updatedEvent.maxAttendees, newMaxParticipants);

      await eventProvider.EditEventMaxParticipants(eventToUpdate.id, originalMaxParticipants);
    });


  });
}
