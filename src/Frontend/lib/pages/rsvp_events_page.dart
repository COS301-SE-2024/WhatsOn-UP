import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card_RSVP.dart';

class RsvpEventsPage extends StatefulWidget {
  const RsvpEventsPage({Key? key}) : super(key: key);

  @override
  _RsvpEventsPageState createState() => _RsvpEventsPageState();
}

class _RsvpEventsPageState extends State<RsvpEventsPage> {
  List<Event> events = [
    Event(nameOfEvent: 'something1', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something2', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something3', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something4', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something5', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something6', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something7', imageUrl: 'https://picsum.photos/200'),
    Event(nameOfEvent: 'something8', imageUrl: 'https://picsum.photos/200'),
  ];

  void removeEvent(String nameOfEvent, String imageUrl) {
    setState(() {
      events.removeWhere((event) =>
          event.nameOfEvent == nameOfEvent && event.imageUrl == imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSVP Events'),
      ),
      body: Center(
        child: GridView.builder(
          itemCount: events.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
           
            
          ),
          itemBuilder: (context, index) {
            return EventCard(
              event: events[index],
              removeEvent: removeEvent,
            );
          },
        ),
      ),
    );
  }
}
