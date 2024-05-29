import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Event {
  final String nameOfEvent;
  final String imageUrl;

  Event({
    required this.nameOfEvent,
    required this.imageUrl,
  });
}

class EventCard extends StatelessWidget {
  final Event event;
  final Function(String, String) removeEvent;

  EventCard({required this.event, required this.removeEvent});

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
                height: 100.0,
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
             SizedBox(height: 10.0),
                ElevatedButton(
                        onPressed: () {
                          showDeleteDialog(context);
                        },
                        child: Text('Cancel'),
                      ),
            ],
          ),
        ),
      ),
    );
  }

void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text('Delete'),
              onPressed: () {
                removeEvent(event.nameOfEvent, event.imageUrl);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }




}