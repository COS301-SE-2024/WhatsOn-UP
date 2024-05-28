import 'package:flutter/material.dart';

class Event {
  final String nameOfEvent;
  final String dateAndTime;
  final String location;
  final String imageUrl;

  Event({
    required this.nameOfEvent,
    required this.dateAndTime,
    required this.location,
    required this.imageUrl,
  });
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: Container(
        width: 200.0, 
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Image.network(
                event.imageUrl,
                height: 95.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(
                event.nameOfEvent,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              Text(
                event.dateAndTime,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                event.location,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}