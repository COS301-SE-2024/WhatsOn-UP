// import 'package:flutter/material.dart';
// import 'package:firstapp/widgets/event_card.dart';
//
// import '../services/api.dart';
//
//
// class eventProvider with ChangeNotifier {
//   Api api = Api();
//
//   late Future<List<Event>> _eventsHome = await api.getAllEvents();
//   // List<Event> get eventsHome => _eventsH;
//   Future<List<Event>> get eventsHome async {
//     try {
//       return _eventsHome;
//     } catch (e) {
//       throw Exception('Failed to fetch home events: $e');
//     }
//   }
//
//
//   List<Event> _eventsRsvp = [];
//   List<Event> get eventsRsvp => _eventsRsvp;
//
//   List<Event> _eventsSaved = [];
//   List<Event> get eventsSaved => _eventsSaved;
//
//   void addEventHome(Event event) {
//     _eventsHome.then((events) {
//       events.add(event);
//       notifyListeners();
//     });
//
//   }
//   // void addEventsHome(List<Event> events) {
//   //   _eventsHome.then((events) {
//   //     events.add(event);
//   //     notifyListeners();
//   //   });
//   // }
//   void addEventsHome(List<Event> events) {
//     _eventsHome.then((existingEvents) {
//       existingEvents.addAll(events);
//       notifyListeners();
//     });
//   }
//   void removeEventHome(Event event) {
//
//     _eventsHome.then((events) {
//       events.remove(event);
//       notifyListeners();
//     });
//   }
//
//   void addEventRsvp(Event event) {
//     _eventsRsvp.add(event);
//     notifyListeners();
//   }
//   void removeEventRsvp(Event event) {
//     _eventsRsvp.remove(event);
//     notifyListeners();
//   }
//   void addEventSaved(Event event) {
//     _eventsSaved.add(event);
//     notifyListeners();
//   }
//   void removeEventSaved(Event event) {
//     _eventsSaved.remove(event);
//     notifyListeners();
//   }
//
//
// }

import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../main.dart';
import '../services/api.dart';

class EventProvider with ChangeNotifier {



  final Api api = Api();

  late Future<List<Event>> _eventsHome;
  late   Future<List<dynamic>> _eventsRsvp;
  //late Future<List<Event>> _eventsSaved;
  // List<Event> _eventsRsvp = [];
  List<Event> _eventsSaved = [];

  EventProvider() {
    _eventsHome = _fetchEventsHome();

    // _eventsSaved = _fetchEventsSaved();
  }
  Future<void> refreshEvents() async {
    try {
      _eventsHome = _fetchEventsHome();
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
  Future<List<dynamic>>_fetchEventsRsvp(String userId) async {
    final user = supabase.auth.currentUser;
    try {
      return await api.getRSVPEvents(userId);
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
  void fetchfortheFirstTimeRsvp(String userId) {
    _eventsRsvp = _fetchEventsRsvp(userId);
  }
  //
  // Future<List<Event>> _fetchEventsSaved() async {
  //   try {
  //     return await api.getAllEvents();
  //   } catch (e) {
  //     throw Exception('Failed to fetch home events: $e');
  //   }
  // }


  Future<List<Event>> get eventsHome async {
    try {
      return await _eventsHome;
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
     Future<List<dynamic>> get eventsRsvp async {
    try {
       return await _eventsRsvp;
     } catch (e) {
       throw Exception('Failed to fetch RSVP events: $e');
     }
   }

  // Future<List<Event>> get eventsSaved async {
  //   try {
  //     return await _eventsSaved; // Return the awaited _eventsHome future
  //   } catch (e) {
  //     throw Exception('Failed to fetch saved events: $e');
  //   }
  // }

  // List<Event> get eventsRsvp => _eventsRsvp;
  List<Event> get eventsSaved => _eventsSaved;

  // void addEventHome(Event event) {
  //   _eventsHome.then((events) {
  //     events.add(event);
  //     notifyListeners();
  //   });
  // }
  void addEventHome(Map<String, dynamic> eventData) {
    Event event = Event.fromJson(eventData);
    _eventsHome.then((events) {
      events.add(event);
      notifyListeners();
    });
  }
  void addEventsHome(List<Event> events) {
    _eventsHome.then((existingEvents) {
      existingEvents.addAll(events);
      notifyListeners();
    });
  }

  void removeEventHome(Event event) {
    _eventsHome.then((events) {
      events.remove(event);
      notifyListeners();
    });
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

  // void addEventRsvp(Event event) {
  //   _eventsRsvp.add(event);
  //   notifyListeners();
  // }

  // void removeEventRsvp(Event event) {
  //   _eventsRsvp.remove(event);
  //   notifyListeners();
  // }

  void addEventSaved(Event event) {
    _eventsSaved.add(event);
    notifyListeners();
  }

  void removeEventSaved(Event event) {
    _eventsSaved.remove(event);
    notifyListeners();
  }
  Future<Event?> getEventById(String id) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event= events.firstWhere((event) => event.id == id);
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
  void EditEventName(String id, String eventName) async {
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
      Event? event= events.firstWhere((event) => event.id == id);
      event.description=Description;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }

  }


  void EditEventLocation(String id, String Location) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.location = Location ;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }
  void EditEventMaxParticipants(String id, int maxParticipants) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.maxAttendees = maxParticipants ;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }
  void EditEventsIsPrivate(String id, bool isPrivate) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.isPrivate = isPrivate ;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }
  void EditEventStartTime(String id, DateTime startTime) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.startTime = startTime as String ;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }
  void EditEventEndTime(String id, DateTime endTime) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      event.endTime = endTime as String ;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }
  }

  // void EditEventDateandTime(String id, String startDate) async {
  //   try {
  //     List<Event> events = await _eventsHome;
  //     Event? event = events.firstWhere((event) => event.id == id);
  //     event. = startDate ;
  //   } catch (e) {
  //     throw Exception('Failed to get event by ID: $e');
  //   }
  // }



}


// void addEventSaved(Event event) {
//   _eventsHome.then((events) {
//     events.add(event);
//     notifyListeners();
//   });
// }
//
// void addEventsSaved(List<Event> events) {
//   _eventsHome.then((existingEvents) {
//     existingEvents.addAll(events);
//     notifyListeners();
//   });
// }
//
// void removeEventSaved(Event event) {
//   _eventsHome.then((events) {
//     events.remove(event);
//     notifyListeners();
//   });
// }


