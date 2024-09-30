/*import 'package:flutter/material.dart';

class FilteredEventsScreen extends StatelessWidget {
  final List<dynamic> events;

  FilteredEventsScreen({required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Events'),
      ),
      body: events.isEmpty
          ? Center(
              child: Text('No events found'),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event['description']),
                      Text('Location: ${event['location']}'),
                      Text('Start Time: ${event['start_time']}'),
                      Text('End Time: ${event['end_time']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
*/