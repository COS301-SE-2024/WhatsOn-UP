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
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Container(
        width: 30.0,
        
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                event.imageUrls[0],
                height: 120.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      
              Text(
                event.nameOfEvent,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
                 const SizedBox(height: 8.0),
              Text(
                event.dateAndTime,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
     
        Row(
          mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on, 
                    size: 20.0,
                    color: Colors.grey,
                  ),
            
                  Expanded(
                    child: Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                   IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        
                      },
                   )
                  // Icon(
                  //   Icons.bookmark_border, 
                  //   size: 20.0,
                  //   color: Colors.grey,
                  // ),
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