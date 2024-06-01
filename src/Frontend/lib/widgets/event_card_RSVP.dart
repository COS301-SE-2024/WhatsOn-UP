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
    final theme = Theme.of(context);
    final cardColour = theme.colorScheme.surface;
    final textColour = theme.colorScheme.onSurface;

    return Card(
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
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
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
                    event.imageUrl,
                    height: 120.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      size: 120.0,
                      color: textColour,
                    ),
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
              SizedBox(
                width: 100, // Adjust the width as needed
                height: 20, // Adjust the height as needed
                child: ElevatedButton(
                  onPressed: () {
                    showDeleteDialog(context);
                  },
                  child: const Text('Cancel'),
                ),
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
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text('Delete'),
              onPressed: () {
                print("Deleting event: ${event.nameOfEvent}");
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
