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
import '../services/api.dart';

class EventProvider with ChangeNotifier {
  final Api api = Api();

  late Future<List<Event>> _eventsHome;
  //late Future<List<Event>> _eventsRsvp;
  //late Future<List<Event>> _eventsSaved;
  List<Event> _eventsRsvp = [];
  List<Event> _eventsSaved = [];

  EventProvider() {
    _eventsHome = _fetchEventsHome();
    // _eventsRsvp = _fetchEventsRsvp();
    // _eventsSaved = _fetchEventsSaved();
  }

  Future<List<Event>> _fetchEventsHome() async {
    try {
      return await api.getAllEvents();
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
  // Future<List<Event>> _fetchEventsRsvp() async {
  //   try {
  //     return await api.getAllEvents();
  //   } catch (e) {
  //     throw Exception('Failed to fetch home events: $e');
  //   }
  // }
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
      return await _eventsHome; // Return the awaited _eventsHome future
    } catch (e) {
      throw Exception('Failed to fetch home events: $e');
    }
  }
  // Future<List<Event>> get eventsRsvp async {
  //   try {
  //     return await _eventsRsvp; // Return the awaited _eventsHome future
  //   } catch (e) {
  //     throw Exception('Failed to fetch RSVP events: $e');
  //   }
  // }

  // Future<List<Event>> get eventsSaved async {
  //   try {
  //     return await _eventsSaved; // Return the awaited _eventsHome future
  //   } catch (e) {
  //     throw Exception('Failed to fetch saved events: $e');
  //   }
  // }

  List<Event> get eventsRsvp => _eventsRsvp;
  List<Event> get eventsSaved => _eventsSaved;

  void addEventHome(Event event) {
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

  // void addEventRSVP(Event event) {
  //   _eventsHome.then((events) {
  //     events.add(event);
  //     notifyListeners();
  //   });
  // }
  //
  // void addEventsRSVP(List<Event> events) {
  //   _eventsHome.then((existingEvents) {
  //     existingEvents.addAll(events);
  //     notifyListeners();
  //   });
  // }
  //
  // void removeEventRSVP(Event event) {
  //   _eventsHome.then((events) {
  //     events.remove(event);
  //     notifyListeners();
  //   });
  // }

  void addEventRsvp(Event event) {
    _eventsRsvp.add(event);
    notifyListeners();
  }

  void removeEventRsvp(Event event) {
    _eventsRsvp.remove(event);
    notifyListeners();
  }

  void addEventSaved(Event event) {
    _eventsSaved.add(event);
    notifyListeners();
  }

  void removeEventSaved(Event event) {
    _eventsSaved.remove(event);
    notifyListeners();
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
}