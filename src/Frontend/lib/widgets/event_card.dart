import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/detailed_event_page.dart';

class Event {
  final String nameOfEvent;
  final String dateAndTime;
  final String location;
  final List<String> imageUrls;
  final String description;

  Event({
    required this.nameOfEvent,
    required this.dateAndTime,
    required this.location,
    required this.imageUrls,
    required this.description,
  });

   factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      nameOfEvent: json['title'],
      dateAndTime: json['startTime'],
      location: json['location'],
      imageUrls: List<String>.from(json['eventMedia']),
      description: json['description'],
    );
   }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColour = theme.colorScheme.surface;
    final textColour = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedEventPage(event: event),
          ),
        );
      },
      child: Card(
        color: cardColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 200,
          height: 265,
          decoration: BoxDecoration(
            color: cardColour,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 7.0),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      event.imageUrls[0],
                      height: 120.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  event.nameOfEvent,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    color: textColour,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  event.dateAndTime,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: textColour,
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: textColour,
                    ),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: textColour,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                        size: 20.0,
                        color: textColour,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
