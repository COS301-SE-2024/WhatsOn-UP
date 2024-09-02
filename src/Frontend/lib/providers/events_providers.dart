
import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../main.dart';
import '../services/api.dart';
import 'dart:convert';

class EventProvider with ChangeNotifier {
  late final Api api;

  late Future<List<Event>> _eventsHome;
  late Future<List<Event>> _eventsRsvp;

  late Future<List<Event>> _eventsSaved;
  late Future<List<Event>> _eventRecommedations;
  EventProvider({required this.api}) {
    _eventsHome = _fetchEventsHome();
    _eventsSaved = Future.value([]);

  }
  Future<void> refreshEvents() async {
    try {
      _eventsHome = _fetchEventsHome();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh events: $e');
    }
  }

  Future<void> refreshRSVPEvents(String userId) async {
    try {
      _eventsRsvp = _fetchEventsRsvp(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh events: $e');
    }
  }
Future<void> refreshRecommendations(String userId) async {
    try {
      _eventRecommedations = _fetchRecommendations(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh events: $e');
    }
  }
  Future<List<Event>> _fetchEventsHome() async {
    try {
      return await api.getAllEvents();
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
Future<void> refreshSavedEvents(String userId) async {
    try {
      _eventsSaved = _fetchEventsSaved(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to refresh events: $e');
    }
  }Future<List<Event>> _fetchRecommendations(String userId) async {
    try {
      return await api.RecommendedEvents(userId);
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
  Future<List<Event>> _fetchCalendarEventsGuest() async {
    try {
      // return await api.getAllEventsGuest();
      return await api.getAllEvents();
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }


Future<List<Event>> _fetchEventsRsvp(String userId) async {
  try {
    List<dynamic> responseData;
    if (userId == "guest") {
      responseData = await api.getAllEventsGuest();
    }
    else {
      responseData = await api.getRSVPEvents(userId);
    }

    List<Event> events = responseData
        .map((eventData) => Event.fromJson(eventData as Map<String, dynamic>))
        .toList();



    return events;
  }
  catch (e) {
    print('Error in _fetchEventsRsvp: $e');
    throw Exception('Failed to fetch RSVP events: $e');
  }
}


  void fetchfortheFirstTimeRsvp(String userId) {
    _eventsRsvp = _fetchEventsRsvp(userId);
  }



  Future<List<Event>> _fetchEventsSaved(String userId) async {
    try {
      List<dynamic> responseData;
      responseData=await api.getAllSavedEvents(userId);
      List<Event> events = responseData
          .map((eventData) => Event.fromJson(eventData as Map<String, dynamic>))
          .toList();
      return events;
    } catch (e) {
      throw Exception('Failed to fetch saved events: $e');
    }
  }


  Future<List<Event>> get recommendations async {
    try {
      return await _eventRecommedations;
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
  Future<List<Event>> get eventsHome async {
    try {
      return await _eventsHome;
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }

  Future<List<Event>> get eventsRsvp async {
    try {
      return await _eventsRsvp;
    } catch (e) {
      throw Exception('Failed to fetch RSVP events: $e');
    }
  }

  Future<List<Event>> get eventsSaved async {
    try {

      return await _eventsSaved;
    } catch (e) {
      throw Exception('Failed to fetch saved events: $e');
    }
  }


  Future<void> addEventHome(Map<String, dynamic> eventData) async {

    Event event = Event.fromJson(eventData);
    List<Event> events = await _eventsHome;
    events.add(event);
    notifyListeners();
  }

  void addEventsHome(List<Event> events) {
    _eventsHome.then((existingEvents) {
      existingEvents.addAll(events);
      notifyListeners();
    });
  }

  Future<void> removeEventHome(Event event) async {
    // _eventsHome.then((events) {
    //   events.remove(event);
    //   notifyListeners();
    // });
    List<Event> events = await _eventsHome;
    events.remove(event);
    notifyListeners();
  }

  void addEventRSVP(Event event) {
    _eventsHome.then((events) {
      events.add(event);
      notifyListeners();
    });
  }

  //
  void addEventsRSVP(List<Event> events) {
    _eventsHome.then((existingEvents) {
      existingEvents.addAll(events);
      notifyListeners();
    });
  }

  //
  void removeEventRSVP(Event event) {
    _eventsHome.then((events) {
      events.remove(event);
      notifyListeners();
    });
  }



  void addEventSaved(Event event,String userId) {
    _eventsSaved.then((events) {
      api.putSavedEvent(event.id,userId);
      events.add(event);
      notifyListeners();
    });
  }

  void removeEventSaved(Event event,String userId) {
    _eventsSaved.then((events) {
      api.DeleteSavedEvent(event.id,userId);
      events.remove(event);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<Event?> getEventById(String id) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      return event;
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }
  Future<Event?> getEventByIdR(String id) async {
    try {
      List<Event> events = await _eventRecommedations;
      Event? event = events.firstWhere((event) => event.id == id);
      return event;
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }
  // void EditEventName(String id, String eventName) async {
  //   try {
  //     List<Event> events = await _eventsHome;
  //     Event? event= events.firstWhere((event) => event.id == id);
  //      event.nameOfEvent=eventName;
  //     notifyListeners();
  //   } catch (e) {
  //     throw Exception('Failed to get event by ID: $e');
  //   }
  // }
  Future<void> EditEventName(String id, String eventName) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      if (event != null) {
        event.nameOfEvent = eventName;
        notifyListeners();
      } else {
        throw Exception('Event with ID $id not found');
      }
    } catch (e) {
      throw Exception('Failed to edit event name: $e');
    }
  }

  void EditEventDescription(String id, String Description) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.description = Description;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }


  Future<void> EditEventLocation(String id, String Location) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      if (event != null) {
        event.venue?.name = Location;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }

  Future<void> EditEventMaxParticipants(String id, int maxParticipants) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      if (event != null) {
        event.maxAttendees = maxParticipants;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }

  void EditEventsIsPrivate(String id, bool isPrivate) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.isPrivate = isPrivate;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }

  void EditEventStartTime(String id, DateTime startTime) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.startTime = startTime as String;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }

  void EditEventEndTime(String id, DateTime endTime) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.endTime = endTime as String;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }

  Future<List<Event>> _fetchHostEvents(String hostId) async {

    try {
      List<Event> allEvents = await api.getAllEvents();
      List<Event> hostEvents = allEvents.where((event) => event.hosts.contains(hostId)).toList();
      return hostEvents;
    }
    catch (e) {
      throw Exception('Failed to fetch host events: $e');
    }
  }
  Future<List<Event>> getHostEvents(String hostId) async {

    try {
      return await _fetchHostEvents(hostId);
    } catch (e) {
      throw Exception('Failed to fetch host events: $e');
    }
  }

}

