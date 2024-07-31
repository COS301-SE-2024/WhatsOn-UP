import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card_RSVP.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RsvpEventsPage extends StatefulWidget {
  const RsvpEventsPage({super.key});

  @override
  _RsvpEventsPageState createState() => _RsvpEventsPageState();
}

class _RsvpEventsPageState extends State<RsvpEventsPage> {
  List<Event> events = [
    Event(nameOfEvent: 'Event name 1', imageUrl: 'https://source.unsplash.com/random/200x200?sig=1'),
    Event(nameOfEvent: 'Event name 2', imageUrl: 'https://source.unsplash.com/random/200x200?sig=2'),
    Event(nameOfEvent: 'Event name 3', imageUrl: 'https://source.unsplash.com/random/200x200?sig=3'),
    Event(nameOfEvent: 'Event name 4', imageUrl: 'https://source.unsplash.com/random/200x200?sig=4'),
    Event(nameOfEvent: 'Event name 5', imageUrl: 'https://source.unsplash.com/random/200x200?sig=5'),
    Event(nameOfEvent: 'Event name 6', imageUrl: 'https://source.unsplash.com/random/200x200?sig=6'),
    Event(nameOfEvent: 'Event name 7', imageUrl: 'https://source.unsplash.com/random/200x200?sig=7'),
    Event(nameOfEvent: 'Event name 8', imageUrl: 'https://source.unsplash.com/random/200x200?sig=8'),
  ];
  bool _isLoading =false;
  void removeEvent(String nameOfEvent, String imageUrl) {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        events.removeWhere((event) =>
        event.nameOfEvent == nameOfEvent && event.imageUrl == imageUrl);
        _isLoading = false;
      });

      print("Event removed: $nameOfEvent");
    });
   

     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child:SpinKitPianoWave(
        color:  Color.fromARGB(255, 149, 137, 74),
        size: 50.0,
      ))
          :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'RSVP Events',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: events.isEmpty
                  ? const Text(
                      "You have not made any reservations",
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
          ),
        ],
      ),
    );
  }
}
