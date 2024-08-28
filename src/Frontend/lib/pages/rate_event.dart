import 'package:flutter/material.dart';

class RateEventPage extends StatelessWidget {
  final String eventId;
  final String eventName;

  const RateEventPage({Key? key, required this.eventId, required this.eventName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Event'),
      ),
      body: Center(
        child: Text(
          'Event ID: $eventId',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}