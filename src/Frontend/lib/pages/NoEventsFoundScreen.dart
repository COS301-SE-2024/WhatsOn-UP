import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../providers/events_providers.dart';
import '../widgets/event_card.dart';

// class NoEventsFoundScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         //title: Text('No Events'),
//       ),
//       body: Center(
//         child: Text(
//           'No events with this category found',
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
import 'package:provider/provider.dart';

class NoEventsFoundScreen extends StatefulWidget {
  final String categoryName;

  NoEventsFoundScreen({required this.categoryName});

  @override
  _NoEventsFoundScreenState createState() => _NoEventsFoundScreenState();
}

class _NoEventsFoundScreenState extends State<NoEventsFoundScreen> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();

    fetchEvents();
  }

  Future<void> fetchEvents() async {
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);


    var eventsHome = await eventP.eventsHome;


    List<Event> allEvents = eventsHome;

    setState(() {
      _events = searchEventsByCategory(widget.categoryName, allEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Events'),
      ),
      body: _events.isEmpty
          ? Center(child: Text('No events found in this category.'))
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 8.0,
            ),
            child: EventCard(
              event: event,
              showBookmarkButton: true,
            ),
          );

        },
      ),
    );
  }

  List<Event> searchEventsByCategory(String category, List<Event> allEvents) {

    return allEvents.where((event) =>  event.extractCategoryFromMetadata() == category).toList();
  }
}

