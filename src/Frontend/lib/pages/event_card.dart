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
      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Container(
        width: 30.0,
        
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                event.imageUrl,
                height: 120.0,
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
                 SizedBox(height: 8.0),
              Text(
                event.dateAndTime,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
     
        Row(
          mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on, 
                    size: 20.0,
                    color: Colors.grey,
                  ),
            
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                   IconButton(
                      icon: Icon(
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
    );
  }
}