import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card_RSVP.dart';

class RsvpEventsPage extends StatefulWidget {
  const RsvpEventsPage({Key? key}) : super(key: key);

  @override
  _RsvpEventsPageState createState() => _RsvpEventsPageState();
}

class _RsvpEventsPageState extends State<RsvpEventsPage> {
  List<Event> events = [
    Event(nameOfEvent: 'something1', imageUrl: 'https://source.unsplash.com/random/200x200?sig=1'),
    Event(nameOfEvent: 'something2', imageUrl: 'https://source.unsplash.com/random/200x200?sig=2'),
    Event(nameOfEvent: 'something3', imageUrl: 'https://source.unsplash.com/random/200x200?sig=3'),
    Event(nameOfEvent: 'something4', imageUrl: 'https://source.unsplash.com/random/200x200?sig=4'),
    Event(nameOfEvent: 'something5', imageUrl: 'https://source.unsplash.com/random/200x200?sig=5'),
    Event(nameOfEvent: 'something6', imageUrl: 'https://source.unsplash.com/random/200x200?sig=6'),
    Event(nameOfEvent: 'something7', imageUrl: 'https://source.unsplash.com/random/200x200?sig=7'),
    Event(nameOfEvent: 'something8', imageUrl: 'https://source.unsplash.com/random/200x200?sig=8'),
  ];

  void removeEvent(String nameOfEvent, String imageUrl) {
    setState(() {
      events.removeWhere((event) =>
          event.nameOfEvent == nameOfEvent && event.imageUrl == imageUrl);
    });
   
       print("Event removed: $nameOfEvent");
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSVP Events'),
      ),
      body:Center(
        child: events.isEmpty
            ? const Text(
                "You haven't RSVPED any event",
                style: TextStyle(fontSize: 18),
              )
            : GridView.builder(
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
