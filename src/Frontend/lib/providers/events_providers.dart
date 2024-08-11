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
import 'dart:convert';

class EventProvider with ChangeNotifier {



  // late final Api api = Api();
  late final Api api ;

  late Future<List<Event>> _eventsHome;
  late Future<List<Event>> _eventsRsvp;
  //late Future<List<Event>> _eventsSaved;
  // List<Event> _eventsRsvp = [];
  List<Event> _eventsSaved = [];

  // EventProvider() {
  //   _eventsHome = _fetchEventsHome();
  //
  //   // _eventsSaved = _fetchEventsSaved();
  // }
  EventProvider({required this.api}) {
    _eventsHome = _fetchEventsHome();
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
  Future<List<Event>> _fetchEventsHome() async {
    try {
      return await api.getAllEvents();
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

  // Future<List<Event>> _fetchEventsRsvp(String userId) async {

  //   try {
  //     final response= await api.getRSVPEvents(userId);
  //     List<Event> events = (response as List)
  //         .map((eventData) => Event.fromJson(eventData))
  //         .toList();

  //     return events;
  //   } catch (e) {
  //     throw Exception('Failed to fetch home events: $e');
  //   }
  // }

  // Future<List<dynamic>>_fetchEventsRsvp(String userId) async {
  //   final user = supabase.auth.currentUser;
  //   try {
  //     return await api.getRSVPEvents(userId);
  //   } catch (e) {
  //     throw Exception('Failed to fetch home events: $e');
  //   }
  // }



//   Future<List<Event>> _fetchEventsRsvp(String userId) async {
//     if (userId == "guest") { // If id received is "guest", user is a guest
//       final response = await api.getAllEventsGuest();
//       List<Event> events = (response as List)
//           .map((eventData) => Event.fromJson(eventData))
//           .toList();

//       print("RESPONSE IN GUEST VIEW EVENTS: $response");
//       List<Map<String, dynamic>> eventMaps = events.map((event) => event.toJson()).toList();
//       List<Event> events2 = eventMaps.map((map) => Event.fromJson(map)).toList();

//       print("GUEST VIEW EVENTS: $events2");
//       return events2;
//     }
//   try {
//     // return await api.getRSVPEvents(userId!);
//     print("USER ID IN RSVPEVENTS CALL: $userId");
//     final response= await api.getRSVPEvents(userId);
//       List<Event> events = (response as List)
//           .map((eventData) => Event.fromJson(eventData))
//           .toList();

//       print("RSVP EVENTS FOR SIGNED IN USERS: $events");
//       return events;
//   } catch (e) {
//     throw Exception('Failed to fetch RSVP events: $e');
//   }
// }

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

    // if (userId == "guest") {
    //   print("GUEST VIEW EVENTS: $events");
    // } 
    // else {
    //   print("RSVP EVENTS FOR SIGNED IN USERS: $events");
    // }

    return events;
  } 
  catch (e) {
    print('Error in _fetchEventsRsvp: $e');
    throw Exception('Failed to fetch RSVP events: $e');
  }
}


  void fetchfortheFirstTimeRsvp(String userId) {
    _eventsRsvp =  _fetchEventsRsvp(userId);
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
  Future<void> addEventHome(Map<String, dynamic> eventData) async {
    // Event event = Event.fromJson(eventData);
    // _eventsHome.then((events) {
    //   events.add(event);
    //   notifyListeners();
    // });
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
      Event? event= events.firstWhere((event) => event.id == id);
      event.description=Description;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get event by ID: $e');
    }

  }

//modified here - check here
  Future<void> EditEventLocation(String id, String Location) async {
    try {
      List<Event> events = await _eventsHome;
      Event? event = events.firstWhere((event) => event.id == id);
      if (event != null) {
        event.venue?.name = Location ;
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
        event.maxAttendees = maxParticipants ;
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


